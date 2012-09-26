/**
* @author Keven Poulin
*/

package com.funcom.project.manager.implementation.loader.struct 
{
	import com.funcom.project.manager.implementation.loader.enum.EFileType;
	import com.funcom.project.manager.implementation.loader.enum.ELoadGroupState;
	import com.funcom.project.manager.implementation.loader.enum.ELoadPacketState;
	import com.funcom.project.manager.implementation.loader.event.LoaderManagerEvent;
	import flash.events.EventDispatcher;
	import flash.system.ApplicationDomain;
	
	public class LoadGroup extends EventDispatcher
	{
		/************************************************************************************************/
		/*	Member var																					*/
		/************************************************************************************************/
		//Reference
		private var m_packetList:Vector.<LoadPacket>;
		
		//Config
		private var m_callback:Function;
		private var m_loaderPriority:int;
		
		//Management
		private var m_state:String;
		private var m_loaded_count:int;
		private var m_failed_count:int;
		
		/************************************************************************************************/
		/*	Constructor / Init / Dispose																*/
		/************************************************************************************************/
		public function LoadGroup(callback:Function = null, loaderPriority:int = 1) 
		{
			init();
			
			m_callback = callback;
			m_loaderPriority = loaderPriority;
		}
		
		private function init():void 
		{
			m_packetList = new Vector.<LoadPacket>;
			state = ELoadGroupState.PENDING;
		}
		
		public function dispose():void 
		{
			m_packetList.length = 0;
			m_loaded_count = 0;
			m_failed_count = 0;
			m_loaderPriority = 0;
			m_callback = null;
			state = ELoadGroupState.DISPOSED;
		}
		
		/************************************************************************************************/
		/*	Public																						*/
		/************************************************************************************************/
		public function addToLoad(filePath:String, fileType:EFileType, applicationDomain:ApplicationDomain = null, avoidCaching:Boolean = false):void
		{
			var packet:LoadPacket = new LoadPacket(filePath, fileType, null, applicationDomain, m_loaderPriority, avoidCaching);
			registerPacket(packet);
		}
		
		public function substitutePacket(currentPacket:LoadPacket, newPacket:LoadPacket):void
		{
			var index:int = m_packetList.indexOf(currentPacket);
			if (index == -1)
			{
				return;
			}
			
			unregisterPacket(m_packetList[index]);
			registerPacket(newPacket);
		}
		
		/************************************************************************************************/
		/*	Private																						*/
		/************************************************************************************************/
		private function registerPacket(packet:LoadPacket):void
		{
			//Basic validation
			if (!packet)
			{
				return;
			}
			
			packet.addEventListener(LoaderManagerEvent.PACKET_STATE_CHANGED, onPacketStateChanged, false, 0, true);
			
			m_packetList.push(packet);
		}
		
		private function unregisterPacket(packet:LoadPacket):void
		{
			//Basic validation
			if (!packet)
			{
				return;
			}
			
			var index:int = m_packetList.indexOf(packet);
			if (index != -1)
			{
				m_packetList[index].removeEventListener(LoaderManagerEvent.PACKET_STATE_CHANGED, onPacketStateChanged);
				m_packetList.splice(index, 1);
			}
		}
		
		/************************************************************************************************/
		/*	Handler																						*/
		/************************************************************************************************/
		private function onPacketStateChanged(event:LoaderManagerEvent):void 
		{
			var totalLoaded:int;
			
			//Change current state
			state = ELoadGroupState.LOADING;
			
			//Update Count
			switch(event.packetReference.state)
			{
				case ELoadPacketState.LOADED:
				{
					m_loaded_count++;
					break;
				}
				case ELoadPacketState.FAILED:
				{
					m_failed_count++;
					break;
				}
			}
			
			//Get total loaded files
			totalLoaded = m_loaded_count + m_failed_count;
			
			//Check if the group has been fully loaded
			if (totalLoaded == m_packetList.length)
			{
				m_callback.apply(null, []);
				state = ELoadGroupState.COMPLETED;
			}
		}
		
		public function get packetList():Vector.<LoadPacket> 
		{
			return m_packetList;
		}
		
		public function get state():String 
		{
			return m_state;
		}
		
		public function set state(value:String):void 
		{
			if (m_state == value)
			{
				return;
			}
			
			m_state = value;
			
			dispatchEvent(new LoaderManagerEvent(LoaderManagerEvent.GROUP_STATE_CHANGED, null, null, this));
		}
	}
}