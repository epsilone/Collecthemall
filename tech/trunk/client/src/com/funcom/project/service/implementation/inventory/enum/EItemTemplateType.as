/**
 * @author Keven Poulin
 * @compagny Funcom
 */
package com.funcom.project.service.implementation.inventory.enum 
{
	import com.funcom.project.manager.implementation.console.enum.ELogType;
	import com.funcom.project.manager.implementation.console.Logger;
	import com.funcom.project.service.implementation.inventory.struct.template.GhostTemplate;
	
	public class EItemTemplateType 
	{
		private static var _instanceList:Vector.<EItemTemplateType> = new Vector.<EItemTemplateType>();
		
		private var _id:int; 
		private var _name:String; 
		private var _templateClass:Class;
		
		public static const GHOST:EItemTemplateType 	= new EItemTemplateType(1, "Ghost", GhostTemplate);
		
		public function EItemTemplateType(aId:int, aClassName:String, aTemplateClass:Class)
		{
			_id = aId;
			_name = aClassName;
			_templateClass = aTemplateClass;
			_instanceList.push(this);
		}
		
		public static function getItemTemplateTypeById(aId:int):EItemTemplateType
		{
			for each (var itemTemplateType:EItemTemplateType in _instanceList) 
			{
				if (itemTemplateType.id == aId)
				{
					return itemTemplateType;
				}
			}
			
			Logger.log(ELogType.WARNING, "EItemTemplateType.as", "getTypeById", "Can't find an item type for id " + aId);
			return null;
		}
		
		static public function getList():Vector.<EItemTemplateType> 
		{
			return _instanceList.slice();
		}
		
		public function get id():int 
		{
			return _id;
		}
		
		public function get name():String 
		{
			return _name;
		}
		
		public function get templateClass():Class 
		{
			return _templateClass;
		}
	}
}
