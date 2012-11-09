/**
* @author Keven Poulin
* @compagny Funcom
*/

package com.funcom.project.service.implementation.inventory.struct.itemtemplate 
{
	import com.funcom.project.manager.implementation.inventory.cache.ICacheObject;
	import flash.events.EventDispatcher;
	
	public class ItemTemplate implements ICacheObject
	{
		/************************************************************************************************/
		/*	Const var																					*/
		/************************************************************************************************/
		
		/************************************************************************************************/
		/*	Member var																					*/
		/************************************************************************************************/
		//Data
		protected var _itemTemplateId:int;
		protected var _itemTemplateTypeId:int;
		protected var _nameToken:String;
		protected var _descriptionToken:String;
		protected var _assetPath:String;
		protected var _assetThumbnailPath:String;
		
		/************************************************************************************************/
		/*	Constructor / Init / Dispose																*/
		/************************************************************************************************/
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
			_assetPath = String(aXmlNode["assetPath"]);
			_assetThumbnailPath = String(aXmlNode["assetThumbnailPath"]);
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
		public function get itemTemplateId():int 
		{
			return _itemTemplateId;
		}
		
		public function get itemTemplateTypeId():int 
		{
			return _itemTemplateTypeId;
		}
		
		public function get nameToken():String 
		{
			return _nameToken;
		}
		
		public function get descriptionToken():String 
		{
			return _descriptionToken;
		}
		
		public function get assetPath():String 
		{
			return _assetPath;
		}
		
		public function get assetThumbnailPath():String 
		{
			return _assetThumbnailPath;
		}
	}
}