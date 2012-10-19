/**
* @author Keven Poulin
* @compagny Funcom
*/

package com.funcom.project.service.implementation.inventory.struct.cache 
{
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
		private var _itemTemplateByItemTemplateIdDict:Dictionary;
		
		private var _itemTemplateByItemTemplateId:Dictionary;
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
			_itemTemplateByItemTemplateIdDict = new Dictionary(true);
		}
		
		/************************************************************************************************/
		/*	Public																						*/
		/************************************************************************************************/
		public function put(aObject:ICacheObject):void
		{
			
		}
		
		public function remove(aObject:ICacheObject):void
		{
			
		}
		
		/************************************************************************************************/
		/*	Private																						*/
		/************************************************************************************************/
		private function isElementAlreadyInCache(aObject:ICacheObject):Boolean
		{
			var found:Boolean = false;
			if (aObject is ItemTemplate)
			{
				found = Boolean((aObject as ItemTemplate).itemTemplateId.toString() in _itemTemplateByItemTemplateIdDict);
			}
			else if (aObject is Item)
			{
				found = Boolean((aObject as Item).id.toString() in _itemByItemIdDict);
			}
			
			return found;
		}

		/************************************************************************************************/
		/*	Handler																						*/
		/************************************************************************************************/
		
		/************************************************************************************************/
		/*	Getter / Setter																				*/
		/************************************************************************************************/
	}

}