/**
* @author Keven Poulin
* @compagny Funcom
*/
package com.funcom.project.module.debug.struct.log
{
	import com.funcom.project.manager.enum.EManagerDefinition;
	import com.funcom.project.manager.implementation.console.enum.ELogType;
	import com.funcom.project.manager.implementation.loader.ILoaderManager;
	import com.funcom.project.manager.implementation.module.enum.EModuleDefinition;
	import com.funcom.project.manager.ManagerA;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	
	public class LogTypeComponent extends Sprite
	{
		/************************************************************************************************************
		* Static/Constant variables																					*
		************************************************************************************************************/
		public static const FIXED_HEIGHT:int = 15;
		public static const FIXED_WIDTH:int = 50;
		
		private const LOGTYPE_COMPONENT_LINKAGE:String = "LogTypeComponent_DebugModule";
		
		/************************************************************************************************************
		* Member Variables																							*
		************************************************************************************************************/
		//Manager
		private var _loaderManager:ILoaderManager;
		
		//Reference holder
		private var _logType:ELogType;
		
		//Visual
		private var _mainVisual:MovieClip; //TODO: SHould be a button
		private var _countTxt:TextField;
		private var _iconContainer:Sprite;
		private var _icon:Sprite;
		
		/************************************************************************************************************
		* Constructor / Init / Dispose																				*	
		************************************************************************************************************/
		public function LogTypeComponent(aLogType:ELogType) 
		{
			_logType = aLogType;
			
			init();
		}
		
		private function init():void 
		{
			_loaderManager = ManagerA.getManager(EManagerDefinition.LOADER_MANAGER) as ILoaderManager;
		}
		
		public function activate():void 
		{
			_mainVisual = _loaderManager.getSymbol(EModuleDefinition.DEBUG.assetFilePath, LOGTYPE_COMPONENT_LINKAGE) as MovieClip;
			_icon = _loaderManager.getSymbol(EModuleDefinition.DEBUG.assetFilePath, _logType.iconLinkage) as MovieClip;
			_countTxt = _mainVisual["logTypeCount"] as TextField;
			_iconContainer = _mainVisual["logTypeIconContainer"] as Sprite;
			
			_iconContainer.addChild(_icon);
			addChild(_mainVisual);
			
			update();
		}
		
		public function destroy():void
		{
			//release manager
			_loaderManager = null;
			
			//remove main child
			if (_mainVisual && _mainVisual.parent)
			{
				_mainVisual.parent.removeChild(_mainVisual);
			}
			
			//release visual
			_mainVisual = null;
			_countTxt = null;
			_iconContainer = null;
			_icon = null;
		}

		/************************************************************************************************************
		* Public Methods																							*
		************************************************************************************************************/
		public function update():void
		{
			if (Number(_countTxt.text) != Number(_logType.count))
			{
				flash();
			}
			
			_countTxt.text = _logType.count.toString();
		}
		
		/************************************************************************************************************
		* Private Methods																							*
		************************************************************************************************************/
		private function flash():void
		{
			
		}
		
		/************************************************************************************************************
		* Handler Methods																							*
		************************************************************************************************************/

		/************************************************************************************************************
		* Getter/Setter Methods																						*
		************************************************************************************************************/
	}
}