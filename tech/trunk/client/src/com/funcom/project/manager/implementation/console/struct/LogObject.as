/**
* @author Keven Poulin
*/
package com.funcom.project.manager.implementation.console.struct
{
	import com.funcom.project.manager.implementation.console.enum.ELogType;
	
	public class LogObject
	{
		/************************************************************************************************************
		* Member Variables																							*
		************************************************************************************************************/
		private var _type:ELogType;
		private var _className:String;
		private var _methodName:String;
		private var _message:String;
		
		/************************************************************************************************************
		* Constructor / Init / Dispose																				*	
		************************************************************************************************************/
		public function LogObject(aType:ELogType, aClassName:String, aMethodName:String, aMessage:String)
		{
			_type = aType;
			_className = aClassName;
			_methodName = aMethodName;
			_message = aMessage;
		}
		
		public function Destroy():void
		{
			_type = null;
			_className = "";
			_methodName = "";
			_message = "";
		}
		
		/************************************************************************************************************
		* Public Methods																							*
		************************************************************************************************************/
		public function toString():String 
		{
			var string:String = _type.prefix + " - " + _className + " - " + _methodName + "() - " + _message;
			if (_type == ELogType.CRITICAL)
			{
				var error:Error = new Error();
				string += error.getStackTrace();
			}
			return string;
		}
		
		/************************************************************************************************************
		* Getter/Setter Methods																						*
		************************************************************************************************************/
		public function get type():ELogType 
		{
			return _type;
		}
	}
}