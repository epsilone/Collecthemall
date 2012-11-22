/**
 * @author Keven Poulin
 * @compagny Funcom
 */
package com.funcom.project.service.importation
{
	import com.funcom.project.service.enum.EServiceDefinition;
	import com.funcom.project.service.implementation.inventory.InventoryService;
	import com.funcom.project.service.implementation.minigame.MinigameService;
	import com.funcom.project.service.implementation.time.TimeService;
	
	public class GameServiceImport
	{
		/************************************************************************************************************
		* Static/Constant variables																					*
		************************************************************************************************************/
		
		/************************************************************************************************************
		* Member Variables																							*
		************************************************************************************************************/
		
		/************************************************************************************************************
		* Constructor / Init / Dispose																				*	
		************************************************************************************************************/
		public function GameServiceImport()
		{
		}

		/************************************************************************************************************
		* Public Methods																							*
		************************************************************************************************************/
		public static function getList():Vector.<EServiceDefinition>
		{
			TimeService;
			InventoryService;
			MinigameService;
			
			var list:Vector.<EServiceDefinition> = new Vector.<EServiceDefinition>();
			list.push(EServiceDefinition.TIME_SERVICE);
			list.push(EServiceDefinition.INVENTORY_SERVICE);
			list.push(EServiceDefinition.MINIGAME_SERVICE);
			return list;
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
	}
}