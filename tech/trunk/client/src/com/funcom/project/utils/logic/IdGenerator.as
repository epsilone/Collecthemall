/**
* @author Keven Poulin
* @compagny Funcom
*/
package com.funcom.project.utils.logic 
{
	public class IdGenerator 
	{
		private static var m_lastIdGenerated:int = int.MAX_VALUE;
		
		public static function getUniqueId():int
		{
			m_lastIdGenerated--;
			return m_lastIdGenerated;
		}
	}
}