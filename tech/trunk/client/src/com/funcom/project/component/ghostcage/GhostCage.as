package com.funcom.project.component.ghostcage 
{
	import com.funcom.buddyworld.ui.Component;
	import com.funcom.project.manager.implementation.ghost.enum.ECageType;
	import com.funcom.project.manager.implementation.ghost.enum.EGhostType;
	import flash.display.MovieClip;
	
	/**
	 * @author Kevin Fields
	 */
	public class GhostCage extends Component 
	{
		/************************************************************************************************************
		* Static/Constant variables																					*
		************************************************************************************************************/

		/************************************************************************************************************
		* Member Variables																							*
		************************************************************************************************************/
		public var cageImages:MovieClip;
		public var ghostieImages:MovieClip;
		
		private var _cageType:ECageType = ECageType.BASIC;
		private var _ghostType:EGhostType = EGhostType.NONE;
		
		/************************************************************************************************************
		* Constructor / Init / Dispose																				*	
		************************************************************************************************************/		
		public function GhostCage(aGhostType:EGhostType, aCageType:ECageType) 
		{
			_cageType = aCageType;
			_ghostType = aGhostType;
			draw();
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
		override protected function onDraw():void 
		{
			const isValidType:Boolean = !_ghostType.equals(EGhostType.NONE);
			ghostieImages.visible = isValidType;
			
			if (isValidType)
			{
				ghostieImages.gotoAndStop(_ghostType.value);
			}
			
			cageImages.gotoAndStop(_cageType.value);
		}
		
		/************************************************************************************************************
		* Getter/Setter Methods																						*
		************************************************************************************************************/
		public function get cageType():ECageType 
		{
			return _cageType;
		}
		
		public function set cageType(value:ECageType):void 
		{
			_cageType = value;
			draw();
		}
		
		public function get ghostType():EGhostType 
		{
			return _ghostType;
		}
		
		public function set ghostType(value:EGhostType):void 
		{
			_ghostType = value;
			draw();
		}
	}
}