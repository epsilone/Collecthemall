/**
* @author Keven Poulin
*/
package com.funcom.project.module.hud.component.packet
{
	import com.funcom.project.controller.step.ActiveStepController;
	import com.funcom.project.controller.step.StepController;
	import com.funcom.project.manager.enum.EManagerDefinition;
	import com.funcom.project.manager.implementation.console.enum.ELogType;
	import com.funcom.project.manager.implementation.console.Logger;
	import com.funcom.project.manager.implementation.inventory.event.InventoryCacheEvent;
	import com.funcom.project.manager.implementation.inventory.IInventoryManager;
	import com.funcom.project.manager.implementation.loader.ILoaderManager;
	import com.funcom.project.manager.implementation.module.enum.EModuleDefinition;
	import com.funcom.project.manager.implementation.module.IModuleManager;
	import com.funcom.project.manager.implementation.transition.enum.ETransitionDefinition;
	import com.funcom.project.manager.ManagerA;
	import com.funcom.project.module.hud.component.packet.event.CardPackComponentEvent;
	import com.funcom.project.module.hud.component.packet.struct.CardPackThumbnail;
	import com.funcom.project.service.implementation.inventory.enum.EItemTemplateType;
	import com.funcom.project.service.implementation.inventory.struct.item.CardItem;
	import com.funcom.project.service.implementation.inventory.struct.item.CardPackItem;
	import com.funcom.project.service.implementation.inventory.struct.item.Item;
	import com.funcom.project.service.implementation.inventory.struct.itemtemplate.ItemTemplate;
	import com.funcom.project.utils.display.DisplayUtil;
	import com.funcom.project.utils.event.Listener;
	import com.greensock.easing.Linear;
	import com.greensock.easing.Quint;
	import com.greensock.TweenLite;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	public class CardPackComponent extends Sprite
	{
		/************************************************************************************************************
		* Static/Constant variables																					*
		************************************************************************************************************/
		//Class name
		private const VISUAL_CLASS_NAME:String = "CardPackComponent_HudModule";
		
		//Occurrence name
		private const LEFT_ARROW_OCCURRENCE_NAME:String = "leftArrow";
		private const RIGHT_ARROW_OCCURRENCE_NAME:String = "rightArrow";
		private const PACK_CONTAINER_OCCURRENCE_NAME:String = "packContainer";
		private const ADD_PACK_OCCURRENCE_NAME:String = "addBtn";
		
		//Config
		private const NUMBER_OF_SIMULTANEOUS_PACK:int = 8;
		private const SPACING_BETWEEN_PACK_THUMB:Number = 40; //px
		private const PACK_GENERIC_WIDTH:int = 50;
		private const PACK_GENERIC_HEIGHT:int = 85;
		private const SCROLL_TWEEN_SPEED:Number = 0.15; //sec
		private const OVER_TWEEN_SPEED:Number = 0.2; //sec
		
		/************************************************************************************************************
		* Member Variables																							*
		************************************************************************************************************/
		//Manager
		private var _inventoryManager:IInventoryManager;
		private var _loaderManager:ILoaderManager;
		private var _moduleManager:IModuleManager;
		
		//Reference holder
		private var _packXPositionList:Vector.<int>;
		private var _packAlphaList:Vector.<Number>;
		private var _cardPackThumbList:Vector.<CardPackThumbnail>;
		private var _tweenList:Vector.<TweenLite>;
		
		//config
		
		//Management
		private var _initStepList:StepController;
		private var _previousIndex:int;
		private var _currentIndex:int;
		private var _scrollStepController:ActiveStepController;
		private var _isTweening:Boolean;
		
		//Visual
		private var _mainVisual:MovieClip;
		private var _packContainer:Sprite;
		private var _leftArrow:MovieClip;
		private var _rightArrow:MovieClip;
		private var _addBtn:MovieClip;
		
		/************************************************************************************************************
		* Constructor / Init / Dispose																				*	
		************************************************************************************************************/
		public function CardPackComponent()
		{
			init();
		}
		
		private function init():void 
		{
			//Get manager definition
			_inventoryManager = ManagerA.getManager(EManagerDefinition.INVENTORY_MANAGER) as IInventoryManager;
			_loaderManager = ManagerA.getManager(EManagerDefinition.LOADER_MANAGER) as ILoaderManager;
			_moduleManager = ManagerA.getManager(EManagerDefinition.MODULE_MANAGER) as IModuleManager;
			
			//Init var
			_packXPositionList = new Vector.<int>();
			_packAlphaList = new Vector.<Number>();
			_cardPackThumbList = new Vector.<CardPackThumbnail>();
			_tweenList = new Vector.<TweenLite>();
			_scrollStepController = new ActiveStepController(2);
			_initStepList = new StepController("PacketComponent");
			_isTweening = false;
			
			//Build init step list
			_initStepList.addStep(addComponentVisual);
			_initStepList.addStep(populateScrollingVector);
			_initStepList.addStep(populateCardPackThumbnailList);
			_initStepList.addStep(drawThumbnail);
			_initStepList.addStep(registerEvent);
			
			//Start step initialization
			_initStepList.start();
		}
		
		public function destroy():void
		{
			_initStepList.destroy();
			
			
			//Relese visual reference
			_mainVisual = null;
			
			//Release manager reference
			_inventoryManager = null;
			_loaderManager = null;
			_moduleManager = null;
		}
		
		/************************************************************************************************************
		* Public Methods																							*
		************************************************************************************************************/
		
		
		/************************************************************************************************************
		* Private Methods																							*
		************************************************************************************************************/
		private function addComponentVisual():void 
		{
			_mainVisual = _loaderManager.getSymbol(EModuleDefinition.HUD.assetFilePath, VISUAL_CLASS_NAME) as MovieClip;
			_packContainer = _mainVisual[PACK_CONTAINER_OCCURRENCE_NAME] as Sprite;
			_leftArrow = _mainVisual[LEFT_ARROW_OCCURRENCE_NAME] as MovieClip;
			_rightArrow = _mainVisual[RIGHT_ARROW_OCCURRENCE_NAME] as MovieClip;
			_addBtn = _mainVisual[ADD_PACK_OCCURRENCE_NAME] as MovieClip;
			
			addChild(_mainVisual);
			
			_initStepList.stepCompleted();
		}
		
		private function populateScrollingVector():void 
		{
			var numberOfSlot:int = NUMBER_OF_SIMULTANEOUS_PACK + 2;
			var xPosition:int = -SPACING_BETWEEN_PACK_THUMB;
			var index:int;
			
			//Position vecor
			for (index = 0; index < numberOfSlot; index++) 
			{
				_packXPositionList.push(xPosition);
				xPosition += SPACING_BETWEEN_PACK_THUMB;
			}
			
			//Alpha vector
			_packAlphaList.push(0);
			for (index = 0; index < NUMBER_OF_SIMULTANEOUS_PACK; index++) 
			{
				_packAlphaList.push(1);
			}
			_packAlphaList.push(0);
			
			_initStepList.stepCompleted();
		}
		
		private function populateCardPackThumbnailList():void 
		{
			var cardPackItemList:Vector.<Item> = _inventoryManager.cache.getItemListByItemTemplateTypeId(EItemTemplateType.CARD_PACK_TEMPLATE_TYPE.id);
			var cardPackItemBuffer:CardPackItem;
			var cardPackThumbBuffer:CardPackThumbnail;
			var len:int = cardPackItemList.length;
			
			destroyThumbnail();
			
			for (var i:int = 0; i < len; i++) 
			{
				cardPackItemBuffer = cardPackItemList[i] as CardPackItem;
				for (var j:int = 0; j < cardPackItemBuffer.quantity; j++) 
				{
					cardPackThumbBuffer = new CardPackThumbnail(cardPackItemBuffer.id);
					Listener.add(CardPackComponentEvent.ON_THUMBNAIL_MOUSE_OVER, cardPackThumbBuffer, onMouseOverThumbnail);
					Listener.add(CardPackComponentEvent.ON_THUMBNAIL_MOUSE_OUT, cardPackThumbBuffer, onMouseOutThumbnail);
					Listener.add(CardPackComponentEvent.ON_THUMBNAIL_MOUSE_CLICK, cardPackThumbBuffer, onMouseClickThumbnail);
					_cardPackThumbList.push(cardPackThumbBuffer);
				}
			}
			
			_initStepList.stepCompleted();
		}
		
		private function drawThumbnail():void 
		{
			var cardPackThumbBuffer:CardPackThumbnail;
			var len:int = _cardPackThumbList.length;
			var index:int;
			var i:int;
			
			//Remove previous instance
			for (i = 0; i < len; i++) 
			{
				cardPackThumbBuffer = _cardPackThumbList[i];
				cardPackThumbBuffer.deactivate();
				if (cardPackThumbBuffer.parent)
				{
					cardPackThumbBuffer.parent.removeChild(cardPackThumbBuffer);
				}
			}
			
			//Render from the current index
			for (i = 0; i < NUMBER_OF_SIMULTANEOUS_PACK; i++) 
			{
				index = _currentIndex + i;
				if (index > len - 1)
				{
					break;
				}
				cardPackThumbBuffer = _cardPackThumbList[index];
				
				cardPackThumbBuffer.x = _packXPositionList[i + 1];
				cardPackThumbBuffer.activate();
				_packContainer.addChild(cardPackThumbBuffer);
			}
			
			//Update arrow visual
			updateArrow();
			
			_initStepList.stepCompleted();
		}
		
		private function updateArrow():void 
		{
			if (_currentIndex == 0)
			{
				_leftArrow.visible = false;
			}
			else
			{
				_leftArrow.visible = true;
			}
			
			if (_currentIndex >= _cardPackThumbList.length - NUMBER_OF_SIMULTANEOUS_PACK)
			{
				_rightArrow.visible = false;
			}
			else
			{
				_rightArrow.visible = true;
			}
		}
		
		private function scroll(aScrollDirection:int):void
		{
			var affectedThumbList:Vector.<CardPackThumbnail> = new Vector.<CardPackThumbnail>();
			var cardPackThumbnail:CardPackThumbnail;
			var i:int;
			var len:int;
			var previousIndex:int = _currentIndex;
			var directionFactor:int;
			var cardPackArrayIndexOffset:int;
			var initialPositionArrayIndexOffset:int;
			var finalPositionArrayIndexOffset:int;
			var index:int;
			
			//Evaluate the new index
			if (aScrollDirection > 0)
			{
				directionFactor = 1;
				cardPackArrayIndexOffset = 0;
				initialPositionArrayIndexOffset = 1;
				finalPositionArrayIndexOffset = 0;
			}
			else if (aScrollDirection < 0)
			{
				directionFactor = -1;
				cardPackArrayIndexOffset = -1;
				initialPositionArrayIndexOffset = 0;
				finalPositionArrayIndexOffset = 1;
			}
			else
			{
				Logger.log(ELogType.WARNING, "BookSelectionModule", "scroll", "The provided scroll direction is neutral, no scroll will be apply.");
				return;
			}
			
			//Convert relative index into absolute index (cycle through vector)
			_previousIndex = _currentIndex;
			_currentIndex += directionFactor;
			if (_currentIndex == _cardPackThumbList.length)
			{
				_currentIndex = 0;
			}
			else if (_currentIndex < 0)
			{
				_currentIndex = _cardPackThumbList.length - 1;
			}
			
			//Populate affected thumbList
			index = cardPackArrayIndexOffset;
			while (affectedThumbList.length != NUMBER_OF_SIMULTANEOUS_PACK + 1)
			{
				affectedThumbList.push(_cardPackThumbList[previousIndex + index]);
				index++;
			}
			
			//Give initial position
			len = affectedThumbList.length;
			for (i = 0; i < len; i++) 
			{
				cardPackThumbnail = affectedThumbList[i];
				cardPackThumbnail.activate();
				index = i + initialPositionArrayIndexOffset;
				cardPackThumbnail.x = _packXPositionList[index];
				cardPackThumbnail.alpha = _packAlphaList[index];
				_packContainer.addChild(cardPackThumbnail);
			}
			
			//Tween to target position
			for (i = 0; i < len; i++) 
			{
				cardPackThumbnail = affectedThumbList[i];
				index = i + finalPositionArrayIndexOffset;
				if (i != len - 1)
				{
					_tweenList.push(TweenLite.to(cardPackThumbnail, SCROLL_TWEEN_SPEED, { x:_packXPositionList[index], alpha:_packAlphaList[index], ease:Linear.easeNone} ));
				}
				else
				{
					_tweenList.push(TweenLite.to(cardPackThumbnail, SCROLL_TWEEN_SPEED, { x:_packXPositionList[index], alpha:_packAlphaList[index], ease:Linear.easeNone, onComplete: onTweenCompleted } ));
				}
			}
			
			_isTweening = true;
			
			updateArrow();
		}
		
		private function registerEvent():void 
		{
			Listener.add(MouseEvent.CLICK, _leftArrow, onLeftArrowClicked);
			Listener.add(MouseEvent.CLICK, _rightArrow, onRightArrowClicked);
			Listener.add(MouseEvent.CLICK, _addBtn, onAddClick);
			Listener.add(InventoryCacheEvent.ITEM_UPDATED, _inventoryManager.cache, onItemUpdate);
			
			_initStepList.stepCompleted();
		}
		
		private function unregisterEvent():void 
		{
			Listener.remove(MouseEvent.CLICK, _leftArrow, onLeftArrowClicked);
			Listener.remove(MouseEvent.CLICK, _rightArrow, onRightArrowClicked);
			Listener.remove(MouseEvent.CLICK, _addBtn, onAddClick);
			Listener.remove(InventoryCacheEvent.ITEM_UPDATED, _inventoryManager.cache, onItemUpdate);
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
		
		private function destroyThumbnail():void
		{
			for each (var cardPackThumbnail:CardPackThumbnail in _cardPackThumbList) 
			{
				if (cardPackThumbnail.parent)
				{
					cardPackThumbnail.parent.removeChild(cardPackThumbnail);
				}
				Listener.remove(CardPackComponentEvent.ON_THUMBNAIL_MOUSE_OVER, cardPackThumbnail, onMouseOverThumbnail);
				Listener.remove(CardPackComponentEvent.ON_THUMBNAIL_MOUSE_OUT, cardPackThumbnail, onMouseOutThumbnail);
				Listener.remove(CardPackComponentEvent.ON_THUMBNAIL_MOUSE_CLICK, cardPackThumbnail, onMouseClickThumbnail);
				cardPackThumbnail.destroy();
				cardPackThumbnail = null;
			}
			_cardPackThumbList.length = 0;
		}
		
		private function sortThumbnail():void
		{
			var index:int = _currentIndex;
			var len:int = Math.min(index + NUMBER_OF_SIMULTANEOUS_PACK, _cardPackThumbList.length)
			for (var i:int = 0; i < len; i++) 
			{
				_packContainer.addChild(_cardPackThumbList[i]);
			}
		}
		
		
		/************************************************************************************************************
		* Handler Methods																							*
		************************************************************************************************************/
		private function onLeftArrowClicked(aEvent:MouseEvent):void 
		{
			_scrollStepController.addStep(scroll, [-1]);
			
			//_currentIndex++;
			//drawThumbnail();
		}
		
		private function onRightArrowClicked(aEvent:MouseEvent):void 
		{
			_scrollStepController.addStep(scroll, [1]);
			
			//_currentIndex--;
			//drawThumbnail();
		}
		
		private function onAddClick(aEvent:MouseEvent):void 
		{
			var id:int = 1000 + (10000000 - 1000) * Math.random();
			var templateId:int = 7 + (10 - 7) * Math.random();
			var fakeCardPack:CardPackItem = new CardPackItem(id, templateId, 1);
			_inventoryManager.cache.put(fakeCardPack);
		}
		
		private function onTweenCompleted():void 
		{
			var thumbBuffer:CardPackThumbnail;
			var indexBuffer:int;
			
			//Clear previous tween reference
			_tweenList.length = 0;
			
			//Deactivate outside thumb
			if (_cardPackThumbList.length >= _packXPositionList.length)
			{
				if (_previousIndex < _currentIndex)
				{
					indexBuffer = _currentIndex - 1;
				}
				else
				{
					indexBuffer = _currentIndex + NUMBER_OF_SIMULTANEOUS_PACK;
				}
				
				if (indexBuffer >= 0 || indexBuffer < _cardPackThumbList.length)
				{
					thumbBuffer = _cardPackThumbList[indexBuffer];
					thumbBuffer.deactivate();
					if (thumbBuffer.parent) { thumbBuffer.parent.removeChild(thumbBuffer); }
				}
			}
			
			_isTweening = false;
			
			//Completed scroll
			_scrollStepController.stepCompleted();
		}
		
		private function onItemUpdate(aEvent:InventoryCacheEvent):void 
		{
			var itemTemplate:ItemTemplate = _inventoryManager.cache.getItemTemplateByItemTemplateId(aEvent.itemTemplateId);
			if (itemTemplate.itemTemplateTypeId != EItemTemplateType.CARD_PACK_TEMPLATE_TYPE.id)
			{
				return;
			}
			
			populateCardPackThumbnailList();
			drawThumbnail();
		}
		
		private function onMouseOverThumbnail(aEvent:CardPackComponentEvent):void
		{
			if (_isTweening) { return; }
			
			var cardPackThumb:CardPackThumbnail = aEvent.currentTarget as CardPackThumbnail;
			_tweenList.push(TweenLite.to(cardPackThumb, OVER_TWEEN_SPEED, { y:15, ease:Linear.easeNone}));
			_packContainer.addChild(cardPackThumb);
		}
		
		private function onMouseOutThumbnail(aEvent:CardPackComponentEvent):void
		{
			if (_isTweening) { return; }
			
			var cardPackThumb:CardPackThumbnail = aEvent.currentTarget as CardPackThumbnail;
			_tweenList.push(TweenLite.to(cardPackThumb, OVER_TWEEN_SPEED, { y:0, ease:Linear.easeNone}));
			sortThumbnail();
		}
		
		private function onMouseClickThumbnail(aEvent:CardPackComponentEvent):void
		{
			if (_isTweening) { return; }
			
			var cardPackThumb:CardPackThumbnail = aEvent.currentTarget as CardPackThumbnail;
			_moduleManager.launchModule(EModuleDefinition.SCRATCH_CARD_MINIGAME, [cardPackThumb.cardPackItem.id], ETransitionDefinition.PROCESSING);
		}
		
		/************************************************************************************************************
		* Getter/Setter Methods																						*
		************************************************************************************************************/
	}
}