/**
* @author Keven Poulin
* @compagny Funcom
*/

package com.funcom.project.service.implementation.inventory.struct.object 
{
	import flash.events.EventDispatcher;
	
	public class BookContent
	{
		/************************************************************************************************/
		/*	Const var																					*/
		/************************************************************************************************/
		
		/************************************************************************************************/
		/*	Member var																					*/
		/************************************************************************************************/
		private var _pageList:Vector.<BookPage>;
		
		/************************************************************************************************/
		/*	Constructor / Init / Dispose																*/
		/************************************************************************************************/
		public function BookContent(aXmlNode:XML) 
		{
			if (aXmlNode == null)
			{
				return;
			}
			
			_pageList = new Vector.<BookPage>();
			for each (var pageXmlNode:XML in aXmlNode.children())
			{
				_pageList.push(new BookPage(pageXmlNode));
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
		public function get pageList():Vector.<BookPage> 
		{
			return _pageList;
		}
	}
}