/**
 * @author Keven Poulin
 * @compagny Funcom
 */
package com.funcom.project.manager.enum 
{
	import com.funcom.project.manager.AbstractManager;
	import com.funcom.project.manager.implementation.console.enum.ELogType;
	import com.funcom.project.manager.implementation.console.Logger;
	import flash.utils.getQualifiedClassName;
	public class EManagerDefinition 
	{
		private static const CORE_MANAGER_CLASS_NAME:String = "com.funcom.project.manager.implementation.";
		
		private static var _definitionList:Vector.<EManagerDefinition> = new Vector.<EManagerDefinition>();
		private static var _definitionId:int;
		
		private var _id:int; 
		private var _className:String; 
		private var _assetFilePath:String;
		
		public static const LOADER_MANAGER:EManagerDefinition 		= new EManagerDefinition(CORE_MANAGER_CLASS_NAME + "loader::LoaderManager", "asset/manager/LoaderManager.swf");
		static public const RESOURCE_MANAGER:EManagerDefinition 	= new EManagerDefinition(CORE_MANAGER_CLASS_NAME + "resource::ResourceManager");
		static public const LAYER_MANAGER:EManagerDefinition 		= new EManagerDefinition(CORE_MANAGER_CLASS_NAME + "layer::LayerManager");
		static public const UPDATE_MANAGER:EManagerDefinition 		= new EManagerDefinition(CORE_MANAGER_CLASS_NAME + "update::UpdateManager");
		static public const MODULE_MANAGER:EManagerDefinition 		= new EManagerDefinition(CORE_MANAGER_CLASS_NAME + "module::ModuleManager");
		static public const RESOLUTION_MANAGER:EManagerDefinition 	= new EManagerDefinition(CORE_MANAGER_CLASS_NAME + "resolution::ResolutionManager");
		static public const TIME_MANAGER:EManagerDefinition 		= new EManagerDefinition(CORE_MANAGER_CLASS_NAME + "time::TimeManager");
		static public const TRANSITION_MANAGER:EManagerDefinition 	= new EManagerDefinition(CORE_MANAGER_CLASS_NAME + "transition::TransitionManager", "asset/manager/TransitionManager.swf");
		public static const GHOST_MANAGER:EManagerDefinition 		= new EManagerDefinition(CORE_MANAGER_CLASS_NAME + "ghost::GhostManager");
		public static const INVENTORY_MANAGER:EManagerDefinition 	= new EManagerDefinition(CORE_MANAGER_CLASS_NAME + "inventory::InventoryManager");
		public static const MINIGAME_MANAGER:EManagerDefinition 	= new EManagerDefinition(CORE_MANAGER_CLASS_NAME + "minigame::MinigameManager");
		
		public function EManagerDefinition(aClassName:String, aAssetFilePath:String = "")
		{
			_id = _definitionId++;
			_className = aClassName;
			_assetFilePath = aAssetFilePath;
			_definitionList.push(this);
		}
		
		public static function getManagerDefinitionByManagerInstance(manager:AbstractManager):EManagerDefinition
		{
			var managerSignature:String = getQualifiedClassName(manager);
			
			for each (var managerDefinition:EManagerDefinition in _definitionList) 
			{
				if (managerSignature == managerDefinition.className)
				{
					return managerDefinition;
				}
			}
			
			Logger.log(ELogType.WARNING, "EManagerDefinition", "getManagerDefinitionByManagerInstance", "Can't find a manager definition for instance " + manager);
			return null;
		}
		
		static public function get definitionList():Vector.<EManagerDefinition> 
		{
			return _definitionList.slice();
		}
		
		public function get className():String 
		{
			return _className;
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
