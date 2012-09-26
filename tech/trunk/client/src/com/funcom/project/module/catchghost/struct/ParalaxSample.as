package com.funcom.project.module.catchghost.struct {
	
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import flash.text.*;
	import flash.filters.BlurFilter;
	import flash.ui.Mouse;
	
	import com.lextalkington.parallax.ParallaxEngine;
	import com.lextalkington.parallax.ParallaxReturn;
	import com.lextalkington.parallax.ParallaxInertia;
	import flashx.textLayout.formats.BackgroundColor;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	
	public class ParalaxSample extends Sprite{
		
		private var _pE:ParallaxEngine;
		private var _pEr:ParallaxReturn;
		private var _pEi:ParallaxInertia;
		
		private var _mouseCursor:TargetCursor;
		
		//Game objects
		private var _moutain:Mountains;
		private var _backgroundMC:Background;
		private var _foreground:Foreground;
		private var _platform:Platform;
		private var _inGameHud:InGameHud;
		private var _munition:Munition;
		
		//Ghosts list
		private var _ghostList:Array = new Array();

		public function ParalaxSample() {
			super();
			addEventListener(Event.ADDED_TO_STAGE, init);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, follow, false, 0, true);
		}
		
		//-----------------------------------
		//	init
		//-----------------------------------
		private function init(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, init);	
			
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP;	
			stage.showDefaultContextMenu = false;
			stage.quality = StageQuality.BEST;
			
			Mouse.hide();
			
			_mouseCursor = new TargetCursor();
			_inGameHud = new InGameHud();
			
			_inGameHud.x = 20;
			_inGameHud.y = stage.stageHeight - _inGameHud.width - 20;
			
			_munition = _inGameHud["munition"];
			
			//some default values to test
			_munition.minDamage = 1;
			_munition.maxDamage = 10;
			_munition.range = 1;
			
			const xpos:uint = 0;
			const w:uint = 770;
			const h:uint = 600;
			
			//------------------------------------------ INERTIA VARIATION
			_pEr = new ParallaxReturn(w,h,0.05,ParallaxEngine.BOTH_AXIS);
			_pEi = new ParallaxInertia(w,h,0.09,ParallaxEngine.BOTH_AXIS);
			_pEi.x = _pEr.x;
			_pEi.y = _pEr.y;
			_moutain = new Mountains();
			_backgroundMC = new Background();
			_foreground = new Foreground();
			_platform = new Platform();
			//_moutain.filters = [new BlurFilter(20,20,3)];
			_pEi.addPlate(_backgroundMC);
			_pEi.addPlate(_moutain);
			_pEi.addPlate(_platform);
			_pEi.addPlate(_foreground);
			
			addChild(_pEi);
			_pEi.start();
			
			addChild(_inGameHud);
			
			addChild(_mouseCursor);
			
			_foreground.mouseEnabled = false;
			_foreground.mouseChildren = false;
			
			createGhosts();
		}
		
		
		private function createGhosts():void{
			var iceGhost1:IceGhost = new IceGhost(2200, 417);
			iceGhost1.addEventListener("MOUSE_OVER_GHOST", onTargetOverGhost, false, 0, true);
			iceGhost1.addEventListener("MOUSE_ROLL_OUT_GHOST", onTargetRollOutGhost, false, 0, true);
			iceGhost1.addEventListener("MOUSE_CLICK_GHOST", onClickGhost, false, 0, true);
			
			/*
			* It should read from an XML file
			*/
			iceGhost1.moveGhost( new Point(2020, 392), 3 );
			
			//We have to add the ghost to the playable layer of the game
			_platform.addChild(iceGhost1);
			
			_ghostList[0] = iceGhost1;
			
			var iceGhost2:IceGhost = new IceGhost(2900, 150);
			iceGhost2.addEventListener("MOUSE_OVER_GHOST", onTargetOverGhost, false, 0, true);
			iceGhost2.addEventListener("MOUSE_ROLL_OUT_GHOST", onTargetRollOutGhost, false, 0, true);
			iceGhost2.addEventListener("MOUSE_CLICK_GHOST", onClickGhost, false, 0, true);
			
			/*
			* It should read from an XML file
			*/
			iceGhost2.ghost.scaleX = iceGhost2.ghost.scaleY = 0.25;
			
			iceGhost2.moveGhost( new Point(200, 150), 30 );
			
			//We have to add the ghost to the playable layer of the game
			_platform.addChild(iceGhost2);
			
			_ghostList[1] = iceGhost2;
			
			
			var iceGhost3:IceGhost = new IceGhost(500, 900);
			iceGhost3.addEventListener("MOUSE_OVER_GHOST", onTargetOverGhost, false, 0, true);
			iceGhost3.addEventListener("MOUSE_ROLL_OUT_GHOST", onTargetRollOutGhost, false, 0, true);
			iceGhost3.addEventListener("MOUSE_CLICK_GHOST", onClickGhost, false, 0, true);
			
			/*
			* It should read from an XML file
			*/
			iceGhost3.ghost.scaleX = iceGhost3.ghost.scaleY = 2;
			
			iceGhost3.moveGhost( new Point(80, 950), 5 );
			
			//We have to add the ghost to the playable layer of the game
			_platform.addChild(iceGhost3);
			
			_ghostList[2] = iceGhost3;
		}
		
		private function follow(e:MouseEvent):void{
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

	}
	
}
