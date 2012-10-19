package com.funcom.project.manager.implementation.inventory 
{
	import com.funcom.project.manager.AbstractManager;
	import com.funcom.project.service.enum.EServiceDefinition;
	import com.funcom.project.service.implementation.inventory.event.InventoryServiceEvent;
	import com.funcom.project.service.implementation.inventory.IInventoryService;
	import com.funcom.project.service.implementation.time.ITimeService;
	import com.funcom.project.service.ServiceA;
	import com.funcom.project.utils.event.Listener;
	import com.funcom.project.utils.time.timekeeper.TimekeeperEvent;
	
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
		

		/************************************************************************************************************
		* Public Methods																							*
		************************************************************************************************************/
		
		
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