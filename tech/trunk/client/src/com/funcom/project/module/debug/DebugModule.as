/**
* @author Keven Poulin
* @compagny Funcom
*/
package com.funcom.project.module.debug
{
	import com.funcom.project.manager.implementation.console.enum.ELogType;
	import com.funcom.project.manager.implementation.layer.enum.ELayerDefinition;
	import com.funcom.project.manager.implementation.module.struct.AbstractModule;
	import com.funcom.project.module.debug.struct.log.LogTypeMenu;
	import flash.display.MovieClip;
	import flash.text.TextField;
	
	public class DebugModule extends AbstractModule
	{
		/************************************************************************************************************
		* Static/Constant variables																					*
		************************************************************************************************************/
		
		/************************************************************************************************************
		* Member Variables																							*
		************************************************************************************************************/
		//Visual ref
		private var _versionComponent:MovieClip;
		private var _logTypeMenu:LogTypeMenu;
		
		/************************************************************************************************************
		* Constructor / Init / Dispose																				*	
		************************************************************************************************************/
		public function DebugModule()
		{
			
		}
		
		override public function destroy():void 
		{
			//Release visual reference
			_versionComponent = null;
			
			//LogType Menu
			if (_logTypeMenu)
			{
				if (_logTypeMenu.parent)
				{
					_logTypeMenu.parent.removeChild(_logTypeMenu);
				}
				_logTypeMenu.destroy();
				_logTypeMenu = null;
			}
			
			super.destroy();
		}

		/************************************************************************************************************
		* Public Methods																							*
		************************************************************************************************************/

		/************************************************************************************************************
		* Private Methods																							*
		************************************************************************************************************/
		override protected function populateInitStep():void 
		{
			_initStepController.addStep(getvisualDefinition);
			_initStepController.addStep(activateMenu);
			_initStepController.addStep(render);
			_initStepController.addStep(addVisualOnStage);
			_initStepController.addStep(registerEventListener);
		}
		
		override protected function setModuleContainer():void 
		{
			_moduleContainer = _layerManager.getLayer(ELayerDefinition.DEBUG);
			
			_initStepController.stepCompleted();
		}
		
		override protected function getvisualDefinition():void 
		{
			_versionComponent = _loaderManager.getSymbol(_moduleDefinition.assetFilePath, "VersionComponent_DebugModule") as MovieClip;
			_logTypeMenu = new LogTypeMenu();
			
			super.getvisualDefinition();
		}
		
		private function activateMenu():void 
		{
			//Version Component
			(_versionComponent["versionNumber"] as TextField). text = "0.0.1"; //TODO: Get this data from flashvar
			
			//LogType Menu
			_logTypeMenu.activate();
			
			_initStepController.stepCompleted();
		}
		
		override protected function render():void 
		{
			//Version Component
			_versionComponent.x = 0;
			_versionComponent.y = _resolutionManager.stageHeight - LogTypeMenu.FIXED_HEIGHT;
			
			//LogType Menu
			_logTypeMenu.x = _versionComponent.width;
			_logTypeMenu.y = _resolutionManager.stageHeight - LogTypeMenu.FIXED_HEIGHT;
			
			super.render();
		}
		
		override protected function addVisualOnStage():void 
		{
			addChild(_versionComponent);
			addChild(_logTypeMenu);
			
			super.addVisualOnStage();
		}
		
		override protected function registerEventListener():void 
		{
			super.registerEventListener();
		}
		
		/************************************************************************************************************
		* Handler Methods																							*
		************************************************************************************************************/
		
		/************************************************************************************************************
		* Getter/Setter Methods																						*
		************************************************************************************************************/
	}
}