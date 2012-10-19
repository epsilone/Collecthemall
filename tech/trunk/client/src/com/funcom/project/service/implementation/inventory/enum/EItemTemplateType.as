/**
 * @author Keven Poulin
 * @compagny Funcom
 */
package com.funcom.project.service.implementation.inventory.enum 
{
	import com.funcom.project.service.implementation.inventory.struct.itemtemplate.BookItemTemplate;
	import com.funcom.project.service.implementation.inventory.struct.itemtemplate.CardItemTemplate;
	import com.funcom.project.service.implementation.inventory.struct.itemtemplate.CardPackItemTemplate;
	import flash.utils.ByteArray;
	public class EItemTemplateType 
	{
		private static var m_referenceList:Vector.<EItemTemplateType> = new Vector.<EItemTemplateType>();
		
		public static const CARD_TEMPLATE_TYPE:EItemTemplateType 	= new EItemTemplateType(1, "CARD", CardItemTemplate);
		public static const BOOK_TEMPLATE_TYPE:EItemTemplateType 	= new EItemTemplateType(2, "BOOK", BookItemTemplate);
		public static const CARD_PACK_TEMPLATE_TYPE:EItemTemplateType 	= new EItemTemplateType(3, "CARD PACK", CardPackItemTemplate);
		public static const UNKNOWN_TEMPLATE_TYPE:EItemTemplateType 	= new EItemTemplateType(-1, "UNKNOWN", null);
		
		private var _id:int;
		private var _type:String;
		private var _itemTemplateClass:Class;
		
		public function EItemTemplateType(aId:int, aType:String, aItemTemplateClass:Class) 
		{
			_id = aId;
			_type = aType;
			_itemTemplateClass = aItemTemplateClass;
			
			if (!m_referenceList)
			{
				m_referenceList = new Vector.<EItemTemplateType>();
			}
			
			m_referenceList.push(this);
		}
		
		public static function getItemTemplateTypeById(id:int):EItemTemplateType
		{
			for each (var itemTemplateType:EItemTemplateType in m_referenceList) 
			{
				if (itemTemplateType.id == id)
				{
					return itemTemplateType;
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
		
		public function get itemTemplateClass():Class 
		{
			return _itemTemplateClass;
		}
	}
}