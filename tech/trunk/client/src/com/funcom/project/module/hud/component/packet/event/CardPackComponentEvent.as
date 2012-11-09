/**
 * @author Keven Poulin
 * @compagny Funcom
 */
package com.funcom.project.module.hud.component.packet.event 
{
	import com.funcom.project.service.implementation.inventory.struct.item.Item;
	import com.funcom.project.service.implementation.inventory.struct.itemtemplate.ItemTemplate;
	import flash.events.Event;
	
	public class CardPackComponentEvent extends Event
	{
		/************************************************************************************************/
		/*	Const var																					*/
		/************************************************************************************************/
		//THUMBNAIL
		public static const ON_THUMBNAIL_MOUSE_OVER:String = "CardPackComponentEvent::ON_THUMBNAIL_MOUSE_OVER";
		public static const ON_THUMBNAIL_MOUSE_OUT:String = "CardPackComponentEvent::ON_THUMBNAIL_MOUSE_OUT";
		public static const ON_THUMBNAIL_MOUSE_CLICK:String = "CardPackComponentEvent::ON_THUMBNAIL_MOUSE_CLICK";
		
		//COMPONENT
		
		/************************************************************************************************/
		/*	Member var																					*/
		/************************************************************************************************/
		
		/************************************************************************************************/
		/*	Constructor / Init / Dispose																*/
		/************************************************************************************************/
		public function CardPackComponentEvent(type:String)
		{
			super(type, false, false);
		}
		
		/************************************************************************************************/
		/*	Public																						*/
		/************************************************************************************************/
		public function getCopy():CardPackComponentEvent
		{
			return new CardPackComponentEvent(type);
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