/**
* @author Keven Poulin
*/
package com.funcom.project.module.book.struct
{
	import com.funcom.project.controller.step.StepController;
	import com.funcom.project.manager.enum.EManagerDefinition;
	import com.funcom.project.manager.implementation.inventory.event.InventoryCacheEvent;
	import com.funcom.project.manager.implementation.inventory.IInventoryManager;
	import com.funcom.project.manager.implementation.loader.enum.EFileType;
	import com.funcom.project.manager.implementation.loader.ILoaderManager;
	import com.funcom.project.manager.implementation.loader.struct.LoadPacket;
	import com.funcom.project.manager.implementation.module.enum.EModuleDefinition;
	import com.funcom.project.manager.ManagerA;
	import com.funcom.project.module.book.event.BookEvent;
	import com.funcom.project.service.implementation.inventory.struct.item.CardItem;
	import com.funcom.project.service.implementation.inventory.struct.item.Item;
	import com.funcom.project.service.implementation.inventory.struct.itemtemplate.CardItemTemplate;
	import com.funcom.project.service.implementation.inventory.struct.object.BookCard;
	import com.funcom.project.utils.display.DisplayUtil;
	import com.funcom.project.utils.event.Listener;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.system.ApplicationDomain;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	public class CardSlot extends Sprite
	{
		/************************************************************************************************************
		* Static/Constant variables																					*
		************************************************************************************************************/
		private const DEFAULT_CARDSLOT_VISUAL_CLASS_NAME:String = "CardSlotDefault_BookModule";
		private const CARDSLOT_BUY_BTN_VISUAL_CLASS_NAME:String = "BuyCard_BookModule";
		private const CARDSLOT_MARGIN:int = 5;
		
		/************************************************************************************************************
		* Member Variables																							*
		************************************************************************************************************/
		//Manager
		private var _inventoryManager:IInventoryManager;
		private var _loaderManager:ILoaderManager;
		
		//Reference holder
		private var _bookCardInfo:BookCard;
		private var _cardItemTemplate:CardItemTemplate;
		private var _cardItem:CardItem;
		private var _cardQuantity:int;
		
		//Management
		private var _initStepList:StepController;
		private var _isActivated:Boolean;
		private var _cardVisualLoaded:Boolean;
		
		//Visual container
		private var _slotContainer:Sprite;
		private var _cardContainer:Sprite;
		private var _uiContainer:Sprite;
		
		//Visual
		private var _slotVisual:MovieClip;
		private var _cardVisual:Sprite;
		private var _slotIdTxt:TextField;
		private var _buyCardBtn:MovieClip; // TODO:Change for button
		
		/************************************************************************************************************
		* Constructor / Init / Dispose																				*	
		************************************************************************************************************/
		public function CardSlot(aBookCard:BookCard)
		{
			_bookCardInfo = aBookCard;
			
			init();
		}
		
		private function init():void 
		{
			//Get manager definition
			_inventoryManager = ManagerA.getManager(EManagerDefinition.INVENTORY_MANAGER) as IInventoryManager;
			_loaderManager = ManagerA.getManager(EManagerDefinition.LOADER_MANAGER) as ILoaderManager;
			
			//Get main data
			_cardItemTemplate = _inventoryManager.cache.getItemTemplateByItemTemplateId(_bookCardInfo.itemTemplateId) as CardItemTemplate;
			var itemList:Vector.<Item> = _inventoryManager.cache.getItemListByItemTemplateId(_bookCardInfo.itemTemplateId);
			if (itemList.length > 0)
			{
				_cardItem = itemList[0] as CardItem;
				_cardQuantity = _inventoryManager.cache.getItemQuantityByItemTemplateId(_bookCardInfo.itemTemplateId);
				trace("_cardQuantity",_cardQuantity);
			}
			_slotContainer = new Sprite();
			_cardContainer = new Sprite();
			_uiContainer = new Sprite();
			
			//Init var
			_initStepList = new StepController("CardSlotInit");
			_cardVisualLoaded = false;
			
			//Build init step list
			_initStepList.addStep(addContainerStep);
			_initStepList.addStep(createBaseVisualStep);
			_initStepList.addStep(loadCardStep);
			_initStepList.addStep(registerEventStep);
			
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
			
			//Raise the priority
			if (!_cardVisualLoaded)
			{
				_loaderManager.setLoadingPriority(_cardItemTemplate.assetPath, 1);
			}
		}
		
		public function deactivate():void
		{
			if (!_isActivated)
			{
				return;
			}
			_isActivated = false;
			
			//Drop the priority
			if (!_cardVisualLoaded)
			{
				_loaderManager.setLoadingPriority(_cardItemTemplate.assetPath, 2);
			}
		}
		
		public function destroy():void
		{
			deactivate();
			
			unregisterEvent();
			
			_initStepList.destroy();
			
			//Relese visual reference
			_slotVisual = null;
			_cardVisual = null;
			_slotIdTxt = null;
			
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
		private function addContainerStep():void 
		{
			addChild(_slotContainer);
			addChild(_cardContainer);
			addChild(_uiContainer);
			
			_initStepList.stepCompleted();
		}
		
		private function createBaseVisualStep():void 
		{
			//Set the default slot visual
			_slotVisual = _loaderManager.getSymbol(EModuleDefinition.BOOK.assetFilePath, DEFAULT_CARDSLOT_VISUAL_CLASS_NAME) as MovieClip;
			_slotVisual.width = _cardItemTemplate.width;
			_slotVisual.height = _cardItemTemplate.height;
			
			//Set the Id textfield
			_slotIdTxt = new TextField();
			_slotIdTxt.autoSize = TextFieldAutoSize.RIGHT;
			_slotIdTxt.text = _bookCardInfo.slotId.toString();
			_slotIdTxt.x = _slotVisual.width - _slotIdTxt.width - CARDSLOT_MARGIN;
			_slotIdTxt.y = _slotVisual.height - _slotIdTxt.height - CARDSLOT_MARGIN;
			
			//Get buy button
			_buyCardBtn = _loaderManager.getSymbol(EModuleDefinition.BOOK.assetFilePath, CARDSLOT_BUY_BTN_VISUAL_CLASS_NAME) as MovieClip;
			_buyCardBtn.x = (_slotVisual.width * 0.5) - (_buyCardBtn.width * 0.5);
			_buyCardBtn.y = (_slotVisual.height * 0.5) - (_buyCardBtn.height * 0.5);
			_buyCardBtn.visible = false;
			
			_slotContainer.addChild(_slotVisual);
			_slotContainer.addChild(_slotIdTxt);
			_uiContainer.addChild(_buyCardBtn);
			
			disptach(new BookEvent(BookEvent.CARDSLOT_VISUAL_UPDATED));
			
			_initStepList.stepCompleted();
		}
		
		private function loadCardStep():void 
		{
			if (_cardItem != null)
			{
				loadCard();
			}
			else
			{
				_initStepList.stepCompleted();
			}
		}
		
		
		private function loadCard():void 
		{
			_loaderManager.load(_cardItemTemplate.assetPath, EFileType.AUTO_FILE, onCardLoaded, new ApplicationDomain(ApplicationDomain.currentDomain), 2);
		}
		
		private function registerEventStep():void 
		{
			Listener.add(MouseEvent.MOUSE_OVER, this, onMouseOver);
			Listener.add(MouseEvent.ROLL_OUT, this, onMouseOut);
			Listener.add(MouseEvent.CLICK, _buyCardBtn, onBuyCardClick);
			Listener.add(InventoryCacheEvent.ITEM_UPDATED, _inventoryManager.cache, onItemUpdate);
			
			_initStepList.stepCompleted();
		}
		
		private function unregisterEvent():void 
		{
			Listener.remove(MouseEvent.MOUSE_OVER, this, onMouseOver);
			Listener.remove(MouseEvent.ROLL_OUT, this, onMouseOut);
			Listener.remove(MouseEvent.CLICK, _buyCardBtn, onBuyCardClick);
			Listener.remove(InventoryCacheEvent.ITEM_UPDATED, _inventoryManager.cache, onItemUpdate);
		}
		
		private function disptach(aEvent:BookEvent):void
		{
			aEvent.cardSlotRef = this;
			dispatchEvent(aEvent);
		}
		
		private function refreshData():void
		{
			//Get item instance
			var itemList:Vector.<Item> = _inventoryManager.cache.getItemListByItemTemplateId(_bookCardInfo.itemTemplateId);
			if (itemList.length > 0)
			{
				_cardItem = itemList[0] as CardItem;
				_cardQuantity = _inventoryManager.cache.getItemQuantityByItemTemplateId(_bookCardInfo.itemTemplateId);
			}
			else
			{
				_cardItem = null;
				_cardQuantity = 0;
			}
			
			if (_cardItem != null)
			{
				if (_cardVisualLoaded)
				{
					addCardVisual();
				}
				else
				{
					loadCard();
				}
			}
		}
		
		private function addCardVisual():void
		{
			//Get the card
			_cardVisual = _loaderManager.getSymbol(_cardItemTemplate.assetPath, "itemAsset") as Sprite;
			
			//Add the card
			DisplayUtil.recursivePlay(_cardVisual);
			_cardContainer.addChild(_cardVisual);
			
			//Hide the slot
			_slotVisual.visible = false;
			
			disptach(new BookEvent(BookEvent.CARDSLOT_VISUAL_UPDATED));
		}
		
		/************************************************************************************************************
		* Handler Methods																							*
		************************************************************************************************************/
		private function onCardLoaded(aLoadPacket:LoadPacket):void 
		{
			_cardVisualLoaded = true;
			
			addCardVisual();
			
			_initStepList.stepCompleted();
		}
		
		private function onMouseOver(aEvent:MouseEvent):void 
		{
			if (_cardItem == null)
			{
				_buyCardBtn.visible = true;
			}
		}
		
		private function onMouseOut(aEvent:MouseEvent):void 
		{
			_buyCardBtn.visible = false;
		}
		
		private function onBuyCardClick(aEvent:MouseEvent):void 
		{
			_inventoryManager.cache.put(new CardItem(401, 2, 1));
			aEvent.stopImmediatePropagation();
			_buyCardBtn.visible = false;
		}
		
		private function onItemUpdate(aEvent:InventoryCacheEvent):void 
		{
			if (aEvent.itemTemplateId != _cardItemTemplate.itemTemplateId)
			{
				return;
			}
			
			refreshData();
		}
		
		/************************************************************************************************************
		* Getter/Setter Methods																						*
		************************************************************************************************************/
		
	}
}