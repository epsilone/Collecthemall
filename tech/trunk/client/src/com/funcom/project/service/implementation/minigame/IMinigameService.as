/**
 * @author Keven Poulin
 * @compagny Funcom
 */
package com.funcom.project.service.implementation.minigame
{
	import flash.events.IEventDispatcher;
	public interface IMinigameService extends IEventDispatcher
	{
		function getScratchResult():void;
	}
}