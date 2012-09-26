/**
 * @author Keven Poulin
 * @compagny Funcom
 */
package com.funcom.project.manager.implementation.module.event 
{
	import com.funcom.project.manager.implementation.module.enum.EModuleDefinition;
	import flash.events.Event;
	
	public class ModuleManagerEvent extends Event
	{
		/************************************************************************************************/
		/*	Const var																					*/
		/************************************************************************************************/
		public static const MODULE_OPENING:String = "ModuleManagerEvent::MODULE_OPENING";
		public static const MODULE_OPENED:String = "ModuleManagerEvent::MODULE_OPENED";
		public static const MODULE_CLOSING:String = "ModuleManagerEvent::MODULE_CLOSING";
		public static const MODULE_CLOSED:String = "ModuleManagerEvent::MODULE_CLOSED";
		
		/************************************************************************************************/
		/*	Member var																					*/
		/************************************************************************************************/
		private var _moduleDefinition:EModuleDefinition;
		
		/************************************************************************************************/
		/*	Constructor / Init / Dispose																*/
		/************************************************************************************************/
		public function ModuleManagerEvent(aType:String, aModuleDefinition:EModuleDefinition)
		{
			_moduleDefinition = aModuleDefinition;
			super(aType, false, false);
		}
		
		/************************************************************************************************/
		/*	Public																						*/
		/************************************************************************************************/
		public function getCopy():ModuleManagerEvent
		{
			return new ModuleManagerEvent(type, _moduleDefinition);
		}
		
		/************************************************************************************************/
		/*	Private																						*/
		/************************************************************************************************/
		
		/************************************************************************************************/
		/*	Handler																						*/
		/************************************************************************************************/
		
		/************************************************************************************************/
		/*	Getter / Setter																				*/
		/************************************************************************************************/
		public function get moduleDefinition():EModuleDefinition 
		{
			return _moduleDefinition;
		}
	}
}