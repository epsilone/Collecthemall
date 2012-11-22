/**
* @author Keven Poulin
* @compagny Funcom
*/
package com.funcom.project.manager.implementation.minigame.enum 
{
	public class EMinigameType 
	{
		/************************************************************************************************************
		* Static/Constant variables																					*
		************************************************************************************************************/
		private static var _referenceList:Vector.<EMinigameType> = new Vector.<EMinigameType>();
		
		public static const SCARTCH_CARD:EMinigameType = new EMinigameType(1, "Scratchcard");
		
		/************************************************************************************************************
		* Member Variables																							*
		************************************************************************************************************/
		private var _id:int;
		private var _name:String;
		
		/************************************************************************************************************
		* Constructor / Init / Dispose																				*	
		************************************************************************************************************/
		public function EMinigameType(aId:int, aName:String) 
		{
			_id = aId;
			_name = aName;
			_referenceList.push(this);
		}
		
		/************************************************************************************************************
		* Static Methods																							*
		************************************************************************************************************/
		public static function getList():Vector.<EMinigameType>
		{
			return _referenceList;
		}
		
		/************************************************************************************************************
		* Getter/Setter Methods																						*
		************************************************************************************************************/
		public function get id():int 
		{
			return _id;
		}
		
		public function get name():String 
		{
			return _name;
		}
	}
}