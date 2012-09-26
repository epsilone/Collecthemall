package  {
	import flash.display.MovieClip;
	import flash.text.TextField;
	import com.greensock.*;
	import com.greensock.easing.*;
	
	public class FloatDamage extends MovieClip {

		private var _damageTextField:TextField;
		private var _posY:Number;

		public function FloatDamage() {
			_damageTextField = this["txtDamage"];
		}
		
		public function anim(damage:uint)
		{
			this.y = _posY;
			_damageTextField.text = "+" + damage;
			TweenLite.to(this, 1, {y: _posY-20, alpha:1, onComplete:endAnim});
		}
		
		private function endAnim():void {		
			TweenLite.to(this, 1, {alpha:0});			
		}
		
		public function set posY(value:Number):void
		{
			_posY = value;
		}

	}
	
}
