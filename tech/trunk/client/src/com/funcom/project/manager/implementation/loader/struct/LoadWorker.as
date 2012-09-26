/**
* @author Keven Poulin
*/
package com.funcom.project.manager.implementation.loader.struct 
{
	import com.funcom.project.manager.implementation.console.enum.ELogType;
	import com.funcom.project.manager.implementation.console.Logger;
	import com.funcom.project.manager.implementation.loader.enum.EFileType;
	import com.funcom.project.manager.implementation.loader.enum.ELoaderType;
	import com.funcom.project.manager.implementation.loader.enum.ELoadPacketState;
	import com.funcom.project.manager.implementation.loader.event.LoaderManagerEvent;
	import flash.display.Bitmap;
	import flash.display.DisplayObjectContainer;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.media.Sound;
	import flash.media.SoundLoaderContext;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import flash.system.Security;
	import flash.system.SecurityDomain;
	import flash.text.StyleSheet;
	import flash.utils.ByteArray;
	import flash.utils.getTimer;
	
	public class LoadWorker extends EventDispatcher implements IEventDispatcher
	{
		/************************************************************************************************/
		/*	Const var																					*/
		/************************************************************************************************/
		private const MAX_NUMBER_OF_RETRY:int = 3;
		
		/************************************************************************************************/
		/*	Member var																					*/
		/************************************************************************************************/
		//Ref Container
		private var _currentPacket:LoadPacket;
		
		//Management
		private var _loader:Loader;
		private var _urlLoader:URLLoader;
		private var _soundLoader:Sound;
		private var _isProcessing:Boolean;
		private var _numberOfRetry:int;
		private var _loadingTimeStamp:int;
		
		/************************************************************************************************/
		/*	Constructor / Init / Dispose																*/
		/************************************************************************************************/
		public function LoadWorker() 
		{
			init();
		}
		
		private function init():void
		{
			//Init var
			_loader = new Loader();
			_urlLoader = new URLLoader();
			_numberOfRetry = 0;
			_loadingTimeStamp = -1;
			
			//Register event
			registerEvent();
		}
		
		public function dispose():void
		{
			//Unregister event
			unregisterEvent();
			unregisterSoundLoaderEvent(_soundLoader);
		}
		
		/************************************************************************************************/
		/*	Public																						*/
		/************************************************************************************************/
		public function Load(loadPacket:LoadPacket):void
		{
			//Basic condition
			if (isProcessing)
			{
				return;
			}
			
			if (_loadingTimeStamp == -1)
			{
				_loadingTimeStamp = getTimer();
			}
			
			//Init var
			var urlRequest:URLRequest;
			var loaderContext:LoaderContext;
			var soundLoaderContext:SoundLoaderContext;
			
			//Raise processing flag
			_isProcessing = true;
			
			//Keep the packet in reference
			_currentPacket = loadPacket;
			_currentPacket.state = ELoadPacketState.LOADING;
			
			//Create UrlRequest
			urlRequest = new URLRequest(_currentPacket.filePath);
			//urlRequest.url = formatUrl(urlRequest.url);
			
			//Client versionning
			if (!_currentPacket.avoidCaching)
			{
				//TODO urlRequest.url += "?" + m_loaderService.versionningId;
			}
			else
			{
				urlRequest.url += "?" + new Date().getTime().toString();
			}
			
			//Use the correct loader depending of the file type to load
			switch (_currentPacket.fileType.loaderType)
			{
				case ELoaderType.LOADER:
				{
					loaderContext = new LoaderContext(true, _currentPacket.applicationDomain);
					if (Security.sandboxType == Security.REMOTE)
					{
						loaderContext.securityDomain = SecurityDomain.currentDomain;
					}
					_loader.load(urlRequest, loaderContext);
					break;
				}
				case ELoaderType.URL_LOADER:
				{
					if (_currentPacket.fileType == EFileType.BINARY_FILE || _currentPacket.fileType == EFileType.ZLIB_XML_FILE)
					{
						_urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
					}
					else
					{
						_urlLoader.dataFormat = URLLoaderDataFormat.TEXT;
					}
					_urlLoader.load(urlRequest); 
					break;
				}
				case ELoaderType.SOUND_LOADER:
				{
					soundLoaderContext = new SoundLoaderContext(1000, true);
					_soundLoader = new Sound();
					registerSoundLoaderEvent(_soundLoader);
					_soundLoader.load(urlRequest, soundLoaderContext);
					break;
				}
			}
			Logger.log(ELogType.INFO, "LoadWorker.as", "Load", "Start Loading. - [File: " + _currentPacket.filePath + "]");
		}
		
		private function formatUrl(url:String):String 
		{
			var index:int;
			var buffer:String;
			var isSecure:Boolean;
			
			//Check if secure
			isSecure = Boolean(url.indexOf("https") != -1);
			
			//Import case
			buffer = "[[IMPORT]]/";
			index = url.indexOf(buffer);
			if (index != -1)
			{
				url = url.substr(index + buffer.length);
			}
			
			//Check if the url is well formed
			if (url.indexOf("http") == -1)
			{
				if (isSecure)
				{
					url = "https://" + url;
				}
				else
				{
					url = "http://" + url;
				}
			}
			
			return url;
		}
		
		/************************************************************************************************/
		/*	Private																						*/
		/************************************************************************************************/
		private function registerSoundLoaderEvent(soundLoader:Sound):void
		{
			if (!soundLoader)
			{
				return;
			}
			
			//Sound Loader
			soundLoader.addEventListener(Event.COMPLETE, onComplete, false, 0, true);
			soundLoader.addEventListener(ProgressEvent.PROGRESS, onProgress, false, 0, true);
			soundLoader.addEventListener(IOErrorEvent.IO_ERROR, onFailed, false, 0, true);
			soundLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError, false, 0, true);
		}
		
		private function unregisterSoundLoaderEvent(soundLoader:Sound):void
		{
			if (!soundLoader)
			{
				return;
			}
			
			//Sound Loader
			soundLoader.removeEventListener(Event.COMPLETE, onComplete);
			soundLoader.removeEventListener(ProgressEvent.PROGRESS, onProgress);
			soundLoader.removeEventListener(IOErrorEvent.IO_ERROR, onFailed);
			soundLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
		}
		
		private function registerEvent():void
		{
			//loader
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onComplete, false, 0, true);
			_loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onProgress, false, 0, true);
			_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onFailed, false, 0, true);
			_loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError, false, 0, true);
			
			//URL loader
			_urlLoader.addEventListener(Event.COMPLETE, onComplete, false, 0, true);
			_urlLoader.addEventListener(ProgressEvent.PROGRESS, onProgress, false, 0, true);
			_urlLoader.addEventListener(IOErrorEvent.IO_ERROR, onFailed, false, 0, true);
			_urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError, false, 0, true);
		}
		
		private function unregisterEvent():void
		{
			//Loader
			_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onComplete);
			_loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, onProgress);
			_loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onFailed);
			_loader.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
			
			//URL Loader
			_urlLoader.removeEventListener(Event.COMPLETE, onComplete);
			_urlLoader.removeEventListener(ProgressEvent.PROGRESS, onProgress);
			_urlLoader.removeEventListener(IOErrorEvent.IO_ERROR, onFailed);
			_urlLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
		}
		
		private function completeLoading():void
		{
			Logger.log(ELogType.INFO, "LoadWorker.as", "completeLoading", "Loading Completed. - [File: " + _currentPacket.filePath + "]");
			
			//Dispatch loading completed
			_currentPacket.state = ELoadPacketState.LOADED;
			_currentPacket.timeToLoad = getTimer() - _loadingTimeStamp;
			dispatchEvent(new LoaderManagerEvent(LoaderManagerEvent.LOADING_COMPLETED, _currentPacket, this));
		}
		
		private function freeWorker():void
		{
			//Drop processing flag
			_isProcessing = false;
			
			//Remove sound event
			unregisterSoundLoaderEvent(_soundLoader);
			
			//ReInit var
			_numberOfRetry = 0;
			_loadingTimeStamp = -1;
			
			dispatchEvent(new LoaderManagerEvent(LoaderManagerEvent.WORKER_FREE, _currentPacket, this));
		}
		
		private function formatContent():void 
		{
			if (!_currentPacket)
			{
				return;
			}
			
			switch(_currentPacket.fileType)
			{
				case EFileType.SWF_FILE:
				{
					if (_currentPacket.content is DisplayObjectContainer)
					{
						//TODO DisplayUtil.recursiveStop(m_currentPacket.content as DisplayObjectContainer);
					}
					break;
				}
				case EFileType.XML_FILE:
				{
					_currentPacket.content = new XML(_currentPacket.content);
					break;
				}
				case EFileType.ZLIB_XML_FILE:
				{
					try
					{
						var byteArray:ByteArray = _currentPacket.content as ByteArray;
						byteArray.uncompress();
						_currentPacket.content = XML(byteArray);
					}
					catch (e:Error)
					{
						_currentPacket.content = new XML(_currentPacket.content);
					}
					break;
				}
				case EFileType.CSS_FILE:
				{
					var sheet:StyleSheet = new StyleSheet();
					sheet.parseCSS(_currentPacket.content);
					_currentPacket.content = sheet;
					break;
				}
				case EFileType.IMG_FILE:
				{
					var bitmap:Bitmap = Bitmap(_currentPacket.content);
					_currentPacket.content = bitmap;
					break;
				}
			}
		}
		
		private function retryToLoad():void
		{
			if (_numberOfRetry >= MAX_NUMBER_OF_RETRY)
			{
				cancelLoading();
				return;
			}
			
			Logger.log(ELogType.WARNING, "LoadWorker.as", "retryToLoad", "A file has failed to load, the worker will retry the process. - [File: " + _currentPacket.filePath + "]");
			
			//Increment the number of try
			_numberOfRetry++;
			
			//Restart the loading
			_isProcessing = false;
			Load(_currentPacket);
		}
		
		private function cancelLoading():void
		{
			Logger.log(ELogType.ERROR, "LoadWorker.as", "cancelLoading", "A file is impossible to reach, the worker will cancel this load request. - [File: " + _currentPacket.filePath + "]");
			
			_currentPacket.timeToLoad = -1;
			_currentPacket.state = ELoadPacketState.FAILED;
			dispatchEvent(new LoaderManagerEvent(LoaderManagerEvent.LOADING_CANCELED, _currentPacket, this));
			freeWorker();
		}
		
		/************************************************************************************************/
		/*	Handler																						*/
		/************************************************************************************************/
		private function onComplete(event:Event):void 
		{
			//Save the data in the packet
			switch (_currentPacket.fileType.loaderType)
			{
				case ELoaderType.LOADER:
				{
					var debug1:LoaderInfo = _loader.contentLoaderInfo;
					var debug2:LoaderInfo = _loader.loaderInfo;
					_currentPacket.content = event.currentTarget.content;
					break;
				}
				case ELoaderType.URL_LOADER:
				{
					if (event.target.hasOwnProperty("data"))
					{
						_currentPacket.content = event.target.data;
					}
					break;
				}
				case ELoaderType.SOUND_LOADER:
				{
					unregisterSoundLoaderEvent(_soundLoader);
					_currentPacket.content = _soundLoader;
					break;
				}
			}
			
			formatContent();
			
			completeLoading();
			
			freeWorker();
		}
		
		private function onProgress(event:ProgressEvent):void 
		{
			var customEvent:LoaderManagerEvent = new LoaderManagerEvent(LoaderManagerEvent.LOADING_PROGRESS, _currentPacket, this);
			//Keep the data in the packet object
			_currentPacket.bytesLoaded = event.bytesLoaded;
			_currentPacket.bytesTotal = event.bytesTotal;
			
			//Dispatch progress event
			dispatchEvent(customEvent);
		}
		
		private function onFailed(event:IOErrorEvent):void 
		{
			//We will retry to load it
			retryToLoad();
		}
		
		private function onSecurityError(e:SecurityErrorEvent):void 
		{
			//There is nothing to do, cancel this request
			cancelLoading();
		}
		
		/************************************************************************************************/
		/*	Getter / Setter																				*/
		/************************************************************************************************/
		public function get isProcessing():Boolean 
		{
			return _isProcessing;
		}
	}
}