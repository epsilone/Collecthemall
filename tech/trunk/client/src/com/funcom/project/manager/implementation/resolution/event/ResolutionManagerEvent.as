/**
* @author Keven Poulin
* @compagny Funcom
*/
package com.funcom.project.manager.implementation.resolution.event 
{
	import flash.events.Event;
	
	public class ResolutionManagerEvent extends Event
	{
		/************************************************************************************************/
		/*	Const var																					*/
		/************************************************************************************************/
		public static const STAGE_RESIZE:String = "ResolutionManagerEvent::STAGE_RESIZE";
		
		/************************************************************************************************/
		/*	Member var																					*/
		/************************************************************************************************/
		private var _stageWidth:int;
		private var _stageHeight:int;
		
		/************************************************************************************************/
		/*	Constructor / Init / Dispose																*/
		/************************************************************************************************/
		public function ResolutionManagerEvent(aType:String, aStageWidth:int, aStageHeight:int)
		{
			super(aType, false, false);
			_stageWidth = aStageWidth;
			_stageHeight = aStageHeight;
		}
		
		/************************************************************************************************/
		/*	Public																						*/
		/************************************************************************************************/
		public function getCopy():ResolutionManagerEvent
		{
			return new ResolutionManagerEvent(type, _stageWidth, _stageHeight);
		}
		
		public function get stageWidth():int 
		{
			return _stageWidth;
		}
		
		public function get stageHeight():int 
		{
			return _stageHeight;
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
	}

}