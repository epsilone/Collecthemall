package com.funcom.project.manager.implementation.time 
{
	import com.funcom.project.manager.AbstractManager;
	import com.funcom.project.service.enum.EServiceDefinition;
	import com.funcom.project.service.implementation.time.ITimeService;
	import com.funcom.project.service.ServiceA;
	import com.funcom.project.utils.time.timekeeper.Timekeeper;
	import com.funcom.project.utils.time.timekeeper.TimekeeperEvent;
	import flash.utils.getTimer;
	
	public class TimeManager extends AbstractManager implements ITimeManager 
	{
		/************************************************************************************************************
		* Static/Constant variables																					*
		************************************************************************************************************/

		/************************************************************************************************************
		* Member Variables																							*
		************************************************************************************************************/
		//Service
		private var _timeService:ITimeService;
		
		//Reference holder
		private var _serverDateInMilli:Number;
		
		//Management
		private var _timeKeeper:Timekeeper;
		
		/************************************************************************************************************
		* Constructor / Init / Dispose																				*	
		************************************************************************************************************/
		public function TimeManager() 
		{
			
		}
		
		override public function activate():void 
		{
			super.activate();
			
			_timeKeeper.addEventListener(TimekeeperEvent.CHANGE, onTick);
			_serverDateInMilli = _timeService.serverDate.getTime() + (_timeService.serverDateTimeStamp - getTimer());
			_timeKeeper.startTicking();
			
			onActivated();
		}
		

		/************************************************************************************************************
		* Public Methods																							*
		************************************************************************************************************/
		
		
		/************************************************************************************************************
		* Private Methods																							*
		************************************************************************************************************/
		override protected function init():void 
		{
			_timeService = ServiceA.getService(EServiceDefinition.TIME_SERVICE) as ITimeService;
			_timeKeeper = new Timekeeper();
			_timeKeeper.setRealTimeValue();
			_timeKeeper.setRealTimeTick();
			
			super.init();
		}
		
		/************************************************************************************************************
		* Handler Methods																							*
		************************************************************************************************************/
		protected function onTick(event:TimekeeperEvent):void
		{
			_serverDateInMilli += _timeKeeper.getTickDuration();
		}
		
		/************************************************************************************************************
		* Getter/Setter Methods																						*
		************************************************************************************************************/
	}
}