/**
 * @author Keven Poulin
 * @compagny Funcom
 */
package com.funcom.project.manager.implementation.transition.enum 
{
	import com.funcom.project.manager.implementation.console.enum.ELogType;
	import com.funcom.project.manager.implementation.console.Logger;
	import com.funcom.project.manager.implementation.transition.struct.ProcessingTransition;
	import flash.utils.ByteArray;
	
	public class ETransitionDefinition 
	{
		private static var _definitionList:Vector.<ETransitionDefinition> = new Vector.<ETransitionDefinition>();
		private static var _definitionId:int;
		
		private var _id:int; 
		private var _name:String; 
		private var _instanceClass:Class;
		
		public static const PROCESSING:ETransitionDefinition = new ETransitionDefinition("Processing", ProcessingTransition);
		
		public function ETransitionDefinition(aName:String, aInstanceClass:Class) 
		{
			_id = _definitionId++;
			_name = aName;
			_instanceClass = aInstanceClass;
			
			_definitionList.push(this);
		}
		
		public static function getTransitionDefinitionById(id:int):ETransitionDefinition
		{
			for each (var transitionDefinition:ETransitionDefinition in _definitionList) 
			{
				if (transitionDefinition.id == id)
				{
					return transitionDefinition;
				}
			}
			
			Logger.log(ELogType.WARNING, "ETransitionDefinition", "getTransitionDefinitionById", "Can't find a transition definition for Id " + id.toString());
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
	}
}