/**
* @author Keven Poulin
* @compagny Funcom
*/

package com.funcom.project.service.implementation.inventory.struct.cache 
{
	import com.funcom.project.manager.implementation.console.enum.ELogType;
	import com.funcom.project.manager.implementation.console.Logger;
	import com.funcom.project.service.implementation.inventory.struct.item.Item;
	import com.funcom.project.service.implementation.inventory.struct.itemtemplate.ItemTemplate;
	import flash.utils.Dictionary;
	public class InventoryCache
	{
		/************************************************************************************************/
		/*	Const var																					*/
		/************************************************************************************************/
		
		/************************************************************************************************/
		/*	Member var																					*/
		/************************************************************************************************/
		//List
		private var _itemList:Vector.<Item>;
		private var _itemTemplateList:Vector.<ItemTemplate>;
		
		//Logical cache
		private var _itemByItemIdDict:Dictionary;
		private var _itemListByItemTemplateIdDict:Dictionary;
		private var _itemTemplateByItemTemplateIdDict:Dictionary;
		private var _itemTemplateListByItemTemplateTypeId:Dictionary;
		
		/************************************************************************************************/
		/*	Constructor / Init / Dispose																*/
		/************************************************************************************************/
		public function InventoryCache() 
		{
			init();
		}
		
		private function init():void 
		{
			_itemList = new Vector.<Item>();
			_itemTemplateList = new Vector.<ItemTemplate>();
			
			_itemByItemIdDict = new Dictionary(true);
			_itemListByItemTemplateIdDict = new Dictionary(true);
			_itemTemplateByItemTemplateIdDict = new Dictionary(true);
			_itemTemplateListByItemTemplateTypeId = new Dictionary(true);
		}
		
		public function destroy():void
		{
			if (_itemList != null)
			{
				_itemList.length = 0;
				_itemList = null;
			}
			
			if (_itemTemplateList != null)
			{
				_itemTemplateList.length = 0;
				_itemTemplateList = null;
			}
		}
		
		/************************************************************************************************/
		/*	Public (INPUT)																				*/
		/************************************************************************************************/
		public function put(aObject:ICacheObject):Boolean
		{
			var success:Boolean = true;
			if (aObject is ItemTemplate)
			{
				var itemTemplate:ItemTemplate = aObject as ItemTemplate;
				if (isItemTemplateAlreadyInCache(itemTemplate))
				{
					updateItemTemplate(itemTemplate)
				}
				else
				{
					addItemTemplate(itemTemplate);
				}
			}
			else if (aObject is Item)
			{
				var item:Item = aObject as Item;
				if (isItemAlreadyInCache(item))
				{
					updateItem(item)
				}
				else
				{
					addItem(item);
				}
			}
			else
			{
				success = false;
				Logger.log(ELogType.WARNING, "InventoryCache", "put", "The object type is not handled by the inventory caching system! [" + aObject + "]");
			}
			
			return success;
		}
		
		public function remove(aObject:ICacheObject):Boolean
		{
			var success:Boolean = true;
			if (aObject is ItemTemplate)
			{
				var itemTemplate:ItemTemplate = aObject as ItemTemplate;
				if (isItemTemplateAlreadyInCache(itemTemplate))
				{
					RemoveItemTemplate(itemTemplate)
				}
				else
				{
					Logger.log(ELogType.WARNING, "InventoryCache", "remove", "The object provided cannot be found in the caching system! [" + aObject + "]");
				}
			}
			else if (aObject is Item)
			{
				var item:Item = aObject as Item;
				if (isItemAlreadyInCache(item))
				{
					RemoveItem(item)
				}
				else
				{
					Logger.log(ELogType.WARNING, "InventoryCache", "remove", "The object provided cannot be found in the caching system! [" + aObject + "]");
				}
			}
			else
			{
				success = false;
				Logger.log(ELogType.WARNING, "InventoryCache", "remove", "The object type is not handled by the inventory caching system! [" + aObject + "]");
			}
			
			return success;
		}
		
		/************************************************************************************************/
		/*	Public (OUTPUT)																				*/
		/************************************************************************************************/
		public function getItemByItemId(aItemId:int):Item
		{
			return _itemByItemIdDict[aItemId];
		}
		
		public function getItemListByItemTemplateId(aItemTemplateId:int):Vector.<Item>
		{
			var vectorBuffer:Vector.<Item>;
			vectorBuffer = _itemListByItemTemplateIdDict[aItemTemplateId];
			if (vectorBuffer == null)
			{
				vectorBuffer = new Vector.<Item>();
				_itemListByItemTemplateIdDict[aItemTemplateId] = vectorBuffer;
			}
			return vectorBuffer;
		}
		
		public function getItemTemplateByItemTemplateId(aItemTemplateId:int):ItemTemplate
		{
			return _itemTemplateByItemTemplateIdDict[aItemTemplateId];
		}
		
		public function getItemTemplateListByItemTemplateTypeId(aItemTemplateTypeId:int):Vector.<ItemTemplate>
		{
			var vectorBuffer:Vector.<ItemTemplate>;
			vectorBuffer = _itemTemplateListByItemTemplateTypeId[aItemTemplateTypeId];
			if (vectorBuffer == null)
			{
				vectorBuffer = new Vector.<ItemTemplate>();
				_itemTemplateListByItemTemplateTypeId[aItemTemplateTypeId] = vectorBuffer;
			}
			return vectorBuffer;
		}
		
		/************************************************************************************************/
		/*	Private																						*/
		/************************************************************************************************/
		//---------------[ ITEM ]---------------
		private function isItemAlreadyInCache(aItem:Item):Boolean
		{
			return Boolean(aItem.id.toString() in _itemByItemIdDict);
		}
		
		private function addItem(aItem:Item):void
		{
			var vectorBuffer:Vector.<Item>;
			
			//Add to main list
			_itemList.push(aItem);
			
			//Add to logical dict
			_itemByItemIdDict[aItem.id] = aItem;
			if (_itemListByItemTemplateIdDict[aItem.itemTemplateId] == null)
			{
				_itemListByItemTemplateIdDict[aItem.itemTemplateId] = new Vector.<Item>();
			}
			vectorBuffer = _itemListByItemTemplateIdDict[aItem.itemTemplateId];
			vectorBuffer.push(aItem);
		}
		
		private function updateItem(aItem:Item):void
		{
			var itemBuffer:Item;
			var len:int = _itemList.length;
			var index:int = -1;
			var vectorBuffer:Vector.<Item>;
			
			//Find in main list
			for (var i:int = 0; i < len; i++) 
			{
				itemBuffer = _itemList[i];
				if (itemBuffer.id == aItem.id)
				{
					index = i;
					break;
				}
			}
			
			if (index == -1)
			{
				Logger.log(ELogType.WARNING, "InventoryCache", "updateItem", "The object provided cannot be found in the caching system! [itemId = " + aItem.id+ "]");
				return;
			}
			
			//Update from logical dict
			_itemByItemIdDict[itemBuffer.id] = aItem;
			vectorBuffer = _itemListByItemTemplateIdDict[itemBuffer.itemTemplateId];
			vectorBuffer.splice(vectorBuffer.indexOf(itemBuffer), 1, aItem);
			
			//Update from main list
			_itemList.splice(i, 1, aItem);
		}
		
		private function RemoveItem(aItem:Item):void
		{
			var itemBuffer:Item;
			var len:int = _itemList.length;
			var index:int = -1;
			var vectorBuffer:Vector.<Item>;
			
			//Find in main list
			for (var i:int = 0; i < len; i++) 
			{
				itemBuffer = _itemList[i];
				if (itemBuffer.id == aItem.id)
				{
					index = i;
					break;
				}
			}
			
			if (index == -1)
			{
				Logger.log(ELogType.WARNING, "InventoryCache", "RemoveItem", "The object provided cannot be found in the caching system! [itemId = " + aItem.id+ "]");
				return;
			}
			
			//Remove from logical dict
			delete _itemByItemIdDict[aItem.id];
			vectorBuffer = _itemListByItemTemplateIdDict[itemBuffer.itemTemplateId];
			vectorBuffer.splice(vectorBuffer.indexOf(itemBuffer), 1);
			
			//Remove from main list
			_itemList.splice(i, 1);
		}
		
		//---------------[ ITEM TEMPLATE ]---------------
		private function isItemTemplateAlreadyInCache(aItemTemplate:ItemTemplate):Boolean
		{
			return Boolean(aItemTemplate.itemTemplateId.toString() in _itemTemplateByItemTemplateIdDict);
		}
		
		private function addItemTemplate(aItemTemplate:ItemTemplate):void
		{
			var vectorBuffer:Vector.<ItemTemplate>;
			
			//Add to main list
			_itemTemplateList.push(aItemTemplate);
			
			//Add to logical dict
			_itemTemplateByItemTemplateIdDict[aItemTemplate.itemTemplateId] = aItemTemplate;
			if (_itemTemplateListByItemTemplateTypeId[aItemTemplate.itemTemplateTypeId] == null)
			{
				_itemTemplateListByItemTemplateTypeId[aItemTemplate.itemTemplateTypeId] = new Vector.<ItemTemplate>();
			}
			vectorBuffer = _itemTemplateListByItemTemplateTypeId[aItemTemplate.itemTemplateTypeId];
			vectorBuffer.push(aItemTemplate);
		}
		
		private function updateItemTemplate(aItemTemplate:ItemTemplate):void
		{
			var itemTemplateBuffer:ItemTemplate;
			var len:int = _itemTemplateList.length;
			var vectorBuffer:Vector.<ItemTemplate>;
			var index:int = -1;
			
			//Find in main list
			for (var i:int = 0; i < len; i++) 
			{
				itemTemplateBuffer = _itemTemplateList[i];
				if (itemTemplateBuffer.itemTemplateId == aItemTemplate.itemTemplateId)
				{
					index = i;
					break;
				}
			}
			
			if (index == -1)
			{
				Logger.log(ELogType.WARNING, "InventoryCache", "updateItemTemplate", "The object provided cannot be found in the caching system! [itemTemplateId = " + aItemTemplate.itemTemplateId + "]");
				return;
			}
			
			//Update from logical dict
			_itemTemplateByItemTemplateIdDict[itemTemplateBuffer.itemTemplateId] = aItemTemplate;
			vectorBuffer = _itemTemplateListByItemTemplateTypeId[itemTemplateBuffer.itemTemplateTypeId];
			vectorBuffer.splice(vectorBuffer.indexOf(itemTemplateBuffer), 1, aItemTemplate);
			
			//Update from main list
			_itemTemplateList.splice(index, 1, aItemTemplate);
		}
		
		private function RemoveItemTemplate(aItemTemplate:ItemTemplate):void
		{
			var itemTemplateBuffer:ItemTemplate;
			var len:int = _itemTemplateList.length;
			var vectorBuffer:Vector.<ItemTemplate>;
			var index:int = -1;
			
			//Find in main list
			for (var i:int = 0; i < len; i++) 
			{
				itemTemplateBuffer = _itemTemplateList[i];
				if (itemTemplateBuffer.itemTemplateId == aItemTemplate.itemTemplateId)
				{
					index = i;
					break;
				}
			}
			
			if (index == -1)
			{
				Logger.log(ELogType.WARNING, "InventoryCache", "RemoveItemTemplate", "The object provided cannot be found in the caching system! [itemTemplateId = " + aItemTemplate.itemTemplateId + "]");
				return;
			}
			
			//Remove from logical dict
			delete _itemTemplateByItemTemplateIdDict[itemTemplateBuffer.itemTemplateId];
			vectorBuffer = _itemTemplateListByItemTemplateTypeId[itemTemplateBuffer.itemTemplateTypeId];
			vectorBuffer.splice(vectorBuffer.indexOf(itemTemplateBuffer), 1);
			
			//Remove from main list
			_itemTemplateList.splice(index, 1);
		}

		/************************************************************************************************/
		/*	Handler																						*/
		/************************************************************************************************/
		
		/************************************************************************************************/
		/*	Getter / Setter																				*/
		/************************************************************************************************/
	}

}