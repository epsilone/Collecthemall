/**
* @author Keven Poulin
*/
package com.funcom.project.module.book.struct
{
	import com.funcom.project.controller.step.StepController;
	import com.funcom.project.manager.enum.EManagerDefinition;
	import com.funcom.project.manager.implementation.console.enum.ELogType;
	import com.funcom.project.manager.implementation.console.Logger;
	import com.funcom.project.manager.implementation.inventory.IInventoryManager;
	import com.funcom.project.manager.implementation.loader.enum.EFileType;
	import com.funcom.project.manager.implementation.loader.ILoaderManager;
	import com.funcom.project.manager.implementation.loader.struct.LoadPacket;
	import com.funcom.project.manager.implementation.module.enum.EModuleDefinition;
	import com.funcom.project.manager.ManagerA;
	import com.funcom.project.module.book.event.BookEvent;
	import com.funcom.project.service.implementation.inventory.struct.object.BookCard;
	import com.funcom.project.service.implementation.inventory.struct.object.BookPage;
	import com.funcom.project.utils.event.Listener;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.system.ApplicationDomain;
	
	public class Page extends Sprite
	{
		/************************************************************************************************************
		* Static/Constant variables																					*
		************************************************************************************************************/
		private const DEFAULT_PAGE_VISUAL_CLASS_NAME:String = "BookPageDefault_BookModule";
		
		/************************************************************************************************************
		* Member Variables																							*
		************************************************************************************************************/
		//Manager
		private var _inventoryManager:IInventoryManager;
		private var _loaderManager:ILoaderManager;
		
		//Reference holder
		private var _bookPageInfo:BookPage;
		private var _pageContainer:DisplayObjectContainer;
		private var _cardSlotList:Vector.<CardSlot>;
		private var _index:int;
		
		//config
		private var _pageWidth:int;
		private var _pageHeight:int;
		
		//Management
		private var _initStepList:StepController;
		private var _isActivated:Boolean;
		
		//Visual
		private var _defaultVisual:MovieClip;
		private var _backgroundVisual:MovieClip;
		
		/************************************************************************************************************
		* Constructor / Init / Dispose																				*	
		************************************************************************************************************/
		public function Page(aBookPage:BookPage, aPageContainer:DisplayObjectContainer, aPageWidth:int, aPageHeight:int, aIndex:int)
		{
			_bookPageInfo = aBookPage;
			_pageContainer = aPageContainer;
			_pageWidth = aPageWidth;
			_pageHeight = aPageHeight;
			_index = aIndex;
			
			init();
		}
		
		private function init():void 
		{
			//Get manager definition
			_inventoryManager = ManagerA.getManager(EManagerDefinition.INVENTORY_MANAGER) as IInventoryManager;
			_loaderManager = ManagerA.getManager(EManagerDefinition.LOADER_MANAGER) as ILoaderManager;
			
			//Get main ref
			
			//Init var
			_cardSlotList = new Vector.<CardSlot>();
			_initStepList = new StepController("PageInit");
			_isActivated = false;
			
			if (isLeftPage)
			{
				this.x = -_pageWidth;
			}
			
			//Build init step list
			_initStepList.addStep(addDefaultBackground);
			_initStepList.addStep(loadBackground);
			_initStepList.addStep(populateCardSlotList);
			_initStepList.addStep(registerEvent);
			
			//Start step initialization
			_initStepList.start();
		}
		
		public function activate():void
		{
			if (_isActivated)
			{
				return;
			}
			_isActivated = true;
			
			
			if (_cardSlotList != null)
			{
				for each (var cardSlot:CardSlot in _cardSlotList) 
				{
					cardSlot.activate();
				}
			}
			
			_pageContainer.addChild(this);
		}
		
		public function deactivate():void
		{
			if (!_isActivated)
			{
				return;
			}
			_isActivated = false;
			
			
			if (_cardSlotList != null)
			{
				for each (var cardSlot:CardSlot in _cardSlotList) 
				{
					cardSlot.deactivate();
				}
			}
			
			_pageContainer.removeChild(this);
		}
		
		public function destroy():void
		{
			deactivate();
			
			_initStepList.destroy();
			
			if (_cardSlotList != null)
			{
				for each (var cardSlot:CardSlot in _cardSlotList) 
				{
					cardSlot.destroy();
					cardSlot = null;
				}
				_cardSlotList.length = 0;
				_cardSlotList = null;
			}
			
			//Relese visual reference
			_defaultVisual = null;
			_backgroundVisual = null;
			
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
		private function addDefaultBackground():void 
		{
			_defaultVisual = _loaderManager.getSymbol(EModuleDefinition.BOOK.assetFilePath, DEFAULT_PAGE_VISUAL_CLASS_NAME) as MovieClip;
			_defaultVisual.width = _pageWidth;
			_defaultVisual.height = _pageHeight;
			
			addChild(_defaultVisual);
			
			_initStepList.stepCompleted();
		}
		
		private function loadBackground():void 
		{
			_loaderManager.load(_bookPageInfo.bgAssetPath, EFileType.AUTO_FILE, onBackgroundLoaded, new ApplicationDomain(ApplicationDomain.currentDomain));
		}
		
		private function populateCardSlotList():void 
		{
			//Release previous reference
			_cardSlotList.length = 0; //TODO: remove them from stage
			
			//Populate the main list
			for each (var bookCard:BookCard in _bookPageInfo.cardList) 
			{
				addCardSlot(bookCard);
			}
			
			_initStepList.stepCompleted();
		}
		
		private function disptach(aEvent:BookEvent):void
		{
			aEvent.pageRef = this;
			dispatchEvent(aEvent);
		}
		
		private function addCardSlot(aBookCard:BookCard):void
		{
			var cardSlotBuffer:CardSlot = new CardSlot(aBookCard);
			Listener.add(BookEvent.CARDSLOT_VISUAL_UPDATED,cardSlotBuffer ,onEventDispatched);
			_cardSlotList.push(cardSlotBuffer);
			
			cardSlotBuffer.x = aBookCard.xPos;
			cardSlotBuffer.y = aBookCard.yPos;
			addChild(cardSlotBuffer);
		}
		
		private function registerEvent():void 
		{
			Listener.add(MouseEvent.CLICK, this, onClick);
			
			_initStepList.stepCompleted();
		}
		
		private function unregisterEvent():void 
		{
			Listener.remove(MouseEvent.CLICK, this, onClick);
		}
		
		private function onClick(aEvent:MouseEvent):void 
		{
			var event:BookEvent = new BookEvent(BookEvent.PAGE_CLICKED);
			dispatch(event);
		}
		
		private function dispatch(aEvent:BookEvent):void
		{
			aEvent.pageRef = this;
			dispatchEvent(aEvent);
		}
		
		/************************************************************************************************************
		* Handler Methods																							*
		************************************************************************************************************/
		private function onBackgroundLoaded(aLoadPacket:LoadPacket):void 
		{
			_backgroundVisual = _loaderManager.getSymbol(_bookPageInfo.bgAssetPath, "asset");
			
			if (_backgroundVisual != null)
			{
				if (_defaultVisual.parent)
				{
					_defaultVisual.parent.removeChild(_defaultVisual);
				}
				addChild(_backgroundVisual);
			}
			else
			{
				Logger.log(ELogType.WARNING, "Page", "onBackgroundLoaded", "The background image can't be retrieve!");
			}
			
			_initStepList.stepCompleted();
		}
		
		private function onEventDispatched(aEvent:BookEvent):void
		{
			disptach(aEvent.getCopy());
		}
		
		/************************************************************************************************************
		* Getter/Setter Methods																						*
		************************************************************************************************************/
		public function get bookPageInfo():BookPage 
		{
			return _bookPageInfo;
		}
		
		public function get pageWidth():int 
		{
			return _pageWidth;
		}
		
		public function get pageHeight():int 
		{
			return _pageHeight;
		}
		
		public function get index():int 
		{
			return _index;
		}
		
		public function get isLeftPage():Boolean
		{
			if (_index == 0 || _index % 2 == 0)
			{
				return false;
			}
			else
			{
				return true;
			}
		}
	}
}