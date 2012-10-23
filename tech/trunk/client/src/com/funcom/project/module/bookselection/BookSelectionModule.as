/**
* @author Keven Poulin
* @compagny Funcom
*/
package com.funcom.project.module.bookselection
{
	import com.funcom.project.controller.step.ActiveStepController;
	import com.funcom.project.manager.enum.EManagerDefinition;
	import com.funcom.project.manager.implementation.console.enum.ELogType;
	import com.funcom.project.manager.implementation.console.Logger;
	import com.funcom.project.manager.implementation.inventory.IInventoryManager;
	import com.funcom.project.manager.implementation.module.struct.AbstractModule;
	import com.funcom.project.manager.ManagerA;
	import com.funcom.project.module.bookselection.struct.BookThumbnail;
	import com.funcom.project.service.implementation.inventory.enum.EItemTemplateType;
	import com.funcom.project.service.implementation.inventory.struct.itemtemplate.BookItemTemplate;
	import com.funcom.project.utils.event.Listener;
	import com.greensock.easing.Linear;
	import com.greensock.TweenLite;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	public class BookSelectionModule extends AbstractModule
	{
		/************************************************************************************************************
		* Static/Constant variables																					*
		************************************************************************************************************/
		//Class name
		private const MODULE_VISUAL_CLASS_NAME:String = "MainVisual_BookSelectionModule";
		private const LEFT_ARROW_CLASS_NAME:String = "LeftArrow_BookSelectionModule";
		private const RIGHT_ARROW_CLASS_NAME:String = "RightArrow_BookSelectionModule";
		
		//Config
		private const NUMBER_OF_SIMULTANEOUS_BOOK:int = 3;
		private const SCREEN_MARGIN:int = 10;
		private const SPACING_BETWEEN_BOOK_THUMB:Number = 200; //px
		private const BOOK_GENERIC_WIDTH:int = 200;
		private const BOOK_GENERIC_HEIGHT:int = 260;
		private const TWEEN_SPEED:Number = 0.35; //sec
		
		/************************************************************************************************************
		* Member Variables																							*
		************************************************************************************************************/
		//Manager
		private var _inventoryManager:IInventoryManager;
		
		//Ref Holder
		private var _bookThumbnailList:Vector.<BookThumbnail>;
		private var _bookPositionList:Vector.<Point>;
		private var _bookAlphaList:Vector.<Number>;
		private var _bookScaleList:Vector.<Number>;
		private var _tweenList:Vector.<TweenLite>;
		
		//Visual ref
		private var _mainVisual:MovieClip;
		private var _bookContainer:Sprite;
		private var _leftArrow:MovieClip; //TODO: Change that for button
		private var _rightArrow:MovieClip; //TODO: Change that for button
		
		//Management
		private var _currentIndex:int;
		private var _scrollStepController:ActiveStepController;
		
		/************************************************************************************************************
		* Constructor / Init / Dispose																				*	
		************************************************************************************************************/
		public function BookSelectionModule()
		{
			
		}
		
		override public function destroy():void 
		{
			cancelTweening();
			
			//Remove book
			for each (var book:BookThumbnail in _bookThumbnailList) 
			{
				if (book.parent != null)
				{
					book.parent.removeChild(book);
				}
				book.destroy();
				book = null;
			}
			_bookThumbnailList.length = 0;
			_bookThumbnailList = null;
			
			//Release visual reference
			_mainVisual = null;
			_bookContainer = null;
			_leftArrow = null;
			_rightArrow = null;
			
			_bookPositionList.length = 0;
			_bookPositionList = null;
			_bookAlphaList.length = 0;
			_bookAlphaList = null;
			_bookScaleList.length = 0;
			_bookScaleList = null;
			
			_scrollStepController.destroy();
			
			super.destroy();
			
			//Release manager reference
			_inventoryManager = null;
		}
		
		/************************************************************************************************************
		* Private INIT STEP Methods																					*
		************************************************************************************************************/
		override protected function populateInitStep():void 
		{
			_initStepController.addStep(getvisualDefinition);
			_initStepController.addStep(createBookThumbnailList);
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
			_bookThumbnailList = new Vector.<BookThumbnail>();
			_bookPositionList = new Vector.<Point>();
			_bookAlphaList = new Vector.<Number>();
			_bookScaleList = new Vector.<Number>();
			_scrollStepController = new ActiveStepController(2);
			_tweenList = new Vector.<TweenLite>();
			
			//Populate alpha vector
			_bookAlphaList.push(0, 1, 1, 1, 0);
			
			//Populate scale vector
			_bookScaleList.push(0.5, 0.5, 1, 0.5, 0.5);
			
			super.initVar();
		}
		
		override protected function getvisualDefinition():void 
		{
			_bookContainer = new Sprite();
			_mainVisual = _loaderManager.getSymbol(_moduleDefinition.assetFilePath, MODULE_VISUAL_CLASS_NAME) as MovieClip;
			_leftArrow = _loaderManager.getSymbol(_moduleDefinition.assetFilePath, LEFT_ARROW_CLASS_NAME) as MovieClip;
			_rightArrow = _loaderManager.getSymbol(_moduleDefinition.assetFilePath, RIGHT_ARROW_CLASS_NAME) as MovieClip;
			
			super.getvisualDefinition();
		}
		
		private function createBookThumbnailList():void 
		{
			var fullBookList:Vector.<BookItemTemplate> = Vector.<BookItemTemplate>(_inventoryManager.getItemTemplateListByItemTemplateTypeId(EItemTemplateType.BOOK_TEMPLATE_TYPE.id));
			
			for each (var bookTemplate:BookItemTemplate in fullBookList) 
			{
				_bookThumbnailList.push(new BookThumbnail(bookTemplate));
			}
			
			if (_bookThumbnailList.length < NUMBER_OF_SIMULTANEOUS_BOOK)
			{
				var i:int = 0;
				var bookThumbBuffer:BookThumbnail;
				while (_bookThumbnailList.length < NUMBER_OF_SIMULTANEOUS_BOOK)
				{
					bookThumbBuffer = getBookThumbnailByRelativeIndex(i);
					_bookThumbnailList.push(new BookThumbnail(bookThumbBuffer.bookItemTemplate));
					i++;
				}
			}
			
			_initStepController.stepCompleted();
		}
		
		override protected function render():void 
		{
			_mainVisual.x = 0;
			_mainVisual.y = 0;
			
			_rightArrow.x = _resolutionManager.stageWidth - _rightArrow.width - SCREEN_MARGIN;
			_rightArrow.y = (_resolutionManager.stageHeight * 0.5) - (_rightArrow.height * 0.5);
			
			_leftArrow.x = 0 + SCREEN_MARGIN;
			_leftArrow.y = (_resolutionManager.stageHeight * 0.5) - (_leftArrow.height * 0.5);
			
			//Populate position vector
			var p2:Point = new Point((_resolutionManager.stageWidth * 0.5), (_resolutionManager.stageHeight * 0.5));
			var p0:Point = new Point(-BOOK_GENERIC_WIDTH, p2.y);
			var p1:Point = new Point(p2.x - SPACING_BETWEEN_BOOK_THUMB, p2.y);
			var p3:Point = new Point(p2.x + SPACING_BETWEEN_BOOK_THUMB, p2.y);
			var p4:Point = new Point(_resolutionManager.stageWidth + BOOK_GENERIC_WIDTH, p2.y);
			_bookPositionList.length = 0;
			_bookPositionList.push(p0, p1, p2, p3, p4);
			
			cancelTweening();
			drawBook();
			
			super.render();
		}
		
		override protected function addVisualOnStage():void 
		{
			addChild(_mainVisual);
			_mainVisual.addChild(_bookContainer);
			
			addChild(_rightArrow);
			addChild(_leftArrow);
			
			_bookThumbnailList[0].activate();
			
			drawBook();
			
			super.addVisualOnStage();
		}
		
		override protected function registerEventListener():void 
		{
			Listener.add(MouseEvent.CLICK, _rightArrow, onRightArrowClicked);
			Listener.add(MouseEvent.CLICK, _leftArrow, onLeftArrowClicked);
			
			super.registerEventListener();
		}
		
		override protected function unregisterEventListener():void 
		{
			Listener.remove(MouseEvent.CLICK, _rightArrow, onRightArrowClicked);
			Listener.remove(MouseEvent.CLICK, _leftArrow, onLeftArrowClicked);
			
			super.unregisterEventListener();
		}
		
		/************************************************************************************************************
		* Private Methods																							*
		************************************************************************************************************/
		private function drawBook():void
		{
			var bookDisplayedList:Vector.<BookThumbnail> = new Vector.<BookThumbnail>();
			var bookBuffer:BookThumbnail;
			var listIndexOffset:int = 1;
			var i:int;
			var len:int;
			
			//Clear previous instance
			clearBook();
			
			//Populate book to create
			bookDisplayedList.push(getBookThumbnailByRelativeIndex(_currentIndex - 1));
			bookDisplayedList.push(getBookThumbnailByRelativeIndex(_currentIndex));
			bookDisplayedList.push(getBookThumbnailByRelativeIndex(_currentIndex + 1));
			
			//Draw book on stage
			len = bookDisplayedList.length;
			for (i = 0; i < len; i++) 
			{
				bookBuffer = bookDisplayedList[i];
				bookBuffer.activate();
				
				bookBuffer.scaleX = bookBuffer.scaleY = _bookScaleList[i + listIndexOffset];
				bookBuffer.alpha = _bookAlphaList[i + listIndexOffset];
				bookBuffer.x = _bookPositionList[i + listIndexOffset].x;
				bookBuffer.y = _bookPositionList[i + listIndexOffset].y;
				
				_bookContainer.addChild(bookBuffer);
			}
		}
		
		private function clearBook():void
		{
			var bookBuffer:BookThumbnail;
			var i:int;
			var len:int;
			
			len = _bookThumbnailList.length;
			for (i = 0; i < len; i++) 
			{
				bookBuffer = _bookThumbnailList[i];
				bookBuffer.deactivate();
				if (bookBuffer.parent)
				{
					bookBuffer.parent.removeChild(bookBuffer);
				}
			}
		}
		
		private function scroll(aScrollDirection:int):void
		{
			var affectedThumbList:Vector.<BookThumbnail> = new Vector.<BookThumbnail>();
			var bookBuffer:BookThumbnail;
			var i:int;
			var len:int;
			var previousIndex:int = _currentIndex;
			var directionFactor:int;
			var bookArrayIndexOffset:int;
			var initialPositionArrayIndexOffset:int;
			var finalPositionArrayIndexOffset:int;
			var index:int;
			
			//Evaluate the new index
			if (aScrollDirection > 0)
			{
				directionFactor = 1;
				bookArrayIndexOffset = 0;
				initialPositionArrayIndexOffset = 1;
				finalPositionArrayIndexOffset = 0;
			}
			else if (aScrollDirection < 0)
			{
				directionFactor = -1;
				bookArrayIndexOffset = 1;
				initialPositionArrayIndexOffset = 0;
				finalPositionArrayIndexOffset = 1;
			}
			else
			{
				Logger.log(ELogType.WARNING, "BookSelectionModule", "scroll", "The provided scroll direction is neutral, no scroll will be apply.");
				return;
			}
			
			//Convert relative index into absolute index (cycle through vector)
			_currentIndex += directionFactor;
			if (_currentIndex == _bookThumbnailList.length)
			{
				_currentIndex = 0;
			}
			else if (_currentIndex < 0)
			{
				_currentIndex = _bookThumbnailList.length - 1;
			}
			
			//Populate affected thumbList
			index = -(1 + bookArrayIndexOffset);
			while (affectedThumbList.length != 4)
			{
				affectedThumbList.push(getBookThumbnailByRelativeIndex(previousIndex + index));
				index++;
			}
			
			//Give initial position
			len = affectedThumbList.length;
			for (i = 0; i < len; i++) 
			{
				bookBuffer = affectedThumbList[i];
				bookBuffer.activate();
				index = i + initialPositionArrayIndexOffset;
				bookBuffer.x = _bookPositionList[index].x;
				bookBuffer.y = _bookPositionList[index].y;
				_bookContainer.addChild(bookBuffer);
			}
			
			//Tween to target position
			for (i = 0; i < len; i++) 
			{
				bookBuffer = affectedThumbList[i];
				index = i + finalPositionArrayIndexOffset;
				if (i != len - 1)
				{
					_tweenList.push(TweenLite.to(bookBuffer, TWEEN_SPEED, { x:_bookPositionList[index].x, y:_bookPositionList[index].y, scaleX:_bookScaleList[index], scaleY:_bookScaleList[index], alpha:_bookAlphaList[index], ease:Linear.easeNone} ));
				}
				else
				{
					_tweenList.push(TweenLite.to(bookBuffer, TWEEN_SPEED, { x:_bookPositionList[index].x, y:_bookPositionList[index].y, scaleX:_bookScaleList[index], scaleY:_bookScaleList[index], alpha:_bookAlphaList[index], ease:Linear.easeNone, onComplete: onTweenCompleted } ));
				}
			}
		}
		
		private function getBookThumbnailByRelativeIndex(aRelativeIndex:int):BookThumbnail
		{
			var returnedThumbnail:BookThumbnail;
			var absoluteIndex:int = aRelativeIndex;
			var hasBeenAdjusted:Boolean = false;
			
			if (aRelativeIndex >= _bookThumbnailList.length)
			{
				absoluteIndex = aRelativeIndex - _bookThumbnailList.length;
				hasBeenAdjusted = true;
			}
			else if (aRelativeIndex < 0)
			{
				absoluteIndex = _bookThumbnailList.length + aRelativeIndex;
				hasBeenAdjusted = true;
			}
			
			if (hasBeenAdjusted)
			{
				returnedThumbnail = getBookThumbnailByRelativeIndex(absoluteIndex); //Recursivity
			}
			else
			{
				returnedThumbnail = _bookThumbnailList[absoluteIndex];
			}
			
			return returnedThumbnail;
		}
		
		private function cancelTweening():void
		{
			for each (var tween:TweenLite in _tweenList) 
			{
				tween.kill();
			}
			_tweenList.length = 0;
			_scrollStepController.clearAllStep();
		}
		
		/************************************************************************************************************
		* Handler Methods																							*
		************************************************************************************************************/
		private function onLeftArrowClicked(aEvent:MouseEvent):void 
		{
			_scrollStepController.addStep(scroll, [-1]);
		}
		
		private function onRightArrowClicked(aEvent:MouseEvent):void 
		{
			_scrollStepController.addStep(scroll, [1]);
		}
		
		private function onTweenCompleted():void 
		{
			var thumbBuffer:BookThumbnail;
			
			//Clear previous tween reference
			_tweenList.length = 0;
			
			//Deactivate outside thumb
			if (_bookThumbnailList.length >= _bookPositionList.length)
			{
				thumbBuffer = getBookThumbnailByRelativeIndex(_currentIndex - 2);
				thumbBuffer.deactivate();
				if (thumbBuffer.parent) { thumbBuffer.parent.removeChild(thumbBuffer); }
				thumbBuffer = getBookThumbnailByRelativeIndex(_currentIndex + 2);
				thumbBuffer.deactivate();
				if (thumbBuffer.parent) { thumbBuffer.parent.removeChild(thumbBuffer); }
			}
			
			//Completed scroll
			_scrollStepController.stepCompleted();
		}
		
		/************************************************************************************************************
		* Getter/Setter Methods																						*
		************************************************************************************************************/
	}
}