/**
* @author Keven Poulin
* @compagny Funcom
*/
package com.funcom.project.controller.step.enum
{
	public class EStepState
	{
		private static var value:int;
		
		public static const PENDING:EStepState = 		new EStepState("EStepState::PENDING", value++);
		public static const INITIALIZING:EStepState = 	new EStepState("EStepState::INITIALIZING", value++);
		public static const COMPLETED:EStepState = 		new EStepState("EStepState::COMPLETED", value++);
		public static const DESTROYED:EStepState = 		new EStepState("EStepState::DESTROYED", value++);
		
		private var m_name:String;
		private var m_value:int;
		
		public function EStepState(aName:String, aValue:int)
		{
			m_name = aName;
			m_value = aValue;
		}
		
		public function get name():String 
		{
			return m_name;
		}
		
		public function get value():int 
		{
			return m_value;
		}
	}
}