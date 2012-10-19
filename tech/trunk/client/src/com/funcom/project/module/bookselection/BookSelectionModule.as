/**
* @author Keven Poulin
* @compagny Funcom
*/
package com.funcom.project.module.bookselection
{
	import com.funcom.project.manager.implementation.module.struct.AbstractModule;
	import flash.display.MovieClip;
	
	public class BookSelectionModule extends AbstractModule
	{
		/************************************************************************************************************
		* Static/Constant variables																					*
		************************************************************************************************************/
		
		/************************************************************************************************************
		* Member Variables																							*
		************************************************************************************************************/
		//Manager
		
		//Visual ref
		private var _mainVisual:MovieClip;
		
		//Management
		
		/************************************************************************************************************
		* Constructor / Init / Dispose																				*	
		************************************************************************************************************/
		public function BookSelectionModule()
		{
			
		}
		
		override public function destroy():void 
		{
			//Release visual reference
			_mainVisual = null;
			
			super.destroy();
			
			//Release manager reference
		}
		
		
		/************************************************************************************************************
		* Public Methods																							*
		************************************************************************************************************/

		/************************************************************************************************************
		* Private Methods																							*
		************************************************************************************************************/
		override protected function populateInitStep():void 
		{
			super.populateInitStep();
		}
		
		override protected function getManagerDefinition():void 
		{
			super.getManagerDefinition();
		}
		
		override protected function initVar():void 
		{
			
			super.initVar();
		}
		
		override protected function getvisualDefinition():void 
		{
			_mainVisual = _loaderManager.getSymbol(_moduleDefinition.assetFilePath, "MainVisual_BookSelectionModule") as MovieClip;
			
			super.getvisualDefinition();
		}
		
		override protected function render():void 
		{
			_mainVisual.x = 0;
			_mainVisual.y = 0;
			
			super.render();
		}
		
		override protected function addVisualOnStage():void 
		{
			addChild(_mainVisual);
			
			super.addVisualOnStage();
		}
		
		override protected function registerEventListener():void 
		{
			super.registerEventListener();
		}
		
		override protected function unregisterEventListener():void 
		{
			super.unregisterEventListener();
		}
		
		/************************************************************************************************************
		* Handler Methods																							*
		************************************************************************************************************/
		
		/************************************************************************************************************
		* Getter/Setter Methods																						*
		************************************************************************************************************/
	}
}