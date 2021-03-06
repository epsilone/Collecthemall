/**
 * @author Keven Poulin
 * @compagny Funcom
 */
package com.funcom.project.manager.implementation.time.event 
{
	import flash.events.Event;
	
	public class TimeManagerEvent extends Event
	{
		/************************************************************************************************/
		/*	Const var																					*/
		/************************************************************************************************/
		//Worker
		public static const EXEMPLE:String = "TimeManagerEvent::EXEMPLE";
		
		/************************************************************************************************/
		/*	Member var																					*/
		/************************************************************************************************/
		
		/************************************************************************************************/
		/*	Constructor / Init / Dispose																*/
		/************************************************************************************************/
		public function TimeManagerEvent(type:String)
		{
			super(type, false, false);
		}
		
		/************************************************************************************************/
		/*	Public																						*/
		/************************************************************************************************/
		public function getCopy():TimeManagerEvent
		{
			return new TimeManagerEvent(type);
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