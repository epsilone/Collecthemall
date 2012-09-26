/**
 * @author Keven Poulin
 * @compagny Funcom
 */
package com.funcom.project.manager.implementation.module 
{
	import com.funcom.project.manager.AbstractManager;
	import com.funcom.project.manager.enum.EManagerDefinition;
	import com.funcom.project.manager.implementation.console.enum.ELogType;
	import com.funcom.project.manager.implementation.console.Logger;
	import com.funcom.project.manager.implementation.module.enum.EModuleDefinition;
	import com.funcom.project.manager.implementation.module.enum.EModuleType;
	import com.funcom.project.manager.implementation.module.event.ModuleManagerEvent;
	import com.funcom.project.manager.implementation.module.struct.AbstractModule;
	import com.funcom.project.manager.implementation.transition.enum.ETransitionDefinition;
	import com.funcom.project.manager.implementation.transition.ITransitionManager;
	import com.funcom.project.manager.ManagerA;
	import com.funcom.project.utils.event.Listener;
	import flash.events.IEventDispatcher;
	
	public class ModuleManager extends AbstractManager implements IModuleManager 
	{
		/************************************************************************************************************
		* Static/Constant variables																					*
		************************************************************************************************************/

		/************************************************************************************************************
		* Member Variables																							*
		************************************************************************************************************/
		//Manager
		private var _transitionManager:ITransitionManager;
		
		//Reference holder
		private var _screenModuleList:Vector.<AbstractModule>;
		private var _standAloneModuleList:Vector.<AbstractModule>;
		private var _transitionDefinitionRequested:ETransitionDefinition;
		
		/************************************************************************************************************
		* Constructor / Init / Dispose																				*	
		************************************************************************************************************/
		public function ModuleManager() 
		{
			
		}
		
		override public function activate():void 
		{
			super.activate();
			
			_transitionManager = ManagerA.getManager(EManagerDefinition.TRANSITION_MANAGER) as ITransitionManager;
			
			onActivated();
		}
		
		/************************************************************************************************************
		* Public Methods																							*
		************************************************************************************************************/
		public function launchModule(aModuleDefinition:EModuleDefinition, aModuleParameter:Array = null, aTransitionDefinition:ETransitionDefinition = null):void
		{
			Logger.log(ELogType.INFO, "ModuleManager.as", "launchModule", "The opening of the module [" + aModuleDefinition.name + "] has been requested.");
			var moduleInstance:AbstractModule = new aModuleDefinition.instanceClass() as AbstractModule;
			moduleInstance.setModuleParameter(aModuleParameter);
			
			_transitionDefinitionRequested = aTransitionDefinition;
			
			addModule(moduleInstance);
			
			switch(aModuleDefinition.moduleType)
			{
				case EModuleType.STAND_ALONE:
				{
					moduleInstance.activate();
					Logger.log(ELogType.INFO, "ModuleManager.as", "launchModule", "The module [" + aModuleDefinition.name + "] will be open has stand alone.");
					break;
				}
				case EModuleType.SCREEN:
				{
					if (_screenModuleList.length <= 1)
					{
						moduleInstance.activate();
					}
					else
					{
						if (_transitionDefinitionRequested != null)
						{
							_transitionManager.openTransition(_transitionDefinitionRequested, closePreviousScreen);
						}
						else
						{
							closePreviousScreen();
						}
					}
					break;
				}
			}
		}
		
		public function isModuleOpen(aModuleDefinition:EModuleDefinition):Boolean
		{
			var moduleBuffer:AbstractModule = getModuleInstance(aModuleDefinition);
			
			if (moduleBuffer != null)
			{
				return true;
			}
			else
			{
				return false;
			}
		}
		
		public function getModuleInstance(aModuleDefinition:EModuleDefinition):AbstractModule
		{
			var moduleBuffer:AbstractModule;
			
			//Screen
			for each (moduleBuffer in _screenModuleList) 
			{
				if (moduleBuffer.moduleDefinition.id == aModuleDefinition.id)
				{
					return moduleBuffer;
				}
			}
			
			//Stand alone
			for each (moduleBuffer in _standAloneModuleList) 
			{
				if (moduleBuffer.moduleDefinition.id == aModuleDefinition.id)
				{
					return moduleBuffer;
				}
			}
			
			return null;
		}
		
		/************************************************************************************************************
		* Private Methods																							*
		************************************************************************************************************/
		override protected function init():void 
		{
			_screenModuleList = new Vector.<AbstractModule>();
			_standAloneModuleList = new Vector.<AbstractModule>();
			
			super.init();
		}
		
		private function registerModuleEvent(aModule:AbstractModule):void
		{
			if (aModule == null)
			{
				return;
			}
			
			Listener.add(ModuleManagerEvent.MODULE_OPENING, (aModule as IEventDispatcher), onModuleOpening);
			Listener.add(ModuleManagerEvent.MODULE_OPENED, (aModule as IEventDispatcher), onModuleOpened);
			Listener.add(ModuleManagerEvent.MODULE_CLOSED, (aModule as IEventDispatcher), onModuleClosing);
			Listener.add(ModuleManagerEvent.MODULE_CLOSED, (aModule as IEventDispatcher), onModuleClosed);
		}
		
		private function unregisterModuleEvent(aModule:AbstractModule):void
		{
			if (aModule == null)
			{
				return;
			}
			
			Listener.remove(ModuleManagerEvent.MODULE_OPENING, (aModule as IEventDispatcher), onModuleOpening);
			Listener.remove(ModuleManagerEvent.MODULE_OPENED, (aModule as IEventDispatcher), onModuleOpened);
			Listener.remove(ModuleManagerEvent.MODULE_CLOSED, (aModule as IEventDispatcher), onModuleClosing);
			Listener.remove(ModuleManagerEvent.MODULE_CLOSED, (aModule as IEventDispatcher), onModuleClosed);
		}
		
		private function addModule(aModule:AbstractModule):void
		{
			registerModuleEvent(aModule);
			
			switch(aModule.moduleDefinition.moduleType)
			{
				case EModuleType.SCREEN:
				{
					_screenModuleList.push(aModule);
					break;
				}
				case EModuleType.STAND_ALONE:
				{
					_standAloneModuleList.push(aModule);
					break;
				}
			}
		}
		
		private function removeModule(aModule:AbstractModule):void
		{
			unregisterModuleEvent(aModule);
			var index:int;
			
			switch(aModule.moduleDefinition.moduleType)
			{
				case EModuleType.SCREEN:
				{
					index = _screenModuleList.indexOf(aModule);
					if (index != -1) { _screenModuleList.splice(index, 1);}
					break;
				}
				case EModuleType.STAND_ALONE:
				{
					index = _standAloneModuleList.indexOf(aModule);
					if (index != -1) { _standAloneModuleList.splice(index, 1);}
					break;
				}
			}
			
			if (index == -1)
			{
				Logger.log(ELogType.WARNING, "ModuleManager.as", "removeModule", "Module instance [" + aModule + "] is not registered.");
			}
		}
		
		private function closePreviousScreen():void 
		{
			var len:int = _screenModuleList.length - 1;
			for (var i:int = 0; i < len; i++) 
			{
				_screenModuleList[i].destroy();
			}
		}
		
		/************************************************************************************************************
		* Handler Methods																							*
		************************************************************************************************************/
		private function onModuleOpening(aEvent:ModuleManagerEvent):void 
		{
			
			dispatchEvent(aEvent.getCopy());
		}
		
		private function onModuleOpened(aEvent:ModuleManagerEvent):void 
		{
			_transitionManager.closeTransition();
			dispatchEvent(aEvent.getCopy());
		}
		
		private function onModuleClosing(aEvent:ModuleManagerEvent):void 
		{
			dispatchEvent(aEvent.getCopy());
		}
		
		private function onModuleClosed(aEvent:ModuleManagerEvent):void 
		{
			removeModule(aEvent.target as AbstractModule);
			dispatchEvent(aEvent.getCopy());
			
			if (_screenModuleList.length == 1)
			{
				_screenModuleList[0].activate();
			}
		}
		/************************************************************************************************************
		* Getter/Setter Methods																						*
		************************************************************************************************************/
	}
}