/**
* @author Keven Poulin
* @compagny Funcom
*/
package com.funcom.project.service.implementation.minigame
{
	import com.funcom.project.manager.enum.EManagerDefinition;
	import com.funcom.project.manager.implementation.console.enum.ELogType;
	import com.funcom.project.manager.implementation.console.Logger;
	import com.funcom.project.manager.implementation.inventory.IInventoryManager;
	import com.funcom.project.manager.ManagerA;
	import com.funcom.project.module.scratchcard.enum.EScratchType;
	import com.funcom.project.service.AbstractService;
	import com.funcom.project.service.implementation.inventory.struct.item.CardItem;
	import com.funcom.project.service.implementation.inventory.struct.item.CardPackItem;
	import com.funcom.project.service.implementation.inventory.struct.item.Item;
	import com.funcom.project.service.implementation.minigame.event.MinigameServiceEvent;
	
	public class MinigameService extends AbstractService implements IMinigameService
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
		public function MinigameService() 
		{
			
		}
		
		override public function initialize():void
		{
			super.initialize();
			
			onInitialized();
		}
		
		/************************************************************************************************************
		* Request Methodes																							*
		************************************************************************************************************/
		public function getScratchResult():void
		{
			onGetScratchResult();
		}
		
		/************************************************************************************************************
		* Public Methods																							*
		************************************************************************************************************/
		
		
		/************************************************************************************************************
		* Private Methods																							*
		************************************************************************************************************/

		/************************************************************************************************************
		* Handler Methods																							*
		************************************************************************************************************/
		public function onGetScratchResult():void
		{
			var event:MinigameServiceEvent;
			var scratchResult:Array = new Array();
			var scratchReward:Array = new Array();
			var itemBuffer:Item;
			
			for (var i:int = 0; i < 6; i++) 
			{
				scratchResult.push(rnd(1,4));
			}
			
			for (var j:int = 0; j < 3; j++) 
			{
				if (scratchResult[j] == EScratchType.WIN_CARD.id)
				{
					scratchReward.push(rnd(1, 3));
				}
				else if (scratchResult[j] == EScratchType.WIN_PACK.id)
				{
					scratchReward.push(rnd(7, 10));
				}
			}
			
			Logger.log(ELogType.TODO, "MinigameService", "onGetScratchResult()", "Need to be implement with server communication.");
			
			event = new MinigameServiceEvent(MinigameServiceEvent.ON_GET_SCRATCH_RESULT);
			event.dataList = scratchResult;
			event.rewardList = scratchReward;
			dispatchEvent(event);
		}
		
		private function rnd(a:int, b:int):int
		{
			return a + (b - a) * Math.random();
		}
		
		/************************************************************************************************************
		* Getter/Setter Methods																						*
		************************************************************************************************************/
	}
}