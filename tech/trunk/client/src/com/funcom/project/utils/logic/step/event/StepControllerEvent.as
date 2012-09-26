/**
* @author Keven Poulin
* @compagny Funcom
*/
package com.funcom.project.utils.logic.step.event
{
	import flash.events.Event;
	
	public class StepControllerEvent extends Event
	{
		/************************************************************************************************************
		* Static/Constant variables																					*
		************************************************************************************************************/
		public static const ON_STARTED:String = "StepControllerEvent::ON_STARTED";
		public static const ON_STEP_STARTED:String = "StepControllerEvent::ON_STEP_STARTED";
		public static const ON_STEP_COMPLETED:String = "StepControllerEvent::ON_STEP_COMPLETED";
		public static const ON_COMPLETED:String = "StepControllerEvent::ON_COMPLETED";
		
		/************************************************************************************************************
		* Member Variables																							*
		************************************************************************************************************/
		private var _numberOfStepDone:int;
		private var _numberOfStepTotal:int;
		
		/************************************************************************************************************
		* Constructor / Init / Dispose																				*	
		************************************************************************************************************/
		public function StepControllerEvent(aEventType:String, aNumberOfStepDone:int = 0, aNumberOfStepTotal:int = 0) 
		{
			super(aEventType, false, false);
			
			_numberOfStepDone = aNumberOfStepDone;
			_numberOfStepTotal = aNumberOfStepTotal;
		}
		
		/************************************************************************************************************
		* Public Methods																							*
		************************************************************************************************************/
		public override function clone():Event 
		{
			return new StepControllerEvent(type, numberOfStepDone, numberOfStepTotal);
		}
		
		public function get numberOfStepTotal():int 
		{
			return _numberOfStepTotal;
		}
		
		public function set numberOfStepTotal(value:int):void 
		{
			_numberOfStepTotal = value;
		}
		
		public function get numberOfStepDone():int 
		{
			return _numberOfStepDone;
		}
		
		public function set numberOfStepDone(value:int):void 
		{
			_numberOfStepDone = value;
		}
		
		
		
		/************************************************************************************************************
		* Private Methods																							*
		************************************************************************************************************/
		
		/************************************************************************************************************
		* Handler Methods																							*
		************************************************************************************************************/
		
		/************************************************************************************************************
		* Getter/Setter Methods																						*
		************************************************************************************************************/
	}
}