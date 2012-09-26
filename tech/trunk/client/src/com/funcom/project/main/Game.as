package com.funcom.project.main
{
	import com.funcom.project.manager.enum.EManagerDefinition;
	import com.funcom.project.manager.event.ManagerEvent;
	import com.funcom.project.manager.implementation.layer.enum.ELayerDefinition;
	import com.funcom.project.manager.implementation.layer.ILayerManager;
	import com.funcom.project.manager.implementation.loader.ILoaderManager;
	import com.funcom.project.manager.implementation.module.enum.EModuleDefinition;
	import com.funcom.project.manager.implementation.module.event.ModuleManagerEvent;
	import com.funcom.project.manager.implementation.module.IModuleManager;
	import com.funcom.project.manager.implementation.update.IUpdateManager;
	import com.funcom.project.manager.importation.GameManagerImport;
	import com.funcom.project.manager.ManagerA;
	import com.funcom.project.service.enum.EServiceDefinition;
	import com.funcom.project.service.event.ServiceEvent;
	import com.funcom.project.service.implementation.time.ITimeService;
	import com.funcom.project.service.importation.GameServiceImport;
	import com.funcom.project.service.ServiceA;
	import com.funcom.project.utils.event.Listener;
	import com.funcom.project.utils.logic.step.ConcurrentStepController;
	import com.funcom.project.utils.logic.step.event.StepControllerEvent;
	import com.funcom.project.utils.logic.step.StepController;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	
	public class Game extends Sprite implements IGame
	{
		/************************************************************************************************************
		* Static/Constant variables																					*
		************************************************************************************************************/
		
		/************************************************************************************************************
		* Member Variables																							*
		************************************************************************************************************/
		//Manager
		private var _updateManager:IUpdateManager;
		private var _moduleManager:IModuleManager;
		
		//Management
		private var _initStepController:ConcurrentStepController;
		private var _gameStepController:StepController;
		
		/************************************************************************************************************
		* Constructor / Init / start																				*	
		************************************************************************************************************/
		public function Game()
		{
			
		}
		
		public function init():void
		{
			const definitionList:Vector.<EManagerDefinition> = EManagerDefinition.definitionList;
			_initStepController = new ConcurrentStepController("Game init step");
			_initStepController.addStep(1, initializeVar);
			_initStepController.addStep(2, initializeGameService, null, [1]);
			_initStepController.addStep(3, initializeGameManager, null, [2]);
			_initStepController.addStep(4, activateGameManager, null, [3]);
			_initStepController.addStep(5, getNeededGameManager, null, [4]);
			_initStepController.addStep(6, startUpdateManager, null, [5]);
			_initStepController.addStep(7, openHudModule, null, [6]);
			_initStepController.addStep(8, openWorldMapModule, null, [6]);
			_initStepController.addStep(9, openDebugModule, null, [6]);
			
			Listener.add(StepControllerEvent.ON_STEP_COMPLETED, _initStepController as IEventDispatcher, onInitStepCompleted);
			_initStepController.start();
		}
		
		public function start():void
		{
			_gameStepController = new StepController("Game step");
			_gameStepController.addStep(clearInitializationReference);
			_gameStepController.start();
		}
		
		/************************************************************************************************************
		* INIT STEP METHODS																							*
		************************************************************************************************************/
		private function initializeVar():void 
		{
			//TODO
			
			_initStepController.stepCompleted(1);
		}
		/*************************************************************/
		
		private function initializeGameService():void 
		{
			Listener.add(ServiceEvent.ON_SERVICE_INITIALIZED, ServiceA.dispatcher, onGameServiceInitialized);
			ServiceA.initializeService(GameServiceImport.getList());
		}
		
		private function onGameServiceInitialized(aEvent:ServiceEvent):void 
		{
			Listener.remove(ServiceEvent.ON_SERVICE_INITIALIZED, ServiceA.dispatcher, onGameServiceInitialized);
			_initStepController.stepCompleted(2);
		}
		/*************************************************************/
		
		private function initializeGameManager():void 
		{
			Listener.add(ManagerEvent.ON_MANAGER_INITIALIZED, ManagerA.dispatcher, onGameManagerInitialized);
			ManagerA.initializeManager(GameManagerImport.getList());
		}
		
		private function onGameManagerInitialized(aEvent:ManagerEvent):void 
		{
			Listener.remove(ManagerEvent.ON_MANAGER_INITIALIZED, ManagerA.dispatcher, onGameManagerInitialized);
			_initStepController.stepCompleted(3);
		}
		/*************************************************************/
		
		private function activateGameManager():void 
		{
			Listener.add(ManagerEvent.ON_MANAGER_ACTIVATED, ManagerA.dispatcher, onGameManagerActivated);
			ManagerA.activateManager(GameManagerImport.getList());
		}
		
		private function onGameManagerActivated(aEvent:ManagerEvent):void 
		{
			Listener.remove(ManagerEvent.ON_MANAGER_INITIALIZED, ManagerA.dispatcher, onGameManagerActivated);
			_initStepController.stepCompleted(4);
		}
		/*************************************************************/
		
		private function getNeededGameManager():void 
		{
			_updateManager = ManagerA.getManager(EManagerDefinition.UPDATE_MANAGER) as IUpdateManager;
			_moduleManager = ManagerA.getManager(EManagerDefinition.MODULE_MANAGER) as IModuleManager;
			
			_initStepController.stepCompleted(5);
		}
		/*************************************************************/
		
		private function startUpdateManager():void 
		{
			Listener.add(Event.ENTER_FRAME, this.stage as IEventDispatcher, onUpdate);
			_updateManager.start();
			
			_initStepController.stepCompleted(6);
		}
		/*************************************************************/
		
		private function openHudModule():void 
		{
			Listener.add(ModuleManagerEvent.MODULE_OPENED,_moduleManager, onHudModuleOpened);
			_moduleManager.launchModule(EModuleDefinition.HUD);
		}
		
		private function onHudModuleOpened(aEvent:ModuleManagerEvent):void 
		{
			if (aEvent.moduleDefinition == EModuleDefinition.HUD)
			{
				Listener.remove(ModuleManagerEvent.MODULE_OPENED,_moduleManager, onHudModuleOpened);
				_initStepController.stepCompleted(7);
			}
		}
		/*************************************************************/
		
		private function openWorldMapModule():void 
		{
			Listener.add(ModuleManagerEvent.MODULE_OPENED,_moduleManager, onWorldMapModuleOpened);
			_moduleManager.launchModule(EModuleDefinition.WORLD_MAP);
		}
		
		private function onWorldMapModuleOpened(aEvent:ModuleManagerEvent):void 
		{
			if (aEvent.moduleDefinition == EModuleDefinition.WORLD_MAP)
			{
				Listener.remove(ModuleManagerEvent.MODULE_OPENED,_moduleManager, onWorldMapModuleOpened);
				_initStepController.stepCompleted(8);
			}
		}
		/*************************************************************/
		private function openDebugModule():void 
		{
			Listener.add(ModuleManagerEvent.MODULE_OPENED,_moduleManager, onDebugModuleOpened);
			_moduleManager.launchModule(EModuleDefinition.DEBUG);
		}
		
		private function onDebugModuleOpened(aEvent:ModuleManagerEvent):void 
		{
			if (aEvent.moduleDefinition == EModuleDefinition.WORLD_MAP)
			{
				Listener.remove(ModuleManagerEvent.MODULE_OPENED,_moduleManager, onDebugModuleOpened);
				_initStepController.stepCompleted(9);
			}
		}
		/*************************************************************/
		
		
		/************************************************************************************************************
		* GAME STEP METHODS																							*
		************************************************************************************************************/
		private function clearInitializationReference():void 
		{
			Listener.remove(StepControllerEvent.ON_STEP_COMPLETED, _initStepController as IEventDispatcher, onInitStepCompleted);
			_initStepController.destroy();
			_initStepController = null;
			
			_gameStepController.stepCompleted();
		}
		/*************************************************************/
		
		/************************************************************************************************************
		* Private Methods																							*
		************************************************************************************************************/

		/************************************************************************************************************
		* Handler Methods																							*
		************************************************************************************************************/
		private function onUpdate(aEvent:Event):void 
		{
			//Main game loop
			_updateManager.update();
		}
		
		private function onInitStepCompleted(aEvent:StepControllerEvent):void 
		{
			dispatchEvent(aEvent.clone());
		}
		
		/************************************************************************************************************
		* Getter/Setter Methods																						*
		************************************************************************************************************/
	}
}