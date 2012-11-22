/**
* @author Keven Poulin
* @compagny Funcom
*/
package com.funcom.project.module.scratchcard.struct 
{
	import com.funcom.project.manager.enum.EManagerDefinition;
	import com.funcom.project.manager.implementation.loader.ILoaderManager;
	import com.funcom.project.manager.implementation.module.enum.EModuleDefinition;
	import com.funcom.project.manager.ManagerA;
	import com.funcom.project.module.scratchcard.enum.EScratchType;
	import com.funcom.project.utils.event.Listener;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	
	public class ScratchComponent extends Sprite
	{
		/************************************************************************************************************
		* Static/Constant variables																					*
		************************************************************************************************************/
		private const SCRATCHBOX_VISUAL_CLASS_NAME:String = "ScartchBox_ScratchCardMinigameModule";
		
		private const SCRATCH_SURFACE_OCCURRENCE_NAME:String = "scratchSurface";
		private const SYMBOL_CONTAINER_OCCURRENCE_NAME:String = "container";
		private const FRAME_OCCURRENCE_NAME:String = "frame";
		
		/************************************************************************************************************
		* Member Variables																							*
		************************************************************************************************************/
		//Manager
		private var _loaderManager:ILoaderManager;
		
		//Reference holder
		private var _scratchType:EScratchType; 
		
		//Visual
		private var _mainVisual:MovieClip;
		private var _scratchSurface:MovieClip;
		private var _symbolContainer:Sprite;
		private var _frame:MovieClip;
		private var _symbol:MovieClip;
		
		//Management
		private var _isScratched:Boolean;
		private var _scratchedByUser:Boolean;
		
		/************************************************************************************************************
		* Constructor / Init / Dispose																				*	
		************************************************************************************************************/
		public function ScratchComponent() 
		{
			init();
		}
		
		private function init():void
		{
			//Init manager
			_loaderManager = ManagerA.getManager(EManagerDefinition.LOADER_MANAGER) as ILoaderManager;
			
			//Init var
			_isScratched = false;
			_scratchedByUser = false;
			
			//Init visual
			_mainVisual = _loaderManager.getSymbol(EModuleDefinition.SCRATCH_CARD_MINIGAME.assetFilePath, SCRATCHBOX_VISUAL_CLASS_NAME) as MovieClip;
			_scratchSurface = _mainVisual[SCRATCH_SURFACE_OCCURRENCE_NAME] as MovieClip;
			_symbolContainer = _mainVisual[SYMBOL_CONTAINER_OCCURRENCE_NAME] as MovieClip;
			_frame = _mainVisual[FRAME_OCCURRENCE_NAME] as MovieClip;
			_symbolContainer.visible = false;
		}
		
		public function activate():void
		{
			addChild(_mainVisual);
			
			registerEvent();
		}
		
		public function deactivate():void
		{
			unregisterEvent();
		}
		
		public function destroy():void
		{
			deactivate();
		}
		
		/************************************************************************************************************
		* Public Methods																							*
		************************************************************************************************************/
		public function scratch(aScratchType:EScratchType, aScrachByUser:Boolean = true):void
		{
			if (_isScratched)
			{
				return;
			}
			_isScratched = true;
			_scratchedByUser = aScrachByUser;
			
			//Set the type
			_scratchType = aScratchType;
			
			//change frame color
			var colorTransform:ColorTransform = _frame.transform.colorTransform;
			if (aScrachByUser)
			{
				colorTransform.color = uint(0x00FF00);
				this.alpha = 1;
			}
			else
			{
				colorTransform.color = uint(0xFF0000);
				this.alpha = 0.5;
			}
			
			_frame.transform.colorTransform = colorTransform;
			
			//Populate with the correct symbol
			_symbol = _loaderManager.getSymbol(EModuleDefinition.SCRATCH_CARD_MINIGAME.assetFilePath, _scratchType.linkageName) as MovieClip;
			_symbolContainer.addChild(_symbol);
			
			//Make it visible
			_symbolContainer.visible = true;
			
			//Scratch it
			_scratchSurface.gotoAndPlay(1);
		}
		
		/************************************************************************************************************
		* Private Methods																							*
		************************************************************************************************************/
		private function registerEvent():void
		{
			
		}
		
		private function unregisterEvent():void
		{
			
		}
		
		/************************************************************************************************************
		* Handler Methods																							*
		************************************************************************************************************/
		
		/************************************************************************************************************
		* Getter/Setter Methods																						*
		************************************************************************************************************/
		public function get isScratched():Boolean 
		{
			return _isScratched;
		}
		
		public function get scratchedByUser():Boolean 
		{
			return _scratchedByUser;
		}
	}

}