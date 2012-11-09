/**
 * @author Keven Poulin
 * @compagny Funcom
 */
package com.funcom.project.manager.implementation.inventory 
{
	import com.funcom.project.manager.implementation.inventory.cache.InventoryCache;
	import flash.events.IEventDispatcher;
	
	public interface IInventoryManager extends IEventDispatcher
	{
		function get cache():InventoryCache;
	}
}