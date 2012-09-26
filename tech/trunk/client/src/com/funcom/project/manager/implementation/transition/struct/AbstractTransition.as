/**
 * @author Keven Poulin
 * @compagny Funcom
 */
package com.funcom.project.manager.implementation.transition.struct 
{
	import com.funcom.project.manager.enum.EManagerDefinition;
	import com.funcom.project.manager.implementation.layer.enum.ELayerDefinition;
	import com.funcom.project.manager.implementation.layer.ILayerManager;
	import com.funcom.project.manager.implementation.loader.ILoaderManager;
	import com.funcom.project.manager.implementation.resolution.event.ResolutionManagerEvent;
	import com.funcom.project.manager.implementation.resolution.IResolutionManager;
	import com.funcom.project.manager.implementation.transition.event.TransitionManagerEvent;
	import com.funcom.project.manager.ManagerA;
	import com.funcom.project.utils.event.Listener;
	import flash.display.DisplayObjectContainer;
	import flash.events.EventDispatcher;
	
	public class AbstractTransition extends EventDispatcher
	{
		/************************************************************************************************************
		* Static/Constant variables																					*
		************************************************************************************************************/

		/************************************************************************************************************
		* Member Variables																							*
		************************************************************************************************************/
		//Manager
		protected var _layerManager:ILayerManager;
		protected var _resolutionManager:IResolutionManager;
		protected var _loaderManager:ILoaderManager;
		
		//Reference holder
		protected var _callbackList:Vector.<Function>;
		
		//Management
		protected var _transitionContainer:DisplayObjectContainer;
		protected var _numberOfRequest:int;
		
		/************************************************************************************************************
		* Constructor / Init / Dispose																				*	
		************************************************************************************************************/
		public function AbstractTransition() 
		{
			
		}
		
		public function init():void
		{
			//Get manager
			_layerManager = ManagerA.getManager(EManagerDefinition.LAYER_MANAGER) as ILayerManager;
			_resolutionManager = ManagerA.getManager(EManagerDefinition.RESOLUTION_MANAGER) as IResolutionManager;
			_loaderManager = ManagerA.getManager(EManagerDefinition.LOADER_MANAGER) as ILoaderManager;
			
			//Init var
			_callbackList = new Vector.<Function>();
			_numberOfRequest = 0;
			_transitionContainer = _layerManager.getLayer(ELayerDefinition.TRANSITION);
			
			registerEventListener();
		}
		
		public function destroy():void
		{
			unregisterEventListener();
			
			_numberOfRequest = 0;
			
			_callbackList.length = 0;
			_callbackList = null;
			
			//Release manager reference
			_layerManager = null;
			_resolutionManager = null;
			_loaderManager = null;
		}
		
		
		/************************************************************************************************************
		* Public Methods																							*
		************************************************************************************************************/
		public function startRequest():void
		{
			_numberOfRequest++;
			
			if (_numberOfRequest == 1)
			{
				open();
			}
		}
		
		public function stopRequest():void
		{
			_numberOfRequest--;
			
			if (_numberOfRequest == 0)
			{
				close();
			}
		}
		
		public function addCallback(callback:Function):void
		{
			_callbackList.push(callback);
		}
		
		/************************************************************************************************************
		* Private Methods																							*
		************************************************************************************************************/
		protected function open():void
		{
			dispatchEvent(new TransitionManagerEvent(TransitionManagerEvent.TRANSITION_OPENING, this));
		}
		
		protected function close():void
		{
			dispatchEvent(new TransitionManagerEvent(TransitionManagerEvent.TRANSITION_CLOSING, this));
		}
		
		protected function registerEventListener():void 
		{
			Listener.add(ResolutionManagerEvent.STAGE_RESIZE, _resolutionManager, onResize);
		}
		
		protected function unregisterEventListener():void 
		{
			Listener.remove(ResolutionManagerEvent.STAGE_RESIZE, _resolutionManager, onResize);
		}
		
		protected function render(aStageWidth:int, aStageHeight:int):void 
		{
			
		}
		
		/************************************************************************************************************
		* Handler Methods																							*
		************************************************************************************************************/
		protected function onResize(aEvent:ResolutionManagerEvent):void 
		{
			render(aEvent.stageWidth, aEvent.stageHeight);
		}
		
		protected function onOpened():void
		{
			for each (var callback:Function in _callbackList) 
			{
				callback.apply();
			}
			
			dispatchEvent(new TransitionManagerEvent(TransitionManagerEvent.TRANSITION_OPENED, this));
		}
		
		protected function onClosed():void
		{
			dispatchEvent(new TransitionManagerEvent(TransitionManagerEvent.TRANSITION_CLOSED, this));
		}
		
		/************************************************************************************************************
		* Getter/Setter Methods																						*
		************************************************************************************************************/
	}
}