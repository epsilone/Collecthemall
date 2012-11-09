/**
* @author Keven Poulin
* @compagny Funcom
*/
package com.funcom.project.module.hud
{
	import com.funcom.project.manager.enum.EManagerDefinition;
	import com.funcom.project.manager.implementation.layer.enum.ELayerDefinition;
	import com.funcom.project.manager.implementation.module.enum.EModuleDefinition;
	import com.funcom.project.manager.implementation.module.IModuleManager;
	import com.funcom.project.manager.implementation.module.struct.AbstractModule;
	import com.funcom.project.manager.implementation.transition.enum.ETransitionDefinition;
	import com.funcom.project.manager.ManagerA;
	import com.funcom.project.module.hud.component.packet.CardPackComponent;
	import com.funcom.project.utils.event.Listener;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
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
		private var _bookSelectionBtn:MovieClip;
		private var _friendbar:MovieClip;
		private var _cardPackComponent:CardPackComponent;
		
		/************************************************************************************************************
		* Constructor / Init / Dispose																				*	
		************************************************************************************************************/
		public function HudModule()
		{
			
		}
		
		override public function destroy():void 
		{
			//Release visual reference
			_bookSelectionBtn = null;
			_friendbar = null;
			
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
			_friendbar = _loaderManager.getSymbol(_moduleDefinition.assetFilePath, "FriendBar_HudModule") as MovieClip;
			_cardPackComponent = new CardPackComponent();
			
			_bookSelectionBtn = _friendbar["BookSelectionBtn"] as MovieClip;
			
			super.getvisualDefinition();
		}
		
		override protected function render():void 
		{
			//Friendbar
			_friendbar.x = (_resolutionManager.stageWidth * 0.5) - (_friendbar.width * 0.5);
			_friendbar.y = _resolutionManager.stageHeight - _friendbar.height - BOTTOM_MARGIN;
			
			//Packet component
			_cardPackComponent.x = _resolutionManager.stageWidth - _cardPackComponent.width - RIGHT_MARGIN;
			_cardPackComponent.y = TOP_MARGIN;
			
			super.render();
		}
		
		override protected function addVisualOnStage():void 
		{
			addChild(_friendbar);
			addChild(_cardPackComponent);
			
			super.addVisualOnStage();
		}
		
		override protected function registerEventListener():void 
		{
			Listener.add(MouseEvent.CLICK, _bookSelectionBtn, onBookSelectionClicked);
			
			super.registerEventListener();
		}
		
		override protected function unregisterEventListener():void 
		{
			Listener.remove(MouseEvent.CLICK, _bookSelectionBtn, onBookSelectionClicked);
			
			super.unregisterEventListener();
		}
		
		/************************************************************************************************************
		* Handler Methods																							*
		************************************************************************************************************/
		private function onBookSelectionClicked(aEvent:MouseEvent):void 
		{
			(ManagerA.getManager(EManagerDefinition.MODULE_MANAGER) as IModuleManager).launchModule(EModuleDefinition.BOOK_SELECTION, null, ETransitionDefinition.PROCESSING);
		}
		
		/************************************************************************************************************
		* Getter/Setter Methods																						*
		************************************************************************************************************/
	}
}