/**
 * @author Keven Poulin
 * @compagny Funcom
 */
package com.funcom.project.manager.implementation.module.enum 
{
	//[SCRIPT_HOOK::MODULE_IMPORT]\nOMG
	import com.funcom.project.manager.implementation.console.enum.ELogType;
	import com.funcom.project.manager.implementation.console.Logger;
	import com.funcom.project.manager.implementation.module.struct.AbstractModule;
	import com.funcom.project.module.catchghost.CatchGhostModule;
	import com.funcom.project.module.debug.DebugModule;
	import com.funcom.project.module.hud.HudModule;
	import com.funcom.project.module.islandmap.IslandMapModule;
	import com.funcom.project.module.worldmap.WorldMapModule;
	import flash.utils.ByteArray;
	
	public class EModuleDefinition 
	{
		private static var _definitionList:Vector.<EModuleDefinition> = new Vector.<EModuleDefinition>();
		private static var _definitionId:int;
		
		private var _id:int; 
		private var _name:String; 
		private var _instanceClass:Class; 
		private var _assetFilePath:String; 
		private var _moduleType:String; 
		private var _renderOnResize:Boolean;
		
		//[SCRIPT_HOOK::MODULE_DEFINITION]
		public static const HUD:EModuleDefinition = new EModuleDefinition("Hud", HudModule, "asset/module/HudModule.swf", EModuleType.STAND_ALONE, true);
		public static const DEBUG:EModuleDefinition = new EModuleDefinition("Debug", DebugModule, "asset/module/DebugModule.swf", EModuleType.STAND_ALONE, true);
		public static const WORLD_MAP:EModuleDefinition = new EModuleDefinition("World Map", WorldMapModule, "asset/module/WorldMapModule.swf", EModuleType.SCREEN);
		public static const ISLAND_MAP:EModuleDefinition = new EModuleDefinition("Island Map", IslandMapModule, "asset/module/IslandMapModule.swf", EModuleType.SCREEN);
		public static const CATCH_GHOST:EModuleDefinition = new EModuleDefinition("Catch Ghost", CatchGhostModule, "asset/module/CatchGhostModule.swf", EModuleType.SCREEN);
		
		
		public function EModuleDefinition(aName:String, aInstanceClass:Class, aAssetFilePath:String, aModuleType:String, aRenderOnResize:Boolean = false) 
		{
			_id = _definitionId++;
			_name = aName;
			_instanceClass = aInstanceClass;
			_assetFilePath = aAssetFilePath;
			_moduleType = aModuleType;
			_renderOnResize = aRenderOnResize;
			
			if (!(aInstanceClass is AbstractModule))
			{
				Logger.log(ELogType.WARNING, "EModuleDefinition", "EModuleDefinition", "The instance class of the module definition [" + _name + "] doesn't inherited from AbstractModule.");
			}
			
			_definitionList.push(this);
		}
		
		public static function getModuleDefinitionById(id:int):EModuleDefinition
		{
			for each (var moduleDefinition:EModuleDefinition in _definitionList) 
			{
				if (moduleDefinition.id == id)
				{
					return moduleDefinition;
				}
			}
			
			Logger.log(ELogType.WARNING, "EModuleDefinition", "getModuleDefinitionById", "Can't find a module definition for Id " + id.toString());
			return null;
		}
		
		public static function getModuleDefinitionByModuleInstance(module:AbstractModule):EModuleDefinition
		{
			for each (var moduleDefinition:EModuleDefinition in _definitionList) 
			{
				if (module is moduleDefinition.instanceClass)
				{
					return moduleDefinition;
				}
			}
			
			Logger.log(ELogType.WARNING, "EModuleDefinition", "getModuleDefinitionByModuleInstance", "Can't find a module definition for instance " + module);
			return null;
		}
		
		public static function getList():Array
		{
			//TODO: Should be put in an util class
			var byteArray:ByteArray = new ByteArray();
			byteArray.writeObject(_definitionList);
			byteArray.position = 0;
			return byteArray.readObject() as Array;
		}
		
		public function get id():int 
		{
			return _id;
		}
		
		public function get name():String 
		{
			return _name;
		}
		
		public function get instanceClass():Class 
		{
			return _instanceClass;
		}
		
		public function get assetFilePath():String 
		{
			return _assetFilePath;
		}
		
		public function get moduleType():String 
		{
			return _moduleType;
		}
		
		public function get renderOnResize():Boolean 
		{
			return _renderOnResize;
		}
	}
}