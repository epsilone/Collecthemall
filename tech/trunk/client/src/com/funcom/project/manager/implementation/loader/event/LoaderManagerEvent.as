/**
 * @author Keven Poulin
 * @compagny Funcom
 */
package com.funcom.project.manager.implementation.loader.event 
{
	import com.funcom.project.manager.implementation.loader.struct.LoadGroup;
	import com.funcom.project.manager.implementation.loader.struct.LoadPacket;
	import com.funcom.project.manager.implementation.loader.struct.LoadWorker;
	import flash.events.Event;
	
	public class LoaderManagerEvent extends Event
	{
		/************************************************************************************************/
		/*	Const var																					*/
		/************************************************************************************************/
		//Worker
		public static const WORKER_FREE:String = "LoaderManagerEvent::WORKER_FREE";
		
		//Worker / FWLLoader
		public static const LOADING_START:String = "LoaderManagerEvent::LOADING_START";
		public static const LOADING_PROGRESS:String = "LoaderManagerEvent::LOADING_PROGRESS";
		public static const LOADING_FAILED:String = "LoaderManagerEvent::LOADING_FAILED";
		public static const LOADING_COMPLETED:String = "LoaderManagerEvent::LOADING_COMPLETED";
		public static const LOADING_CANCELED:String = "LoaderManagerEvent::LOADING_CANCELED";
		
		//LoadPacket
		public static const PACKET_STATE_CHANGED:String = "LoaderManagerEvent::PACKET_STATE_CHANGED";
		
		//LoadGroup
		public static const GROUP_STATE_CHANGED:String = "LoaderManagerEvent::GROUP_STATE_CHANGED";
		
		/************************************************************************************************/
		/*	Member var																					*/
		/************************************************************************************************/
		private var m_packetReference:LoadPacket;
		private var m_groupReference:LoadGroup;
		private var m_workerReference:LoadWorker;
		
		/************************************************************************************************/
		/*	Constructor / Init / Dispose																*/
		/************************************************************************************************/
		public function LoaderManagerEvent(type:String, packetReference:LoadPacket = null, workerReference:LoadWorker = null, groupReference:LoadGroup = null)
		{
			m_packetReference = packetReference;
			m_workerReference = workerReference;
			m_groupReference = groupReference;
			super(type, false, false);
		}
		
		/************************************************************************************************/
		/*	Public																						*/
		/************************************************************************************************/
		public function getCopy():LoaderManagerEvent
		{
			return new LoaderManagerEvent(type, m_packetReference);
		}
		
		/************************************************************************************************/
		/*	Private																						*/
		/************************************************************************************************/
		
		/************************************************************************************************/
		/*	Handler																						*/
		/************************************************************************************************/
		
		/************************************************************************************************/
		/*	Getter / Setter																				*/
		/************************************************************************************************/
		public function get packetReference():LoadPacket 
		{
			return m_packetReference;
		}
		
		public function get groupReference():LoadGroup 
		{
			return m_groupReference;
		}
		
		public function get workerReference():LoadWorker 
		{
			return m_workerReference;
		}
	}

}