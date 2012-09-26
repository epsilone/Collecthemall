/**
* @author Keven Poulin
*/
package com.funcom.project.service
{
	import com.funcom.project.manager.implementation.console.enum.ELogType;
	import com.funcom.project.manager.implementation.console.Logger;
	import com.funcom.project.service.enum.EServiceDefinition;
	import com.funcom.project.service.enum.EServiceState;
	import com.funcom.project.service.event.ServiceEvent;
	import com.funcom.project.utils.event.Listener;
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	
	public class ServiceA
	{
		/************************************************************************************************************
		* Static/Constant variables																					*
		************************************************************************************************************/
		private static var _serviceDict:Dictionary = new Dictionary();
		private static var _usedServiceDict:Dictionary = new Dictionary();
		
		private static var _processingCount:int = 0;
		private static var _processingEventType:String = "";
		
		private static const _dispatcher:EventDispatcher = new EventDispatcher();
		
		/************************************************************************************************************
		* Member Variables																							*
		************************************************************************************************************/

		/************************************************************************************************************
		* Constructor / Init / Dispose																				*	
		************************************************************************************************************/
		public function ServiceA()
		{
			
		}

		/************************************************************************************************************
		* Public Methods																							*
		************************************************************************************************************/
		public static function initializeService(aServiceDefinitionList:Vector.<EServiceDefinition>):void
		{
			if (_processingCount > 0)
			{
				//TODO: log error: Impossible to start 2 process in the same time in the ServiceA
				return;
			}
			
			var serviceDefinition:EServiceDefinition;
			var service:IAbstractService;
			var waitingAsynchProcess:Boolean = false;
			
			_processingEventType = ServiceEvent.ON_SERVICE_INITIALIZED;
			_processingCount = aServiceDefinitionList.length;
			
			for each (serviceDefinition in aServiceDefinitionList) 
			{
				service = getServiceByDefinition(serviceDefinition);
				
				if (service.state.stateValue <= EServiceState.INITIALIZING.stateValue)
				{
					waitingAsynchProcess = true;
					Listener.add(_processingEventType, service as EventDispatcher, onProcess);
					
					if (service.state.stateValue <= EServiceState.NOT_INITIALIZED.stateValue)
					{
						service.initialize();
					}
				}
			}
			
			if (!waitingAsynchProcess)
			{
				onProcess();
			}
		}
		
		public static function getService(aServiceDefinition:EServiceDefinition):IAbstractService
		{
			if (hasService(aServiceDefinition))
			{
				if (_usedServiceDict[aServiceDefinition] != null)
				{
					Logger.log(ELogType.WARNING, "ServiceA.as", "getService", "The service [" + aServiceDefinition.className + "] is already used by someone else.");
					return null;
				}
				
				_usedServiceDict[aServiceDefinition] = true;
				return _serviceDict[aServiceDefinition.id] as IAbstractService;
			}
			else
			{
				//TODO: Log warning 
				return null;
			}
		}
		
		/************************************************************************************************************
		* Private Methods																							*
		************************************************************************************************************/
		public static function hasService(aServiceDefinition:EServiceDefinition):Boolean
		{
			if (_serviceDict[aServiceDefinition.id] != null)
			{
				return true;
			}
			else
			{
				return false;
			}
		}
		
		private static function getServiceByDefinition(aServiceDefinition:EServiceDefinition):IAbstractService
		{
			if (hasService(aServiceDefinition))
			{
				return _serviceDict[aServiceDefinition.id] as IAbstractService;
			}
			
			var serviceClass:Class = getDefinitionByName(aServiceDefinition.className) as Class;
			var instance:IAbstractService = new serviceClass();
			
			registerServiceInstance(aServiceDefinition, instance);
			
			return instance;
		}
		
		private static function registerServiceInstance(aServiceDefinition:EServiceDefinition, aServiceInstance:IAbstractService):void
		{
			if (!hasService(aServiceDefinition))
			{
				_serviceDict[aServiceDefinition.id] = aServiceInstance;
			}
			else
			{
				//TODO: Log warning 
			}
		}
		/************************************************************************************************************
		* Handler Methods																							*
		************************************************************************************************************/
		static private function onProcess(aEvent:ServiceEvent = null):void 
		{
			if (aEvent != null)
			{
				Listener.remove(_processingEventType, aEvent.target as EventDispatcher, onProcess);
				_processingCount--;
			}
			
			if (_processingCount <= 0)
			{
				_processingCount = 0;
				_dispatcher.dispatchEvent(new ServiceEvent(_processingEventType));
			}
		}
		
		/************************************************************************************************************
		* Getter/Setter Methods																						*
		************************************************************************************************************/
		static public function get dispatcher():EventDispatcher 
		{
			return _dispatcher;
		}
	}
}