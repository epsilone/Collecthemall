/**
 * @author Keven Poulin
 * @compagny Funcom
 */
package com.funcom.project.service.implementation.inventory 
{
	import com.funcom.project.service.implementation.inventory.struct.cache.InventoryCache;
	import com.funcom.project.service.implementation.inventory.struct.itemtemplate.ItemTemplate;
	import flash.events.IEventDispatcher;
	
	public interface IInventoryService extends IEventDispatcher
	{
		function loadItemTemplate():void;
		function getInventory():void;
		
		function get cache():InventoryCache;
	}
}