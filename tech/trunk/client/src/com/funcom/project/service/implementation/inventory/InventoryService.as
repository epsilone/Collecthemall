/**
 * @author Keven Poulin
 * @compagny Funcom
 */
package com.funcom.project.service.implementation.inventory 
{
	import com.funcom.project.manager.implementation.console.enum.ELogType;
	import com.funcom.project.manager.implementation.console.Logger;
	import com.funcom.project.manager.implementation.loader.enum.EFileType;
	import com.funcom.project.manager.implementation.loader.struct.LoadPacket;
	import com.funcom.project.service.AbstractService;
	import com.funcom.project.service.implementation.inventory.enum.EItemTemplateType;
	import com.funcom.project.service.implementation.inventory.event.InventoryServiceEvent;
	import com.funcom.project.service.implementation.inventory.struct.cache.InventoryCache;
	import com.funcom.project.service.implementation.inventory.struct.item.BookItem;
	import com.funcom.project.service.implementation.inventory.struct.item.CardItem;
	import com.funcom.project.service.implementation.inventory.struct.item.Item;
	import com.funcom.project.service.implementation.inventory.struct.itemtemplate.ItemTemplate;
	
	public class InventoryService extends AbstractService implements IInventoryService 
	{
		/************************************************************************************************************
		* Static/Constant variables																					*
		************************************************************************************************************/
		private const ITEM_TEMPLATE_PATH:String = "data/inventory/ItemTemplate.xml";
		/************************************************************************************************************
		* Member Variables																							*
		************************************************************************************************************/
		//Reference holder
		private var _cache:InventoryCache;
		
		/************************************************************************************************************
		* Constructor / Init / Dispose																				*	
		************************************************************************************************************/
		public function InventoryService() 
		{
			
		}
		
		override public function initialize():void
		{
			super.initialize();
			
			_cache = new InventoryCache();
			
			onInitialized();
		}
		
		/************************************************************************************************************
		* Request Methodes																							*
		************************************************************************************************************/
		public function loadItemTemplate():void
		{
			loaderManager.load(ITEM_TEMPLATE_PATH, EFileType.AUTO_FILE, onItemTemplateLoaded);
		}
		
		public function getInventory():void
		{
			Logger.log(ELogType.TODO, "InventoryService", "getInventory()", "Need to be implement with server communication.");
			
			var item:Item;
			
			//Add 1 card
			item = new CardItem(201, 1, 1);
			_cache.put(item);
			
			//Add 1 book
			item = new BookItem(301, 3, 1);
			_cache.put(item);
			
			onGetInventory();
		}
		
		/************************************************************************************************************
		* Private Methods																							*
		************************************************************************************************************/
		
		/************************************************************************************************************
		* Handler Methods																							*
		************************************************************************************************************/
		private function onItemTemplateLoaded(aLoadPacket:LoadPacket):void 
		{
			XML.ignoreWhitespace = true;
			var xmlData:XML = loaderManager.getXML(ITEM_TEMPLATE_PATH); 
			var itemTemplateListNodes:XMLList = xmlData["ItemTemplate"];
			var itemTemplateCount:int = itemTemplateListNodes.length();
			var itemTemplateType:EItemTemplateType;
			var itemTemplateTypeId:int;
			var itemTemplate:ItemTemplate;
			
			for (var i:int = 0; i < itemTemplateCount; i++)
            {
				itemTemplateTypeId = XML(itemTemplateListNodes[i])["itemTemplateTypeId"];
				itemTemplateType = EItemTemplateType.getItemTemplateTypeById(itemTemplateTypeId);
				itemTemplate = new itemTemplateType.itemTemplateClass(XML(itemTemplateListNodes[i]));
				_cache.put(itemTemplate);
            }
			
			dispatchEvent(new InventoryServiceEvent(InventoryServiceEvent.ON_ITEM_TEMPLATE_LOADED));
		}
		
		private function onGetInventory():void
		{
			dispatchEvent(new InventoryServiceEvent(InventoryServiceEvent.ON_GET_INVENOTRY));
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