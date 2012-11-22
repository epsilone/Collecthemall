/**
* @author Keven Poulin
* @compagny Funcom
*/
package com.funcom.project.module.scratchcard
{
	import com.funcom.project.manager.enum.EManagerDefinition;
	import com.funcom.project.manager.implementation.inventory.IInventoryManager;
	import com.funcom.project.manager.implementation.loader.enum.EFileType;
	import com.funcom.project.manager.implementation.loader.struct.LoadGroup;
	import com.funcom.project.manager.implementation.loader.struct.LoadPacket;
	import com.funcom.project.manager.implementation.minigame.event.MinigameManagerEvent;
	import com.funcom.project.manager.implementation.minigame.IMinigameManager;
	import com.funcom.project.manager.implementation.module.struct.AbstractModule;
	import com.funcom.project.manager.ManagerA;
	import com.funcom.project.module.scratchcard.enum.EScratchCardMinigameState;
	import com.funcom.project.module.scratchcard.enum.EScratchType;
	import com.funcom.project.module.scratchcard.struct.ScratchComponent;
	import com.funcom.project.service.implementation.inventory.struct.item.CardPackItem;
	import com.funcom.project.service.implementation.inventory.struct.item.Item;
	import com.funcom.project.service.implementation.inventory.struct.itemtemplate.CardPackItemTemplate;
	import com.funcom.project.service.implementation.inventory.struct.itemtemplate.ItemTemplate;
	import com.funcom.project.utils.display.DisplayUtil;
	import com.funcom.project.utils.event.Listener;
	import com.greensock.easing.Back;
	import com.greensock.easing.Elastic;
	import com.greensock.easing.Quad;
	import com.greensock.TweenLite;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.system.ApplicationDomain;
	import flash.utils.setTimeout;
	
	public class ScratchCardMinigameModule extends AbstractModule
	{
		/************************************************************************************************************
		* Static/Constant variables																					*
		************************************************************************************************************/
		//Class name
		private const MODULE_VISUAL_CLASS_NAME:String = "MainVisual_ScratchCardMinigameModule";
		private const OPENING_VISUAL_CLASS_NAME:String = "ExplosionFX_ScratchCardMinigameModule";
		
		//Config
		private const NUMBER_SCRATCH_ALLOWED:int = 3;
		private const NUMBER_SCRATCH_ROW:int = 3;
		private const NUMBER_SCRATCH_COLLUMN:int = 2;
		private const SCRATCH_GRID_SPACING:int = 5;
		private const REWARD_SPACING:int = 10;
		
		/************************************************************************************************************
		* Member Variables																							*
		************************************************************************************************************/
		//Manager
		private var _inventoryManager:IInventoryManager;
		private var _minigameManager:IMinigameManager;
		
		//Ref Holder
		private var _cardPackItem:CardPackItem;
		private var _cardPackItemTemplate:CardPackItemTemplate;
		private var _scratchComponentList:Vector.<ScratchComponent>;
		private var _scratchTypeResultList:Vector.<EScratchType>;
		private var _scratchRewardTemplateList:Vector.<ItemTemplate>;
		
		//Visual ref
		private var _mainVisual:MovieClip;
		private var _cardVisual:MovieClip;
		private var _openingAnimFX:MovieClip;
		
		//Container
		private var _mainContainer:Sprite;
		private var _rewardContainer:Sprite;
		private var _cardPackContainer:Sprite;
		private var _scratchContainer:Sprite;
		private var _scratchGridContainer:Sprite;
		private var _rewardVisualList:Vector.<MovieClip>;
		
		//Management
		private var _minigameState:String;
		private var _numberOfScratchedComponent:int;
		
		/************************************************************************************************************
		* Constructor / Init / Dispose																				*	
		************************************************************************************************************/
		public function ScratchCardMinigameModule()
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
		* Private INIT STEP Methods																					*
		************************************************************************************************************/
		override protected function populateInitStep():void 
		{
			_initStepController.addStep(getvisualDefinition);
			_initStepController.addStep(loadCardVisual);
			_initStepController.addStep(render);
			_initStepController.addStep(populateScratchComponentList);
			_initStepController.addStep(createScratchGrid);
			_initStepController.addStep(addVisualOnStage);
			_initStepController.addStep(getScratchResult);
			_initStepController.addStep(loadRewardVisual);
			_initStepController.addStep(registerEventListener);
		}
		
		override protected function getManagerDefinition():void 
		{
			_inventoryManager = ManagerA.getManager(EManagerDefinition.INVENTORY_MANAGER) as IInventoryManager;
			_minigameManager = ManagerA.getManager(EManagerDefinition.MINIGAME_MANAGER) as IMinigameManager;
			
			var cardPackItemId:int = _moduleParamater[0] as int;
			_cardPackItem = _inventoryManager.cache.getItemByItemId(cardPackItemId) as CardPackItem;
			_cardPackItemTemplate = _inventoryManager.cache.getItemTemplateByItemTemplateId(_cardPackItem.itemTemplateId) as CardPackItemTemplate;
			
			super.getManagerDefinition();
		}
		
		override protected function initVar():void 
		{
			changeMinigameState(EScratchCardMinigameState.INIT);
			
			_mainContainer = new Sprite();
			_cardPackContainer = new Sprite();
			_rewardContainer = new Sprite();
			_scratchContainer = new Sprite();
			_scratchGridContainer = new Sprite();
			_scratchComponentList = new Vector.<ScratchComponent>();
			_scratchTypeResultList = new Vector.<EScratchType>();
			_scratchRewardTemplateList = new Vector.<ItemTemplate>();
			_rewardVisualList = new Vector.<MovieClip>();
			_numberOfScratchedComponent = 0;
			
			_scratchContainer.alpha = 0;
			
			super.initVar();
		}
		
		override protected function getvisualDefinition():void 
		{
			_mainVisual = _loaderManager.getSymbol(_moduleDefinition.assetFilePath, MODULE_VISUAL_CLASS_NAME) as MovieClip;
			_openingAnimFX = _loaderManager.getSymbol(_moduleDefinition.assetFilePath, OPENING_VISUAL_CLASS_NAME) as MovieClip;
			
			super.getvisualDefinition();
		}
		
		private function loadCardVisual():void 
		{
			_loaderManager.load(_cardPackItemTemplate.assetPath, EFileType.SWF_FILE, onCardVisualLoaded, new ApplicationDomain(ApplicationDomain.currentDomain));
		}
		
		override protected function render():void 
		{
			_mainVisual.x = 0;
			_mainVisual.y = 0;
			
			switch(_minigameState)
			{
				case EScratchCardMinigameState.PLAYING_INTRO:
				case EScratchCardMinigameState.PLAYING_OUTRO:
				case EScratchCardMinigameState.INIT:
				{
					break;
				}
				case EScratchCardMinigameState.PLAYING_MINIGAME:
				{
					_cardPackContainer.x = _resolutionManager.stageWidth * 0.5;
					_cardPackContainer.y = _resolutionManager.stageHeight * 0.5;
					break;
				}
			}
			
			super.render();
		}
		
		private function createScratchGrid():void
		{
			var indexRow:int;
			var indexCollumn:int;
			var index:int;
			var scratchBufffer:ScratchComponent;
			
			for (indexRow = 0; indexRow < NUMBER_SCRATCH_ROW; indexRow++) 
			{
				for (indexCollumn = 0; indexCollumn < NUMBER_SCRATCH_COLLUMN; indexCollumn++) 
				{
					scratchBufffer = _scratchComponentList[index];
					scratchBufffer.activate();
					scratchBufffer.x = (indexCollumn * scratchBufffer.width) + (indexCollumn * SCRATCH_GRID_SPACING);
					scratchBufffer.y = (indexRow * scratchBufffer.height) + (indexRow * SCRATCH_GRID_SPACING);
					_scratchGridContainer.addChild(scratchBufffer);
					
					index++
				}
			}
			
			_initStepController.stepCompleted();
		}
		
		override protected function addVisualOnStage():void 
		{
			addChild(_mainVisual);
			addChild(_mainContainer)
			_cardPackContainer.addChild(_cardVisual);
			_cardPackContainer.addChild(_scratchContainer);
			_scratchContainer.addChild(_scratchGridContainer);
			
			super.addVisualOnStage();
		}
		
		private function getScratchResult():void 
		{
			Listener.add(MinigameManagerEvent.ON_GET_SCRATCH_RESULT, _minigameManager, onGetScratchResult);
			_minigameManager.getScratchResult();
		}
		
		private function loadRewardVisual():void 
		{
			var loadGroup:LoadGroup = new LoadGroup(onRewardVisualLoaded);
			
			for each (var itemTemplate:ItemTemplate in _scratchRewardTemplateList) 
			{
				loadGroup.addToLoad(itemTemplate.assetPath, EFileType.SWF_FILE, new ApplicationDomain(ApplicationDomain.currentDomain));
			}
			
			_loaderManager.loadGroup(loadGroup);
		}
		
		private function populateScratchComponentList():void 
		{
			var indexRow:int;
			var indexCollumn:int;
			
			for (indexRow = 0; indexRow < NUMBER_SCRATCH_ROW; indexRow++) 
			{
				for (indexCollumn = 0; indexCollumn < NUMBER_SCRATCH_COLLUMN; indexCollumn++) 
				{
					addScratchComponent(new ScratchComponent());
				}
			}
			
			_initStepController.stepCompleted();
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
			
			changeMinigameState(EScratchCardMinigameState.PLAYING_INTRO);
		}
		
		private function playIntroAnim():void 
		{	
			//Evaluate target position
			var xPos:int = _resolutionManager.stageWidth * 0.5;
			var yPos:int = _resolutionManager.stageHeight * 0.5;
			
			//Place correctly the visual element
			_cardPackContainer.scaleX = _cardPackContainer.scaleY = 1.4;
			_cardPackContainer.rotation = -90;
			_cardPackContainer.x = -_cardPackContainer.width;
			_cardPackContainer.y = (_resolutionManager.stageHeight * 0.5) - (_cardPackContainer.height * 0.5);
			
			//Make sure teh stage is on stage
			_mainContainer.addChild(_cardPackContainer);
			
			//Start the tween
			TweenLite.to(_cardPackContainer, 0.5, {x:xPos, y:yPos, rotation:0, ease:Back.easeOut, onComplete:onPackIntroCompleted});
		}
		
		private function playOutroAnim():void 
		{	
			//Evaluate target position
			var xPos:int = -(_cardPackContainer.height * 0.5);
			var yPos:int = (_resolutionManager.stageHeight * 0.5);
			
			//Set correct state
			changeMinigameState(EScratchCardMinigameState.PLAYING_OUTRO);
			
			//Place correctly the visual element
			_cardPackContainer.scaleX = _cardPackContainer.scaleY = 1.4;
			_cardPackContainer.rotation = 0;
			_cardPackContainer.x = _resolutionManager.stageWidth * 0.5;
			_cardPackContainer.y = _resolutionManager.stageHeight * 0.5;
			
			//Make sure teh stage is on stage
			_mainContainer.addChild(_cardPackContainer);
			
			//Start the tween
			TweenLite.to(_cardPackContainer, 1, {x:xPos, y:yPos, rotation:-90, ease:Quad.easeIn, onComplete:onOutroAnimCompleted});
		}
		
		private function addScratchComponent(aScratchComponent:ScratchComponent):void 
		{
			Listener.add(MouseEvent.CLICK, aScratchComponent, onScratchClick);
			_scratchComponentList.push(aScratchComponent);
		}
		
		/************************************************************************************************************
		* Private Methods																							*
		************************************************************************************************************/
		private function changeMinigameState(aMinigameGameState:String):void
		{
			if (_minigameState == aMinigameGameState)
			{
				return;
			}
			
			_minigameState = aMinigameGameState;
			
			switch (_minigameState)
			{
				case EScratchCardMinigameState.INIT:
				{
					
					break;
				}
				case EScratchCardMinigameState.PLAYING_INTRO:
				{
					playIntroAnim();
					break;
				}
				case EScratchCardMinigameState.PLAYING_MINIGAME:
				{
					
					break;
				}
				case EScratchCardMinigameState.SHOW_MINIGAME_RESULT:
				{
					showMiniGameResult();
					break;
				}
				case EScratchCardMinigameState.SHOW_REWARD:
				{
					showReward();
					break;
				}
				case EScratchCardMinigameState.PLAYING_OUTRO:
				{
					playOutroAnim();
					break;
				}
			}
			
			if (_minigameState != EScratchCardMinigameState.INIT)
			{
				render();
			}
		}
		
		private function playScratchIntroAnim():void
		{
			//Set correct visual state
			_scratchContainer.alpha = 0;
			_scratchGridContainer.x = -(_scratchGridContainer.width * 0.5);
			_scratchGridContainer.y = -(_scratchGridContainer.height * 0.5);
			_scratchContainer.scaleX = _scratchContainer.scaleY = 0;
			
			//Start the tween
			TweenLite.to(_scratchContainer, 1, {scaleX:1, scaleY:1, alpha:1, ease:Elastic.easeOut, onComplete:onScratchIntroCompleted});
		}
		
		private function scratchRemainingScratchComponent():void
		{
			var indexOffset:int = 0;
			
			for each (var scratchComponent:ScratchComponent in _scratchComponentList) 
			{
				if (!scratchComponent.isScratched)
				{
					scratchComponent.scratch(_scratchTypeResultList[_numberOfScratchedComponent + indexOffset], false);
					indexOffset++;
				}
			}
			
			setTimeout(playScratchOutroAnim, 1000);
		}
		
		private function playScratchOutroAnim():void
		{
			//Set correct visual state
			_scratchContainer.alpha = 1;
			_scratchGridContainer.x = -(_scratchGridContainer.width * 0.5);
			_scratchGridContainer.y = -(_scratchGridContainer.height * 0.5);
			_scratchContainer.scaleX = _scratchContainer.scaleY = 1;
			
			//Start the tween
			TweenLite.to(_scratchContainer, 1, {scaleX:0, scaleY:0, alpha:0, ease:Elastic.easeIn, onComplete:onScratchOutroCompleted});
		}
		
		private function showMiniGameResult():void 
		{
			setTimeout(scratchRemainingScratchComponent, 500);
		}
		
		private function showReward():void
		{
			//Set correct visual state
			_cardPackContainer.x = _resolutionManager.stageWidth * 0.5;
			_cardPackContainer.y = _resolutionManager.stageHeight * 0.5;
			_scratchContainer.alpha = 0;
			_scratchGridContainer.x = -(_scratchGridContainer.width * 0.5);
			_scratchGridContainer.y = -(_scratchGridContainer.height * 0.5);
			_scratchContainer.scaleX = _scratchContainer.scaleY = 0;
			
			_openingAnimFX.x = _cardPackContainer.x;
			_openingAnimFX.y = _cardPackContainer.y;
			
			_mainContainer.addChild(_openingAnimFX);
			DisplayUtil.recursivePlay(_openingAnimFX);
			
			setTimeout(placeRewardOnStage, 2100);
		}
		
		private function placeRewardOnStage():void 
		{
			var xPos:int = 0;
			
			_cardPackContainer.parent.removeChild(_cardPackContainer);
			
			if (_rewardVisualList.length <= 0)
			{
				return;
			}
			
			for each (var rewardVisual:MovieClip in _rewardVisualList) 
			{
				rewardVisual.x = xPos;
				_rewardContainer.addChild(rewardVisual);
				xPos = rewardVisual.width + REWARD_SPACING;
			}
			
			_rewardContainer.x = (_resolutionManager.stageWidth * 0.5) - (_rewardContainer.width * 0.5);
			_rewardContainer.y = (_resolutionManager.stageHeight * 0.5) - (_rewardContainer.height * 0.5);
			
			_mainContainer.addChild(_rewardContainer);
		}
		
		/************************************************************************************************************
		* Handler Methods																							*
		************************************************************************************************************/
		private function onCardVisualLoaded(aLoadPacket:LoadPacket):void
		{
			_cardVisual = _loaderManager.getSymbol(_cardPackItemTemplate.assetPath, "itemAsset") as MovieClip;
			_cardVisual.x = -(_cardVisual.width * 0.5);
			_cardVisual.y = -(_cardVisual.height * 0.5);
			
			_initStepController.stepCompleted();
		}
		
		private function onRewardVisualLoaded():void 
		{
			for each (var itemTemplate:ItemTemplate in _scratchRewardTemplateList) 
			{
				_rewardVisualList.push(_loaderManager.getSymbol(itemTemplate.assetPath, "itemAsset") as MovieClip);
			}
			
			_initStepController.stepCompleted();
		}
		
		private function onGetScratchResult(aEvent:MinigameManagerEvent):void 
		{
			Listener.remove(MinigameManagerEvent.ON_GET_SCRATCH_RESULT, _minigameManager, onGetScratchResult);
			
			for each (var scratchResultTypeId:int in aEvent.dataList) 
			{
				_scratchTypeResultList.push(EScratchType.getScratchTypeByScratchTypeId(scratchResultTypeId))
			}
			
			for each (var itemTemplateId:int in aEvent.rewardList) 
			{
				_scratchRewardTemplateList.push(_inventoryManager.cache.getItemTemplateByItemTemplateId(itemTemplateId));
			}
			
			_initStepController.stepCompleted();
		}
		
		private function onPackIntroCompleted():void 
		{
			playScratchIntroAnim();
		}
		
		private function onScratchIntroCompleted():void 
		{
			changeMinigameState(EScratchCardMinigameState.PLAYING_MINIGAME);
		}
		
		private function onScratchOutroCompleted():void 
		{
			changeMinigameState(EScratchCardMinigameState.SHOW_REWARD);
		}
		
		private function onScratchClick(aEvent:MouseEvent):void 
		{
			if (_numberOfScratchedComponent >= NUMBER_SCRATCH_ALLOWED)
			{
				return;
			}
			
			var scratchClicked:ScratchComponent = aEvent.currentTarget as ScratchComponent;
			if (scratchClicked.isScratched)
			{
				return;
			}
			
			scratchClicked.scratch(_scratchTypeResultList[_numberOfScratchedComponent]);
			_numberOfScratchedComponent++;
			
			if (_numberOfScratchedComponent >= NUMBER_SCRATCH_ALLOWED)
			{
				changeMinigameState(EScratchCardMinigameState.SHOW_MINIGAME_RESULT);
			}
		}
		
		private function onOutroAnimCompleted():void 
		{
			
		}
		
		/************************************************************************************************************
		* Getter/Setter Methods																						*
		************************************************************************************************************/
	}
}