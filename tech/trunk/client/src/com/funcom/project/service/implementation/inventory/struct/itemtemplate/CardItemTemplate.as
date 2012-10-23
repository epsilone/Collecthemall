/**
* @author Keven Poulin
* @compagny Funcom
*/

package com.funcom.project.service.implementation.inventory.struct.itemtemplate 
{
	import flash.events.EventDispatcher;
	
	public class CardItemTemplate extends ItemTemplate
	{
		/************************************************************************************************/
		/*	Const var																					*/
		/************************************************************************************************/
		
		/************************************************************************************************/
		/*	Member var																					*/
		/************************************************************************************************/
		//Data
		protected var _cardCategoryTypeId:int;
		
		/************************************************************************************************/
		/*	Constructor / Init / Dispose																*/
		/************************************************************************************************/
		public function CardItemTemplate(aXmlNode:XML) 
		{
			super(aXmlNode);
			
			if (aXmlNode == null)
			{
				return;
			}
			_cardCategoryTypeId = int(aXmlNode["cardCategoryTypeId"]);
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
		public function get cardCategoryTypeId():int 
		{
			return _cardCategoryTypeId;
		}
	}
}