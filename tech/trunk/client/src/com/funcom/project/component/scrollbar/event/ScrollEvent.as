package com.funcom.buddyworld.ui.event 
{
	import flash.events.Event;
	
	/**
	 * @author Kevin Fields
	 */
	public class ScrollEvent extends Event 
	{
		private var _oldValue:int;
		private var _newValue:int;
		
		public function ScrollEvent(oldValue:int, newValue:int, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super("ScrollEvent::ADJUSTED", bubbles, cancelable);
			_oldValue = oldValue;
			_newValue = newValue;
		} 
		
		public override function clone():Event 
		{ 
			return new ScrollEvent(_oldValue, _newValue, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("ScrollEvent", "type", "oldValue", "newValue", "bubbles", "cancelable", "eventPhase"); 
		}
		
		public function get oldValue():int 
		{
			return _oldValue;
		}
		
		public function get newValue():int 
		{
			return _newValue;
		}
	}
}