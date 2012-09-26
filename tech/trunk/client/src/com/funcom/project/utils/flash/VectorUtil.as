package com.funcom.project.utils.flash 
{
	import flash.utils.Dictionary;
	
	/**
	 * @author Kevin Fields
	 */
	public final class VectorUtil 
	{
		public static function fromDictionary(aDictionary:Dictionary):Vector.<*>
		{
			var vector:Vector.<*> = new Vector.<*>();
			
			for each(var entry:* in aDictionary)
			{
				vector.push(entry);
			}
			
			return vector.slice();
		}
	}
}