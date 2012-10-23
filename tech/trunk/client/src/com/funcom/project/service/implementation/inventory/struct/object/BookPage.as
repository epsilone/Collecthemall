/**
* @author Keven Poulin
* @compagny Funcom
*/

package com.funcom.project.service.implementation.inventory.struct.object 
{
	import flash.events.EventDispatcher;
	
	public class BookPage
	{
		/************************************************************************************************/
		/*	Const var																					*/
		/************************************************************************************************/
		
		/************************************************************************************************/
		/*	Member var																					*/
		/************************************************************************************************/
		private var _bgAssetPath:String;
		private var _cardList:Vector.<BookCard>;
		
		/************************************************************************************************/
		/*	Constructor / Init / Dispose																*/
		/************************************************************************************************/
		public function BookPage(aXmlNode:XML) 
		{
			if (aXmlNode == null)
			{
				return;
			}
			
			_bgAssetPath = String(aXmlNode.@bgAssetPath);
			_cardList = new Vector.<BookCard>();
			for each (var cardXmlNode:XML in aXmlNode.children())
			{
				_cardList.push(new BookCard(cardXmlNode));
			}
		}
		
		/************************************************************************************************/
		/*	Public																						*/
		/************************************************************************************************/
		
		/************************************************************************************************/
		/*	Private																						*/
		/************************************************************************************************/

		/************************************************************************************************/
		/*	Handler																						*/
		/************************************************************************************************/
		
		/************************************************************************************************/
		/*	Getter / Setter																				*/
		/************************************************************************************************/
		public function get bgAssetPath():String 
		{
			return _bgAssetPath;
		}
		
		public function get cardList():Vector.<BookCard> 
		{
			return _cardList;
		}
	}
}