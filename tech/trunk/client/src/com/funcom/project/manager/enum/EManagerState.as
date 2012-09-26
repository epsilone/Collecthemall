/**
* @author Keven Poulin
* @compagny Funcom
*/
package com.funcom.project.manager.enum
{
	public class EManagerState
	{
		public static const NOT_INITIALIZED:EManagerState = 	new EManagerState("EManagerState::NOT_INITIALIZED", 0);
		public static const INITIALIZING:EManagerState = 		new EManagerState("EManagerState::INITIALIZING", 1);
		public static const INITIALIZED:EManagerState = 		new EManagerState("EManagerState::INITIALIZED", 2);
		public static const ACTIVATING:EManagerState = 			new EManagerState("EManagerState::ACTIVATING", 3);
		public static const ACTIVATED:EManagerState = 			new EManagerState("EManagerState::ACTIVATED", 4);
		
		private var m_stateName:String;
		private var m_stateValue:int;
		
		public function EManagerState(aStateName:String, aStateValue:int)
		{
			m_stateName	= aStateName;
			m_stateValue = aStateValue;
		}
		
		public function get stateName():String 
		{
			return m_stateName;
		}
		
		public function get stateValue():int 
		{
			return m_stateValue;
		}
	}
}