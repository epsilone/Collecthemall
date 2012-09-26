/**
* @author Keven Poulin
* @compagny Funcom
*/
package com.funcom.project.utils.event 
{
	import flash.events.EventDispatcher;
	
	public final class GlobalDispatcher
	{
		private static const mDispatcher:EventDispatcher = new EventDispatcher();
		
		public static function Dispatch(aEvent:String, aDispatcher:EventDispatcher, aParam:Array = null):void 
		{
			Listener.add(aEvent, aDispatcher, GlobalDispatcher.OnEvent);
			aDispatcher.dispatchEvent(new GlobalEventInformation(aEvent, aParam));
			Listener.remove(aEvent, aDispatcher, GlobalDispatcher.OnEvent);
		}
		
		public static function RegisterToListenEvent(aEvent:String, aHandler:Function):void 
		{
			Listener.add(aEvent, mDispatcher, aHandler);
		}
		
		public static function UnRegisterToListenEvent(aEvent:String, aHandler:Function):void 
		{
			Listener.remove(aEvent, mDispatcher, aHandler);			
		}		
		
		private static function OnEvent(aEvent:GlobalEventInformation):void 
		{
			mDispatcher.dispatchEvent(new GlobalEventInformation(aEvent.ListedEvent, aEvent.Parameters));
		}
	}
}






