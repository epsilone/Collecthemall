/**
* @author Keven Poulin
* @compagny Funcom
*/
package com.funcom.project.controller.step
{
	import com.funcom.project.controller.step.event.StepControllerEvent;
	import com.funcom.project.controller.step.struct.StepObject;
	import com.funcom.project.utils.commoninterface.IDestroyable;
	import com.funcom.project.utils.event.Listener;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	public class ActiveStepController extends EventDispatcher implements IDestroyable
	{
		/************************************************************************************************************
		* Static/Constant variables																					*
		************************************************************************************************************/

		/************************************************************************************************************
		* Member Variables																							*
		************************************************************************************************************/
		private var _stepList:Vector.<StepObject>;
		private var _inProcess:Boolean;
		private var _maxAmountOfStep:int;
		
		/************************************************************************************************************
		* Constructor / Init / Dispose																				*	
		************************************************************************************************************/
		public function ActiveStepController(aMaxAmountOfStep:int = 1000)
		{
			_maxAmountOfStep = aMaxAmountOfStep;
			
			init();
		}
		
		private function init():void
		{
			//Init var
			_stepList = new Vector.<StepObject>();
			_inProcess = false;
		}
		
		public function destroy():void
		{
			if (_stepList)
			{
				for each (var step:StepObject in _stepList) 
				{
					unregisterStepEvent(step);
					step.destroy();
					step = null;
				}
				_stepList.length = 0;
				_stepList = null;
			}
			
			_inProcess = false;
		}

		/************************************************************************************************************
		* Public Methods																							*
		************************************************************************************************************/
		public function addStep(aFunction:Function, aParam:Array = null):void
		{
			if (_stepList.length >= _maxAmountOfStep)
			{
				return;
			}
			
			var step:StepObject = new StepObject(-1, aFunction, aParam);
			
			registerStepEvent(step);
			_stepList.push(step);
			
			if (!_inProcess)
			{
				processNextStep();
			}
		}
		
		public function stepCompleted():void
		{
			_inProcess = false;
			
			if (_stepList.length > 0)
			{
				_stepList[0].completed();
				_stepList.splice(0, 1);
			}
			
			processNextStep();
		}
		
		public function clearAllStep():void
		{
			_stepList.length = 0;
			_inProcess = false;
		}
		
		/************************************************************************************************************
		* Private Methods																							*
		************************************************************************************************************/
		private function processNextStep():void
		{
			if (_stepList.length > 0)
			{
				_inProcess = true;
				_stepList[0].trigger();
			}
		}
		
		private function registerStepEvent(aStep:StepObject):void
		{
			if (aStep)
			{
				Listener.add(StepControllerEvent.ON_STEP_STARTED, aStep as IEventDispatcher, OnEvent);
				Listener.add(StepControllerEvent.ON_STEP_COMPLETED, aStep as IEventDispatcher, OnEvent);
			}
		}
		
		private function unregisterStepEvent(aStep:StepObject):void
		{
			if (aStep)
			{
				Listener.remove(StepControllerEvent.ON_STEP_STARTED, aStep as IEventDispatcher, OnEvent);
				Listener.remove(StepControllerEvent.ON_STEP_COMPLETED, aStep as IEventDispatcher, OnEvent);
			}
		}
		
		/************************************************************************************************************
		* Handler Methods																							*
		************************************************************************************************************/
		private function OnEvent(aEvent:StepControllerEvent):void
		{
			var clonedEvent:StepControllerEvent = aEvent.clone() as StepControllerEvent;
			clonedEvent.numberOfStepDone = 1;
			clonedEvent.numberOfStepTotal = _stepList.length;
			dispatchEvent(clonedEvent);
		}
		
		/************************************************************************************************************
		* Getter/Setter Methods																						*
		************************************************************************************************************/
		public function get maxAmountOfStep():int 
		{
			return _maxAmountOfStep;
		}
		
		public function set maxAmountOfStep(value:int):void 
		{
			_maxAmountOfStep = value;
		}
	}
}