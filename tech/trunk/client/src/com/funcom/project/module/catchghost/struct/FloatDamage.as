package com.funcom.project.module.catchghost.struct {
	import flash.display.MovieClip;
	import flash.text.TextField;
	import com.greensock.*;
	import com.greensock.easing.*;
	import flash.utils.getDefinitionByName;
	
	public class FloatDamage extends MovieClip {

		private var _visual:MovieClip;
		
		private var _damageTextField:TextField;
		private var _posY:Number;

		public function FloatDamage() {
			var classDefinition:Class;
			classDefinition = getDefinitionByName("FloatDamage") as Class;
			_visual = new classDefinition() as MovieClip;
			addChild(_visual);
			
			_damageTextField = _visual["txtDamage"];
		}
		
		public function anim(damage:uint):void
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
