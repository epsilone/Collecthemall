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
	import com.funcom.project.module.book.enum.EBookState;
	import com.funcom.project.module.book.event.BookEvent;
	import com.funcom.project.module.book.struct.Book;
	import com.funcom.project.service.implementation.inventory.struct.itemtemplate.BookItemTemplate;
	import com.funcom.project.utils.event.Listener;
	import com.greensock.easing.Quad;
	import com.greensock.TweenLite;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Point;
	
	public class BookModule extends AbstractModule
	{
		/************************************************************************************************************
		* Static/Constant variables																					*
		************************************************************************************************************/
		private const TWEEN_SPEED:Number = 0.75;
		
		/************************************************************************************************************
		* Member Variables																							*
		************************************************************************************************************/
		//Manager
		private var _inventoryManager:IInventoryManager;
		
		//Visual ref
		private var _mainVisual:MovieClip;
		private var _bookItemTemplate:BookItemTemplate;
		private var _bookContainer:Sprite;
		private var _book:Book;
		
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
			
			_book.destroy();
			_book = null;
			
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
				_bookItemTemplate = _inventoryManager.cache.getItemTemplateByItemTemplateId(_moduleParamater[0]) as BookItemTemplate;
				if(_bookItemTemplate != null)
				{
					_book = new Book(_bookItemTemplate.itemTemplateId);
					_book.x = -(_bookItemTemplate.width * 0.5);
					_book.y = -(_bookItemTemplate.height * 0.5);
					
					Listener.add(BookEvent.BOOK_STATE_CHANGED, _book, onBookStateChanged);
				}
				else
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
			_bookContainer = new Sprite();
			
			super.getvisualDefinition();
		}
		
		override protected function render():void 
		{
			_mainVisual.x = 0;
			_mainVisual.y = 0;
			
			_bookContainer.x = _resolutionManager.stageWidth * 0.5;
			_bookContainer.y = _resolutionManager.stageHeight * 0.5;
			
			super.render();
		}
		
		override protected function addVisualOnStage():void 
		{
			addChild(_mainVisual);
			addChild(_bookContainer);
			
			_bookContainer.addChild(_book);
			
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
		
		override protected function initCompleted():void 
		{
			super.initCompleted();
		}
		
		/************************************************************************************************************
		* Handler Methods																							*
		************************************************************************************************************/
		private function onBookStateChanged(aEvent:BookEvent):void 
		{
			var targetPosition:Point = new Point(_book.x, _book.y);
			
			switch(_book.currentState)
			{
				case EBookState.CLOSE_TOP_COVER:
				{
					targetPosition.x = -(_bookItemTemplate.width * 0.5);
					break;
				}
				case EBookState.OPEN:
				{
					targetPosition.x = 0;
					break;
				}
				case EBookState.CLOSE_BACK_COVER:
				{
					targetPosition.x = (_bookItemTemplate.width * 0.5);
					break;
				}
			}
			
			TweenLite.to(_book, TWEEN_SPEED, {x:targetPosition.x, y:targetPosition.y, ease:Quad.easeInOut});
		}
		
		/************************************************************************************************************
		* Getter/Setter Methods																						*
		************************************************************************************************************/
	}
}