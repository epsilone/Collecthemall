package com.funcom.project.utils.flash 
{
	public final class MathUtil 
	{
		public static function clampInt(aValue:int, aMin:int = int.MIN_VALUE, aMax:int = int.MAX_VALUE):int
		{
			if (aValue > aMax)
			{
				return aMax;
			}
			else if (aValue < aMin)
			{
				return aMin;
			}
			
			return aValue;
		}
		
		public static function clampUint(aValue:uint, aMin:uint = uint.MIN_VALUE, aMax:uint = uint.MAX_VALUE):uint
		{
			if (aValue > aMax)
			{
				return aMax;
			}
			else if (aValue < aMin)
			{
				return aMin;
			}
			
			return aValue;
		}
		
		public static function clampNumber(aValue:Number, aMin:Number, aMax:Number, aEpsilon:Number = 0.0001):Number
		{
			if (aValue < aMin)
			{
				return aMin;
			}
			else if (aValue > aMax)
			{
				return aMax;
			}
			
			return aValue;
		}
	}
}