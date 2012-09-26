/**
 * @author Keven Poulin
 * @compagny Funcom
 */
package com.funcom.project.manager.implementation.module.struct 
{
	import com.funcom.project.manager.enum.EManagerDefinition;
	import com.funcom.project.manager.implementation.console.enum.ELogType;
	import com.funcom.project.manager.implementation.console.Logger;
	import com.funcom.project.manager.implementation.layer.enum.ELayerDefinition;
	import com.funcom.project.manager.implementation.layer.ILayerManager;
	import com.funcom.project.manager.implementation.loader.enum.EFileType;
	import com.funcom.project.manager.implementation.loader.ILoaderManager;
	import com.funcom.project.manager.implementation.loader.struct.LoadPacket;
	import com.funcom.project.manager.implementation.module.enum.EModuleDefinition;
	import com.funcom.project.manager.implementation.module.enum.EModuleState;
	import com.funcom.project.manager.implementation.module.event.ModuleManagerEvent;
	import com.funcom.project.manager.implementation.resolution.event.ResolutionManagerEvent;
	import com.funcom.project.manager.implementation.resolution.IResolutionManager;
	import com.funcom.project.manager.ManagerA;
	import com.funcom.project.utils.commoninterface.IDestroyable;
	import com.funcom.project.utils.event.Listener;
	import com.funcom.project.utils.flash.FlashUtil;
	import com.funcom.project.utils.logic.step.StepController;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	
	public class AbstractModule extends Sprite implements IDestroyable 
	{
		/************************************************************************************************************
		* Static/Constant variables																					*
		************************************************************************************************************/

		/************************************************************************************************************
		* Member Variables																							*
		************************************************************************************************************/
		//Manager
		protected var _loaderManager:ILoaderManager;
		protected var _layerManager:ILayerManager;
		protected var _resolutionManager:IResolutionManager;
		
		//Reference
		protected var _moduleDefinition:EModuleDefinition;
		protected var _moduleContainer:DisplayObjectContainer;
		protected var _moduleState:String;
		protected var _moduleParamater:Array;
		
		//Management
		protected var _initStepController:StepController;
		
		/************************************************************************************************************
		* Constructor / Init / Dispose																				*	
		************************************************************************************************************/		
		public function AbstractModule() 
		{
			init();
		}
		
		private function init():void
		{
			//Init base var
			_moduleDefinition = EModuleDefinition.getModuleDefinitionByModuleInstance(this);
			_initStepController = new StepController(FlashUtil.getClassName(this) + " Init Step");
			_moduleState = EModuleState.PENDING;
			
			//Create/Populate init step list
			populatePreInitStep();
			populateInitStep();
			populatePostInitStep();
		}
		
		public function setModuleParameter(aModuleParameter:Array = null):void
		{
			if (aModuleParameter == null) { aModuleParameter = new Array(); }
			
			_moduleParamater = aModuleParameter;
		}
		
		public function destroy():void 
		{
			unregisterEventListener();
			
			for (var index:int = 0; index < numChildren; index++)
			{
				var child:DisplayObject = getChildAt(index);
				if (child is IDestroyable)
				{
					IDestroyable(child).destroy();
				}
			}
			
			close();
			
			_moduleState = EModuleState.CLOSED;
			dispatchEvent(new ModuleManagerEvent(ModuleManagerEvent.MODULE_CLOSED, _moduleDefinition));
			_moduleDefinition = null;
			
			//Release manager reference
			_loaderManager = null;
			_layerManager = null;
			_resolutionManager = null;
		}
		
		/************************************************************************************************************
		* Public Methods																							*
		************************************************************************************************************/
		public function activate():void
		{
			_moduleState = EModuleState.OPENING;
			dispatchEvent(new ModuleManagerEvent(ModuleManagerEvent.MODULE_OPENING, _moduleDefinition));
			_initStepController.start();
		}
		
		/************************************************************************************************************
		* Protected Methods																							*
		************************************************************************************************************/
		protected function populateInitStep():void 
		{
			_initStepController.addStep(getvisualDefinition);
			_initStepController.addStep(render);
			_initStepController.addStep(addVisualOnStage);
			_initStepController.addStep(registerEventListener);
		}
		
		protected function initVar():void 
		{
			//OVERRIDE ME
			
			_initStepController.stepCompleted();
		}
		
		protected function getManagerDefinition():void 
		{
			_loaderManager = ManagerA.getManager(EManagerDefinition.LOADER_MANAGER) as ILoaderManager;
			_layerManager = ManagerA.getManager(EManagerDefinition.LAYER_MANAGER) as ILayerManager;
			_resolutionManager = ManagerA.getManager(EManagerDefinition.RESOLUTION_MANAGER) as IResolutionManager;
			
			_initStepController.stepCompleted();
		}
		
		protected function setModuleContainer():void 
		{
			_moduleContainer = _layerManager.getLayer(ELayerDefinition.MODULE);
			
			_initStepController.stepCompleted();
		}
		
		protected function getvisualDefinition():void 
		{
			//OVERRIDE ME
			
			_initStepController.stepCompleted();
		}
		
		protected function render():void 
		{
			//OVERRIDE ME
			
			if (_moduleState == EModuleState.OPENING)
			{
				_initStepController.stepCompleted();
			}
		}
		
		protected function addVisualOnStage():void 
		{
			//OVERRIDE ME
			
			_initStepController.stepCompleted();
		}
		
		protected function registerEventListener():void 
		{
			//OVERRIDE ME
			
			Listener.add(ResolutionManagerEvent.STAGE_RESIZE, _resolutionManager, onResize);
			
			_initStepController.stepCompleted();
		}
		
		protected function unregisterEventListener():void 
		{
			//OVERRIDE ME
			
			Listener.remove(ResolutionManagerEvent.STAGE_RESIZE, _resolutionManager, onResize);
		}
		
		/************************************************************************************************************
		* Private Methods																							*
		************************************************************************************************************/
		private function populatePreInitStep():void 
		{
			_initStepController.addStep(initVar);
			_initStepController.addStep(getManagerDefinition);
			_initStepController.addStep(loadModuleAsset);
			_initStepController.addStep(setModuleContainer);
		}
		
		private function populatePostInitStep():void 
		{
			_initStepController.addStep(initCompleted);
		}
		
		protected function initCompleted():void 
		{
			_initStepController.stepCompleted();
			
			open();
		}
		
		private function loadModuleAsset():void
		{
			if (_moduleDefinition.assetFilePath != "")
			{
				_loaderManager.load(_moduleDefinition.assetFilePath, EFileType.SWF_FILE, onModuleAssetLoaded);
			}
			else
			{
				_initStepController.stepCompleted();
			}
		}
		
		private function onModuleAssetLoaded(aLoadPacket:LoadPacket):void
		{
			_initStepController.stepCompleted();
		}
		
		private function close():void
		{
			if (this.parent != null)
			{
				this.parent.removeChild(this);
				
				_moduleState = EModuleState.CLOSING;
				dispatchEvent(new ModuleManagerEvent(ModuleManagerEvent.MODULE_CLOSING, _moduleDefinition));
			}
			else
			{
				Logger.log(ELogType.WARNING, "AbstractModule.as", "close", "The module is not on the stage!");
			}
		}
		
		private function open():void
		{
			if (this.parent == null)
			{
				_moduleContainer.addChild(this);
				
				_moduleState = EModuleState.OPENED;
				dispatchEvent(new ModuleManagerEvent(ModuleManagerEvent.MODULE_OPENED, _moduleDefinition));
			}
			else
			{
				Logger.log(ELogType.WARNING, "AbstractModule.as", "open", "The module seem to already be on the stage!");
			}
		}
		
		/************************************************************************************************************
		* Handler Methods																							*
		************************************************************************************************************/
		private function onResize(aEvent:ResolutionManagerEvent):void 
		{
			if (_moduleDefinition.renderOnResize)
			{
				render();
			}
		}
		
		/************************************************************************************************************
		* Getter/Setter Methods																						*
		************************************************************************************************************/
		public function get moduleDefinition():EModuleDefinition 
		{
			return _moduleDefinition;
		}
		
		public function get moduleContainer():DisplayObjectContainer 
		{
			return _moduleContainer;
		}
		
		public function get moduleState():String 
		{
			return _moduleState;
		}
	}
}