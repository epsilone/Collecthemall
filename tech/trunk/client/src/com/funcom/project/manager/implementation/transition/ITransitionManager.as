/**
 * @author Keven Poulin
 * @compagny Funcom
 */
package com.funcom.project.manager.implementation.transition 
{
	import com.funcom.project.manager.implementation.transition.enum.ETransitionDefinition;
	import flash.events.IEventDispatcher;
	
	public interface ITransitionManager extends IEventDispatcher
	{
		function openTransition(aTransitionDefinition:ETransitionDefinition, callbackWhenOpened:Function = null):void;
		function closeTransition():void;
	}
}