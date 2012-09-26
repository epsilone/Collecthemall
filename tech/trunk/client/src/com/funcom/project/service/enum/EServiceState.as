/**
* @author Keven Poulin
* @compagny Funcom
*/
package com.funcom.project.service.enum
{
	public class EServiceState
	{
		public static const NOT_INITIALIZED:EServiceState = 	new EServiceState("EServiceState::NOT_INITIALIZED", 0);
		public static const INITIALIZING:EServiceState = 		new EServiceState("EServiceState::INITIALIZING", 1);
		public static const INITIALIZED:EServiceState = 		new EServiceState("EServiceState::INITIALIZED", 2);
		
		private var _stateName:String;
		private var _stateValue:int;
		
		public function EServiceState(aStateName:String, aStateValue:int)
		{
			_stateName	= aStateName;
			_stateValue = aStateValue;
		}
		
		public function get stateName():String 
		{
			return _stateName;
		}
		
		public function get stateValue():int 
		{
			return _stateValue;
		}
	}
}