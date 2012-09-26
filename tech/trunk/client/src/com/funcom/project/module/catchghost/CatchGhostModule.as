/**
* @author Keven Poulin
* @compagny Funcom
*/
package com.funcom.project.module.catchghost
{
	import com.funcom.project.manager.implementation.module.struct.AbstractModule;
	import com.funcom.project.module.catchghost.struct.IceGhost;
	import com.funcom.project.module.catchghost.struct.Munition;
	import com.funcom.project.module.catchghost.struct.parallax_engine.ParallaxEngine;
	import com.funcom.project.module.catchghost.struct.parallax_engine.ParallaxInertia;
	import com.funcom.project.module.catchghost.struct.parallax_engine.ParallaxReturn;
	import com.funcom.project.module.catchghost.struct.Snow;
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.ui.Mouse;
	
	public class CatchGhostModule extends AbstractModule
	{
		/************************************************************************************************************
		* Static/Constant variables																					*
		************************************************************************************************************/
		
		/************************************************************************************************************
		* Member Variables																							*
		************************************************************************************************************/
		//Game objects
		private var _mountain:MovieClip;
		private var _background:MovieClip;
		private var _foreground:MovieClip;
		private var _platform:MovieClip;
		//private var _inGameHud:InGameHud;
		private var _munition:Munition;
		
		private var _mouseCursor:MovieClip;
		
		//Management
		private var _pEr:ParallaxReturn;
		private var _pEi:ParallaxInertia;
		
		//Reference holder
		private var _ghostList:Array;
		
		/************************************************************************************************************
		* Constructor / Init / Dispose																				*	
		************************************************************************************************************/
		public function CatchGhostModule()
		{
			
		}
		
		override public function destroy():void 
		{
			//Release visual reference
			_mountain = null;
			
			Mouse.show();
			
			super.destroy();
		}

		/************************************************************************************************************
		* Public Methods																							*
		************************************************************************************************************/

		/************************************************************************************************************
		* Private Methods																							*
		************************************************************************************************************/
		override protected function initVar():void 
		{
			super.initVar();
			
			_ghostList = new Array();
		}
		
		override protected function populateInitStep():void 
		{
			_initStepController.addStep(getvisualDefinition);
			_initStepController.addStep(createParallaxEngine);
			_initStepController.addStep(createGhosts);
			_initStepController.addStep(createMunition);
			_initStepController.addStep(createSpecialEffects);
			_initStepController.addStep(render);
			_initStepController.addStep(addVisualOnStage);
			_initStepController.addStep(registerEventListener);
		}
		
		override protected function getvisualDefinition():void 
		{
			_mountain = _loaderManager.getSymbol(_moduleDefinition.assetFilePath, "Mountains") as MovieClip;
			_mouseCursor = _loaderManager.getSymbol(_moduleDefinition.assetFilePath, "TargetCursor") as MovieClip;
			_background = _loaderManager.getSymbol(_moduleDefinition.assetFilePath, "Background") as MovieClip;
			_platform = _loaderManager.getSymbol(_moduleDefinition.assetFilePath, "Platform") as MovieClip;
			_foreground = _loaderManager.getSymbol(_moduleDefinition.assetFilePath, "Foreground") as MovieClip;
			
			_foreground.mouseEnabled = false;
			_foreground.mouseChildren = false;
			
			super.getvisualDefinition();
		}
		
		private function createParallaxEngine():void 
		{
			Mouse.hide();
			//------------------------------------------ INERTIA VARIATION
			_pEr = new ParallaxReturn(_resolutionManager.stageWidth, _resolutionManager.stageHeight,0.05,ParallaxEngine.BOTH_AXIS);
			_pEi = new ParallaxInertia(_resolutionManager.stageWidth, _resolutionManager.stageHeight,0.09,ParallaxEngine.BOTH_AXIS);
			_pEi.x = _pEr.x;
			_pEi.y = _pEr.y;
			
			_pEi.addPlate(_background);
			_pEi.addPlate(_mountain);
			_pEi.addPlate(_platform);
			_pEi.addPlate(_foreground);
			
			_initStepController.stepCompleted();
		}
		
		private function createGhosts():void 
		{
			var iceGhost:IceGhost = new IceGhost(2200, 417);
			iceGhost.moveGhost( new Point(2020, 392), 3 );
			
			_ghostList.push( iceGhost );
			
			iceGhost = new IceGhost(2900, 150);
			iceGhost.ghostVisual.scaleX = iceGhost.ghostVisual.scaleY = 0.25;
			iceGhost.moveGhost( new Point(200, 150), 30 );
			
			_ghostList.push( iceGhost );
			
			iceGhost = new IceGhost(500, 900);
			iceGhost.ghostVisual.scaleX = iceGhost.ghostVisual.scaleY = 2;
			iceGhost.moveGhost( new Point(80, 950), 5 );
			
			_ghostList.push( iceGhost );
			
			_initStepController.stepCompleted();
		}
		
		private function createMunition():void
		{
			_munition = new Munition();
			
			//some default values to test
			_munition.minDamage = 1;
			_munition.maxDamage = 10;
			_munition.range = 1;
			
			_initStepController.stepCompleted();
		}
		
		private function createSpecialEffects():void
		{
			var snow:Snow = new Snow(_platform.width, _platform.height);
			
			_platform.addChild(snow);
			
			_initStepController.stepCompleted();
		}
	
		override protected function render():void 
		{			
			super.render();
		}
		
		override protected function addVisualOnStage():void 
		{
			addChild(_pEi);
			
			for (var i:int = 0; i < _ghostList.length; i++) 
			{
				_platform.addChild( _ghostList[i] as MovieClip );
			}
			
			addChild(_mouseCursor);
			
			super.addVisualOnStage();
		}
		
		override protected function registerEventListener():void 
		{
			super.registerEventListener();
			
			_layerManager.stageReference.addEventListener(MouseEvent.MOUSE_MOVE, mouseFollow, false, 0, true);
			
			for (var i:int = 0; i < _ghostList.length; i++) 
			{
				(_ghostList[i] as IEventDispatcher).addEventListener("MOUSE_OVER_GHOST", onTargetOverGhost, false, 0, true);
				(_ghostList[i] as IEventDispatcher).addEventListener("MOUSE_ROLL_OUT_GHOST", onTargetRollOutGhost, false, 0, true);
				(_ghostList[i] as IEventDispatcher).addEventListener("MOUSE_CLICK_GHOST", onClickGhost, false, 0, true);
			}
		}
		
		override protected function initCompleted():void 
		{
			_pEi.start();
			super.initCompleted();
		}
		
		private function applyColorTransform(target:MovieClip, color:uint):void
		{
			var colorTransform:ColorTransform = new ColorTransform();
			colorTransform.color = color;
			
			target.transform.colorTransform = colorTransform;
		}
		
		private function randomBetween(min:uint, max:uint):uint
		{
			return Math.floor(Math.random() * (max - min) + min);
		}
		
		/************************************************************************************************************
		* Handler Methods																							*
		************************************************************************************************************/
		
		private function mouseFollow(e:MouseEvent):void{
			_mouseCursor.x = mouseX;
			_mouseCursor.y = mouseY;
		}
		
		private function onTargetOverGhost(e:Event):void
		{
			applyColorTransform(_mouseCursor, 0xFF0000);
		}
		
		private function onTargetRollOutGhost(e:Event):void
		{
			applyColorTransform(_mouseCursor, 0xFFFFFF);
		}
		
		private function onClickGhost(e:Event):void
		{
			var iceGhost:IceGhost = e.target as IceGhost;
			var previousHP:Number = iceGhost.hitPoints;
			
			var damage:uint = randomBetween(_munition.minDamage, _munition.maxDamage);
			
			iceGhost.getHitPointsBar().anim(damage);
			iceGhost.getFloatDamage().anim(damage);
			
			var hitPointResult:Number = (previousHP - damage);
			
			if(hitPointResult <= 0)
			{
				hitPointResult = 0; //Keeps the stable state
				
				iceGhost.captured();
			}
			
			iceGhost.hitPoints = hitPointResult;
		}
		
		/************************************************************************************************************
		* Getter/Setter Methods																						*
		************************************************************************************************************/
	}
}