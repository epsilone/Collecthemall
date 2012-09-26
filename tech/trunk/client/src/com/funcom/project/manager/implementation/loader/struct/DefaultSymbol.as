/**
 * @author Keven Poulin
 * @compagny Funcom
 */
package com.funcom.project.manager.implementation.loader.struct 
{
	import com.funcom.project.manager.implementation.console.enum.ELogType;
	import com.funcom.project.manager.implementation.console.Logger;
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.utils.getDefinitionByName;
	
	public class DefaultSymbol extends MovieClip
	{
		private const DEFAULT_SYMBOL:String = "DefaultSymbol_LoaderManager";
		
		/************************************************************************************************/
		/*	Member var																					*/
		/************************************************************************************************/
		
		/************************************************************************************************/
		/*	Constructor / Init / Dispose																*/
		/************************************************************************************************/
		public function DefaultSymbol(filePath:String, symbolLinkage:String) 
		{
			super();
			
			init(filePath, symbolLinkage);
		}
		
		private function init(filePath:String, symbolLinkage:String):void 
		{
			var classDefinition:Class;
			var symbol:MovieClip;
			
			classDefinition = getDefinitionByName(DEFAULT_SYMBOL) as Class;
			symbol = new classDefinition() as MovieClip;
			(symbol["linkageName"] as TextField).text = symbolLinkage;
			(symbol["filePath"] as TextField).text = filePath;
				
			addChild(symbol);
			
			Logger.log(ELogType.ERROR, "DefaultSymbol.as", "init", "A DefaultSymbol as been created because this missing asset [symbolLinkage = " + symbolLinkage + " / filePath = " + filePath + "]");
		}
		
		
		/************************************************************************************************/
		/*	Public																						*/
		/************************************************************************************************/
		override public function gotoAndPlay(frame:Object, scene:String = null):void 
		{
			
		}
		
		override public function gotoAndStop(frame:Object, scene:String = null):void 
		{
			
		}
		
		/************************************************************************************************/
		/*	Private																						*/
		/************************************************************************************************/
		
		
		/************************************************************************************************/
		/*	Handler																						*/
		/************************************************************************************************/
	}
}