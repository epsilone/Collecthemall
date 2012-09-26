/**
* @author Keven Poulin
*/
package com.funcom.project.manager
{
	import com.funcom.project.manager.enum.EManagerDefinition;
	import com.funcom.project.manager.enum.EManagerState;
	import com.funcom.project.manager.event.ManagerEvent;
	import com.funcom.project.manager.IAbstractManager;
	import com.funcom.project.utils.event.Listener;
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	
	public class ManagerA
	{
		/************************************************************************************************************
		* Static/Constant variables																					*
		************************************************************************************************************/
		private static var _managerDict:Dictionary = new Dictionary();
		
		private static var _processingCount:int = 0;
		private static var _processingEventType:String = "";
		
		private static const _dispatcher:EventDispatcher = new EventDispatcher();
		
		/************************************************************************************************************
		* Member Variables																							*
		************************************************************************************************************/

		/************************************************************************************************************
		* Constructor / Init / Dispose																				*	
		************************************************************************************************************/
		public function ManagerA()
		{
			
		}

		/************************************************************************************************************
		* Public Methods																							*
		************************************************************************************************************/
		public static function initializeManager(aManagerDefinitionList:Vector.<EManagerDefinition>):void
		{
			if (_processingCount > 0)
			{
				//TODO: log error: Impossible to start 2 process in the same time in the ManagerA
				return;
			}
			
			var managerDefinition:EManagerDefinition;
			var manager:IAbstractManager;
			var waitingAsynchProcess:Boolean = false;
			
			_processingEventType = ManagerEvent.ON_MANAGER_INITIALIZED;
			_processingCount = aManagerDefinitionList.length;
			
			for each (managerDefinition in aManagerDefinitionList) 
			{
				manager = getManagerByDefinition(managerDefinition);
				
				if (manager.state.stateValue <= EManagerState.INITIALIZING.stateValue)
				{
					waitingAsynchProcess = true;
					Listener.add(_processingEventType, manager as EventDispatcher, onProcess);
					
					if (manager.state.stateValue <= EManagerState.NOT_INITIALIZED.stateValue)
					{
						manager.initialize();
					}
				}
			}
			
			if (!waitingAsynchProcess)
			{
				onProcess();
			}
		}
		
		public static function activateManager(aManagerDefinitionList:Vector.<EManagerDefinition>):void
		{
			if (_processingCount > 0)
			{
				//TODO: log error: Impossible to start 2 process in the same time in the ManagerA
				return;
			}
			
			var managerDefinition:EManagerDefinition;
			var manager:IAbstractManager;
			var waitingAsynchProcess:Boolean = false;
			
			_processingEventType = ManagerEvent.ON_MANAGER_ACTIVATED;
			
			_processingCount = aManagerDefinitionList.length;

			for each (managerDefinition in aManagerDefinitionList) 
			{
				manager = getManagerByDefinition(managerDefinition);
				
				if (manager.state.stateValue >= EManagerState.INITIALIZED.stateValue &&
					manager.state.stateValue <= EManagerState.ACTIVATING.stateValue)
				{
					waitingAsynchProcess = true;
					Listener.add(_processingEventType, manager as EventDispatcher, onProcess);
					
					if (manager.state.stateValue <= EManagerState.INITIALIZED.stateValue)
					{
						manager.activate();
					}
				}
			}
			
			if (!waitingAsynchProcess)
			{
				onProcess();
			}
		}
		
		public static function getManager(aManagerDefinition:EManagerDefinition):IAbstractManager
		{
			if (hasManager(aManagerDefinition))
			{
				return _managerDict[aManagerDefinition.id] as IAbstractManager;
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
		public static function hasManager(aManagerDefinition:EManagerDefinition):Boolean
		{
			if (_managerDict[aManagerDefinition.id] != null)
			{
				return true;
			}
			else
			{
				return false;
			}
		}
		
		private static function getManagerByDefinition(aManagerDefinition:EManagerDefinition):IAbstractManager
		{
			if (hasManager(aManagerDefinition))
			{
				return _managerDict[aManagerDefinition.id] as IAbstractManager;
			}
			
			var managerClass:Class = getDefinitionByName(aManagerDefinition.className) as Class;
			var instance:IAbstractManager = new managerClass();
			
			registerManagerInstance(aManagerDefinition, instance);
			
			return instance;
		}
		
		private static function registerManagerInstance(aManagerDefinition:EManagerDefinition, aManagerInstance:IAbstractManager):void
		{
			if (!hasManager(aManagerDefinition))
			{
				_managerDict[aManagerDefinition.id] = aManagerInstance;
			}
			else
			{
				//TODO: Log warning 
			}
		}
		/************************************************************************************************************
		* Handler Methods																							*
		************************************************************************************************************/
		static private function onProcess(aEvent:ManagerEvent = null):void 
		{
			if (aEvent != null)
			{
				Listener.remove(_processingEventType, aEvent.target as EventDispatcher, onProcess);
				_processingCount--;
			}
			
			if (_processingCount <= 0)
			{
				_processingCount = 0;
				_dispatcher.dispatchEvent(new ManagerEvent(_processingEventType));
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