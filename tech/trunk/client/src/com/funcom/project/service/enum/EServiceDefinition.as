/**
 * @author Keven Poulin
 * @compagny Funcom
 */
package com.funcom.project.service.enum 
{
	public class EServiceDefinition 
	{
		private static const CORE_SERVICE_CLASS_NAME:String = "com.funcom.project.service.implementation.";
		
		private static var _definitionList:Vector.<EServiceDefinition> = new Vector.<EServiceDefinition>();
		private static var _definitionId:int;
		
		private var _id:int; 
		private var _className:String; 
		
		public static const TIME_SERVICE:EServiceDefinition = new EServiceDefinition(CORE_SERVICE_CLASS_NAME + "time::TimeService");
		public static const INVENTORY_SERVICE:EServiceDefinition = new EServiceDefinition(CORE_SERVICE_CLASS_NAME + "inventory::InventoryService");
		
		public function EServiceDefinition(aClassName:String)
		{
			_id = _definitionId++;
			_className = aClassName;
			_definitionList.push(this);
		}
		
		static public function get definitionList():Vector.<EServiceDefinition> 
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
	}
}
