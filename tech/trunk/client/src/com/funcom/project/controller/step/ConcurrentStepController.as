/**
* @author Keven Poulin
* @compagny Funcom
*/
package com.funcom.project.controller.step
{
	import com.funcom.project.controller.step.enum.EStepState;
	import com.funcom.project.controller.step.event.StepControllerEvent;
	import com.funcom.project.controller.step.struct.StepObject;
	import com.funcom.project.manager.implementation.console.enum.ELogType;
	import com.funcom.project.manager.implementation.console.Logger;
	import com.funcom.project.utils.commoninterface.IDestroyable;
	import com.funcom.project.utils.event.Listener;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	public class ConcurrentStepController extends EventDispatcher implements IDestroyable
	{
		/************************************************************************************************************
		* Static/Constant variables																					*
		************************************************************************************************************/

		/************************************************************************************************************
		* Member Variables																							*
		************************************************************************************************************/
		private var _stepListName:String;
		private var _stepList:Vector.<StepObject>;
		private var _numberOfStepDone:int;
		private var _numberOfStepTotal:int;
		
		private var _isActive:Boolean;
		
		/************************************************************************************************************
		* Constructor / Init / Dispose																				*	
		************************************************************************************************************/
		public function ConcurrentStepController(aStepListName:String)
		{
			_stepListName = aStepListName;
			
			init();
		}
		
		private function init():void
		{
			//Init var
			_stepList = new Vector.<StepObject>();
			_numberOfStepDone = 0;
			_numberOfStepTotal = 0;
			_isActive = false;
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
		}

		/************************************************************************************************************
		* Public Methods																							*
		************************************************************************************************************/
		public function addStep(aId:int, aFunction:Function, aParam:Array = null, aIdDependencyList:Array = null):void
		{
			if (_isActive)
			{
				//TODO: No add during activity
				return;
			}
			
			if (aIdDependencyList == null)
			{
				aIdDependencyList = new Array();
			}
			
			var step:StepObject = new StepObject(aId, aFunction, aParam, aIdDependencyList);
			
			if (getStepById(step.id, false) == null)
			{
				registerStepEvent(step);
				_stepList.push(step);
				_numberOfStepTotal++;
			}
			else
			{
				//TODO: ERROR
			}
		}
		
		public function stepCompleted(aStepId:int):void
		{
			var step:StepObject = getStepById(aStepId);
			if (step == null)
			{
				return;
			}
			
			step.completed();
			
			analyzeStep();
		}
		
		public function start():void
		{
			if (_isActive)
			{
				//TODO: warning: double start
				return;
			}
			
			Logger.log(ELogType.INFO, "ConcurrentStepController", "Start", "[" + _stepListName + "] - Start his process...");
			_isActive = true;
			dispatchEvent(new StepControllerEvent(StepControllerEvent.ON_STARTED));
			analyzeStep();
		}
		
		/************************************************************************************************************
		* Private Methods																							*
		************************************************************************************************************/
		private function getStepById(aStepId:int, debugPrint:Boolean = true):StepObject
		{
			for each (var step:StepObject in _stepList) 
			{
				if (step.id == aStepId)
				{
					return step;
				}
			}
			
			if (debugPrint)
			{
				//TODO: Trace
			}
				
			return null;
		}
		
		private function isDependencyCompleted(aStepSource:StepObject):Boolean
		{
			var stepTarget:StepObject;
			for each (var stepId:int in aStepSource.idDependencyList) 
			{
				stepTarget = getStepById(stepId);
				if (stepTarget != null && stepTarget.state != EStepState.COMPLETED)
				{
					return false;
				}
			}
			return true;
		}
		
		private function analyzeStep():void
		{
			for each (var stepSource:StepObject in _stepList) 
			{
				if (stepSource.state == EStepState.PENDING)
				{
					if (isDependencyCompleted(stepSource))
					{
						Logger.log(ELogType.INFO, "ConcurrentStepController", "analyzeStep", "[" + _stepListName + "] - Start step ID [" + stepSource.id + "]");
						stepSource.trigger();
					}
				}
			}
		}
		
		private function registerStepEvent(aStep:StepObject):void
		{
			if (aStep)
			{
				Listener.add(StepControllerEvent.ON_STEP_STARTED, aStep as IEventDispatcher, dispatchEvent);
				Listener.add(StepControllerEvent.ON_STEP_COMPLETED, aStep as IEventDispatcher, onStepCompleted);
			}
		}
		
		private function unregisterStepEvent(aStep:StepObject):void
		{
			if (aStep)
			{
				Listener.remove(StepControllerEvent.ON_STEP_STARTED, aStep as IEventDispatcher, dispatchEvent);
				Listener.remove(StepControllerEvent.ON_STEP_COMPLETED, aStep as IEventDispatcher, onStepCompleted);
			}
		}
		
		/************************************************************************************************************
		* Handler Methods																							*
		************************************************************************************************************/
		private function onStepCompleted(aEvent:StepControllerEvent):void 
		{
			_numberOfStepDone++;
			dispatchEvent(aEvent);
			
			Logger.log(ELogType.INFO, "ConcurrentStepController", "StepCompleted", "[" + _stepListName + "] - Step completed! [" + _numberOfStepDone + "/" + _numberOfStepTotal + "]");
			if (_numberOfStepDone >= _numberOfStepTotal)
			{
				Logger.log(ELogType.INFO, "ConcurrentStepController", "onStepCompleted", "[" + _stepListName + "] - as completed all his steps!");
				_isActive = false;
				dispatchEvent(new StepControllerEvent(StepControllerEvent.ON_COMPLETED));
			}
		}
		
		override public function dispatchEvent(aEvent:Event):Boolean 
		{
			var clonedEvent:StepControllerEvent = aEvent.clone() as StepControllerEvent;
			clonedEvent.numberOfStepDone = _numberOfStepDone;
			clonedEvent.numberOfStepTotal = _numberOfStepTotal;
			
			return super.dispatchEvent(clonedEvent);
		}
		
		/************************************************************************************************************
		* Getter/Setter Methods																						*
		************************************************************************************************************/
	}
}