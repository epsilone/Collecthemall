/**
 * @author Keven Poulin
 * @compagny Funcom
 */
package com.funcom.project.manager.implementation.transition 
{
	import com.funcom.project.manager.AbstractManager;
	import com.funcom.project.manager.implementation.console.enum.ELogType;
	import com.funcom.project.manager.implementation.console.Logger;
	import com.funcom.project.manager.implementation.transition.enum.ETransitionDefinition;
	import com.funcom.project.manager.implementation.transition.event.TransitionManagerEvent;
	import com.funcom.project.manager.implementation.transition.struct.AbstractTransition;
	import com.funcom.project.utils.event.Listener;
	
	public class TransitionManager extends AbstractManager implements ITransitionManager
	{
		/************************************************************************************************************
		* Static/Constant variables																					*
		************************************************************************************************************/

		/************************************************************************************************************
		* Member Variables																							*
		************************************************************************************************************/
		//Service
		
		//Reference holder
		private var _currentTransition:AbstractTransition;
		
		//Management
		
		/************************************************************************************************************
		* Constructor / Init / Dispose																				*	
		************************************************************************************************************/
		public function TransitionManager() 
		{
			
		}
		
		override public function activate():void 
		{
			super.activate();
			
			
			onActivated();
		}
		

		/************************************************************************************************************
		* Public Methods																							*
		************************************************************************************************************/
		public function openTransition(aTransitionDefinition:ETransitionDefinition, callbackWhenOpened:Function = null):void
		{
			if (aTransitionDefinition == null)
			{
				Logger.log(ELogType.WARNING, "TransitionManager.as", "openTransition", "The provided transition definition is null.");
				return;
			}
			
			if (_currentTransition == null)
			{
				_currentTransition = new aTransitionDefinition.instanceClass();
				if (aTransitionDefinition == null)
				{
					Logger.log(ELogType.WARNING, "TransitionManager.as", "openTransition", "Can't instanciate transition for transition definition [" + aTransitionDefinition.name + "]");
					return;
				}
				
				_currentTransition.init();
				registerTransition(_currentTransition);
			}
			
			if (callbackWhenOpened != null)
			{
				_currentTransition.addCallback(callbackWhenOpened);
			}
			
			_currentTransition.startRequest();
		}
		
		public function closeTransition():void
		{
			if (_currentTransition == null)
			{
				Logger.log(ELogType.WARNING, "TransitionManager.as", "closeTransition", "There is no current transition to close.");
				return;
			}
			
			_currentTransition.stopRequest();
		}
		
		/************************************************************************************************************
		* Private Methods																							*
		************************************************************************************************************/
		private function registerTransition(aTransitionInstance:AbstractTransition):void
		{
			Listener.add(TransitionManagerEvent.TRANSITION_OPENING, aTransitionInstance, onEvent);
			Listener.add(TransitionManagerEvent.TRANSITION_OPENED, aTransitionInstance, onEvent);
			Listener.add(TransitionManagerEvent.TRANSITION_CLOSING, aTransitionInstance, onEvent);
			Listener.add(TransitionManagerEvent.TRANSITION_CLOSED, aTransitionInstance, onEvent);
		}
		
		private function unregisterTransition(aTransitionInstance:AbstractTransition):void
		{
			Listener.remove(TransitionManagerEvent.TRANSITION_OPENING, aTransitionInstance, onEvent);
			Listener.remove(TransitionManagerEvent.TRANSITION_OPENED, aTransitionInstance, onEvent);
			Listener.remove(TransitionManagerEvent.TRANSITION_CLOSING, aTransitionInstance, onEvent);
			Listener.remove(TransitionManagerEvent.TRANSITION_CLOSED, aTransitionInstance, onEvent);
		}
		
		private function onEvent(aEvent:TransitionManagerEvent):void 
		{
			if (aEvent.type == TransitionManagerEvent.TRANSITION_CLOSED)
			{
				unregisterTransition(_currentTransition);
				_currentTransition.destroy();
				_currentTransition = null;
			}
			
			dispatchEvent(aEvent.getCopy());
		}
		
		/************************************************************************************************************
		* Handler Methods																							*
		************************************************************************************************************/
		
		/************************************************************************************************************
		* Getter/Setter Methods																						*
		************************************************************************************************************/
	}
}