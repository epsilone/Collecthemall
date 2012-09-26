/**
* @author Keven Poulin
* @compagny Funcom
*/
package com.funcom.project.module.islandmap.struct
{
	import com.funcom.project.manager.enum.EManagerDefinition;
	import com.funcom.project.manager.implementation.module.enum.EModuleDefinition;
	import com.funcom.project.manager.implementation.module.IModuleManager;
	import com.funcom.project.manager.implementation.transition.enum.ETransitionDefinition;
	import com.funcom.project.manager.ManagerA;
	import com.funcom.project.utils.commoninterface.IDestroyable;
	import com.funcom.project.utils.event.Listener;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	
	public class TownObject implements IDestroyable
	{
		/************************************************************************************************************
		* Static/Constant variables																					*
		************************************************************************************************************/

		/************************************************************************************************************
		* Member Variables																							*
		************************************************************************************************************/
		private var _visual:MovieClip;
		
		/************************************************************************************************************
		* Constructor / Init / Dispose																				*	
		************************************************************************************************************/
		public function TownObject(aVisual:MovieClip)
		{
			_visual = aVisual;
			
			Listener.add(MouseEvent.MOUSE_OVER, _visual, onMouseOver);
			Listener.add(MouseEvent.MOUSE_DOWN, _visual, onMouseDown);
		}
		
		public function destroy():void 
		{
			Listener.remove(MouseEvent.MOUSE_OVER, _visual, onMouseOver);
			Listener.remove(MouseEvent.ROLL_OUT, _visual, onMouseOut);
			Listener.remove(MouseEvent.MOUSE_DOWN, _visual, onMouseDown);
			
			_visual = null;
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
		private function onMouseOver(aEvent:MouseEvent):void 
		{
			Listener.remove(MouseEvent.MOUSE_OVER, _visual, onMouseOver);
			
			_visual.scaleX = _visual.scaleY = 1.2;
			_visual.filters = [new GlowFilter(0xFFFFFF)];
			
			Listener.add(MouseEvent.ROLL_OUT, _visual, onMouseOut);
		}
		
		private function onMouseOut(aEvent:MouseEvent):void 
		{
			Listener.remove(MouseEvent.ROLL_OUT, _visual, onMouseOut);
			
			_visual.scaleX = _visual.scaleY = 1;
			_visual.filters = [];
			
			Listener.add(MouseEvent.MOUSE_OVER, _visual, onMouseOver);
		}
		
		private function onMouseDown(aEvent:MouseEvent):void 
		{
			Listener.remove(MouseEvent.ROLL_OUT, _visual, onMouseOut);
			
			_visual.scaleX = _visual.scaleY = 0.7;
			_visual.filters = [];
			
			(ManagerA.getManager(EManagerDefinition.MODULE_MANAGER) as IModuleManager).launchModule(EModuleDefinition.CATCH_GHOST, null, ETransitionDefinition.PROCESSING);
		}
		/************************************************************************************************************
		* Getter/Setter Methods																						*
		************************************************************************************************************/
	}
}