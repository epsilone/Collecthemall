package com.funcom.project.manager.implementation.ghost.enum 
{
	/**
	 * Represents the different types of cages the user can own to house their ghosties.
	 * @author Kevin Fields
	 */
	public final class ECageType 
	{
		/************************************************************************************************************
		* Static/Constant variables																					*
		************************************************************************************************************/
		private static var _entries:Vector.<ECageType> = new Vector.<ECageType>();
		
		public static var BASIC:ECageType = new ECageType(1);

		/************************************************************************************************************
		* Member Variables																							*
		************************************************************************************************************/
		private var _value:uint;
		
		/************************************************************************************************************
		* Constructor / Init / Dispose																				*	
		************************************************************************************************************/		
		public function ECageType(aValue:uint) 
		{
			_value = aValue;
		}
		
		/************************************************************************************************************
		* Public Methods																							*
		************************************************************************************************************/
		public static function fromValue(aValue:uint):ECageType
		{
			for each(var type:ECageType in _entries)
			{
				if (type._value == aValue)
				{
					return type;
				}
			}
			
			return null;
		}
		
		public function equals(aType:ECageType):Boolean
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
		public static function get constants():Vector.<ECageType>
		{
			return _entries;
		}
		
		public function get value():uint 
		{
			return _value;
		}
	}
}