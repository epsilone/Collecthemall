/**
* @author Keven Poulin
* @compagny Epix Studio
*/
package com.funcom.project.service.implementation.inventory.struct.template
{
	
	public class ItemTemplate
	{
		/************************************************************************************************************
		* Static/Constant variables																					*
		************************************************************************************************************/

		/************************************************************************************************************
		* Member Variables																							*
		************************************************************************************************************/
		protected var _itemTemplateId:int;
		protected var _itemTemplateTypeId:int;
		protected var _nameToken:String;
		protected var _descriptionToken:String;
		
		/************************************************************************************************************
		* Constructor / Init / Dispose																				*	
		************************************************************************************************************/
		public function ItemTemplate(aXmlNode:XML)
		{
			if (aXmlNode == null)
			{
				return;
			}
			
			_itemTemplateId = int(aXmlNode["itemTemplateId"]);
			_itemTemplateTypeId = int(aXmlNode["itemTemplateTypeId"]);
			_nameToken = String(aXmlNode["nameToken"]);
			_descriptionToken = String(aXmlNode["descriptionToken"]);
		}
		
		/************************************************************************************************************
		* Public Methods																							*
		************************************************************************************************************/

		/************************************************************************************************************
		* Private Methods																							*
		************************************************************************************************************/

		/************************************************************************************************************
		* Handler Methods																							*
		************************************************************************************************************/

		/************************************************************************************************************
		* Getter/Setter Methods																						*
		************************************************************************************************************/
		public function get itemTemplateId():int 
		{
			return _itemTemplateId;
		}
		
		public function set itemTemplateId(value:int):void 
		{
			_itemTemplateId = value;
		}
		
		public function get itemTemplateTypeId():int 
		{
			return _itemTemplateTypeId;
		}
		
		public function set itemTemplateTypeId(value:int):void 
		{
			_itemTemplateTypeId = value;
		}
		
		public function get nameToken():String 
		{
			return _nameToken;
		}
		
		public function set nameToken(value:String):void 
		{
			_nameToken = value;
		}
		
		public function get descriptionToken():String 
		{
			return _descriptionToken;
		}
		
		public function set descriptionToken(value:String):void 
		{
			_descriptionToken = value;
		}
	}
}