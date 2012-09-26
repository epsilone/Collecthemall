/**
* @author Keven Poulin
* @compagny Funcom
*/
package com.funcom.project.manager.implementation.layer.enum 
{
	public class ELayerDefinition 
	{
		/************************************************************************************************************
		* Static/Constant variables																					*
		************************************************************************************************************/
		private static var _referenceList:Array;
		private static var ID:int = 1;
		
		public static const BACKGROUND:ELayerDefinition = new ELayerDefinition("ELayerDefinition::BACKGROUND");
		public static const MODULE:ELayerDefinition = new ELayerDefinition("ELayerDefinition::MODULE");
		public static const SCREEN:ELayerDefinition = new ELayerDefinition("ELayerDefinition::SCREEN");
		public static const HUD:ELayerDefinition = new ELayerDefinition("ELayerDefinition::HUD");
		public static const TRANSITION:ELayerDefinition = new ELayerDefinition("ELayerDefinition::TRANSITION");
		public static const DEBUG:ELayerDefinition = new ELayerDefinition("ELayerDefinition::DEBUG");
		
		/************************************************************************************************************
		* Member Variables																							*
		************************************************************************************************************/
		private var _id:int;
		private var _name:String;
		private var _isInteractive:Boolean;
		
		/************************************************************************************************************
		* Constructor / Init / Dispose																				*	
		************************************************************************************************************/
		public function ELayerDefinition(aName:String, aIsInteractive:Boolean = true) 
		{
			_id = ID++;
			_name = aName;
			_isInteractive = aIsInteractive;
			
			if (!_referenceList)
			{
				_referenceList = new Array;
			}
			_referenceList.push(this);
		}
		
		/************************************************************************************************************
		* Static Methods																							*
		************************************************************************************************************/
		public static function getList():Array
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
		
		public function get isInteractive():Boolean 
		{
			return _isInteractive;
		}
	}
}