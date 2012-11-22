/**
 * @author Keven Poulin
 * @compagny Funcom
 */
package com.funcom.project.service.implementation.minigame.event 
{
	import flash.events.Event;
	
	public class MinigameServiceEvent extends Event
	{
		/************************************************************************************************/
		/*	Const var																					*/
		/************************************************************************************************/
		public static const ON_GET_SCRATCH_RESULT:String = "MinigameServiceEvent::ON_GET_SCRATCH_RESULT";
		
		/************************************************************************************************/
		/*	Member var																					*/
		/************************************************************************************************/
		private var _dataList:Array;
		private var _rewardList:Array;
		
		/************************************************************************************************/
		/*	Constructor / Init / Dispose																*/
		/************************************************************************************************/
		public function MinigameServiceEvent(type:String)
		{
			super(type, false, false);
		}
		
		/************************************************************************************************/
		/*	Public																						*/
		/************************************************************************************************/
		public function getCopy():MinigameServiceEvent
		{
			return new MinigameServiceEvent(type);
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