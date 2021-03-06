/**
* @author Keven Poulin
*/

package com.funcom.project.manager.implementation.loader.struct 
{
	import flash.events.EventDispatcher;
	
	public class LoadStatistic extends EventDispatcher
	{
		/************************************************************************************************/
		/*	Const var																					*/
		/************************************************************************************************/
		
		/************************************************************************************************/
		/*	Member var																					*/
		/************************************************************************************************/
		//Data
		private var m_filePath:String;
		private var m_value:int;
		
		/************************************************************************************************/
		/*	Constructor / Init / Dispose																*/
		/************************************************************************************************/
		public function LoadStatistic(filePath:String, value:int) 
		{
			m_filePath = filePath;
			m_value = value;
		}
		
		/************************************************************************************************/
		/*	Public																						*/
		/************************************************************************************************/
		
		/************************************************************************************************/
		/*	Private																						*/
		/************************************************************************************************/

		/************************************************************************************************/
		/*	Handler																						*/
		/************************************************************************************************/
		
		/************************************************************************************************/
		/*	Getter / Setter																				*/
		/************************************************************************************************/
		public function get filePath():String 
		{
			return m_filePath;
		}
		
		public function get value():int 
		{
			return m_value;
		}
	}
}