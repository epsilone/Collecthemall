/**
* @author Keven Poulin
* @compagny Funcom
*/
package com.funcom.project.manager.implementation.console.enum
{
	import flash.automation.ActionGenerator;
	
	public class ELogType
	{
		/************************************************************************************************************
		* Static/Constant variables																					*
		************************************************************************************************************/
		public static const CRITICAL:ELogType 	= new ELogType("Critical", "[CRITICAL]", "CriticalIcon_LogType");
		public static const ERROR:ELogType 		= new ELogType("Error", "[ERROR]", "ErrorIcon_LogType");
		public static const WARNING:ELogType 	= new ELogType("Warning", "[WARNING]", "WarningIcon_LogType");
		public static const ADVICE:ELogType 	= new ELogType("Advice", "[ADVICE]", "AdviceIcon_LogType");
		public static const DEBUG:ELogType 		= new ELogType("Debug", "[DEBUG]", "DebugIcon_LogType");
		public static const INFO:ELogType 		= new ELogType("Info", "[INFO]", "InfoIcon_LogType");
		public static const TIME:ELogType 		= new ELogType("Time", "[TIME]", "TimeIcon_LogType");
		
		private static var m_logTypeList:Array;/*com.funcom.social.service.loader.enum.EFileType*/
		
		/************************************************************************************************************
		* Member Variables																							*
		************************************************************************************************************/
		private var m_name:String;
		private var m_prefix:String;
		private var m_iconLinkage:String;
		private var m_count:Number;
		
		/************************************************************************************************************
		* Constructor / Init / Dispose																				*	
		************************************************************************************************************/
		public function ELogType(aName:String, aPrefix:String, aIconLinkage:String)
		{
			m_name = aName;
			m_prefix = aPrefix;
			m_iconLinkage = aIconLinkage;
			m_count = 0;
			
			if (m_logTypeList == null)
			{
				m_logTypeList = new Array();
			}
			m_logTypeList.push(this);
		}
		
		/************************************************************************************************************
		* Public Methods																							*
		************************************************************************************************************/

		/************************************************************************************************************
		* Getter/Setter Methods																						*
		************************************************************************************************************/
		public function get name():String 
		{
			return m_name;
		}
		
		public function get prefix():String 
		{
			return m_prefix;
		}
		
		static public function getList():Array 
		{
			return m_logTypeList;
		}
		
		public function get count():Number 
		{
			return m_count;
		}
		
		public function set count(value:Number):void 
		{
			m_count = value;
		}
		
		public function get iconLinkage():String 
		{
			return m_iconLinkage;
		}
	}
}