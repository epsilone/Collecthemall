/**
* @author Keven Poulin
* @compagny Funcom
*/
package com.funcom.project.module.book
{
	import com.funcom.project.manager.enum.EManagerDefinition;
	import com.funcom.project.manager.implementation.console.enum.ELogType;
	import com.funcom.project.manager.implementation.console.Logger;
	import com.funcom.project.manager.implementation.inventory.IInventoryManager;
	import com.funcom.project.manager.implementation.module.struct.AbstractModule;
	import com.funcom.project.manager.ManagerA;
	import com.funcom.project.service.implementation.inventory.struct.itemtemplate.BookItemTemplate;
	import flash.display.MovieClip;
	
	public class BookModule extends AbstractModule
	{
		/************************************************************************************************************
		* Static/Constant variables																					*
		************************************************************************************************************/
		
		/************************************************************************************************************
		* Member Variables																							*
		************************************************************************************************************/
		//Manager
		private var _inventoryManager:IInventoryManager;
		
		//Visual ref
		private var _mainVisual:MovieClip;
		private var _bookItemTemplate:BookItemTemplate;
		
		//Management
		
		/************************************************************************************************************
		* Constructor / Init / Dispose																				*	
		************************************************************************************************************/
		public function BookModule()
		{
			
		}
		
		override public function destroy():void 
		{
			//Release visual reference
			_mainVisual = null;
			
			super.destroy();
			
			//Release manager reference
			_inventoryManager = null;
		}
		
		
		/************************************************************************************************************
		* Public Methods																							*
		************************************************************************************************************/

		/************************************************************************************************************
		* Private Methods																							*
		************************************************************************************************************/
		override protected function populateInitStep():void 
		{
			_initStepController.addStep(getBookTemplate);
			_initStepController.addStep(getvisualDefinition);
			_initStepController.addStep(render);
			_initStepController.addStep(addVisualOnStage);
			_initStepController.addStep(registerEventListener);
		}
		
		override protected function getManagerDefinition():void 
		{
			_inventoryManager = ManagerA.getManager(EManagerDefinition.INVENTORY_MANAGER) as IInventoryManager;
			
			super.getManagerDefinition();
		}
		
		override protected function initVar():void 
		{
			super.initVar();
		}
		
		private function getBookTemplate():void 
		{
			if (_moduleParamater.length > 0)
			{
				_bookItemTemplate = _inventoryManager.getItemTemplateByItemTemplateId(_moduleParamater[0]) as BookItemTemplate;
				if (_bookItemTemplate == null)
				{
					Logger.log(ELogType.ERROR, "BookModule", "getBookTemplate", "The book ItemTemplateId received seem to not be valide. [ItemTemplateId = " + _moduleParamater[0] + "]");
					return;
				}
			}
			else
			{
				Logger.log(ELogType.ERROR, "BookModule", "getBookTemplate", "The book module must receive a book ItemTemplateId to open.");
				return;
			}
			
			_initStepController.stepCompleted();
		}
		
		override protected function getvisualDefinition():void 
		{
			_mainVisual = _loaderManager.getSymbol(_moduleDefinition.assetFilePath, "MainVisual_BookModule") as MovieClip;
			
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