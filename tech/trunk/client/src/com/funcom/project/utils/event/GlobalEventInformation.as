/**
* @author Keven Poulin
* @compagny Funcom
*/
package com.funcom.project.utils.event
{
	import flash.events.Event;

	public final class GlobalEventInformation extends Event
	{
		private var m_parametersArray:Array;	
		private var m_event:String;				
		
		public function GlobalEventInformation(event:String, parametersArray:Array = null) 
		{
			super(event);
			
			m_event = event;
			m_parametersArray = parametersArray;		
		}
		
		public function get ListedEvent():String { return m_event; }		
		public function get Parameters():Array { return m_parametersArray; }
	}
}