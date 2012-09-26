/**
 * @author Keven Poulin
 * @compagny Funcom
 */
package com.funcom.project.manager.importation
{
	import com.funcom.project.manager.enum.EManagerDefinition;
	import com.funcom.project.manager.implementation.ghost.GhostManager;
	import com.funcom.project.manager.implementation.inventory.InventoryManager;
	import com.funcom.project.manager.implementation.module.ModuleManager;
	import com.funcom.project.manager.implementation.resolution.ResolutionManager;
	import com.funcom.project.manager.implementation.time.TimeManager;
	import com.funcom.project.manager.implementation.transition.TransitionManager;
	import com.funcom.project.manager.implementation.update.UpdateManager;
	
	public class GameManagerImport
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
		public function GameManagerImport()
		{
		}

		/************************************************************************************************************
		* Public Methods																							*
		************************************************************************************************************/
		public static function getList():Vector.<EManagerDefinition>
		{
			UpdateManager;
			ResolutionManager;
			ModuleManager;
			GhostManager;
			TimeManager;
			TransitionManager;
			InventoryManager;
			
			var list:Vector.<EManagerDefinition> = new Vector.<EManagerDefinition>();
			list.push(EManagerDefinition.UPDATE_MANAGER);
			list.push(EManagerDefinition.RESOLUTION_MANAGER);
			list.push(EManagerDefinition.MODULE_MANAGER);
			list.push(EManagerDefinition.TIME_MANAGER);
			list.push(EManagerDefinition.TRANSITION_MANAGER);
			list.push(EManagerDefinition.INVENTORY_MANAGER);
			//list.push(EManagerDefinition.GHOST_MANAGER);
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