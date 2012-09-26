package com.funcom.project.manager.implementation.ghost.enum 
{
	/**
	 * THIS FILE SHOULD BE GENERATED.
	 * 
	 * @author Kevin Fields
	 */
	public final class EFoodType 
	{
		/************************************************************************************************************
		* Static/Constant variables																					*
		************************************************************************************************************/
		public static const WATER_MELON:EFoodType = new EFoodType(0, "Water Melon", "Yum");
		
		private static var _entries:Vector.<EFoodType> = new Vector.<EFoodType>();

		/************************************************************************************************************
		* Member Variables																							*
		************************************************************************************************************/
		private var _value:uint;
		private var _name:String;
		private var _description:String;
		
		/************************************************************************************************************
		* Constructor / Init / Dispose																				*	
		************************************************************************************************************/		
		public function EFoodType(aValue:uint, aName:String, aDescription:String) 
		{
			_value = aValue;
			_name = aName;
			_description = aDescription;
		}
		
		/************************************************************************************************************
		* Public Methods																							*
		************************************************************************************************************/
		public static function fromValue(aValue:uint):EFoodType
		{
			for each(var type:EFoodType in _entries)
			{
				if (type._value == aValue)
				{
					return type;
				}
			}
			
			return null;
		}
		
		public function equals(aType:EFoodType):Boolean
		{
			return aType._value == _value;
		}
		
		/************************************************************************************************************
		* Private Methods																							*
		************************************************************************************************************/

		/************************************************************************************************************
		* Handler Methods																							*
		************************************************************************************************************/
		
		/************************************************************************************************************
		* Getter/Setter Methods																						*
		************************************************************************************************************/
		public static function get constants():Vector.<EFoodType>
		{
			return _entries;
		}
		
		public function get value():uint 
		{
			return _value;
		}
		
		public function get name():String 
		{
			return _name;
		}
		
		public function get description():String 
		{
			return _description;
		}
	}
}