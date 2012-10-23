/**
 * @author Keven Poulin
 * @compagny Funcom
 */
package com.funcom.project.manager.implementation.inventory 
{
	import com.funcom.project.service.implementation.inventory.struct.cache.ICacheObject;
	import com.funcom.project.service.implementation.inventory.struct.item.Item;
	import com.funcom.project.service.implementation.inventory.struct.itemtemplate.ItemTemplate;
	import flash.events.IEventDispatcher;
	
	public interface IInventoryManager extends IEventDispatcher
	{
		function put(aObject:ICacheObject):Boolean
		function remove(aObject:ICacheObject):Boolean
		function getItemByItemId(aItemId:int):Item
		function getItemListByItemTemplateId(aItemTemplateId:int):Vector.<Item>
		function getItemTemplateByItemTemplateId(aItemTemplateId:int):ItemTemplate
		function getItemTemplateListByItemTemplateTypeId(aItemTemplateTypeId:int):Vector.<ItemTemplate>
	}
}