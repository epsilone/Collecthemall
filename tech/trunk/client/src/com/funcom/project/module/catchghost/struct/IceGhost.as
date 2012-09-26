package com.funcom.project.module.catchghost.struct {
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import com.greensock.*;
	import com.greensock.easing.*;
	import flash.geom.Point;
	import flash.utils.getDefinitionByName;
	
	public class IceGhost extends Ghost{
		
		private var _ghostVisual:MovieClip;

		public function IceGhost(posX:Number, posY:Number) {
			this.x = posX;
			this.y = posY;
			
			// IceGhost have 60 hit points as default
			hitPointsBar.maxPoints = _hitPoints = 60;
			
			
			var classDefinition:Class;
			classDefinition = getDefinitionByName("IceGhost_visual") as Class;
			_ghostVisual = new classDefinition() as MovieClip;
			addChild(_ghostVisual);
			
			_ghostVisual.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver, false, 0, true);
			_ghostVisual.addEventListener(MouseEvent.ROLL_OUT, onMouseRollOut, false, 0, true);
			_ghostVisual.addEventListener(MouseEvent.CLICK, onClick, false, 0, true);
		}
		
		public function moveGhost(finalPos:Point, speed:Number):void
		{
			var lateralTween:TweenLite = new TweenLite(this, speed, {x: finalPos.x, onComplete:reverseTween, onReverseComplete:restartTween, overwrite : 0});
			var verticalTween:TweenLite = new TweenLite(this, speed/3, {y: finalPos.y, onComplete:reverseVerticalTween, onReverseComplete:restartVerticalTween, overwrite : 0});

			function reverseTween():void {
				_ghostVisual.scaleX *= -1;
				lateralTween.reverse();
			}
			function restartTween():void {
				_ghostVisual.scaleX *= -1;
				lateralTween.restart();
			}
			
			function reverseVerticalTween():void {
				verticalTween.reverse();
			}
			function restartVerticalTween():void {
				verticalTween.restart();
			}
			
			adjusthitPointBarPosition();
		}
		
		private function onMouseOver(e:MouseEvent):void
		{
			TweenLite.to( hitPointsBar, 0.25, {alpha:1} );
			dispatchEvent(new Event("MOUSE_OVER_GHOST"));
		}
		
		private function onMouseRollOut(e:MouseEvent):void
		{
			TweenLite.to( hitPointsBar, 0.25, {alpha:0} );
			dispatchEvent(new Event("MOUSE_ROLL_OUT_GHOST"));
		}
		
		private function onClick(e:MouseEvent):void
		{
			dispatchEvent(new Event("MOUSE_CLICK_GHOST"));
		}
		
		private function adjusthitPointBarPosition():void
		{
			hitPointsBar.x = _ghostVisual.x - hitPointsBar.width/2;
			hitPointsBar.y = -_ghostVisual.height/2 - hitPointsBar.height + 10;
			
			floatDamage.x = hitPointsBar.x;
			floatDamage.posY = floatDamage.y = hitPointsBar.y - hitPointsBar.height;
			
		}
		
		public function set hitPoints(value:Number):void
		{
			_hitPoints = value;
		}
		
		public function get hitPoints():Number
		{
			return _hitPoints;
		}
		
		
		
		public function getHitPointsBar():HitPointsBar
		{
			return hitPointsBar;
		}
		
		public function getFloatDamage():FloatDamage
		{
			return floatDamage;
		}
		
		public function captured():void
		{
			_ghostVisual.removeEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			_ghostVisual.removeEventListener(MouseEvent.ROLL_OUT, onMouseRollOut);
			_ghostVisual.removeEventListener(MouseEvent.CLICK, onClick);
			
			TweenLite.to(this, .5, {alpha: 0});
		}

		public function get ghostVisual():MovieClip 
		{
			return _ghostVisual;
		}
		
	}
	
}
