package com.funcom.project.main.enum 
{
	import com.funcom.project.manager.implementation.screen.struct.ScreenDefinition;
	
	/**
	 * @author Kevin Fields
	 */
	public final class EGameScreenDefinitions 
	{
		/************************************************************************************************************
		* Static/Constant variables																					*
		************************************************************************************************************/
		private static const BASE_SCREEN_PACKAGE:String = "com.funcom.project.ui.screen.";
		private static const MINIGAMES_BASE_SCREEN_PACKAGE:String = "com.funcom.project.minigames.";
		
		public static const MAP_SCREEN:ScreenDefinition = new ScreenDefinition("screen/MapScreen.swf", BASE_SCREEN_PACKAGE + "MapScreen");
		public static const COLLECTION_SCREEN:ScreenDefinition = new ScreenDefinition("screen/CollectionScreen.swf", BASE_SCREEN_PACKAGE + "CollectionScreen");
		public static const SELL_SCREEN:ScreenDefinition = new ScreenDefinition("screen/SellScreen.swf", BASE_SCREEN_PACKAGE + "SellScreen");
		public static const NURTURE_SCREEN:ScreenDefinition = new ScreenDefinition("screen/NurtureScreen.swf", BASE_SCREEN_PACKAGE + "NurtureScreen");
		
		// Minigames
		public static const CATCH_GHOSTS_SCREEN:ScreenDefinition = new ScreenDefinition("screen/CatchGhostsScreen.swf", MINIGAMES_BASE_SCREEN_PACKAGE + "example.screen.CatchGhostsScreen");
	}
}