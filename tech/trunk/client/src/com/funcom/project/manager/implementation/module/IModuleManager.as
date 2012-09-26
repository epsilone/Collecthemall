/**
 * @author Keven Poulin
 * @compagny Funcom
 */
package com.funcom.project.manager.implementation.module 
{
	import com.funcom.project.manager.implementation.module.enum.EModuleDefinition;
	import com.funcom.project.manager.implementation.module.struct.AbstractModule;
	import com.funcom.project.manager.implementation.transition.enum.ETransitionDefinition;
	import flash.events.IEventDispatcher;
	
	public interface IModuleManager extends IEventDispatcher
	{
		function launchModule(aModuleDefinition:EModuleDefinition, aModuleParameter:Array = null, aTransitionDefinition:ETransitionDefinition = null):void;
		function isModuleOpen(aModuleDefinition:EModuleDefinition):Boolean;
		function getModuleInstance(aModuleDefinition:EModuleDefinition):AbstractModule;
	}
}