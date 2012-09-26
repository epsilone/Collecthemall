/**
 * @author Keven Poulin
 * @compagny Funcom
 */
package com.funcom.prelauncher.main
{
	import com.funcom.project.main.IGame;
	import com.funcom.project.manager.enum.EManagerDefinition;
	import com.funcom.project.manager.event.ManagerEvent;
	import com.funcom.project.manager.implementation.layer.enum.ELayerDefinition;
	import com.funcom.project.manager.implementation.layer.ILayerManager;
	import com.funcom.project.manager.implementation.loader.enum.EFileType;
	import com.funcom.project.manager.implementation.loader.ILoaderManager;
	import com.funcom.project.manager.implementation.loader.struct.LoadPacket;
	import com.funcom.project.manager.importation.PrelauncherManagerImport;
	import com.funcom.project.manager.ManagerA;
	import com.funcom.project.utils.event.Listener;
	import com.funcom.project.utils.logic.step.event.StepControllerEvent;
	import com.funcom.project.utils.logic.step.StepController;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.TimerEvent;
	import flash.system.Security;
	import flash.text.TextField;
	import flash.utils.getTimer;
	import flash.utils.Timer;
	
	[SWF(backgroundColor="0x000000", frameRate="30", width="720", height="640")]
	public class Prelauncher extends Sprite
	{
		/************************************************************************************************************
		* Static/Constant variables																					*
		************************************************************************************************************/
		//Configuration
		private const PRELAUNCHER_ASSET_PATH:String = "asset/prelauncher/Prelauncher.swf";
		private const PRELAUNCHER_ASSET_LINKAGE:String = "PrelauncherAsset";
		private const GAME_PATH:String = "Ghosties.swf";
		
		private const UPDATING_PERCENT_SPEED:int = 1; //ms
		private const WAITING_TIME_AFTER_FULLY_LOADED:int = 250;//ms
		private const GAME_NUMBER_OF_STEP_TOTAL_DEFAULT:int = 10;
		
		/************************************************************************************************************
		* Member Variables																							*
		************************************************************************************************************/
		//Manager
		private var _loaderManager:ILoaderManager;
		private var _layerManager:ILayerManager;
		
		//Reference
		private var _gameInstance:IGame;
		
		//
		private var _currentDomainBaseUrl:String;
		private var _flashVars:Object;
		
		//Management
		private var _initStepController:StepController;
		private var _prelauncherNumberOfStepDone:int;
		private var _prelauncherNumberOfStepTotal:int;
		private var _gameNumberOfStepDone:int;
		private var _gameNumberOfStepTotal:int;
		private var _currentPercentage:int;
		
		//Time management
		private var _lastTimeStamp:int;
		private var _timeSpent:int;
		private var _endingTimer:Timer;
		
		//Visual
		private var _prelauncherContainer:Sprite;
		private var _prelauncherVisual:Sprite;
		private var _progressbar:MovieClip;
		private var _progressbarLabel:TextField;
		
		/************************************************************************************************************
		* Constructor / Init / Dispose																				*	
		************************************************************************************************************/
		public function Prelauncher()
		{
			if (stage)
			{
				init();
			}
			else 
			{
				addEventListener(Event.ADDED_TO_STAGE, init);
			}
		}
		
		private function init(e:Event = null):void 
		{
			//Remove AddToStage Event
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			_initStepController = new StepController("Prelauncher Init Step");
			_initStepController.addStep(initializeVar);
			_initStepController.addStep(registerEnterFrame);
			_initStepController.addStep(initializePrelauncherManager);
			_initStepController.addStep(activatePrelauncherManager);
			_initStepController.addStep(setLayer);
			_initStepController.addStep(loadPrelauncherVisual);
			_initStepController.addStep(createPrelauncherVisual);
			_initStepController.addStep(setStageParameter);
			_initStepController.addStep(getFlashVar);
			_initStepController.addStep(setSecurityParameter);
			_initStepController.addStep(getCurrentDomainUrl);
			_initStepController.addStep(loadGame);
			_initStepController.addStep(launchGameInitializationStep);
			
			Listener.add(StepControllerEvent.ON_STEP_COMPLETED, _initStepController as IEventDispatcher, onPrelauncherInitStepCompleted);
			_initStepController.start();
		}
		
		private function destroy():void
		{
			//Destroy complex object
			_initStepController.destroy();
			
			//Release manager reference
			_loaderManager = null;
			_layerManager = null;
			
			//Release game instance
			_gameInstance = null;
			
			//Release visual reference
			_prelauncherContainer = null;
			_prelauncherVisual = null;
			_progressbar = null;
			_progressbarLabel = null;
			
			//Release general reference
			_endingTimer = null;
			_initStepController = null;
		}
		
		/************************************************************************************************************
		* INIT STEP METHODS																							*
		************************************************************************************************************/
		private function initializeVar():void 
		{
			_prelauncherContainer = new Sprite();
			_prelauncherContainer.x = 0;
			_prelauncherContainer.y = 0;
			_currentDomainBaseUrl = "";
			_timeSpent = 0;
			_gameNumberOfStepTotal = GAME_NUMBER_OF_STEP_TOTAL_DEFAULT;
			_endingTimer = new Timer(WAITING_TIME_AFTER_FULLY_LOADED);
			
			_initStepController.stepCompleted();
		}
		/*************************************************************/
		
		private function registerEnterFrame():void 
		{
			_lastTimeStamp = getTimer();
			Listener.add(Event.ENTER_FRAME, this.stage as IEventDispatcher, onUpdate);
			
			_initStepController.stepCompleted();
		}
		/*************************************************************/
		
		private function initializePrelauncherManager():void 
		{
			Listener.add(ManagerEvent.ON_MANAGER_INITIALIZED, ManagerA.dispatcher, onPrelauncherManagerInitialized);
			ManagerA.initializeManager(PrelauncherManagerImport.getList());
		}
		
		private function onPrelauncherManagerInitialized(aEvent:ManagerEvent):void 
		{
			Listener.remove(ManagerEvent.ON_MANAGER_INITIALIZED, ManagerA.dispatcher, onPrelauncherManagerInitialized);
			_initStepController.stepCompleted();
		}
		/*************************************************************/
		
		private function activatePrelauncherManager():void 
		{
			Listener.add(ManagerEvent.ON_MANAGER_ACTIVATED, ManagerA.dispatcher, onPrelauncherManagerActivated);
			ManagerA.activateManager(PrelauncherManagerImport.getList());
		}
		
		private function onPrelauncherManagerActivated(aEvent:ManagerEvent):void 
		{
			Listener.remove(ManagerEvent.ON_MANAGER_INITIALIZED, ManagerA.dispatcher, onPrelauncherManagerActivated);
			_initStepController.stepCompleted();
		}
		/*************************************************************/
		
		private function setLayer():void 
		{
			_layerManager = ManagerA.getManager(EManagerDefinition.LAYER_MANAGER) as ILayerManager;
			_layerManager.registerStage(this.stage);
			_layerManager.addLayerList(ELayerDefinition.getList());
			
			_initStepController.stepCompleted();
		}
		/*************************************************************/
		
		private function loadPrelauncherVisual():void 
		{
			_loaderManager = ManagerA.getManager(EManagerDefinition.LOADER_MANAGER) as ILoaderManager;
			
			_loaderManager.load(PRELAUNCHER_ASSET_PATH, EFileType.SWF_FILE, onPrelauncherVisualLoader);
		}
		
		private function onPrelauncherVisualLoader(aLoadPacket:LoadPacket):void 
		{
			_initStepController.stepCompleted();
		}
		/*************************************************************/
		
		private function createPrelauncherVisual():void 
		{
			//Add the main container to the stage
			addChild(_prelauncherContainer);
			
			//Get visual
			_prelauncherVisual = _loaderManager.getSymbol(PRELAUNCHER_ASSET_PATH, PRELAUNCHER_ASSET_LINKAGE) as Sprite;
			_progressbar = _prelauncherVisual["progressbar"] as MovieClip;
			_progressbarLabel = _progressbar["label"] as TextField;
			
			//Set the visual
			_progressbar.gotoAndStop(1);
			
			//Add to stage
			_prelauncherContainer.addChild(_prelauncherVisual);
			
			_initStepController.stepCompleted();
		}
		/*************************************************************/
		
		private function setStageParameter():void 
		{
			_prelauncherContainer.stage.scaleMode = StageScaleMode.NO_SCALE;
			_prelauncherContainer.stage.align = StageAlign.TOP_LEFT;
			
			_initStepController.stepCompleted();
		}
		/*************************************************************/
		
		private function getFlashVar():void 
		{
			//TODO
			//_flashVars = stage.loaderInfo.parameters;
			
			_initStepController.stepCompleted();
		}
		/*************************************************************/
		
		private function setSecurityParameter():void 
		{
			//Facebook crossdomain
			Security.loadPolicyFile("http://profile.ak.fbcdn.net/crossdomain.xml");
			
			//Game crossdomain
			//Security.loadPolicyFile("http://fwl-update.funcom.com/crossdomain.xml");
			
			//Allow scripting in all domain
			Security.allowDomain("*");
			Security.allowInsecureDomain("*");
			
			_initStepController.stepCompleted();
		}
		/*************************************************************/
		
		private function getCurrentDomainUrl():void 
		{
			var index:int;
			_currentDomainBaseUrl = stage.loaderInfo.url;
			index = _currentDomainBaseUrl.lastIndexOf("/");
			_currentDomainBaseUrl = _currentDomainBaseUrl.substr(0, index + 1);
			
			_initStepController.stepCompleted();
		}
		/*************************************************************/
		
		private function loadGame():void 
		{
			_loaderManager.load(GAME_PATH, EFileType.SWF_FILE, onGameLoaded);
		}
		
		private function onGameLoaded(aLoadPacket:LoadPacket):void 
		{
			_gameInstance = aLoadPacket.content as IGame;
			
			_initStepController.stepCompleted();
		}
		/*************************************************************/
		
		private function launchGameInitializationStep():void 
		{
			(_gameInstance as DisplayObjectContainer).visible = false;
			addChildAt(_gameInstance as DisplayObjectContainer, 0);
			
			Listener.add(StepControllerEvent.ON_STEP_COMPLETED, _gameInstance as IEventDispatcher, onGameInitStepCompleted);
			_gameInstance.init();
		}
		
		/************************************************************************************************************
		* Private Methods																							*
		************************************************************************************************************/
		private function updatePercentage():void 
		{
			if (_prelauncherNumberOfStepTotal <= 0 || _gameNumberOfStepTotal <= 0)
			{
				return;
			}
			
			var currentStep:int = _prelauncherNumberOfStepDone + _gameNumberOfStepDone;
			var totalStep:int = _prelauncherNumberOfStepTotal + _gameNumberOfStepTotal;
			var realPercentage:int = int(Math.ceil((currentStep / totalStep) * 100));
			
			if (_currentPercentage < 100)
			{
				if (_currentPercentage < realPercentage)
				{
					_currentPercentage++;
				}
				refreshProgressbarVisual();
			}
			else
			{
				Listener.remove(Event.ENTER_FRAME, this.stage as IEventDispatcher, onUpdate);
				Listener.add(TimerEvent.TIMER, _endingTimer, onTimerTick);
				_endingTimer.start();
			}
		}
		
		private function refreshProgressbarVisual():void 
		{
			if (_progressbar == null)
			{
				return;
			}
			
			_progressbar.gotoAndStop(_currentPercentage + 1);
			_progressbarLabel.text = _currentPercentage.toString() + "%";
		}
		
		/************************************************************************************************************
		* Handler Methods																							*
		************************************************************************************************************/
		private function onGameInitStepCompleted(aEvent:StepControllerEvent):void 
		{
			_gameNumberOfStepDone = aEvent.numberOfStepDone;
			_gameNumberOfStepTotal = aEvent.numberOfStepTotal;
			
			if (_gameNumberOfStepDone == _gameNumberOfStepTotal)
			{
				Listener.remove(StepControllerEvent.ON_STEP_COMPLETED, _gameInstance as IEventDispatcher, onGameInitStepCompleted);
				_initStepController.stepCompleted();
			}
		}
		
		private function onPrelauncherInitStepCompleted(aEvent:StepControllerEvent):void 
		{
			_prelauncherNumberOfStepDone = aEvent.numberOfStepDone;
			_prelauncherNumberOfStepTotal = aEvent.numberOfStepTotal;
			
			if (_prelauncherNumberOfStepDone == _prelauncherNumberOfStepTotal)
			{
				Listener.remove(StepControllerEvent.ON_STEP_COMPLETED, _initStepController as IEventDispatcher, onPrelauncherInitStepCompleted);
			}
		}
		
		private function onUpdate(aEvent:Event):void 
		{
			var currentTime:int = getTimer();
			_timeSpent += currentTime - _lastTimeStamp;
			_lastTimeStamp = currentTime;
			
			if (_timeSpent > UPDATING_PERCENT_SPEED)
			{
				_timeSpent -= UPDATING_PERCENT_SPEED;
				updatePercentage();
			}
		}
		
		private function onTimerTick(aEvent:TimerEvent):void 
		{
			Listener.remove(TimerEvent.TIMER, _endingTimer, onTimerTick);
			_endingTimer.stop();
			onGameReadyToStart();
		}
		
		private function onGameReadyToStart():void 
		{
			//Start the game
			(_gameInstance as DisplayObjectContainer).visible = true;
			_gameInstance.start();
			
			//Destroy the prelauncher
			this.visible = false;
			destroy();
		}
		
		/************************************************************************************************************
		* Getter/Setter Methods																						*
		************************************************************************************************************/
	}
}