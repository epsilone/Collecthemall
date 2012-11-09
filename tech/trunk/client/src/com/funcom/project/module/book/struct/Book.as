/**
* @author Keven Poulin
*/
package com.funcom.project.module.book.struct
{
	import com.funcom.project.controller.step.ActiveStepController;
	import com.funcom.project.controller.step.StepController;
	import com.funcom.project.manager.enum.EManagerDefinition;
	import com.funcom.project.manager.implementation.console.enum.ELogType;
	import com.funcom.project.manager.implementation.console.Logger;
	import com.funcom.project.manager.implementation.inventory.IInventoryManager;
	import com.funcom.project.manager.implementation.loader.ILoaderManager;
	import com.funcom.project.manager.ManagerA;
	import com.funcom.project.module.book.enum.EBookState;
	import com.funcom.project.module.book.event.BookEvent;
	import com.funcom.project.module.book.lib.Flipper.event.PageFlipperEvent;
	import com.funcom.project.module.book.lib.Flipper.PageFlipper;
	import com.funcom.project.service.implementation.inventory.struct.item.BookItem;
	import com.funcom.project.service.implementation.inventory.struct.item.Item;
	import com.funcom.project.service.implementation.inventory.struct.itemtemplate.BookItemTemplate;
	import com.funcom.project.service.implementation.inventory.struct.object.BookPage;
	import com.funcom.project.utils.event.Listener;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	public class Book extends Sprite
	{
		/************************************************************************************************************
		* Static/Constant variables																					*
		************************************************************************************************************/

		/************************************************************************************************************
		* Member Variables																							*
		************************************************************************************************************/
		//Manager
		private var _inventoryManager:IInventoryManager;
		private var _loaderManager:ILoaderManager;
		
		//Reference holder
		private var _bookItemTemplateId:int;
		private var _bookItemTemplate:BookItemTemplate;
		private var _bookItem:BookItem;
		private var _pageList:Vector.<Page>;
		private var _flipperList:Vector.<PageFlipper>
		
		//Management
		private var _initStepList:StepController;
		private var _flippingActiveStepList:ActiveStepController;
		private var _currentPageIndex:int;
		private var _currentState:String;
		
		//Visual
		private var _flipperContainer:Sprite;
		private var _pageContainer:Sprite;
		
		/************************************************************************************************************
		* Constructor / Init / Dispose																				*	
		************************************************************************************************************/
		public function Book(aBookItemTemplateId:int)
		{
			_bookItemTemplateId = aBookItemTemplateId;
			
			init();
		}
		
		private function init():void 
		{
			//Get manager definition
			_inventoryManager = ManagerA.getManager(EManagerDefinition.INVENTORY_MANAGER) as IInventoryManager;
			_loaderManager = ManagerA.getManager(EManagerDefinition.LOADER_MANAGER) as ILoaderManager;
			
			//Get main ref
			_bookItemTemplate = _inventoryManager.cache.getItemTemplateByItemTemplateId(_bookItemTemplateId) as BookItemTemplate;
			var itemList:Vector.<Item> = _inventoryManager.cache.getItemListByItemTemplateId(_bookItemTemplateId);
			if (itemList != null && itemList.length > 0)
			{
				_bookItem = itemList[0] as BookItem;
			}
			
			//Init var
			_initStepList = new StepController("BookInit");
			_flippingActiveStepList = new ActiveStepController(2);
			_currentPageIndex = 0;
			_pageList = new Vector.<Page>();
			_flipperList = new Vector.<PageFlipper>();
			_flipperContainer = new Sprite();
			_pageContainer = new Sprite();
			
			
			//TODO:Move this
			addChild(_pageContainer);
			addChild(_flipperContainer);
			
			//Build init step list
			_initStepList.addStep(populatePageList);
			_initStepList.addStep(activateFirstPage);
			
			//Start step initialization
			_initStepList.start();
		}
		
		public function destroy():void
		{
			_initStepList.destroy();
			_initStepList = null;
			
			if (_pageList != null)
			{
				for each (var page:Page in _pageList) 
				{
					Listener.remove(BookEvent.PAGE_CLICKED, page, onPageClicked);
					page.destroy();
				}
				_pageList.length = 0;
				_pageList = null;
			}
			
			//Release manager reference
			_inventoryManager = null;
			_loaderManager = null;
		}
		
		/************************************************************************************************************
		* Public Methods																							*
		************************************************************************************************************/
		
		
		/************************************************************************************************************
		* Private Methods																							*
		************************************************************************************************************/
		private function populatePageList():void 
		{
			//Release previous reference
			_pageList.length = 0;
			
			//Populate the main list
			var visualBuffer:MovieClip;
			var frontPageInfoBuffer:BookPage;
			var backPageInfoBuffer:BookPage;
			
			var bookPageList:Vector.<BookPage> = _bookItemTemplate.bookContent.pageList;
			var len:int = bookPageList.length;
			for (var i:int = 0; i < len; i++) 
			{
				addPage(bookPageList[i]);
			}
			
			_initStepList.stepCompleted();
		}
		
		private function activateFirstPage():void 
		{
			if (_pageList.length > 0)
			{
				_pageList[0].activate();
			}
			
			changeState(EBookState.CLOSE_TOP_COVER);
			
			_initStepList.stepCompleted();
		}
		
		private function addPage(aPageInfo:BookPage):void
		{
			var pageBuffer:Page = new Page(aPageInfo, _pageContainer, _bookItemTemplate.width, _bookItemTemplate.height, _pageList.length);
			
			_pageList.push(pageBuffer);
			Listener.add(BookEvent.PAGE_CLICKED, pageBuffer, onPageClicked);
		}
		
		private function addFlipper(aFrontPage:Page, aBackPage:Page, aIsGoingToLeft:Boolean = false):void
		{
			var pageFlipper:PageFlipper = new PageFlipper(aFrontPage, aBackPage, aIsGoingToLeft);
			Listener.add(PageFlipperEvent.FLIPPING_STARTED, pageFlipper, onPageFlipperStarted);
			Listener.add(PageFlipperEvent.FLIPPING_COMPLETED, pageFlipper, onPageFlipperCompleted);
			_flipperList.push(pageFlipper);
			
			pageFlipper.start();
			
			_flipperContainer.addChildAt(pageFlipper, 0);
		}
		
		private function removeFlipper(aPageFlipper:PageFlipper):void
		{
			Listener.remove(PageFlipperEvent.FLIPPING_STARTED, aPageFlipper, onPageFlipperStarted);
			Listener.remove(PageFlipperEvent.FLIPPING_COMPLETED, aPageFlipper, onPageFlipperCompleted);
			
			var index:int = _flipperList.indexOf(aPageFlipper);
			if (index != -1)
			{
				_flipperList.splice(index, 1);
			}
			
			_flipperContainer.removeChild(aPageFlipper);
		}
		
		private function dispatch(aEvent:BookEvent):void
		{
			aEvent.bookRef = this;
			dispatchEvent(aEvent);
		}
		
		private function goToPageIndex(aPageIndex:int):void
		{
			var currentPageDuo:Vector.<Page> = getPageDuoByPageIndex(_currentPageIndex);
			var nextPageDuo:Vector.<Page> = getPageDuoByPageIndex(aPageIndex);
			var pageFlipper:PageFlipper;
			var isBookFlippingToLeft:Boolean;
			
			//Check if there is page to display at this index
			if (nextPageDuo.length <= 0)
			{
				Logger.log(ELogType.WARNING, "Book", "goToPageIndex", "can't turn the page, the duo cannot be found");
				return;
			}
			
			//Check if already in the requested page
			if (currentPageDuo[0].index == nextPageDuo[0].index)
			{
				Logger.log(ELogType.WARNING, "Book", "goToPageIndex", "You are already at the requested page! [aPageIndex = " + aPageIndex.toString() + "]");
				return;
			}
			
			isBookFlippingToLeft = Boolean(_currentPageIndex > aPageIndex);
			
			if (isBookFlippingToLeft) //Going to the right
			{
				addFlipper(nextPageDuo[nextPageDuo.length - 1], currentPageDuo[0], isBookFlippingToLeft);
				currentPageDuo[0].deactivate();
				if (nextPageDuo.length > 1)
				{
					nextPageDuo[0].activate();
				}
			}
			else //Going to the left
			{
				addFlipper(currentPageDuo[currentPageDuo.length - 1], nextPageDuo[0], isBookFlippingToLeft);
				currentPageDuo[currentPageDuo.length - 1].deactivate();
				
				if (nextPageDuo.length > 1)
				{
					nextPageDuo[1].activate();
				}
			}
			
			//Adjust book state
			if (nextPageDuo.length > 1)
			{
				changeState(EBookState.OPEN);
			}
			else
			{
				if (isBookFlippingToLeft)
				{
					changeState(EBookState.CLOSE_TOP_COVER);
				}
				else
				{
					changeState(EBookState.CLOSE_BACK_COVER);
				}
			}
			
			//Keep the new index (always the left page index)
			_currentPageIndex = nextPageDuo[0].index;
		}
		
		private function getPageDuoByPageIndex(aPageIndex:int):Vector.<Page>
		{
			var pageDuo:Vector.<Page> = new Vector.<Page>();
			
			if (aPageIndex < 0 || aPageIndex > _pageList.length - 1)
			{
				Logger.log(ELogType.WARNING, "Book", "getPageDuoByPageIndex", "The provided page index in out of the limit [aPageIndex = " + aPageIndex.toString() + "]");
				return pageDuo;
			}
			
			if (aPageIndex == 0 || aPageIndex == _pageList.length - 1)
			{
				pageDuo.push(_pageList[aPageIndex]);
			}
			else
			{
				if (_pageList[aPageIndex].isLeftPage)
				{
					pageDuo.push(_pageList[aPageIndex]);
					pageDuo.push(_pageList[aPageIndex + 1]);
				}
				else
				{
					pageDuo.push(_pageList[aPageIndex - 1]);
					pageDuo.push(_pageList[aPageIndex]);
				}
			}
			
			return pageDuo;
		}
		
		private function changeState(aBookState:String):void
		{
			if (aBookState == _currentState)
			{
				return;
			}
			
			_currentState = aBookState;
			dispatch(new BookEvent(BookEvent.BOOK_STATE_CHANGED));
		}
		
		/************************************************************************************************************
		* Handler Methods																							*
		************************************************************************************************************/
		private function onPageClicked(aEvent:BookEvent):void
		{
			var clickedPage:Page = aEvent.pageRef;
			var targetPageIndex:int;
			
			if (clickedPage.isLeftPage)
			{
				targetPageIndex = _currentPageIndex - 1;
			}
			else
			{
				targetPageIndex = _currentPageIndex + 2;
			}
			
			_flippingActiveStepList.addStep(goToPageIndex, [targetPageIndex]);
		}
		
		private function onPageFlipperStarted(aEvent:PageFlipperEvent):void 
		{
			
		}
		
		private function onPageFlipperCompleted(aEvent:PageFlipperEvent):void 
		{
			var pageFlipper:PageFlipper = aEvent.pageFlipperRef;
			var currentPageDuo:Vector.<Page> = getPageDuoByPageIndex(_currentPageIndex);
			
			if (pageFlipper.isGoingToLeft)
			{
				currentPageDuo[currentPageDuo.length - 1].activate();
			}
			else
			{
				currentPageDuo[0].activate();
			}
			
			removeFlipper(pageFlipper);
			
			_flippingActiveStepList.stepCompleted();
		}
		
		private function onEventDispatched(aEvent:BookEvent):void
		{
			dispatch(aEvent.getCopy());
		}
		
		/************************************************************************************************************
		* Getter/Setter Methods																						*
		************************************************************************************************************/
		public function get bookItemTemplateId():int 
		{
			return _bookItemTemplateId;
		}
		
		public function get bookItemTemplate():BookItemTemplate 
		{
			return _bookItemTemplate;
		}
		
		public function get currentState():String 
		{
			return _currentState;
		}
	}
}