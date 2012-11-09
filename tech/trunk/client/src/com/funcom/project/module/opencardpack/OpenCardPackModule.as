/**
* @author Keven Poulin
* @compagny Funcom
*/
package com.funcom.project.module.opencardpack
{
	import com.adobe.utils.IntUtil;
	import com.funcom.project.manager.enum.EManagerDefinition;
	import com.funcom.project.manager.implementation.inventory.IInventoryManager;
	import com.funcom.project.manager.implementation.loader.enum.EFileType;
	import com.funcom.project.manager.implementation.loader.struct.LoadPacket;
	import com.funcom.project.manager.implementation.module.struct.AbstractModule;
	import com.funcom.project.manager.ManagerA;
	import com.funcom.project.service.implementation.inventory.struct.item.CardPackItem;
	import com.funcom.project.service.implementation.inventory.struct.itemtemplate.CardPackItemTemplate;
	import flash.display.MovieClip;
	import flash.system.ApplicationDomain;
	
	public class OpenCardPackModule extends AbstractModule
	{
		/************************************************************************************************************
		* Static/Constant variables																					*
		************************************************************************************************************/
		//Class name
		private const MODULE_VISUAL_CLASS_NAME:String = "MainVisual_OpenCardPackModule";
		
		//Config
		
		/************************************************************************************************************
		* Member Variables																							*
		************************************************************************************************************/
		//Manager
		private var _inventoryManager:IInventoryManager;
		
		//Ref Holder
		private var _cardPackItem:CardPackItem;
		private var _cardPackItemTemplate:CardPackItemTemplate;
		
		//Visual ref
		private var _mainVisual:MovieClip;
		private var _cardVisual:MovieClip;
		
		//Management
		
		/************************************************************************************************************
		* Constructor / Init / Dispose																				*	
		************************************************************************************************************/
		public function OpenCardPackModule()
		{
			
		}
		
		override public function destroy():void 
		{
			//Release visual reference
			_mainVisual = null;
			
			super.destroy();
			
			//Release manager reference
			_inventoryManager = null;
		}
		
		/************************************************************************************************************
		* Private INIT STEP Methods																					*
		************************************************************************************************************/
		override protected function populateInitStep():void 
		{
			_initStepController.addStep(getvisualDefinition);
			_initStepController.addStep(loadCardVisual);
			_initStepController.addStep(render);
			_initStepController.addStep(addVisualOnStage);
			_initStepController.addStep(registerEventListener);
		}
		
		override protected function getManagerDefinition():void 
		{
			_inventoryManager = ManagerA.getManager(EManagerDefinition.INVENTORY_MANAGER) as IInventoryManager;
			
			super.getManagerDefinition();
		}
		
		override protected function initVar():void 
		{
			var cardPackItemId:int = _moduleParamater[0] as int;
			_cardPackItem = _inventoryManager.cache.getItemByItemId(cardPackItemId);
			_cardPackItemTemplate = _inventoryManager.cache.getItemTemplateByItemTemplateId(_cardPackItem.itemTemplateId);
			
			super.initVar();
		}
		
		override protected function getvisualDefinition():void 
		{
			_mainVisual = _loaderManager.getSymbol(_moduleDefinition.assetFilePath, MODULE_VISUAL_CLASS_NAME) as MovieClip;
			
			super.getvisualDefinition();
		}
		
		private function loadCardVisual():void 
		{
			_loaderManager.load(_cardPackItemTemplate.assetPath, EFileType.SWF_FILE, onCardVisualLoaded, new ApplicationDomain(ApplicationDomain.currentDomain));
		}
		
		override protected function render():void 
		{
			_mainVisual.x = 0;
			_mainVisual.y = 0;
			
			super.render();
		}
		
		override protected function addVisualOnStage():void 
		{
			addChild(_mainVisual);
			
			super.addVisualOnStage();
		}
		
		override protected function registerEventListener():void 
		{
			super.registerEventListener();
		}
		
		override protected function unregisterEventListener():void 
		{
			super.unregisterEventListener();
		}
		
		/************************************************************************************************************
		* Private Methods																							*
		************************************************************************************************************/
		
		/************************************************************************************************************
		* Handler Methods																							*
		************************************************************************************************************/
		private function onCardVisualLoaded(aLoadPacket:LoadPacket):void
		{
			_cardVisual = _loaderManager.getSymbol(_cardPackItemTemplate.assetPath, "itemAsset");
			
			_initStepController.stepCompleted();
		}
		
		/************************************************************************************************************
		* Getter/Setter Methods																						*
		************************************************************************************************************/
	}
}