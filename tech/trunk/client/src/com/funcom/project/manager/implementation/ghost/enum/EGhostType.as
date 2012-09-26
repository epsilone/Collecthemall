package com.funcom.project.manager.implementation.ghost.enum 
{
	/**
	 * @author Kevin Fields
	 */
	public final class EGhostType 
	{
		/************************************************************************************************************
		* Static/Constant variables																					*
		************************************************************************************************************/
		private static var _entries:Vector.<EGhostType> = new Vector.<EGhostType>();

		public static const NONE:EGhostType = new EGhostType(uint.MAX_VALUE);
		public static const CRAZY_FACE:EGhostType = new EGhostType(1);
		public static const CAT:EGhostType = new EGhostType(2);
		
		/************************************************************************************************************
		* Member Variables																							*
		************************************************************************************************************/
		private var _value:uint;
		
		/************************************************************************************************************
		* Constructor / Init / Dispose																				*	
		************************************************************************************************************/		
		public function EGhostType(aValue:uint) 
		{
			_value = aValue;
			
			if (aValue == NONE._value)
			{
				// The value of NONE isn't a valid value, so it shouldn't go into the static entries list.
				return;
			}
			
			_entries.push(this);
		}
		
		/************************************************************************************************************
		* Public Methods																							*
		************************************************************************************************************/
		public static function fromValue(aValue:uint):EGhostType
		{
			for each(var type:EGhostType in _entries)
			{
				if (type._value == aValue)
				{
					return type;
				}
			}
			
			return null;
		}
		
		public function equals(aType:EGhostType):Boolean
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
		public static function get constants():Vector.<EGhostType>
		{
			return _entries.slice();
		}
		
		public function get value():uint 
		{
			return _value;
		}
	}
}