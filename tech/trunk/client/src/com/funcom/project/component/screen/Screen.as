package com.funcom.project.component.screen 
{
	import com.funcom.project.manager.implementation.console.enum.ELogType;
	import com.funcom.project.manager.implementation.console.Logger;
	import com.funcom.project.manager.implementation.screen.event.ScreenEvent;
	import com.funcom.project.utils.commoninterface.IDestroyable;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author Kevin Fields
	 */
	public class Screen extends Sprite implements IDestroyable 
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
		public function Screen() 
		{
			
		}
		
		public function destroy():void 
		{
			for (var index:int = 0; index < numChildren; index++)
			{
				var child:DisplayObject = getChildAt(index);
				if (child is IDestroyable)
				{
					IDestroyable(child).destroy();
				}
			}
		}
		
		/************************************************************************************************************
		* Public Methods																							*
		************************************************************************************************************/
		public final function load():void
		{
			if (onLoaded())
			{
				dispatchEvent(new ScreenEvent(ScreenEvent.LOADED));
			}
		}
		
		public final function unload():void
		{
			onUnloaded();
			dispatchEvent(new ScreenEvent(ScreenEvent.UNLOADED));
		}
		
		public final function disable():void
		{
			Logger.log(ELogType.INFO, "Screen", "disable", "Disable method called");
			mouseChildren = false;
			mouseEnabled = false;
			onDisabled();
		}
		
		public final function enable():void
		{
			Logger.log(ELogType.INFO, "Screen", "enable", "Enable method called");
			mouseChildren = true;
			mouseEnabled = true;
			onEnabled();
		}
		
		/************************************************************************************************************
		* Private Methods																							*
		************************************************************************************************************/

		/************************************************************************************************************
		* Handler Methods																							*
		************************************************************************************************************/
		
		protected function onEnabled():void
		{
			
		}
		
		protected function onDisabled():void
		{
			
		}
		
		/**
		 * @return True is returned to signify that the screen is completely loaded and not waiting for any external data. 
		 * False is returned when the custom screen still has external resources or data it is waiting for. When false is returned,
		 * it is the responsibility of the custom screen to dispatch the ScreenEvent.LOADED event.
		 */
		protected function onLoaded():Boolean
		{
			return true;
		}
		
		protected function onUnloaded():void
		{
		}
		
		/************************************************************************************************************
		* Getter/Setter Methods																						*
		************************************************************************************************************/
	}
}