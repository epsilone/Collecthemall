/**
* @author Keven Poulin
*/
package com.funcom.project.controller.step.struct
{
	import com.funcom.project.controller.step.enum.EStepState;
	import com.funcom.project.controller.step.event.StepControllerEvent;
	import flash.events.EventDispatcher;
	
	public class StepObject extends EventDispatcher
	{
		/************************************************************************************************************
		* Static/Constant variables																					*
		************************************************************************************************************/

		/************************************************************************************************************
		* Member Variables																							*
		************************************************************************************************************/
		private var _id:int;
		private var _function:Function;
		private var _param:Array;
		private var _idDependencyList:Array;
		private var _state:EStepState;
		
		/************************************************************************************************************
		* Constructor / Init / Dispose																				*	
		************************************************************************************************************/
		public function StepObject(aId:int, aFunction:Function, aParam:Array = null, aIdDependencyList:Array = null)
		{
			_id = aId;
			_function = aFunction;
			_param = aParam;
			_idDependencyList = aIdDependencyList;
			if (_idDependencyList == null)
			{
				_idDependencyList = new Array();
			}
			
			init();
		}
		
		private function init():void 
		{
			changeState(EStepState.PENDING);
		}
		
		public function destroy():void
		{
			changeState(EStepState.DESTROYED);
			
			_id = -1;
			_function = null;
			if (_param != null)
			{
				_param.length = 0;
				_param = null;
			}
			_idDependencyList.length = 0;
			_idDependencyList = null;
		}

		/************************************************************************************************************
		* Public Methods																							*
		************************************************************************************************************/
		public function trigger():void
		{
			changeState(EStepState.INITIALIZING);
			dispatchEvent(new StepControllerEvent(StepControllerEvent.ON_STEP_STARTED));
			_function.apply(null, _param);
		}
		
		public function completed():void
		{
			changeState(EStepState.COMPLETED);
			dispatchEvent(new StepControllerEvent(StepControllerEvent.ON_STEP_COMPLETED));
		}
		
		/************************************************************************************************************
		* Private Methods																							*
		************************************************************************************************************/
		private function changeState(aState:EStepState):void
		{
			if (_state == null || (aState.value > _state.value))
			{
				_state = aState;
			}
			else
			{
				//TODO: Error
			}
		}
		
		/************************************************************************************************************
		* Handler Methods																							*
		************************************************************************************************************/

		/************************************************************************************************************
		* Getter/Setter Methods																						*
		************************************************************************************************************/
		public function get id():int 
		{
			return _id;
		}
		
		public function get idDependencyList():Array 
		{
			return _idDependencyList;
		}
		
		public function get state():EStepState 
		{
			return _state;
		}
	}
}