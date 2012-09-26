/**
* @author Keven Poulin
* @compagny Funcom
*/
package com.funcom.project.manager.implementation.resolution 
{
	import com.funcom.project.manager.AbstractManager;
	import com.funcom.project.manager.enum.EManagerDefinition;
	import com.funcom.project.manager.implementation.layer.ILayerManager;
	import com.funcom.project.manager.implementation.resolution.event.ResolutionManagerEvent;
	import com.funcom.project.manager.ManagerA;
	import com.funcom.project.utils.event.Listener;
	import flash.events.Event;
	
	public class ResolutionManager extends AbstractManager implements IResolutionManager 
	{
		/************************************************************************************************************
		* Static/Constant variables																					*
		************************************************************************************************************/

		/************************************************************************************************************
		* Member Variables																							*
		************************************************************************************************************/
		//Manager
		private var _layerManager:ILayerManager;
		
		//Management
		private var _stageHeight:int;
		private var _stageWidth:int;
		
		/************************************************************************************************************
		* Constructor / Init / Dispose																				*	
		************************************************************************************************************/
		public function ResolutionManager() 
		{
			
		}
		
		override public function activate():void 
		{
			super.activate();
			
			//Get needed manager
			_layerManager = ManagerA.getManager(EManagerDefinition.LAYER_MANAGER) as ILayerManager;
			
			//Init base value
			_stageHeight = _layerManager.stageReference.stageHeight;
			_stageWidth = _layerManager.stageReference.stageWidth;
			
			//Register needed event
			registerEvent();
			
			onActivated();
		}
		
		/************************************************************************************************************
		* Public Methods																							*
		************************************************************************************************************/
		
		/************************************************************************************************************
		* Private Methods																							*
		************************************************************************************************************/
		private function registerEvent():void 
		{
			if (_layerManager == null)
			{
				return;
			}
			
			Listener.add(Event.RESIZE, _layerManager.stageReference, onStageResize);
		}
		
		private function unregisterEvent():void 
		{
			if (_layerManager == null)
			{
				return;
			}
			
			Listener.remove(Event.RESIZE, _layerManager.stageReference, onStageResize);
		}
		
		/************************************************************************************************************
		* Handler Methods																							*
		************************************************************************************************************/
		private function onStageResize(aEvent:Event):void 
		{
			var event:ResolutionManagerEvent;
			
			_stageHeight = _layerManager.stageReference.stageHeight;
			_stageWidth = _layerManager.stageReference.stageWidth;
			
			event = new ResolutionManagerEvent(ResolutionManagerEvent.STAGE_RESIZE, _stageWidth, _stageHeight)
			
			dispatchEvent(event);
		}
		
		/************************************************************************************************************
		* Getter/Setter Methods																						*
		************************************************************************************************************/
		public function get stageHeight():int 
		{
			return _stageHeight;
		}
		
		public function get stageWidth():int 
		{
			return _stageWidth;
		}
	}
}