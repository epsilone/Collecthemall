package com.funcom.project.module.catchghost.struct {
	import flash.display.MovieClip;
	import com.greensock.*;
	import com.greensock.easing.*;
	import flash.text.TextField;
	import flash.utils.getDefinitionByName;
	
	public class HitPointsBar extends MovieClip{
		
		private var _visual:MovieClip;
		
		private var _maxPoints:Number;
		private var _bar:MovieClip;
		private var _displayText:TextField;
		private var _accumulatedDamage:Number = 0;
		private var _factor:Number;

		public function HitPointsBar() {
			
			var classDefinition:Class;
			classDefinition = getDefinitionByName("HitPointsBar") as Class;
			_visual = new classDefinition() as MovieClip;
			addChild(_visual);
			
			_bar = _visual["bar"];
			_displayText = _visual["txt_hitPoints"];
		}

		public function anim(damage:uint):void
		{			
			_accumulatedDamage += damage;
			
			_displayText.text = (_maxPoints - _accumulatedDamage) + " / " + _maxPoints;
			
			TweenLite.to(_bar, .5, {width: _bar.width - damage*_factor});
		}
		
		public function set maxPoints(value:Number):void
		{
			_maxPoints = value;
			
			_factor = _bar.width/_maxPoints;
		}
	}
	
}
