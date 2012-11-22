package com.funcom.project.manager.implementation.minigame 
{
	import com.funcom.project.manager.AbstractManager;
	import com.funcom.project.manager.implementation.minigame.event.MinigameManagerEvent;
	import com.funcom.project.service.enum.EServiceDefinition;
	import com.funcom.project.service.implementation.minigame.event.MinigameServiceEvent;
	import com.funcom.project.service.implementation.minigame.IMinigameService;
	import com.funcom.project.service.ServiceA;
	import com.funcom.project.utils.event.Listener;
	
	public class MinigameManager extends AbstractManager implements IMinigameManager
	{
		/************************************************************************************************************
		* Static/Constant variables																					*
		************************************************************************************************************/

		/************************************************************************************************************
		* Member Variables																							*
		************************************************************************************************************/
		//Service
		private var _minigameService:IMinigameService;
		
		//Reference holder
		
		//Management
		
		/************************************************************************************************************
		* Constructor / Init / Dispose																				*	
		************************************************************************************************************/
		public function MinigameManager() 
		{
			
		}
		
		override public function activate():void 
		{
			super.activate();
			
			
			onActivated();
		}
		

		/************************************************************************************************************
		* Public Methods																							*
		************************************************************************************************************/
		public function getScratchResult():void
		{
			_minigameService.getScratchResult();
		}
		
		/************************************************************************************************************
		* Private Methods																							*
		************************************************************************************************************/
		override protected function init():void 
		{
			_minigameService = ServiceA.getService(EServiceDefinition.MINIGAME_SERVICE) as IMinigameService;
			
			super.init();
		}
		
		override protected function registerEvent():void 
		{
			Listener.add(MinigameServiceEvent.ON_GET_SCRATCH_RESULT, _minigameService, onGetScratchResult)
			
			super.registerEvent();
		}
		
		/************************************************************************************************************
		* Handler Methods																							*
		************************************************************************************************************/
		public function onGetScratchResult(aEvent:MinigameServiceEvent):void
		{
			var event:MinigameManagerEvent = new MinigameManagerEvent(MinigameManagerEvent.ON_GET_SCRATCH_RESULT);
			event.dataList = aEvent.dataList;
			event.rewardList = aEvent.rewardList;
			dispatchEvent(event);
		}
		
		/************************************************************************************************************
		* Getter/Setter Methods																						*
		************************************************************************************************************/
	}
}