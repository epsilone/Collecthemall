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
	import com.funcom.project.manager.implementation.update.IUpdatable;
	import com.funcom.project.manager.implementation.update.IUpdateManager;
	import com.funcom.project.manager.ManagerA;
	import flash.display.Sprite;
	
	public class LogTypeMenu extends Sprite implements IUpdatable
	{
		/************************************************************************************************************
		* Static/Constant variables																					*
		************************************************************************************************************/
		public static const FIXED_HEIGHT:int = 15;
		
		private const LOGTYPE_MENU_COMPONENT_LINKAGE:String = "LogTypeMenuComponent_DebugModule";
		private const UPDATE_DELAY:int = 1000;//ms
		private const LOGTYPE_COMPONENT_SPACING:int = 3;
		
		private const TOP_MARGING:int = 0;
		private const BOTTOM_MARGING:int = 0;
		private const LEFT_MARGING:int = 5;
		private const RIGHT_MARGING:int = 5;
		
		/************************************************************************************************************
		* Member Variables																							*
		************************************************************************************************************/
		//Manager
		private var _updateManager:IUpdateManager;
		private var _loaderManager:ILoaderManager;
		
		//Reference holder
		private var _componentList:Vector.<LogTypeComponent>;
		
		//Visual
		private var _componentContainer:Sprite;
		private var _mainVisual:Sprite;
		
		//Management
		private var _timeElapsed:int;
		
		/************************************************************************************************************
		* Constructor / Init / Dispose																				*	
		************************************************************************************************************/
		public function LogTypeMenu() 
		{
			init();
		}
		
		private function init():void 
		{
			//Get manager
			_updateManager = ManagerA.getManager(EManagerDefinition.UPDATE_MANAGER) as IUpdateManager;
			_loaderManager = ManagerA.getManager(EManagerDefinition.LOADER_MANAGER) as ILoaderManager;
			
			//init var
			_componentList = new Vector.<LogTypeComponent>();
			_componentContainer = new Sprite();
			_mainVisual = _loaderManager.getSymbol(EModuleDefinition.DEBUG.assetFilePath, LOGTYPE_MENU_COMPONENT_LINKAGE) as Sprite;
		}
		
		public function activate():void 
		{
			var logTypeList:Array = ELogType.getList();
			var component:LogTypeComponent;
			var xPos:int;
			
			//Create component
			for each (var logType:ELogType in logTypeList) 
			{
				component = new LogTypeComponent(logType);
				component.activate();
				component.x = xPos;
				component.y = 0;
				_componentContainer.addChild(component);
				_componentList.push(component);
				xPos += (component.width + LOGTYPE_COMPONENT_SPACING);
			}
			
			//Positioning
			_mainVisual.width = LEFT_MARGING + LogTypeComponent.FIXED_WIDTH + RIGHT_MARGING;
			_mainVisual.height = TOP_MARGING + LogTypeComponent.FIXED_HEIGHT + BOTTOM_MARGING;
			_mainVisual.x = 0;
			_mainVisual.y = 0;
			_componentContainer.x = LEFT_MARGING;
			_componentContainer.y = TOP_MARGING;
			
			//Addchild
			addChild(_mainVisual);
			addChild(_componentContainer);
			
			_updateManager.registerModule(this);
		}
		
		public function destroy():void
		{
			_updateManager.unRegisterModule(this);
			
			//release manager
			_updateManager = null;
			_loaderManager = null;
			
			//remove child / release visual
			if (_componentList)
			{
				for each (var component:LogTypeComponent in _componentList) 
				{
					if (component.parent)
					{
						component.parent.removeChild(component);
					}
					component.destroy();
				}
				_componentList.length = 0;
				_componentList = null;
			}
			
			_timeElapsed = 0;
		}

		/************************************************************************************************************
		* Public Methods																							*
		************************************************************************************************************/
		public function update(aDeltaFrame:uint, aDeltaTime:uint):void
		{
			_timeElapsed += aDeltaTime;
			
			if (_timeElapsed >= UPDATE_DELAY)
			{
				for each (var component:LogTypeComponent in _componentList) 
				{
					component.update();
				}
				_timeElapsed -= UPDATE_DELAY;
			}
		}
		
		/************************************************************************************************************
		* Private Methods																							*
		************************************************************************************************************/
		
		/************************************************************************************************************
		* Handler Methods																							*
		************************************************************************************************************/

		/************************************************************************************************************
		* Getter/Setter Methods																						*
		************************************************************************************************************/
	}
}