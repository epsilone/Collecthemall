/**
 * @author Keven Poulin
 * @compagny Funcom
 */
package com.funcom.project.service.implementation.inventory.enum 
{
	import com.funcom.project.manager.implementation.console.enum.ELogType;
	import com.funcom.project.manager.implementation.console.Logger;
	public class EGhostType 
	{
		private static var _instanceList:Vector.<EGhostType> = new Vector.<EGhostType>();
		
		private var _id:int; 
		private var _name:String; 
		private var _assetFilePath:String;
		
		public static const FIRE:EGhostType 	= new EGhostType(1, "Fire", "");
		public static const ICE:EGhostType 		= new EGhostType(1, "Ice", "");
		
		public function EGhostType(aId:int, aClassName:String, aAssetFilePath:String = "")
		{
			_id = aId;
			_name = aClassName;
			_assetFilePath = aAssetFilePath;
			_instanceList.push(this);
		}
		
		public static function getGhostTypeById(aId:int):EGhostType
		{
			for each (var ghostType:EGhostType in _instanceList) 
			{
				if (ghostType.id == aId)
				{
					return ghostType;
				}
			}
			
			Logger.log(ELogType.WARNING, "EGhostType.as", "getGhostTypeById", "Can't find a ghost type for id " + aId);
			return null;
		}
		
		static public function getList():Vector.<EGhostType> 
		{
			return _instanceList.slice();
		}
		
		public function get className():String 
		{
			return _name;
		}
		
		public function get id():int 
		{
			return _id;
		}
		
		public function get assetFilePath():String 
		{
			return _assetFilePath;
		}
	}
}
