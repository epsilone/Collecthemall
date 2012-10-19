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
	import com.funcom.project.service.implementation.inventory.struct.item.CardItem;
	import com.funcom.project.service.implementation.inventory.struct.item.Item;
	import com.funcom.project.service.implementation.inventory.struct.itemtemplate.ItemTemplate;
	import flash.utils.Dictionary;
	
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
		private var _itemTemplateByItemTemplateId:Dictionary;
		private var _itemTemplateListByItemTemplateTypeId:Dictionary;
		private var _itemById:Dictionary;
		
		/************************************************************************************************************
		* Constructor / Init / Dispose																				*	
		************************************************************************************************************/
		public function InventoryService() 
		{
			
		}
		
		override public function initialize():void
		{
			super.initialize();
			
			_itemTemplateByItemTemplateId = new Dictionary();
			_itemTemplateListByItemTemplateTypeId = new Dictionary();
			_itemById = new Dictionary();
			
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
			item = new CardItem(201, 1, 1);
			_itemById[item.id] = item;
			
			onGetInventory();
		}
		
		
		/************************************************************************************************************
		* Cache Accessor Methodes																					*
		************************************************************************************************************/
		public function getItemTemplateByItemTemplateId(aItemTemplateId:int):ItemTemplate
		{
			return _itemTemplateByItemTemplateId[aItemTemplateId];
		}
		
		public function getItemTemplateListByItemTemplateTypeId(aItemTemplateTypeId:int):Vector.<ItemTemplate>
		{
			var vector:Vector.<ItemTemplate> = _itemTemplateListByItemTemplateTypeId[aItemTemplateTypeId];
			if (vector == null)
			{
				vector = new Vector.<ItemTemplate>();
			}
			
			return vector;
		}
		
		public function getItemByItemId(aItemId:int):Item
		{
			return _itemById[aItemId];
		}
		
		public function getItemListByItemTemplateId(aItemTemplateId:int):Vector.<ItemTemplate>
		{
			return _itemById[aItemId];
		}
		
		/************************************************************************************************************
		* Cache Management Methodes																					*
		************************************************************************************************************/
		private function addItemTemplate(itemTemplate:ItemTemplate):void
		{
			_itemTemplateByItemTemplateId[itemTemplate.itemTemplateId] = itemTemplate;
			
			var vector:Vector.<ItemTemplate> = _itemTemplateListByItemTemplateTypeId[itemTemplate.itemTemplateTypeId];
			var index:int;
			if (vector == null)
			{
				vector = new Vector.<ItemTemplate>();
				_itemTemplateListByItemTemplateTypeId[itemTemplate.itemTemplateTypeId] = vector;
				index = -1;
			}
			else
			{
				index = vector.indexOf(itemTemplate);
			}
			
			if (index == -1)
			{
				vector.push(itemTemplate);
			}
			else
			{
				vector.splice(index, 1, itemTemplate);
			}
			
		}
		
		private function removeItemTemplate(itemTemplate:ItemTemplate):void
		{
			delete _itemTemplateByItemTemplateId[itemTemplate.itemTemplateId];
			
			var vector:Vector.<ItemTemplate> = _itemTemplateListByItemTemplateTypeId[itemTemplate.itemTemplateTypeId];
			var index:int;
			if (vector)
			{
				index = vector.indexOf(itemTemplate);
				if (index != -1)
				{
					vector.splice(index, 1);
				}
			}
		}
		
		/************************************************************************************************************
		* Private Methods																							*
		************************************************************************************************************/
		
		
		/************************************************************************************************************
		* Handler Methods																							*
		************************************************************************************************************/
		private function onItemTemplateLoaded(aLoadPacket:LoadPacket):void 
		{
			//TODO: CLEAR OLD CACHE
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
				addItemTemplate(itemTemplate);
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
	}

}