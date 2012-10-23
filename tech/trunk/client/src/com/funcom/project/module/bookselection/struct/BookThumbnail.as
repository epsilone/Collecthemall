/**
* @author Keven Poulin
* @compagny Funcom
*/
package com.funcom.project.module.bookselection.struct 
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
	import com.funcom.project.service.implementation.inventory.struct.item.Item;
	import com.funcom.project.service.implementation.inventory.struct.itemtemplate.BookItemTemplate;
	import com.funcom.project.utils.display.DisplayUtil;
	import com.funcom.project.utils.event.Listener;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.system.ApplicationDomain;
	
	public class BookThumbnail extends Sprite
	{
		/************************************************************************************************************
		* Static/Constant variables																					*
		************************************************************************************************************/
		private const LOADING_BOOK_CLASS_NAME:String = "LoadingBookHolder_BookSelectionModule";
		private const LOCKED_ICON_CLASS_NAME:String = "LockedIcon_BookSelectionModule";
		
		/************************************************************************************************************
		* Member Variables																							*
		************************************************************************************************************/
		//Manager
		private var _inventoryManager:IInventoryManager;
		private var _loaderManager:ILoaderManager;
		
		//Ref Holder
		private var _bookItemTemplate:BookItemTemplate;
		
		//Visual ref
		private var _bookImage:Sprite;
		private var _loadingHolder:MovieClip;
		private var _lockedIcon:Sprite;
		
		//Management
		private var _isUnlocked:Boolean;
		private var _isVisualLoaded:Boolean;
		
		/************************************************************************************************************
		* Constructor / Init / Dispose																				*	
		************************************************************************************************************/
		public function BookThumbnail(aBookItemTemplate:BookItemTemplate) 
		{
			_bookItemTemplate = aBookItemTemplate;
			
			init();
		}
		
		private function init():void 
		{
			//Get manager
			_inventoryManager = ManagerA.getManager(EManagerDefinition.INVENTORY_MANAGER) as IInventoryManager;
			_loaderManager = ManagerA.getManager(EManagerDefinition.LOADER_MANAGER) as ILoaderManager;
			
			_lockedIcon = _loaderManager.getSymbol(EModuleDefinition.BOOK_SELECTION.assetFilePath, LOCKED_ICON_CLASS_NAME) as Sprite;
			_loadingHolder = _loaderManager.getSymbol(EModuleDefinition.BOOK_SELECTION.assetFilePath, LOADING_BOOK_CLASS_NAME) as MovieClip;
			
			_isUnlocked = false;
			_isVisualLoaded = false;
			
			this.visible = false;
			
			renderBook();
			
			loadBookVisual();
			
			Listener.add(MouseEvent.MOUSE_OVER, this, onMouseOver);
		}
		
		public function activate():void
		{
			this.visible = true;
			
			if (!_isVisualLoaded)
			{
				DisplayUtil.recursivePlay(_loadingHolder);
				//TODO: Raise the loading priority
			}
		}
		
		public function deactivate():void
		{
			this.visible = false;
		}
		
		public function destroy():void
		{
			deactivate();
			
			Listener.remove(MouseEvent.MOUSE_OVER, this, onMouseOver);
			Listener.remove(MouseEvent.ROLL_OUT, this, onMouseOut);
			Listener.remove(MouseEvent.MOUSE_DOWN, this, onMouseDown);
			
			//Release manager reference
			_inventoryManager = null;
			_loaderManager = null;
			
			//Release var
			_isUnlocked = false;
			_bookItemTemplate = null;
		}
		
		/************************************************************************************************************
		* Public Methods																							*
		************************************************************************************************************/

		/************************************************************************************************************
		* Private Methods																							*
		************************************************************************************************************/
		private function loadBookVisual():void 
		{
			_loaderManager.load(_bookItemTemplate.assetPath, EFileType.SWF_FILE, onBookVisualLoaded, new ApplicationDomain(ApplicationDomain.currentDomain));
		}
		
		private function renderBook():void
		{
			//Clean the visual
			DisplayUtil.RemoveAllChildren(this);
			
			//Get the curent locked state
			var itemList:Vector.<Item> = _inventoryManager.getItemListByItemTemplateId(_bookItemTemplate.itemTemplateId);
			_isUnlocked = Boolean(itemList.length > 0);
			
			//Add main image
			if (_bookImage != null)
			{
				_bookImage.x = -(_bookImage.width * 0.5);
				_bookImage.y = -(_bookImage.height * 0.5);
				addChild(_bookImage);
			}
			else
			{
				_loadingHolder.x = -(_loadingHolder.width * 0.5);
				_loadingHolder.y = -(_loadingHolder.height * 0.5);
				addChild(_loadingHolder);
			}
			
			//Add lock if necessary
			if (!_isUnlocked)
			{
				_lockedIcon.x = -(_lockedIcon.width * 0.5);
				_lockedIcon.y = -(_lockedIcon.height * 0.5);
				addChild(_lockedIcon);
			}
		}
		
		/************************************************************************************************************
		* Handler Methods																							*
		************************************************************************************************************/
		private function onBookVisualLoaded(aLoadPacket:LoadPacket):void 
		{
			_isVisualLoaded = true;
			_bookImage = _loaderManager.getSymbol(_bookItemTemplate.assetPath, "itemAsset") as Sprite;
			
			renderBook();
		}
		
		private function onMouseOver(aEvent:MouseEvent):void 
		{
			if (!_isUnlocked)
			{
				return;
			}
			
			Listener.remove(MouseEvent.MOUSE_OVER, this, onMouseOver);
			
			this.filters = [new GlowFilter(0x00CCFF)];
			
			Listener.add(MouseEvent.ROLL_OUT, this, onMouseOut);
			Listener.add(MouseEvent.MOUSE_DOWN, this, onMouseDown);
		}
		
		private function onMouseOut(aEvent:MouseEvent):void 
		{
			Listener.remove(MouseEvent.ROLL_OUT, this, onMouseOut);
			Listener.remove(MouseEvent.MOUSE_DOWN, this, onMouseDown);
			
			this.filters = [];
			
			Listener.add(MouseEvent.MOUSE_OVER, this, onMouseOver);
		}
		
		private function onMouseDown(aEvent:MouseEvent):void 
		{
			Listener.remove(MouseEvent.ROLL_OUT, this, onMouseOut);
			
			this.filters = [];
			
			(ManagerA.getManager(EManagerDefinition.MODULE_MANAGER) as IModuleManager).launchModule(EModuleDefinition.BOOK, [_bookItemTemplate.itemTemplateId], ETransitionDefinition.PROCESSING);
		}
		
		/************************************************************************************************************
		* Getter/Setter Methods																						*
		************************************************************************************************************/
		public function get bookItemTemplate():BookItemTemplate 
		{
			return _bookItemTemplate;
		}
	}
}