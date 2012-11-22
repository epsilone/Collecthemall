package com.funcom.project.manager.implementation.inventory 
{
	import com.funcom.project.manager.AbstractManager;
	import com.funcom.project.manager.implementation.inventory.cache.ICacheObject;
	import com.funcom.project.manager.implementation.inventory.cache.InventoryCache;
	import com.funcom.project.service.enum.EServiceDefinition;
	import com.funcom.project.service.implementation.inventory.event.InventoryServiceEvent;
	import com.funcom.project.service.implementation.inventory.IInventoryService;
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
		
		//Cache
		private var _cache:InventoryCache;
		
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
			
			_cache = new InventoryCache();
			
			registerEvent();
			
			super.init();
		}
		
		override protected function registerEvent():void 
		{
			Listener.add(InventoryServiceEvent.ON_ITEM_TEMPLATE_LOADED, _inventoryService, onItemTemplateLoaded);
			Listener.add(InventoryServiceEvent.ON_GET_INVENOTRY, _inventoryService, onGetInventory);
			
			super.registerEvent();
		}
		
		private function loadItemTemplate():void 
		{
			_inventoryService.loadItemTemplate();
		}
		
		private function getInventory():void 
		{
			_inventoryService.getInventory();
		}
		
		private function updateCache(aEvent:InventoryServiceEvent):void 
		{
			var len:int;
			var itemBuffer:Item;
			var itemTemplateBuffer:Item;
			var index:int;
			
			//Item template added
			len = aEvent.itemTemplateAddedList.length;
			for (index = 0; index < len; index++) 
			{
				_cache.put(aEvent.itemTemplateAddedList[index]);
			}
			
			//Item template removed
			len = aEvent.itemTemplateRemovedList.length;
			for (index = 0; index < len; index++) 
			{
				_cache.remove(aEvent.itemTemplateRemovedList[index]);
			}
			
			//Item added
			len = aEvent.itemAddedList.length;
			for (index = 0; index < len; index++) 
			{
				_cache.put(aEvent.itemAddedList[index]);
			}
			
			//Item removed
			len = aEvent.itemRemovedList.length;
			for (index = 0; index < len; index++) 
			{
				_cache.remove(aEvent.itemRemovedList[index]);
			}
		}
		
		/************************************************************************************************************
		* Handler Methods																							*
		************************************************************************************************************/
		private function onItemTemplateLoaded(aEvent:InventoryServiceEvent):void 
		{
			updateCache(aEvent);
			
			_initStepController.stepCompleted();
		}
		
		private function onGetInventory(aEvent:InventoryServiceEvent):void 
		{
			updateCache(aEvent);
			
			_initStepController.stepCompleted();
		}
		
		/************************************************************************************************************
		* Getter/Setter Methods																						*
		************************************************************************************************************/
		public function get cache():InventoryCache
		{
			return _cache;
		}
	}
}