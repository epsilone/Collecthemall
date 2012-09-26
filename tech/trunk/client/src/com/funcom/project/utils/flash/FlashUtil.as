/**
* @author Keven Poulin
* @compagny Funcom
*/
package com.funcom.project.utils.flash
{
	import flash.utils.getQualifiedClassName;
	
	public class FlashUtil
	{
		public static function getClassName(aObject:*):String
		{
			var definitionName:String = getQualifiedClassName(aObject);
			var splitArr:Array = definitionName.split(":");
			return splitArr[splitArr.length - 1];
		}
	}
}