/**
 * @author Keven Poulin
 */
package com.funcom.project.manager.implementation.loader 
{
	import com.funcom.project.manager.AbstractManager;
	import com.funcom.project.manager.implementation.console.enum.ELogType;
	import com.funcom.project.manager.implementation.console.Logger;
	import com.funcom.project.manager.implementation.loader.enum.EFileType;
	import com.funcom.project.manager.implementation.loader.enum.ELoadGroupState;
	import com.funcom.project.manager.implementation.loader.enum.ELoadPacketState;
	import com.funcom.project.manager.implementation.loader.event.LoaderManagerEvent;
	import com.funcom.project.manager.implementation.loader.struct.DefaultSymbol;
	import com.funcom.project.manager.implementation.loader.struct.LoadGroup;
	import com.funcom.project.manager.implementation.loader.struct.LoadPacket;
	import com.funcom.project.manager.implementation.loader.struct.LoadStatistic;
	import com.funcom.project.manager.implementation.loader.struct.LoadWorker;
	import com.funcom.project.manager.implementation.resolution.event.ResolutionManagerEvent;
	import com.funcom.project.utils.display.DisplayUtil;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.system.ApplicationDomain;
	import flash.text.TextField;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	
	public class LoaderManager extends AbstractManager implements ILoaderManager
	{
		/************************************************************************************************/
		/*	Const var																					*/
		/************************************************************************************************/
		private const DEFAULT_MAXIMUM_NUMBER_OF_SIMULTANEOUS_WORKER:int = 5;
		
		/************************************************************************************************/
		/*	Member var																					*/
		/************************************************************************************************/
		//Ref Container
		private var _pendingGroupList:Vector.<LoadGroup>;
		private var _pendingPacketList:Vector.<LoadPacket>;
		private var _processingPacketList:Vector.<LoadPacket>;
		private var _requestedPacketList:Vector.<LoadPacket>;
		private var _workerList:Vector.<LoadWorker>;
		
		//Config
		private var _maxNumberOfWorker:int;
		private var _versioningId:String;
		
		//Management
		private var _localCache:Dictionary;
		private var _isVersioningActivated:Boolean;
		
		//Stat
		private var _biggestFileLoaded:LoadStatistic;
		private var _longestLoadingTime:LoadStatistic;
		
		/************************************************************************************************/
		/*	Constructor / Init / Dispose																*/
		/************************************************************************************************/
		public function LoaderManager() 
		{
		}
		
		override public function activate():void
		{
			super.activate();
			
			//Activation completed
			onActivated();
		}
		
		public function destroy():void 
		{
			//Clear cache
			_localCache = null;
			
			//Clear worker
			for each (var worker:LoadWorker in _workerList) 
			{
				unregisterWorker(worker);
			}
			_workerList.length = 0;
			_workerList = null;
			
			//Clear group
			for each (var group:LoadGroup in _pendingGroupList) 
			{
				unregisterGroup(group);
			}
			_pendingGroupList.length = 0;
			_pendingGroupList = null;
			
			//Clear packet
			_pendingGroupList.length = 0;
			_pendingGroupList = null;
			_processingPacketList.length = 0;
			_processingPacketList = null;
			_requestedPacketList.length = 0;
			_requestedPacketList = null;
			
			//Destroy var
			_biggestFileLoaded = null;
			_longestLoadingTime = null;
			
			//destroy
			//TODO super.destroy();
		}
		
		/************************************************************************************************/
		/*	Public																						*/
		/************************************************************************************************/
		public function load(filePath:String, fileType:EFileType, callback:Function = null, applicationDomain:ApplicationDomain = null, loaderPriority:int = 1, avoidCaching:Boolean = false):LoadPacket
		{
			var packet:LoadPacket = new LoadPacket(filePath, fileType, callback, applicationDomain, loaderPriority, avoidCaching);
			
			//Make sure this packet is not cached
			if (checkIfPacketCached(packet))
			{
				return packet;
			}
			
			//Make sure this packet is not already in process
			var matchingPacket:LoadPacket = checkForMatchingPacket(packet);
			if (matchingPacket == null)
			{
				loadByPacketObject(packet);
			}
			else
			{
				packet = matchingPacket;
			}
			
			return packet;
		}
		
		public function setLoadingPriority(aFilePath:String, aPriority:int):void
		{
			for each (var packetBuffer:LoadPacket in _pendingPacketList) 
			{
				if (packetBuffer.filePath == aFilePath)
				{
					packetBuffer.loaderPriority = aPriority;
					return;
				}
			}
		}
		
		
		public function loadGroup(loadgroup:LoadGroup):void
		{
			//Put the goupe in the pending group list
			registerGroup(loadgroup);
			
			//Granulate the group in individual packet
			for each (var packet:LoadPacket in loadgroup.packetList) 
			{
				//Make sure this packet is not cached
				if (!checkIfPacketCached(packet))
				{
					//Make sure this packet is not already in process
					var matchingPacket:LoadPacket = checkForMatchingPacket(packet);
					if (matchingPacket == null)
					{
						loadByPacketObject(packet);
					}
					else
					{
						loadgroup.substitutePacket(packet, matchingPacket);
					}
				}
			}
		}
		
		public function hasFile(filePath:String):Boolean
		{
			return filePath in _localCache;
		}
		
		public function getPacket(filePath:String):LoadPacket
		{
			if (hasFile(filePath))
			{
				return _localCache[filePath];
			}
			else
			{
				return null;
			}
		}
		
		public function getSWFStage(filePath:String):MovieClip
		{
			var packet:LoadPacket = _localCache[filePath];
			if (!packet)
			{
				return null;
			}
			
			return packet.content as MovieClip;
		}
		
		public function getSymbol(filePath:String, symbolLinkage:String):*
		{
			var classDefinition:Class;
			var packet:LoadPacket;
			var symbol:*;
			
			packet = _localCache[filePath];
			if (packet)
			{
				try
				{
					classDefinition = packet.applicationDomain.getDefinition(symbolLinkage) as Class;
					symbol = new classDefinition();
					
					if (symbol is DisplayObjectContainer)
					{
						DisplayUtil.recursiveStop(symbol as DisplayObjectContainer);
					}
				}
				catch (e:ReferenceError)
				{
					symbol = new DefaultSymbol(filePath, symbolLinkage);
				}
			}
			else
			{
				symbol = new DefaultSymbol(filePath, symbolLinkage);
			}
			
			return(symbol);
		}
		
		public function getXML(filePath:String):XML
		{
			var packet:LoadPacket;
			var buffer:XML;
			
			packet = _localCache[filePath];
			if (packet)
			{
				buffer = new XML(packet.content);
			}
			else
			{
				buffer = new XML();
			}
			
			return buffer;
		}
		
		/************************************************************************************************/
		/*	Private																						*/
		/************************************************************************************************/
		override protected function init():void 
		{
			//Init var
			_pendingGroupList = new Vector.<LoadGroup>();
			_pendingPacketList = new Vector.<LoadPacket>();
			_processingPacketList = new Vector.<LoadPacket>();
			_requestedPacketList = new Vector.<LoadPacket>();
			_workerList = new Vector.<LoadWorker>();
			_localCache = new Dictionary();
			
			//Set default config
			maxNumberOfWorker = DEFAULT_MAXIMUM_NUMBER_OF_SIMULTANEOUS_WORKER;
			
			//Instanciate worker
			balanceWorker();
			
			//Register basic event
			registerEvent();
			
			super.init();
		}
		
		override protected function loadManagerAsset():void 
		{
			load(_managerDefinition.assetFilePath, EFileType.SWF_FILE, onManagerAssetLoaded);
		}
		
		private function loadByPacketObject(packet:LoadPacket):void
		{
			Logger.log(ELogType.INFO, "LoaderManager.as", "loadByPacketObject", "Requested: " + packet.filePath);
			
			//The packet has been validate, we can add it to the pending list
			_pendingPacketList.push(packet);
			
			//Start the loading if no other packet are pending
			checkForPendingPacketToLoad();
		}
		
		private function registerWorker(worker:LoadWorker):void
		{
			//Basic condition
			if (!worker)
			{
				return;
			}
			
			//Add event
			worker.addEventListener(LoaderManagerEvent.LOADING_START, onLoadingStart, false, 0, true);
			worker.addEventListener(LoaderManagerEvent.LOADING_PROGRESS, onEvent, false, 0, true);
			worker.addEventListener(LoaderManagerEvent.LOADING_COMPLETED, onLoadingCompleted, false, 0, true);
			worker.addEventListener(LoaderManagerEvent.LOADING_CANCELED, onLoadingCanceled, false, 0, true);
			worker.addEventListener(LoaderManagerEvent.WORKER_FREE, onWorkerFree, false, 0, true);
			
			//Add it to the list
			_workerList.push(worker);
		}
		
		private function unregisterWorker(worker:LoadWorker):void
		{
			var index:int = _workerList.indexOf(worker);
			
			//Basic condition
			if (!worker || index == -1)
			{
				return;
			}
			
			//Remove event
			worker.removeEventListener(LoaderManagerEvent.LOADING_START, onLoadingStart);
			worker.removeEventListener(LoaderManagerEvent.LOADING_PROGRESS, onEvent);
			worker.removeEventListener(LoaderManagerEvent.LOADING_COMPLETED, onLoadingCompleted);
			worker.removeEventListener(LoaderManagerEvent.LOADING_CANCELED, onLoadingCanceled);
			worker.removeEventListener(LoaderManagerEvent.WORKER_FREE, onWorkerFree);
			
			//Dispose and clear the object
			worker.dispose();
			
			//Splice it from the list
			_workerList.splice(index, 1);
		}
		
		private function getAvailableWorker():LoadWorker
		{
			for each (var worker:LoadWorker in _workerList) 
			{
				if (!worker.isProcessing)
				{
					return worker;
				}
			}
			
			return null;
		}
		
		private function addToRequestedList(packet:LoadPacket):void
		{
			var packetInList:LoadPacket;
			
			for each (packetInList in _requestedPacketList) 
			{
				if (packetInList.filePath == packet.filePath)
				{
					//Already in the requested list
					return;
				}
			}
			
			_requestedPacketList.push(packet);
		}
		
		private function balanceWorker():void 
		{
			if (_workerList.length < _maxNumberOfWorker)
			{
				while (_workerList.length < _maxNumberOfWorker)
				{
					registerWorker(new LoadWorker());
				}
			}
			else if (_workerList.length > _maxNumberOfWorker)
			{
				for each (var worker:LoadWorker in _workerList) 
				{
					if (!worker.isProcessing)
					{
						unregisterWorker(worker);
						balanceWorker(); //Recursivity
						break;
					}
				}
			}
		}
		
		private function registerGroup(group:LoadGroup):void
		{
			//Basic condition
			if (!group)
			{
				return;
			}
			
			//Add event
			group.addEventListener(LoaderManagerEvent.GROUP_STATE_CHANGED, onGroupStateChanged, false, 0, true);
			
			//Add it to the list
			_pendingGroupList.push(group);
		}
		
		private function unregisterGroup(group:LoadGroup):void
		{
			var index:int = _pendingGroupList.indexOf(group);
			
			//Basic condition
			if (!group || index == -1)
			{
				return;
			}
			
			//Remove event
			group.removeEventListener(LoaderManagerEvent.GROUP_STATE_CHANGED, onGroupStateChanged);
			
			//Dispose and clear the object
			group.dispose();
			
			//Splice it from the list
			_pendingGroupList.splice(index, 1);
		}
		
		private function sortPacket(a:LoadPacket, b:LoadPacket):int 
        {
            return (a.loaderPriority==b.loaderPriority ? 0 : (a.loaderPriority < b.loaderPriority) ? -1 : 1);
        }
		
		private function checkForPendingPacketToLoad():void
		{
			var packetBuffer:LoadPacket;
			
			//Basic condition
			if (_pendingPacketList.length <= 0)
			{
				return;
			}
			
			//Init var
			var availableWorker:LoadWorker;
			
			//Get/Validate worker
			availableWorker = getAvailableWorker();
			if (!availableWorker)
			{
				//There is no available worker to execute the task for the moment
				return;
			}
			
			//Sort packet by priority
			_pendingPacketList.sort(sortPacket);
			
			//Always take the first in the list
			packetBuffer = _pendingPacketList.splice(0, 1)[0];
			_processingPacketList.push(packetBuffer);
			availableWorker.Load(packetBuffer);
		}
		
		private function checkIfPacketCached(requestedPacket:LoadPacket):Boolean
		{
			var cachedPacket:LoadPacket;
			
			//Check if this packet as already been loaded
			cachedPacket = _localCache[requestedPacket.filePath];
			if (cachedPacket)
			{
				if (cachedPacket.compare(requestedPacket))
				{
					if (cachedPacket.state == ELoadPacketState.LOADED)
					{
						Logger.log(ELogType.INFO, "LoaderManager.as", "checkIfPacketCached", "Retrieved in cache:" + requestedPacket.filePath);
						requestedPacket.applicationDomain = cachedPacket.applicationDomain; //Fix: We can't load the same file in different domain. Caused by the resource logic.
						requestedPacket.content = cachedPacket.content;
						requestedPacket.state = cachedPacket.state;
						//addToRequestedList(requestedPacket);
						requestedPacket.triggerCallback();
						return true;
					}
				}
			}
			
			return false;
		}
		
		private function checkForMatchingPacket(requestedPacket:LoadPacket):LoadPacket 
		{
			var packetBuffer:LoadPacket;
			var groupBuffer:LoadGroup;
			
			//Check if this packet has already been requested
			for each (packetBuffer in _pendingPacketList) 
			{
				if (packetBuffer.compare(requestedPacket))
				{
					//Adjust priority if needed
					if (requestedPacket.loaderPriority < packetBuffer.loaderPriority)
					{
						packetBuffer.loaderPriority = requestedPacket.loaderPriority;
					}
					
					//Add the last request callback to the list
					packetBuffer.addCallbackList(requestedPacket.callbackList);
					return packetBuffer;
				}
			}
			
			//Check if this packet is currently in process
			for each (packetBuffer in _processingPacketList) 
			{
				if (packetBuffer.compare(requestedPacket))
				{
					//Add the last request callback to the list
					packetBuffer.addCallbackList(requestedPacket.callbackList);
					return packetBuffer;
				}
			}
			
			return null;
		}
		
		private function getLoadGroupByLoadPacket(loadPacket:LoadPacket):LoadGroup
		{
			for each (var loadGroup:LoadGroup in _pendingGroupList) 
			{
				if (loadGroup.packetList.indexOf(loadPacket) != -1)
				{
					return loadGroup;
				}
			}
			
			return null;
		}
		
		private function evaluatePacketStatistic(packet:LoadPacket):void
		{
			//Biggest file
			if (!_biggestFileLoaded || (packet.bytesTotal > _biggestFileLoaded.value))
			{
				_biggestFileLoaded = new LoadStatistic(packet.filePath, packet.bytesTotal);
			}
			
			//longest loading
			if (!_longestLoadingTime || (packet.timeToLoad > _longestLoadingTime.value))
			{
				_longestLoadingTime = new LoadStatistic(packet.filePath, packet.timeToLoad);
			}
		}
		
		/************************************************************************************************/
		/*	Handler																						*/
		/************************************************************************************************/
		private function onLoadingCompleted(event:LoaderManagerEvent):void 
		{
			var loadPacket:LoadPacket = event.packetReference;
			
			//Update the cache
			_localCache[loadPacket.filePath] = event.packetReference;
			
			//Trigger the callback
			event.packetReference.triggerCallback();
			
			//Update processing list
			var index:int = _processingPacketList.indexOf(loadPacket);
			_processingPacketList.splice(index, 1);
			
			//Dispatch the event outside
			onEvent(event);
			
			//Evaluate statistic
			evaluatePacketStatistic(loadPacket);
		}
		
		private function onLoadingCanceled(event:LoaderManagerEvent):void 
		{
			//Update the cache
			_localCache[event.packetReference.filePath] = event.packetReference;
			
			//Update processing list
			var index:int = _processingPacketList.indexOf(event.packetReference);
			_processingPacketList.splice(index, 1);
			
			//Dispatch the event outside
			onEvent(event);
			
			//Evaluate statistic
			evaluatePacketStatistic(event.packetReference);
		}
		
		private function onLoadingStart(event:LoaderManagerEvent):void 
		{
			//Dispatch the event outside
			onEvent(event);
		}
		
		private function onWorkerFree(event:LoaderManagerEvent):void 
		{
			//If there is to much worker, we should remove the worker if it has finished is task
			if (balanceWorker.length > _maxNumberOfWorker)
			{
				balanceWorker();
				return;
			}
			
			//Check if there is pending packet
			checkForPendingPacketToLoad();
		}
		
		private function onGroupStateChanged(event:LoaderManagerEvent):void 
		{
			if (event.groupReference.state == ELoadGroupState.COMPLETED)
			{
				unregisterGroup(event.groupReference);
			}
		}
		
		public function update(aFrameCount:uint):void 
		{
			
		}
		
		public function onUpdate(timeSpent:int):void
		{
			var len:int = _requestedPacketList.length;
			if (len <= 0)
			{
				return;
			}
			
			var index:int;
			var buffer:LoadPacket = (_requestedPacketList.splice(index, 1)[0] as LoadPacket);
			for (index = len-1; index >= 0; index--) 
			{
				buffer.state = ELoadPacketState.LOADED;
				buffer.triggerCallback();
			}
		}
		
		private function onEvent(event:LoaderManagerEvent):void
		{
			dispatchEvent(event.getCopy());
		}
		
		/************************************************************************************************/
		/*	Getter / Setter																				*/
		/************************************************************************************************/
		public function get maxNumberOfWorker():int 
		{
			return _maxNumberOfWorker;
		}
		
		public function set maxNumberOfWorker(value:int):void 
		{
			_maxNumberOfWorker = value;
			
			balanceWorker();
		}
		
		public function get isVersioningActivated():Boolean 
		{
			return _isVersioningActivated;
		}
		
		public function set isVersioningActivated(value:Boolean):void 
		{
			_isVersioningActivated = value;
		}
		
		public function get versioningId():String 
		{
			return _versioningId;
		}
		
		public function set versioningId(value:String):void 
		{
			_versioningId = value;
		}
		
		/************************************************************************************************/
		/*	Utils																						*/
		/************************************************************************************************/
		/*public function dump():void
		{
			//Init var
			var packet:LoadPacket;
			
			//Dump header
			DebugUtils.print(DebugUtils.DEBUG_PRINT_CHANNEL, "********************************************************");
			DebugUtils.print(DebugUtils.DEBUG_PRINT_CHANNEL, "FWLLoader Memory Dump [START]");
            DebugUtils.print(DebugUtils.DEBUG_PRINT_CHANNEL, "********************************************************");
			
			//Dump general information
			DebugUtils.print(DebugUtils.DEBUG_PRINT_CHANNEL, "[ GENERAL INFORMATION ]---------------------------------");
			DebugUtils.print(DebugUtils.DEBUG_PRINT_CHANNEL, "Current number of worker = " + m_workerList.length);
			DebugUtils.print(DebugUtils.DEBUG_PRINT_CHANNEL, "Current number of pending packet = " + m_pendingPacketList.length);
			DebugUtils.print(DebugUtils.DEBUG_PRINT_CHANNEL, "Current number of processing packet = " + m_processingPacketList.length);
			if (m_biggestFileLoaded)
			{
				DebugUtils.print(DebugUtils.DEBUG_PRINT_CHANNEL, "Biggest packet loaded = " + LoadPacket(m_localCache[m_biggestFileLoaded.filePath]).toString());
			}
			if (m_longestLoadingTime)
			{
				DebugUtils.print(DebugUtils.DEBUG_PRINT_CHANNEL, "Longest packet load time = " + LoadPacket(m_localCache[m_longestLoadingTime.filePath]).toString());
			}
			DebugUtils.print(DebugUtils.DEBUG_PRINT_CHANNEL, "--------------------------------------------------------");
			
			//Dump cache content
			DebugUtils.print(DebugUtils.DEBUG_PRINT_CHANNEL, "[ CACHE CONTENT ]---------------------------------");
			for each (packet in m_localCache) 
			{
				DebugUtils.print(DebugUtils.DEBUG_PRINT_CHANNEL, packet.toString());
			}
			DebugUtils.print(DebugUtils.DEBUG_PRINT_CHANNEL, "--------------------------------------------------------");
			
			//Dump pending content
			DebugUtils.print(DebugUtils.DEBUG_PRINT_CHANNEL, "[ PENDING CONTENT ]---------------------------------");
			for each (packet in m_pendingPacketList) 
			{
				DebugUtils.print(DebugUtils.DEBUG_PRINT_CHANNEL, packet.toString());
			}
			DebugUtils.print(DebugUtils.DEBUG_PRINT_CHANNEL, "--------------------------------------------------------");
			
			//Dump processing content
			DebugUtils.print(DebugUtils.DEBUG_PRINT_CHANNEL, "[ PROCESSING CONTENT ]---------------------------------");
			for each (packet in m_processingPacketList) 
			{
				DebugUtils.print(DebugUtils.DEBUG_PRINT_CHANNEL, packet.toString());
			}
			DebugUtils.print(DebugUtils.DEBUG_PRINT_CHANNEL, "--------------------------------------------------------");
			
			//Dump foot
			DebugUtils.print(DebugUtils.DEBUG_PRINT_CHANNEL, "********************************************************");
			DebugUtils.print(DebugUtils.DEBUG_PRINT_CHANNEL, "FWLLoader Memory Dump [END]");
            DebugUtils.print(DebugUtils.DEBUG_PRINT_CHANNEL, "********************************************************");
		}*/
	}
}