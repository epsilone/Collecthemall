/**
* @author Keven Poulin
* @compagny Funcom
*/
package com.funcom.project.controller.step
{
	import com.funcom.project.controller.step.event.StepControllerEvent;
	import com.funcom.project.controller.step.struct.StepObject;
	import com.funcom.project.manager.implementation.console.enum.ELogType;
	import com.funcom.project.manager.implementation.console.Logger;
	import com.funcom.project.utils.commoninterface.IDestroyable;
	import com.funcom.project.utils.event.Listener;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	public class StepController extends EventDispatcher implements IDestroyable
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
		private var _currentStepIndex:int;
		
		private var _isActive:Boolean;
		
		/************************************************************************************************************
		* Constructor / Init / Dispose																				*	
		************************************************************************************************************/
		public function StepController(aStepListName:String = "")
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
			_currentStepIndex = 0;
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
		public function addStep(aFunction:Function, aParam:Array = null):void
		{
			if (_isActive)
			{
				//TODO: No add during activity
				return;
			}
			
			var step:StepObject = new StepObject(_numberOfStepTotal, aFunction, aParam);
			
			registerStepEvent(step);
			_stepList.push(step);
			_numberOfStepTotal++;
		}
		
		public function stepCompleted():void
		{
			if (_currentStepIndex >= _stepList.length)
			{
				return;
			}
			
			_numberOfStepDone++;
			_stepList[_currentStepIndex].completed();
			_currentStepIndex++;
			
			Logger.log(ELogType.INFO, "StepController", "StepCompleted", "[" + _stepListName + "] - Step completed! [" + _numberOfStepDone + "/" + _numberOfStepTotal + "]");
			
			processNextStep();
		}
		
		public function start():void
		{
			if (_isActive)
			{
				//TODO: warning: double start
				return;
			}
			
			Logger.log(ELogType.INFO, "StepController", "Start", "[" + _stepListName + "] - Start his process...");
			_isActive = true;
			dispatchEvent(new StepControllerEvent(StepControllerEvent.ON_STARTED));
			processNextStep();
		}
		
		/************************************************************************************************************
		* Private Methods																							*
		************************************************************************************************************/
		private function processNextStep():void
		{
			if (_currentStepIndex < _numberOfStepTotal)
			{
				Logger.log(ELogType.INFO, "StepController", "processNextStep", "[" + _stepListName + "] - Start step " + /*String(m_stepList[*/_currentStepIndex/*])*/ + " [" + _numberOfStepDone + "/" + _numberOfStepTotal + "]");
				_stepList[_currentStepIndex].trigger();
			}
			else
			{
				Logger.log(ELogType.INFO, "StepController", "processNextStep", "[" + _stepListName + "] - as completed all his steps!");
				_isActive = false;
				dispatchEvent(new StepControllerEvent(StepControllerEvent.ON_COMPLETED));
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
			clonedEvent.numberOfStepDone = _numberOfStepDone;
			clonedEvent.numberOfStepTotal = _numberOfStepTotal;
			dispatchEvent(clonedEvent);
		}
		
		/************************************************************************************************************
		* Getter/Setter Methods																						*
		************************************************************************************************************/
	}
}