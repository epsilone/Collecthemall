/**
* @author Keven Poulin
* @compagny Funcom
*/
package com.funcom.project.manager.implementation.resolution 
{
	import flash.events.IEventDispatcher;
	public interface IResolutionManager extends IEventDispatcher
	{
		function get stageHeight():int;
		function get stageWidth():int;
	}
}