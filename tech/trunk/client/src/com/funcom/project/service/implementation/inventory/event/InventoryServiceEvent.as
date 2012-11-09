/**
 * @author Keven Poulin
 * @compagny Funcom
 */
package com.funcom.project.service.implementation.inventory.event 
{
	import com.funcom.project.service.implementation.inventory.struct.item.Item;
	import com.funcom.project.service.implementation.inventory.struct.itemtemplate.ItemTemplate;
	import flash.events.Event;
	
	public class InventoryServiceEvent extends Event
	{
		/************************************************************************************************/
		/*	Const var																					*/
		/************************************************************************************************/
		public static const ON_ITEM_TEMPLATE_LOADED:String = "InventoryServiceEvent::ON_ITEM_TEMPLATE_LOADED";
		public static const ON_GET_INVENOTRY:String = "InventoryServiceEvent::ON_GET_INVENOTRY";
		
		/************************************************************************************************/
		/*	Member var																					*/
		/************************************************************************************************/
		private var _itemTemplateAddedList:Vector.<ItemTemplate>;
		private var _itemTemplateRemovedList:Vector.<ItemTemplate>;
		private var _itemAddedList:Vector.<Item>;
		private var _itemRemovedList:Vector.<Item>;
		
		/************************************************************************************************/
		/*	Constructor / Init / Dispose																*/
		/************************************************************************************************/
		public function InventoryServiceEvent(type:String)
		{
			super(type, false, false);
			
			init()
		}
		
		private function init():void 
		{
			_itemTemplateAddedList = new Vector.<ItemTemplate>();
			_itemTemplateRemovedList = new Vector.<ItemTemplate>();
			_itemAddedList = new Vector.<Item>();
			_itemRemovedList = new Vector.<Item>();
		}
		
		/************************************************************************************************/
		/*	Public																						*/
		/************************************************************************************************/
		public function getCopy():InventoryServiceEvent
		{
			return new InventoryServiceEvent(type);
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
		public function get itemTemplateAddedList():Vector.<ItemTemplate> 
		{
			return _itemTemplateAddedList;
		}
		
		public function set itemTemplateAddedList(value:Vector.<ItemTemplate>):void 
		{
			_itemTemplateAddedList = value;
		}
		
		public function get itemTemplateRemovedList():Vector.<ItemTemplate> 
		{
			return _itemTemplateRemovedList;
		}
		
		public function set itemTemplateRemovedList(value:Vector.<ItemTemplate>):void 
		{
			_itemTemplateRemovedList = value;
		}
		
		public function get itemAddedList():Vector.<Item> 
		{
			return _itemAddedList;
		}
		
		public function set itemAddedList(value:Vector.<Item>):void 
		{
			_itemAddedList = value;
		}
		
		public function get itemRemovedList():Vector.<Item> 
		{
			return _itemRemovedList;
		}
		
		public function set itemRemovedList(value:Vector.<Item>):void 
		{
			_itemRemovedList = value;
		}
	}

}