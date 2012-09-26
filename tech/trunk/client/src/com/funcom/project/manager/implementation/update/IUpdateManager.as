/**
* @author Keven Poulin
* @compagny Funcom
*/
package com.funcom.project.manager.implementation.update 
{
	import flash.events.IEventDispatcher;
	public interface IUpdateManager extends IEventDispatcher
	{
		function start():void;
		function update():void;
		function registerModule(aModule:IUpdatable):void;
		function unRegisterModule(aModule:IUpdatable):void;
		function isModuleRegistered(aModule:IUpdatable):Boolean;
		function purge():void;
	}
}