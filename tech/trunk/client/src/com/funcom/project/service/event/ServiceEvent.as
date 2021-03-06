/**
* @author Keven Poulin
* @compagny Funcom
*/
package com.funcom.project.service.event
{
	import flash.events.Event;
	
	public class ServiceEvent extends Event
	{
		/************************************************************************************************************
		* Static/Constant variables																					*
		************************************************************************************************************/
		public static const ON_SERVICE_INITIALIZED:String = "ServiceEvent::ON_SERVICE_INITIALIZED";
		
		/************************************************************************************************************
		* Member Variables																							*
		************************************************************************************************************/

		/************************************************************************************************************
		* Constructor / Init / Dispose																				*	
		************************************************************************************************************/
		public function ServiceEvent(aEventType:String) 
		{
			super(aEventType, false, false);
		}

		/************************************************************************************************************
		* Public Methods																							*
		************************************************************************************************************/

		/************************************************************************************************************
		* Private Methods																							*
		************************************************************************************************************/

		/************************************************************************************************************
		* Handler Methods																							*
		************************************************************************************************************/

		/************************************************************************************************************
		* Getter/Setter Methods																						*
		************************************************************************************************************/
	}
}