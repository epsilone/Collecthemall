/**
* @author Keven Poulin
* @compagny Funcom
*/
package com.funcom.project.utils.event
{
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	
	public final class Listener
	{
		static private var _listenerList:Dictionary = new Dictionary(true);
		static private const INDEX_NOT_FOUND:int=-1;
		
		static public function add(aEvent:String, aModule:IEventDispatcher, aHandler:Function, aUseCapture:Boolean = false, aPriority:int = 0, aUseWeakReference:Boolean = true):void
		{
			if (aModule == null)
			{
				trace("Trying to set an event listener on a null dispatcher");
				return;
			}
			
			var eventList:Vector.<ListenerEvent> = _listenerList[aModule];
			if (eventList == null)
			{
				eventList = new Vector.<ListenerEvent>();
				_listenerList[aModule] = eventList;
			}
			
			var eventExist:Boolean = false;
			
			for (var i:int = eventList.length - 1; i >= 0; i--)
			{
				var currentEvent:ListenerEvent = eventList[i];
				
				if ((currentEvent._event != aEvent) || 
					(currentEvent._handler != aHandler) || 
					(currentEvent._useCapture != aUseCapture))
				{
					continue;
				}
				else
				{
					eventExist = true;
					break;
				}
			}
			
			if (!eventExist)
			{
				eventList.push(new ListenerEvent(aEvent, aHandler, aUseCapture, aPriority, aUseWeakReference));
				aModule.addEventListener(aEvent, aHandler, aUseCapture, aPriority, aUseWeakReference);
			}
		}
		
		static public function traceEventList(aModule:IEventDispatcher):String
		{
			var eventList:Vector.<ListenerEvent> = _listenerList[aModule];
			
			var str:String =	"////////////////////////////////////////////\n" +
								"Event List : " + aModule + "\n" +
								"////////////////////////////////////////////\n";
			
			if (eventList != null)
			{
				for (var i:int = eventList.length - 1; i >= 0; i--)
				{
					var currentEvent:ListenerEvent = eventList[i];
					str += "         **" + currentEvent.toString() + "**\n";
				}
			}
			else
			{
				str += "         **eventList is empty.**\n";
			}
			
			str += "////////////////////////////////////////////";
			
			return (str);
		}
		
		static public function remove(aEvent:String, aModule:IEventDispatcher, aHandler:Function, aUseCapture:Boolean = false):void
		{
			var errorMessage:String;
			
			if (aModule == null)
			{
				trace("Trying to remove an event listener on a null dispatcher");
				return;
			}
			else if (!(aHandler is Function))
			{
				trace("Trying to remove null event listener for [" + aEvent + "] on " + aModule + "]");
				return;
			}
			
			var eventList:Vector.<ListenerEvent> = _listenerList[aModule];
			if (eventList != null)
			{
				var eventExist:Boolean = false;
				
				for (var i:int = eventList.length - 1; i >= 0; i--)
				{
					var currentEvent:ListenerEvent = eventList[i];
					
					if ((currentEvent._event != aEvent) || 
						(currentEvent._handler != aHandler) || 
						(currentEvent._useCapture != aUseCapture))
					{
						continue;
					}
					else
					{
						eventExist = true;
						break;
					}
				}
				
				if (eventExist)
				{
					aModule.removeEventListener(aEvent, aHandler, aUseCapture);
					eventList.splice(i, 1);
					if (eventList.length <= 0)
					{
						delete _listenerList[aModule];
					}
				}
				else
				{
					trace("Trying to remove listener for [" + aEvent + "] on [" + aModule + "], but listener wasn't set via Listener class. Regular \"removeEventListener\" call will be made");
					aModule.removeEventListener(aEvent, aHandler, aUseCapture);
				}
			}
			else
			{
				trace("Couldn't find any reference to [" + aModule + "] in Listener, using regular \"removeEventListener\" call");
				aModule.removeEventListener(aEvent, aHandler, aUseCapture);
			}
		}
		
		static public function removeAllByModule(aModule:IEventDispatcher):void		
		{
			var errorMessage:String;
			
			if (aModule == null)
			{
				trace("Trying to remove an event listener on a null dispatcher");
				return;
			}
			
			var eventList:Vector.<ListenerEvent> = _listenerList[aModule];
			
			if (eventList != null)
			{
				var eventExist:Boolean = false;
				
				for (var i:int = eventList.length - 1; i >= 0; i--)
				{
					var currentEvent:ListenerEvent = eventList[i];
					aModule.removeEventListener(currentEvent._event, currentEvent._handler, currentEvent._useCapture);
				}
				delete _listenerList[aModule];
			}
			else
			{
				trace("Couldn't find any reference to [" + aModule + "] in Listener");
			}
		}
		
		static public function removeAllByEvent(aEvent:String):void
		{
			for(var module:Object in _listenerList)
			{
				var eventList:Vector.<ListenerEvent> = _listenerList[module];
				if (eventList != null)
				{
					var eventExist:Boolean = false;
					
					for (var i:int = eventList.length - 1; i >= 0; i--)
					{
						var currentEvent:ListenerEvent = eventList[i];
						if (currentEvent._event == aEvent)
						{
							module.removeEventListener(currentEvent._event, currentEvent._handler, currentEvent._useCapture);
							eventList.splice(i, 1);
							if (eventList.length <= 0)
							{
								delete _listenerList[module];
							}
						}
					}
				}
				else
				{
					trace("module: [" + module + "] was not found in mListenerList dict.");
				}
			}
		}
	}
}

class ListenerEvent
{
	public var _event:String;
	public var _handler:Function;
	public var _useCapture:Boolean;
	public var _priority:int;
	public var _useWeakReference:Boolean;
	
	public function ListenerEvent(aEvent:String, aHandler:Function, aUseCapture:Boolean = false, aPriority:int = 0, aUseWeakReference:Boolean = false)
	{
		_event = aEvent;
		_handler = aHandler;
		_useCapture = aUseCapture;
		_priority = aPriority;
		_useWeakReference = aUseWeakReference;
	}
	
	public function toString():String
	{
		var str:String = "[ListenerEvent type=\"" + _event + "\" listener=" + _handler + " useCapture=" + _useCapture + " priority=" + _priority + " useWeakReference=" + _useWeakReference + "]";
		return str;
	}
}
