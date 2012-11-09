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
	import com.funcom.project.service.implementation.inventory.struct.item.BookItem;
	import com.funcom.project.service.implementation.inventory.struct.item.CardItem;
	import com.funcom.project.service.implementation.inventory.struct.item.CardPackItem;
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
		
		/************************************************************************************************************
		* Constructor / Init / Dispose																				*	
		************************************************************************************************************/
		public function InventoryService() 
		{
			
		}
		
		override public function initialize():void
		{
			super.initialize();
			
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
			var itemTemplateList:Vector.<ItemTemplate> = new Vector.<ItemTemplate>();
			var event:InventoryServiceEvent;
			
			for (var i:int = 0; i < itemTemplateCount; i++)
            {
				itemTemplateTypeId = XML(itemTemplateListNodes[i])["itemTemplateTypeId"];
				itemTemplateType = EItemTemplateType.getItemTemplateTypeById(itemTemplateTypeId);
				itemTemplate = new itemTemplateType.itemTemplateClass(XML(itemTemplateListNodes[i]));
				itemTemplateList.push(itemTemplate);
            }
			
			
			event = new InventoryServiceEvent(InventoryServiceEvent.ON_ITEM_TEMPLATE_LOADED);
			event.itemTemplateAddedList = itemTemplateList;
			dispatchEvent(event);
		}
		
		private function onGetInventory():void
		{
			var event:InventoryServiceEvent;
			var itemList:Vector.<Item> = new Vector.<Item>();
			
			Logger.log(ELogType.TODO, "InventoryService", "getInventory()", "Need to be implement with server communication.");
			var id:int = 1;
			itemList.push(new CardItem(id++, 1, 1));
			itemList.push(new BookItem(id++, 3, 1));
			//itemList.push(new CardPackItem(id++, 8, 2));
			//itemList.push(new CardPackItem(id++, 7, 1));
			//itemList.push(new CardPackItem(id++, 8, 13));
			
			event = new InventoryServiceEvent(InventoryServiceEvent.ON_GET_INVENOTRY);
			event.itemAddedList = itemList;
			dispatchEvent(event);
		}
		/************************************************************************************************************
		* Getter/Setter Methods																						*
		************************************************************************************************************/
	}

}