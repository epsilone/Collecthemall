/**
 * @author Atila
 * @compagny Funcom
 */
package com.funcom.project.service.implementation.location 
{
	import com.funcom.project.service.implementation.time.struct.Location;
	import flash.events.IEventDispatcher;
	
	public interface ILocationService extends IEventDispatcher
	{
		function loadLocation():void;
		function get locationById(id:int):Location;
	}
	
}