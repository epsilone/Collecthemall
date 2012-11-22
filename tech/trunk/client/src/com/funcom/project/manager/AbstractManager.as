/**
* @author Keven Poulin
*/
package com.funcom.project.manager
{
	import com.funcom.project.controller.step.StepController;
	import com.funcom.project.manager.enum.EManagerDefinition;
	import com.funcom.project.manager.enum.EManagerState;
	import com.funcom.project.manager.event.ManagerEvent;
	import com.funcom.project.manager.implementation.console.enum.ELogType;
	import com.funcom.project.manager.implementation.console.Logger;
	import com.funcom.project.manager.implementation.loader.enum.EFileType;
	import com.funcom.project.manager.implementation.loader.ILoaderManager;
	import com.funcom.project.manager.implementation.loader.struct.LoadPacket;
	import com.funcom.project.service.AbstractService;
	import com.funcom.project.utils.flash.FlashUtil;
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	
	public class AbstractManager extends EventDispatcher implements IAbstractManager
	{
		/************************************************************************************************************
		* Static/Constant variables																					*
		************************************************************************************************************/

		/************************************************************************************************************
		* Member Variables																							*
		************************************************************************************************************/
		//Manager
		private var _loaderManager:ILoaderManager;
		
		//Reference holder
		protected var _managerDefinition:EManagerDefinition;
		
		//Management
		protected var _initStepController:StepController;
		private var _state:EManagerState = EManagerState.NOT_INITIALIZED;
		private var _timeStamp:int;
		
		/************************************************************************************************************
		* Constructor / Init / Dispose																				*	
		************************************************************************************************************/
		public function AbstractManager()
		{
			
		}
		
		/************************************************************************************************************
		* Public Methods																							*
		************************************************************************************************************/
		
		public function initialize():void
		{
			if (_state != EManagerState.NOT_INITIALIZED)
			{
				//TODO: log error
				return;
			}
			changeState(EManagerState.INITIALIZING);
			
			_initStepController = new StepController(FlashUtil.getClassName(this) + " Init Step");
			
			populateInitStep();
			populatePostInitStep();
			
			_initStepController.start();
		}
		
		public function activate():void
		{
			if (_state != EManagerState.INITIALIZED)
			{
				//TODO: log error
				return;
			}
			changeState(EManagerState.ACTIVATING);
		}
		/************************************************************************************************************
		* Private Methods																							*
		************************************************************************************************************/
		protected function populateInitStep():void 
		{
			_initStepController.addStep(getManagerDefinition);
			_initStepController.addStep(init);
			_initStepController.addStep(loadManagerAsset);
		}
		
		protected function getManagerDefinition():void 
		{
			_managerDefinition = EManagerDefinition.getManagerDefinitionByManagerInstance(this);
			
			_initStepController.stepCompleted();
		}
		
		protected function init():void 
		{
			//OVERRIDE ME
			
			_initStepController.stepCompleted();
		}
		
		protected function loadManagerAsset():void
		{
			if (_managerDefinition.assetFilePath != "")
			{
				loaderManager.load(_managerDefinition.assetFilePath, EFileType.SWF_FILE, onManagerAssetLoaded);
			}
			else
			{
				_initStepController.stepCompleted();
			}
		}
		
		protected function registerEvent():void 
		{
			
		}
		
		protected final function changeState(aManagerState:EManagerState):void
		{
			_state = aManagerState;
			
			switch(aManagerState)
			{
				case EManagerState.NOT_INITIALIZED:
				{
					
					break;
				}
				case EManagerState.INITIALIZING:
				case EManagerState.ACTIVATING:
				{
					_timeStamp = getTimer();
					break;
				}
				case EManagerState.INITIALIZED:
				{
					Logger.log(ELogType.TIME, FlashUtil.getClassName(this) + ".as", "ChangeState", "INITIALIZED in " + String(getTimer() - _timeStamp) + " ms.");
					dispatchEvent(new ManagerEvent(ManagerEvent.ON_MANAGER_INITIALIZED));
					break;
				}
				case EManagerState.ACTIVATED:
				{
					Logger.log(ELogType.TIME, FlashUtil.getClassName(this) + ".as", "ChangeState", "ACTIVATED in " + String(getTimer() - _timeStamp) + " ms.");
					dispatchEvent(new ManagerEvent(ManagerEvent.ON_MANAGER_ACTIVATED));
					break;
				}
			}
		}
		
		private function populatePostInitStep():void 
		{
			_initStepController.addStep(initCompleted);
		}
		
		protected function initCompleted():void 
		{
			_initStepController.stepCompleted();
			onInitialized();
		}
		
		/************************************************************************************************************
		* Handler Methods																							*
		************************************************************************************************************/
		protected function onInitialized():void
		{
			changeState(EManagerState.INITIALIZED);
		}
		
		protected function onActivated():void
		{
			changeState(EManagerState.ACTIVATED);
			
			registerEvent();
		}
		
		protected function onManagerAssetLoaded(aLoadPacket:LoadPacket):void
		{
			_initStepController.stepCompleted();
		}
		
		/************************************************************************************************************
		* Getter/Setter Methods																						*
		************************************************************************************************************/
		public final function get state():EManagerState 
		{
			return _state;
		}
		
		protected function get loaderManager():ILoaderManager
		{
			if (_loaderManager == null)
			{
				_loaderManager = ManagerA.getManager(EManagerDefinition.LOADER_MANAGER) as ILoaderManager;
			}
			
			return _loaderManager;
		}
	}
}
