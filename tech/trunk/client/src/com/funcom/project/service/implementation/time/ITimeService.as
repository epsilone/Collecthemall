/**
* @author Keven Poulin
*/
package com.funcom.project.service.implementation.time
{
	import flash.events.IEventDispatcher;
	public interface ITimeService extends IEventDispatcher
	{
		function get serverDate():Date;
		function get serverDateTimeStamp():Number ;
	}
}