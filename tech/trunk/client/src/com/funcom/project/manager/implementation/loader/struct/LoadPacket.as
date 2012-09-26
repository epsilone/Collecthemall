/**
* @author Keven Poulin
*/

package com.funcom.project.manager.implementation.loader.struct 
{
	import com.funcom.project.manager.implementation.loader.enum.EFileType;
	import com.funcom.project.manager.implementation.loader.enum.ELoadPacketState;
	import com.funcom.project.manager.implementation.loader.event.LoaderManagerEvent;
	import com.funcom.project.utils.logic.IdGenerator;
	import flash.events.EventDispatcher;
	import flash.system.ApplicationDomain;
	
	public class LoadPacket extends EventDispatcher
	{
		/************************************************************************************************/
		/*	Const var																					*/
		/************************************************************************************************/
		
		/************************************************************************************************/
		/*	Member var																					*/
		/************************************************************************************************/
		//Config
		private var m_id:int;
		private var m_filePath:String;
		private var m_fileType:EFileType;
		private var m_callbackList:Vector.<Function>;
		private var m_applicationDomain:ApplicationDomain;
		private var m_loaderPriority:int;
		private var m_avoidCaching:Boolean;
		
		//Management
		private var m_state:String;
		
		//Content
		private var m_bytesLoaded:Number = 0;
		private var m_bytesTotal:Number = 0;
		private var m_timeToLoad:int = 0;
		private var m_content:*;
		
		/************************************************************************************************/
		/*	Constructor / Init / Dispose																*/
		/************************************************************************************************/
		public function LoadPacket(filePath:String, fileType:EFileType, callback:Function = null, applicationDomain:ApplicationDomain = null, loaderPriority:int = 1, avoidCaching:Boolean = false) 
		{
			init();
			
			m_filePath = filePath;
			m_fileType = fileType;
			
			if (m_fileType == EFileType.AUTO_FILE)
			{
				m_fileType = EFileType.getFileTypeByFilePath(m_filePath);
			}
			if (callback != null) { m_callbackList.push(callback); }
			m_applicationDomain = (applicationDomain != null) ? applicationDomain : ApplicationDomain.currentDomain;
			m_loaderPriority = loaderPriority;
			m_avoidCaching = avoidCaching;
		}
		
		private function init():void
		{
			m_callbackList = new Vector.<Function>;
			m_id = IdGenerator.getUniqueId();
			state = ELoadPacketState.PENDING;
		}
		
		/************************************************************************************************/
		/*	Public																						*/
		/************************************************************************************************/
		public function addCallbackList(callbackList:Vector.<Function>):void
		{
			for each (var callback:Function in callbackList) 
			{
				addCallback(callback);
			}
		}
		
		public function addCallback(callback:Function):void
		{
			//Basic validation
			if (callback == null)
			{
				return;
			}
			
			//Validate dupe entry
			for each (var callbackBuffer:Function in m_callbackList) 
			{
				if (callbackBuffer === callback)
				{
					return;
				}
			}
			
			//Add callback
			m_callbackList.push(callback);
		}
		
		public function triggerCallback():void
		{
			//Trigger all registered callback
			for each (var callback:Function in m_callbackList) 
			{
				callback.apply(null, [this]);
			}
			
			//Empty the callback list
			m_callbackList.length = 0;
		}
		
		public function compare(loadPacket:LoadPacket):Boolean
		{
			if (loadPacket.filePath == filePath)
			{
				return true;
			}
			else
			{
				return false;
			}
		}
		
		override public function toString():String
        {
			var output:String;
			output = "[LoadPacket - ";
			output += "Id=" + m_id.toString() + ", ";
			output += "FilePath=" + m_filePath + ", ";
			output += "FileType=" + m_fileType.type + ", ";
			output += "LoaderPriority=" + m_loaderPriority.toString() + ", ";
			output += "Status=" + m_state + ", ";
			output += "Bytes=" + m_bytesLoaded.toString() + "/" + m_bytesTotal.toString() + ", ";
			output += "Time to load=" + m_timeToLoad.toString() + "ms";
			output += "]"
            return output;
        }
		
		/************************************************************************************************/
		/*	Private																						*/
		/************************************************************************************************/
		
		/************************************************************************************************/
		/*	Handler																						*/
		/************************************************************************************************/
		
		/************************************************************************************************/
		/*	Getter / Setter																				*/
		/************************************************************************************************/
		public function get id():int 
		{
			return m_id;
		}
		
		public function get filePath():String 
		{
			return m_filePath;
		}
		
		public function get fileType():EFileType 
		{
			return m_fileType;
		}
		
		public function get callbackList():Vector.<Function> 
		{
			return m_callbackList;
		}
		
		public function get applicationDomain():ApplicationDomain 
		{
			return m_applicationDomain;
		}
		
		public function get loaderPriority():int 
		{
			return m_loaderPriority;
		}
		
		public function get bytesLoaded():Number 
		{
			return m_bytesLoaded;
		}
		
		public function set bytesLoaded(value:Number):void 
		{
			m_bytesLoaded = value;
		}
		
		public function get bytesTotal():Number 
		{
			return m_bytesTotal;
		}
		
		public function set bytesTotal(value:Number):void 
		{
			m_bytesTotal = value;
		}
		
		public function set loaderPriority(value:int):void 
		{
			m_loaderPriority = value;
		}
		
		public function get state():String 
		{
			return m_state;
		}
		
		public function set state(value:String):void 
		{
			if (m_state == value)
			{
				return;
			}
			
			m_state = value;
			
			dispatchEvent(new LoaderManagerEvent(LoaderManagerEvent.PACKET_STATE_CHANGED, this, null));
		}
		
		public function get content():* 
		{
			return m_content;
		}
		
		public function set content(value:*):void 
		{
			m_content = value;
		}
		
		public function get timeToLoad():int 
		{
			return m_timeToLoad;
		}
		
		public function set timeToLoad(value:int):void 
		{
			m_timeToLoad = value;
		}
		
		public function set applicationDomain(value:ApplicationDomain):void 
		{
			m_applicationDomain = value;
		}
		
		public function get avoidCaching():Boolean 
		{
			return m_avoidCaching;
		}
	}
}