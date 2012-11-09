/**
 * @author Keven Poulin
 * @compagny Funcom
 */
package com.funcom.project.manager.implementation.inventory.event 
{
	import flash.events.Event;
	
	public class InventoryCacheEvent extends Event
	{
		/************************************************************************************************/
		/*	Const var																					*/
		/************************************************************************************************/
		//Worker
		public static const ITEM_UPDATED:String = "InventoryCacheEvent::ITEM_UPDATED";
		public static const ITEM_TEMPLATE_UPDATED:String = "InventoryCacheEvent::ITEM_TEMPLATE_UPDATED";
		
		/************************************************************************************************/
		/*	Member var																					*/
		/************************************************************************************************/
		private var _itemId:int;
		private var _itemTemplateId:int;
		
		/************************************************************************************************/
		/*	Constructor / Init / Dispose																*/
		/************************************************************************************************/
		public function InventoryCacheEvent(aType:String, aItemTemplateId:int = -1, aItemId:int = -1)
		{
			super(aType, false, false);
			_itemId = aItemId;
			_itemTemplateId = aItemTemplateId;
		}
		
		/************************************************************************************************/
		/*	Public																						*/
		/************************************************************************************************/
		public function getCopy():InventoryManagerEvent
		{
			return new InventoryManagerEvent(type);
		}
		
		/************************************************************************************************/
		/*	Private																						*/
		/************************************************************************************************/
		
		/************************************************************************************************/
		/*	Handler																						*/
		/************************************************************************************************/
		
		/************************************************************************************************/
		/*	Getter / Setter																				*/
		/************************************************************************************************/
		public function get itemId():int 
		{
			return _itemId;
		}
		
		public function set itemId(value:int):void 
		{
			_itemId = value;
		}
		
		public function get itemTemplateId():int 
		{
			return _itemTemplateId;
		}
		
		public function set itemTemplateId(value:int):void 
		{
			_itemTemplateId = value;
		}
	}

}