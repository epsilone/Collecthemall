/**
 * @author Keven Poulin
 * @compagny Funcom
 */
package com.funcom.project.service.implementation.inventory.event 
{
	import flash.events.Event;
	
	public class InventoryServiceEvent extends Event
	{
		/************************************************************************************************/
		/*	Const var																					*/
		/************************************************************************************************/
		public static const ON_ITEM_TEMPLATE_LOADED:String = "InventoryServiceEvent::ON_ITEM_TEMPLATE_LOADED";
		
		/************************************************************************************************/
		/*	Member var																					*/
		/************************************************************************************************/
		
		/************************************************************************************************/
		/*	Constructor / Init / Dispose																*/
		/************************************************************************************************/
		public function InventoryServiceEvent(type:String)
		{
			super(type, false, false);
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
	}

}