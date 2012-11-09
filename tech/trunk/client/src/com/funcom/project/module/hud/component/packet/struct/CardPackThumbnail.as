/**
* @author Keven Poulin
* @compagny Funcom
*/
package com.funcom.project.module.hud.component.packet.struct 
{
	import com.funcom.project.manager.enum.EManagerDefinition;
	import com.funcom.project.manager.implementation.inventory.IInventoryManager;
	import com.funcom.project.manager.implementation.loader.enum.EFileType;
	import com.funcom.project.manager.implementation.loader.ILoaderManager;
	import com.funcom.project.manager.implementation.loader.struct.LoadPacket;
	import com.funcom.project.manager.implementation.module.enum.EModuleDefinition;
	import com.funcom.project.manager.implementation.module.IModuleManager;
	import com.funcom.project.manager.implementation.transition.enum.ETransitionDefinition;
	import com.funcom.project.manager.ManagerA;
	import com.funcom.project.module.hud.component.packet.event.CardPackComponentEvent;
	import com.funcom.project.service.implementation.inventory.struct.item.CardPackItem;
	import com.funcom.project.service.implementation.inventory.struct.item.Item;
	import com.funcom.project.service.implementation.inventory.struct.itemtemplate.BookItemTemplate;
	import com.funcom.project.service.implementation.inventory.struct.itemtemplate.CardItemTemplate;
	import com.funcom.project.service.implementation.inventory.struct.itemtemplate.CardPackItemTemplate;
	import com.funcom.project.utils.display.DisplayUtil;
	import com.funcom.project.utils.event.Listener;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.system.ApplicationDomain;
	
	public class CardPackThumbnail extends Sprite
	{
		/************************************************************************************************************
		* Static/Constant variables																					*
		************************************************************************************************************/
		private const DEFAULT_CARD_THUMB_VISUAL_CLASS_NAME:String = "DefaultCardThumbVisual_HudModule";
		
		/************************************************************************************************************
		* Member Variables																							*
		************************************************************************************************************/
		//Manager
		private var _inventoryManager:IInventoryManager;
		private var _loaderManager:ILoaderManager;
		
		//Ref Holder
		private var _cardPackItemId:int;
		private var _cardPackItem:CardPackItem;
		private var _cardPackItemTemplate:CardPackItemTemplate;
		
		//Visual ref
		private var _cardPackImage:Sprite;
		private var _cardPackDefaultImage:Sprite;
		
		//Management
		private var _isActivated:Boolean;
		
		/************************************************************************************************************
		* Constructor / Init / Dispose																				*	
		************************************************************************************************************/
		public function CardPackThumbnail(aCardPackItemId:int) 
		{
			_cardPackItemId = aCardPackItemId;
			
			init();
		}
		
		private function init():void 
		{
			//Get manager
			_inventoryManager = ManagerA.getManager(EManagerDefinition.INVENTORY_MANAGER) as IInventoryManager;
			_loaderManager = ManagerA.getManager(EManagerDefinition.LOADER_MANAGER) as ILoaderManager;
			
			//Get main ref
			_cardPackItem = _inventoryManager.cache.getItemByItemId(_cardPackItemId) as CardPackItem;
			_cardPackItemTemplate = _inventoryManager.cache.getItemTemplateByItemTemplateId(_cardPackItem.itemTemplateId) as CardPackItemTemplate;
			
			//Init var
			_isActivated = false;
			
			//Get default visual
			_cardPackDefaultImage = _loaderManager.getSymbol(EModuleDefinition.HUD.assetFilePath, DEFAULT_CARD_THUMB_VISUAL_CLASS_NAME) as Sprite;
			
			//Set default state
			visible = false;
			renderCardPack();
			
			loadCardPackImage();
		}
		
		public function activate():void
		{
			if (_isActivated) { return; }
			
			_isActivated = true;
			
			visible = true;
			
			registerEvent();
		}
		
		public function deactivate():void
		{
			if (!_isActivated) { return; }
			
			_isActivated = false;
			
			visible = false;
			
			unregisterEvent();
		}
		
		public function destroy():void
		{
			deactivate();
			
			//Release manager reference
			_inventoryManager = null;
			_loaderManager = null;
			
			//Release var
		}
		
		/************************************************************************************************************
		* Public Methods																							*
		************************************************************************************************************/

		/************************************************************************************************************
		* Private Methods																							*
		************************************************************************************************************/
		private function loadCardPackImage():void 
		{
			_loaderManager.load(_cardPackItemTemplate.assetThumbnailPath, EFileType.SWF_FILE, onCardPackImageLoaded, new ApplicationDomain(ApplicationDomain.currentDomain));
		}
		
		private function renderCardPack():void
		{
			//Clean the visual
			DisplayUtil.RemoveAllChildren(this);
			
			//Add main image
			if (_cardPackImage != null)
			{
				addChild(_cardPackImage);
			}
			else
			{
				addChild(_cardPackDefaultImage);
			}
		}
		
		private function registerEvent():void 
		{
			Listener.add(MouseEvent.MOUSE_OVER, this, onMouseOver);
			Listener.add(MouseEvent.ROLL_OUT, this, onMouseOut);
			Listener.add(MouseEvent.CLICK, this, onMouseClick);
		}
		
		private function unregisterEvent():void 
		{
			Listener.remove(MouseEvent.MOUSE_OVER, this, onMouseOver);
			Listener.remove(MouseEvent.ROLL_OUT, this, onMouseOut);
			Listener.remove(MouseEvent.CLICK, this, onMouseClick);
		}
		
		/************************************************************************************************************
		* Handler Methods																							*
		************************************************************************************************************/
		private function onCardPackImageLoaded(aLoadPacket:LoadPacket):void 
		{
			_cardPackImage = _loaderManager.getSymbol(_cardPackItemTemplate.assetThumbnailPath, "itemAsset") as Sprite;
			
			renderCardPack();
		}
		
		private function onMouseOver(aEvent:MouseEvent):void 
		{
			dispatchEvent(new CardPackComponentEvent(CardPackComponentEvent.ON_THUMBNAIL_MOUSE_OVER));
		}
		
		private function onMouseOut(aEvent:MouseEvent):void 
		{
			dispatchEvent(new CardPackComponentEvent(CardPackComponentEvent.ON_THUMBNAIL_MOUSE_OUT));
		}
		
		private function onMouseClick(aEvent:MouseEvent):void 
		{
			dispatchEvent(new CardPackComponentEvent(CardPackComponentEvent.ON_THUMBNAIL_MOUSE_CLICK));
		}
		
		/************************************************************************************************************
		* Getter/Setter Methods																						*
		************************************************************************************************************/
		public function get cardPackItem():CardPackItem 
		{
			return _cardPackItem;
		}
		
		public function get cardPackItemTemplate():CardPackItemTemplate 
		{
			return _cardPackItemTemplate;
		}
	}
}