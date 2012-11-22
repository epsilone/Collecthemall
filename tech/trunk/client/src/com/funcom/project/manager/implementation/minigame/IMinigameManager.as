/**
 * @author Keven Poulin
 * @compagny Funcom
 */
package com.funcom.project.manager.implementation.minigame 
{
	import flash.events.IEventDispatcher;
	
	public interface IMinigameManager extends IEventDispatcher
	{
		function getScratchResult():void;
	}
}