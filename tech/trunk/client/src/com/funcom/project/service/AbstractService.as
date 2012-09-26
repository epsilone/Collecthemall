package com.funcom.project.service 
{
	import com.funcom.project.manager.enum.EManagerDefinition;
	import com.funcom.project.manager.implementation.console.enum.ELogType;
	import com.funcom.project.manager.implementation.console.Logger;
	import com.funcom.project.manager.implementation.loader.event.LoaderManagerEvent;
	import com.funcom.project.manager.implementation.loader.ILoaderManager;
	import com.funcom.project.manager.implementation.loader.LoaderManager;
	import com.funcom.project.manager.ManagerA;
	import com.funcom.project.service.enum.EServiceState;
	import com.funcom.project.service.event.ServiceEvent;
	import com.funcom.project.utils.flash.FlashUtil;
	import flash.events.EventDispatcher;
	import flash.utils.getTimer;
	
	public class AbstractService extends EventDispatcher implements IAbstractService 
	{
		/************************************************************************************************************
		* Static/Constant variables																					*
		************************************************************************************************************/

		/************************************************************************************************************
		* Member Variables																							*
		************************************************************************************************************/
		//Manager
		private var _loaderManager:ILoaderManager;
		
		private var _state:EServiceState = EServiceState.NOT_INITIALIZED;
		private var _timeStamp:int;
		
		/************************************************************************************************************
		* Constructor / Init / Dispose																				*	
		************************************************************************************************************/		
		public function AbstractService() 
		{
		}
		
		public function initialize():void
		{
			if (_state != EServiceState.NOT_INITIALIZED)
			{
				//TODO: log error
				return;
			}
			
			changeState(EServiceState.INITIALIZING);
		}
		
		/************************************************************************************************************
		* Private Methods																							*
		************************************************************************************************************/
		protected final function changeState(aState:EServiceState):void
		{
			_state = aState;
			
			switch(aState)
			{
				case EServiceState.NOT_INITIALIZED:
				{
					
					break;
				}
				case EServiceState.INITIALIZING:
				{
					_timeStamp = getTimer();
					break;
				}
				case EServiceState.INITIALIZED:
				{
					Logger.log(ELogType.TIME, FlashUtil.getClassName(this) + ".as", "ChangeState", "INITIALIZED in " + String(getTimer() - _timeStamp) + " ms.");
					dispatchEvent(new ServiceEvent(ServiceEvent.ON_SERVICE_INITIALIZED));
					break;
				}
			}
		}
		
		/************************************************************************************************************
		* Handler Methods																							*
		************************************************************************************************************/
		protected function onInitialized():void
		{
			changeState(EServiceState.INITIALIZED);
		}
		
		/************************************************************************************************************
		* Getter/Setter Methods																						*
		************************************************************************************************************/
		public final function get state():EServiceState 
		{
			return _state;
		}
		
		public function get loaderManager():ILoaderManager
		{
			if (_loaderManager == null)
			{
				_loaderManager = ManagerA.getManager(EManagerDefinition.LOADER_MANAGER) as LoaderManager;
			}
			
			return _loaderManager;
		}
	}
}