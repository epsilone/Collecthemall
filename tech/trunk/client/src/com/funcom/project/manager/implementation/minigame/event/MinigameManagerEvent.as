/**
 * @author Keven Poulin
 * @compagny Funcom
 */
package com.funcom.project.manager.implementation.minigame.event 
{
	import flash.events.Event;
	
	public class MinigameManagerEvent extends Event
	{
		/************************************************************************************************/
		/*	Const var																					*/
		/************************************************************************************************/
		public static const ON_GET_SCRATCH_RESULT:String = "MinigameManagerEvent::ON_GET_SCRATCH_RESULT";
		
		/************************************************************************************************/
		/*	Member var																					*/
		/************************************************************************************************/
		private var _dataList:Array;
		private var _rewardList:Array;
		
		/************************************************************************************************/
		/*	Constructor / Init / Dispose																*/
		/************************************************************************************************/
		public function MinigameManagerEvent(type:String)
		{
			super(type, false, false);
		}
		
		/************************************************************************************************/
		/*	Public																						*/
		/************************************************************************************************/
		public function getCopy():MinigameManagerEvent
		{
			return new MinigameManagerEvent(type);
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
		public function get dataList():Array 
		{
			return _dataList;
		}
		
		public function set dataList(value:Array):void 
		{
			_dataList = value;
		}
		
		public function get rewardList():Array 
		{
			return _rewardList;
		}
		
		public function set rewardList(value:Array):void 
		{
			_rewardList = value;
		}
	}

}