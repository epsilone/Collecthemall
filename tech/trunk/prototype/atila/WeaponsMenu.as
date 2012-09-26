package  {
	
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;
	import flash.display.BitmapData;
	
	
	public class WeaponsMenu extends MovieClip {
		
		private var _btnBack:SimpleButton;
		private var _munitionDescriptionContainer:MovieClip;
		private var _munitions:Array;
		
		public function WeaponsMenu() {
			_munitions = new Array(10);
			
			for(var i:int = 0; i < _munitions.length; i++)
			{
				_munitions[i] = this["munition" + i];
				(_munitions[i] as SimpleButton).addEventListener(MouseEvent.CLICK, onMunitionClick, false, 0, true);
			}
			
			_btnBack = this["btnBack"];
			_munitionDescriptionContainer = this["munitionDescriptionContainer"];
			
			_btnBack.addEventListener(MouseEvent.CLICK, onBackClicked, false, 0, true);
		}
		
		private function onBackClicked(e:MouseEvent):void
		{
			dispatchEvent(new Event("HideWeaponsMenu"));
		}
		
		private function onMunitionClick(e:MouseEvent):void
		{
			_munitionDescriptionContainer.gotoAndStop((e.target as SimpleButton).name);
		}
	}
	
}
