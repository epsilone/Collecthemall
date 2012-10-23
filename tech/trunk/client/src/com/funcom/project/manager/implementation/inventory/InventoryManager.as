package com.funcom.project.manager.implementation.inventory 
{
	import com.funcom.project.manager.AbstractManager;
	import com.funcom.project.service.enum.EServiceDefinition;
	import com.funcom.project.service.implementation.inventory.event.InventoryServiceEvent;
	import com.funcom.project.service.implementation.inventory.IInventoryService;
	import com.funcom.project.service.implementation.inventory.struct.cache.ICacheObject;
	import com.funcom.project.service.implementation.inventory.struct.item.Item;
	import com.funcom.project.service.implementation.inventory.struct.itemtemplate.ItemTemplate;
	import com.funcom.project.service.ServiceA;
	import com.funcom.project.utils.event.Listener;
	
	public class InventoryManager extends AbstractManager implements IInventoryManager
	{
		/************************************************************************************************************
		* Static/Constant variables																					*
		************************************************************************************************************/

		/************************************************************************************************************
		* Member Variables																							*
		************************************************************************************************************/
		//Service
		private var _inventoryService:IInventoryService;
		
		/************************************************************************************************************
		* Constructor / Init / Dispose																				*	
		************************************************************************************************************/
		public function InventoryManager() 
		{
			
		}
		
		override public function activate():void 
		{
			super.activate();
			
			onActivated();
		}
		

		/************************************************************************************************/
		/*	Public (INPUT)																				*/
		/************************************************************************************************/
		public function put(aObject:ICacheObject):Boolean
		{
			return _inventoryService.cache.put(aObject);
		}
		
		public function remove(aObject:ICacheObject):Boolean
		{
			return _inventoryService.cache.remove(aObject);
		}
		
		/************************************************************************************************/
		/*	Public (OUTPUT)																				*/
		/************************************************************************************************/
		public function getItemByItemId(aItemId:int):Item
		{
			return _inventoryService.cache.getItemByItemId(aItemId);
		}
		
		public function getItemListByItemTemplateId(aItemTemplateId:int):Vector.<Item>
		{
			return _inventoryService.cache.getItemListByItemTemplateId(aItemTemplateId);
		}
		
		public function getItemTemplateByItemTemplateId(aItemTemplateId:int):ItemTemplate
		{
			return _inventoryService.cache.getItemTemplateByItemTemplateId(aItemTemplateId);
		}
		
		public function getItemTemplateListByItemTemplateTypeId(aItemTemplateTypeId:int):Vector.<ItemTemplate>
		{
			return _inventoryService.cache.getItemTemplateListByItemTemplateTypeId(aItemTemplateTypeId);
		}
		
		/************************************************************************************************************
		* Private Methods																							*
		************************************************************************************************************/
		override protected function populateInitStep():void 
		{
			super.populateInitStep();
			_initStepController.addStep(loadItemTemplate);
			_initStepController.addStep(getInventory);
		}
		
		override protected function init():void 
		{
			_inventoryService = ServiceA.getService(EServiceDefinition.INVENTORY_SERVICE) as IInventoryService;
			
			super.init();
		}
		
		private function loadItemTemplate():void 
		{
			Listener.add(InventoryServiceEvent.ON_ITEM_TEMPLATE_LOADED, _inventoryService, onItemTemplateLoaded);
			_inventoryService.loadItemTemplate();
		}
		
		private function getInventory():void 
		{
			Listener.add(InventoryServiceEvent.ON_GET_INVENOTRY, _inventoryService, onGetInventory);
			_inventoryService.getInventory();
		}
		
		/************************************************************************************************************
		* Handler Methods																							*
		************************************************************************************************************/
		private function onItemTemplateLoaded(aEvent:InventoryServiceEvent):void 
		{
			Listener.remove(InventoryServiceEvent.ON_ITEM_TEMPLATE_LOADED, _inventoryService, onItemTemplateLoaded);
			_initStepController.stepCompleted();
		}
		
		private function onGetInventory(aEvent:InventoryServiceEvent):void 
		{
			Listener.remove(InventoryServiceEvent.ON_GET_INVENOTRY, _inventoryService, onItemTemplateLoaded);
			_initStepController.stepCompleted();
		}
		
		/************************************************************************************************************
		* Getter/Setter Methods																						*
		************************************************************************************************************/
	}
}