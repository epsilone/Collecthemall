/**
* @author Keven Poulin
* @compagny Funcom
*/

package com.funcom.project.service.implementation.inventory.struct.itemtemplate 
{
	import com.funcom.project.service.implementation.inventory.struct.object.BookContent;
	import flash.events.EventDispatcher;
	
	public class BookItemTemplate extends ItemTemplate
	{
		/************************************************************************************************/
		/*	Const var																					*/
		/************************************************************************************************/
		
		/************************************************************************************************/
		/*	Member var																					*/
		/************************************************************************************************/
		protected var _bookContent:BookContent;
		protected var _width:int;
		protected var _height:int;
		
		/************************************************************************************************/
		/*	Constructor / Init / Dispose																*/
		/************************************************************************************************/
		public function BookItemTemplate(aXmlNode:XML) 
		{
			super(aXmlNode);
			
			if (aXmlNode == null)
			{
				return;
			}
			_width = int(aXmlNode["width"]);
			_height = int(aXmlNode["height"]);
			_bookContent = new BookContent(XML(aXmlNode.content));
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
		public function get bookContent():BookContent 
		{
			return _bookContent;
		}
		
		public function get width():int 
		{
			return _width;
		}
		
		public function get height():int 
		{
			return _height;
		}
	}
}