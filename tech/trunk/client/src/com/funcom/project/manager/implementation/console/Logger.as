/**
* @author Keven Poulin
* @langversion ActionScript 3.0
* @playerversion Flash 10.3
*/
package com.funcom.project.manager.implementation.console 
{	
	import com.funcom.project.manager.implementation.console.enum.ELogType;
	import com.funcom.project.manager.implementation.console.struct.LogObject;
	
	public class Logger
	{
		private static var _traceFunction:Function = public::["trace"];
		private static var _logList:Vector.<LogObject> = new Vector.<LogObject>();
		public static var _logBuffer:int = 100;
		
		public static function log(aType:ELogType, aClassName:String, aMethodeName:String, aMessage:*):void
		{
			var log:LogObject = new LogObject(aType, aClassName, aMethodeName, String(aMessage));
			
			if (_traceFunction is Function)
			{
				_traceFunction(log.toString());
			}
			
			registerLog(log);
			aType.count++;
		}
		
		private static function registerLog(log:LogObject):void
		{
			var delCount:int = (_logList.length + 1) - _logBuffer;
			
			if (delCount > 0)
			{
				_logList.splice(0, delCount)
			}
			
			_logList.push(log);
		}
		
		static public function get logList():Vector.<LogObject> 
		{
			return _logList;
		}
	}
}