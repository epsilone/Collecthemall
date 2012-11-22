/**
* @author Keven Poulin
* @compagny Funcom
*/
package com.funcom.project.module.scratchcard.enum 
{
	public class EScratchType 
	{
		/************************************************************************************************************
		* Static/Constant variables																					*
		************************************************************************************************************/
		private static var _referenceList:Vector.<EScratchType> = new Vector.<EScratchType>();
		
		public static const WIN_CARD:EScratchType = new EScratchType(1, "WIN_CARD", "WinCardSymbol_ScratchCardMinigameModule");
		public static const LOSE_CARD:EScratchType = new EScratchType(2, "LOSE_CARD", "LoseCardSymbol_ScratchCardMinigameModule");
		public static const WIN_PACK:EScratchType = new EScratchType(3, "WIN_PACK", "WinPackSymbol_ScratchCardMinigameModule");
		
		/************************************************************************************************************
		* Member Variables																							*
		************************************************************************************************************/
		private var _id:int;
		private var _name:String;
		private var _linkageName:String;
		
		/************************************************************************************************************
		* Constructor / Init / Dispose																				*	
		************************************************************************************************************/
		public function EScratchType(aId:int, aName:String, aLinkageName:String) 
		{
			_id = aId;
			_name = aName;
			_linkageName = aLinkageName;
			_referenceList.push(this);
		}
		
		/************************************************************************************************************
		* Static Methods																							*
		************************************************************************************************************/
		public static function getList():Vector.<EScratchType>
		{
			return _referenceList;
		}
		
		public static function getScratchTypeByScratchTypeId(aScratchTypeId:int):EScratchType
		{
			for each (var scratchType:EScratchType in _referenceList) 
			{
				if (scratchType.id == aScratchTypeId)
				{
					return scratchType;
				}
			}
			
			return null;
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
		
		public function get linkageName():String 
		{
			return _linkageName;
		}
	}
}