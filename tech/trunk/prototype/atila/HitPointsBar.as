package  {
	import flash.display.MovieClip;
	import com.greensock.*;
	import com.greensock.easing.*;
	import flash.text.TextField;
	
	public class HitPointsBar extends MovieClip{
		
		private var _maxPoints:Number;
		private var _bar:MovieClip;
		private var _displayText:TextField;
		private var _accumulatedDamage:Number = 0;
		private var _factor:Number;

		public function HitPointsBar() {
			_bar = this["bar"];
			_displayText = this["txt_hitPoints"];
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
