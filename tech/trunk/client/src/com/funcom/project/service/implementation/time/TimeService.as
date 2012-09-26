/**
* @author Keven Poulin
* @compagny Funcom
*/
package com.funcom.project.service.implementation.time
{
	import com.funcom.project.service.AbstractService;
	import com.funcom.project.service.enum.EServiceState;
	import com.funcom.project.service.implementation.time.event.TimeServiceEvent;
	import com.funcom.project.utils.event.Listener;
	import flash.utils.getTimer;
	
	public class TimeService extends AbstractService implements ITimeService
	{
		/************************************************************************************************************
		* Static/Constant variables																					*
		************************************************************************************************************/

		/************************************************************************************************************
		* Member Variables																							*
		************************************************************************************************************/
		private var _serverDate:Date;
		private var _serverDateTimeStamp:Number;
		
		/************************************************************************************************************
		* Constructor / Init / Dispose																				*	
		************************************************************************************************************/
		public function TimeService() 
		{
			
		}
		
		override public function initialize():void
		{
			super.initialize();
			
			getServerTime();
		}
		

		/************************************************************************************************************
		* Public Methods																							*
		************************************************************************************************************/
		public function getServerTime():void
		{
			onServerTimeRecieved(); //TODO: do the real implementation
		}
		
		/************************************************************************************************************
		* Private Methods																							*
		************************************************************************************************************/

		/************************************************************************************************************
		* Handler Methods																							*
		************************************************************************************************************/
		private function onServerTimeRecieved():void
		{
			_serverDate = new Date(); //TODO: do the real implementation
			_serverDateTimeStamp = getTimer();
			
			dispatchEvent(new TimeServiceEvent(TimeServiceEvent.ON_SERVER_TIME_RECEIVED));
			
			if (state == EServiceState.INITIALIZING)
			{
				onInitialized();
			}
		}
		
		/************************************************************************************************************
		* Getter/Setter Methods																						*
		************************************************************************************************************/
		public function get serverDate():Date 
		{
			return _serverDate;
		}
		
		public function get serverDateTimeStamp():Number 
		{
			return _serverDateTimeStamp;
		}
	}
}