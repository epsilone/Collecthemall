/**
 * @author Keven Poulin
 * @compagny Funcom
 */
package com.funcom.project.service.implementation.inventory 
{
	import com.funcom.project.service.implementation.inventory.struct.itemtemplate.ItemTemplate;
	import flash.events.IEventDispatcher;
	
	public interface IInventoryService extends IEventDispatcher
	{
		function loadItemTemplate():void;
		function getInventory():void;
		
		function getItemTemplateByItemTemplateId(aItemTemplateId:int):ItemTemplate;
		function getItemTemplateListByItemTemplateTypeId(aItemTemplateTypeId:int):Vector.<ItemTemplate>;
	}
}