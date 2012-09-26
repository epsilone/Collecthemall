/**
 * @author Keven Poulin
 * @compagny Funcom
 */
package com.funcom.project.manager.implementation.transition.event 
{
	import com.funcom.project.manager.implementation.transition.struct.AbstractTransition;
	import flash.events.Event;
	
	public class TransitionManagerEvent extends Event
	{
		/************************************************************************************************/
		/*	Const var																					*/
		/************************************************************************************************/
		//Worker
		public static const TRANSITION_OPENING:String = "TransitionManagerEvent::TRANSITION_OPENING";
		public static const TRANSITION_OPENED:String = "TransitionManagerEvent::TRANSITION_OPENED";
		public static const TRANSITION_CLOSING:String = "TransitionManagerEvent::TRANSITION_CLOSING";
		public static const TRANSITION_CLOSED:String = "TransitionManagerEvent::TRANSITION_CLOSED";
		
		/************************************************************************************************/
		/*	Member var																					*/
		/************************************************************************************************/
		private var _transitionReference:AbstractTransition;
		
		/************************************************************************************************/
		/*	Constructor / Init / Dispose																*/
		/************************************************************************************************/
		public function TransitionManagerEvent(type:String, aTransitionReference:AbstractTransition)
		{
			super(type, false, false);
			_transitionReference = aTransitionReference;
		}
		
		/************************************************************************************************/
		/*	Public																						*/
		/************************************************************************************************/
		public function getCopy():TransitionManagerEvent
		{
			return new TransitionManagerEvent(type, _transitionReference);
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
		public function get transitionReference():AbstractTransition 
		{
			return _transitionReference;
		}
	}

}