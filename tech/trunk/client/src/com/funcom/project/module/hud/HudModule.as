/**
* @author Keven Poulin
* @compagny Funcom
*/
package com.funcom.project.module.hud
{
	import com.funcom.project.manager.implementation.layer.enum.ELayerDefinition;
	import com.funcom.project.manager.implementation.module.struct.AbstractModule;
	import flash.display.MovieClip;
	
	public class HudModule extends AbstractModule
	{
		/************************************************************************************************************
		* Static/Constant variables																					*
		************************************************************************************************************/
		private const LEFT_MARGIN:int = 10;
		private const RIGHT_MARGIN:int = 10;
		private const TOP_MARGIN:int = 10;
		private const BOTTOM_MARGIN:int = 10;
		
		/************************************************************************************************************
		* Member Variables																							*
		************************************************************************************************************/
		//Visual ref
		private var _avatarPicture:MovieClip;
		private var _friendbar:MovieClip;
		private var _progressbar:MovieClip;
		
		/************************************************************************************************************
		* Constructor / Init / Dispose																				*	
		************************************************************************************************************/
		public function HudModule()
		{
			
		}
		
		override public function destroy():void 
		{
			//Release visual reference
			_avatarPicture = null;
			_friendbar = null;
			_progressbar = null;
			
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
			super.populateInitStep();
		}
		
		override protected function setModuleContainer():void 
		{
			_moduleContainer = _layerManager.getLayer(ELayerDefinition.HUD);
			
			_initStepController.stepCompleted();
		}
		
		override protected function getvisualDefinition():void 
		{
			_avatarPicture = _loaderManager.getSymbol(_moduleDefinition.assetFilePath, "AvatarPicture_HudModule") as MovieClip;
			_friendbar = _loaderManager.getSymbol(_moduleDefinition.assetFilePath, "FriendBar_HudModule") as MovieClip;
			_progressbar = _loaderManager.getSymbol(_moduleDefinition.assetFilePath, "Progressbar_HudModule") as MovieClip;
			
			super.getvisualDefinition();
		}
		
		override protected function render():void 
		{
			//Avatar picture
			_avatarPicture.x = LEFT_MARGIN;
			_avatarPicture.y = TOP_MARGIN;
			
			//Progressbar
			_progressbar.x = _resolutionManager.stageWidth - _progressbar.width - RIGHT_MARGIN;
			_progressbar.y = TOP_MARGIN;
			
			//Friendbar
			_friendbar.x = (_resolutionManager.stageWidth * 0.5) - (_friendbar.width * 0.5);
			_friendbar.y = _resolutionManager.stageHeight - _friendbar.height - BOTTOM_MARGIN;
			
			super.render();
		}
		
		override protected function addVisualOnStage():void 
		{
			addChild(_avatarPicture);
			addChild(_progressbar);
			addChild(_friendbar);
			
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