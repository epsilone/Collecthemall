/**
 * @author Keven Poulin
 * @compagny Funcom
 */
package com.funcom.project.service.implementation.inventory.enum 
{
	import flash.utils.ByteArray;
	public class ECardCategoryType 
	{
		private static var m_referenceList:Vector.<ECardCategoryType> = new Vector.<ECardCategoryType>();
		
		public static const COMMON_CARD_CATEGORY_TYPE:ECardCategoryType 	= new ECardCategoryType(1, "COMMON", 100);
		public static const FREE_PACK_CARD_CATEGORY_TYPE:ECardCategoryType 	= new ECardCategoryType(2, "FREE PACK", 5);
		public static const UNKNOWN_CARD_CATEGORY_TYPE:ECardCategoryType 	= new ECardCategoryType(-1, "UNKNOWN", 0);
		
		private var _id:int;
		private var _type:String;
		private var _rarityFactor:int;
		
		public function ECardCategoryType(aId:int, aType:String, aRarityFactor:int) 
		{
			_id = aId;
			_type = aType;
			_rarityFactor = aRarityFactor;
			
			if (!m_referenceList)
			{
				m_referenceList = new Vector.<ECardCategoryType>();
			}
			
			m_referenceList.push(this);
		}
		
		public static function getCardCategoryTypeById(aId:int):ECardCategoryType
		{
			for each (var cardCategoryType:ECardCategoryType in m_referenceList) 
			{
				if (cardCategoryType.id == aId)
				{
					return cardCategoryType;
				}
			}
			
			return null;
		}
		
		public static function getList():Array
		{
			var byteArray:ByteArray = new ByteArray();
			byteArray.writeObject(m_referenceList);
			byteArray.position = 0;
			return byteArray.readObject() as Array;
		}
		
		public function get id():int 
		{
			return _id;
		}
		
		public function get type():String 
		{
			return _type;
		}
		
		public function get rarityFactor():int 
		{
			return _rarityFactor;
		}
	}
}