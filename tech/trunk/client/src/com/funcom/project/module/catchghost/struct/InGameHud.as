package com.funcom.project.module.catchghost.struct {
	
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	import flash.events.Event;
	
	
	public class InGameHud extends MovieClip {
		
		private var _expandWeaponsButton:SimpleButton;
		private var _weaponsMenu:WeaponsMenu;
		
		public function InGameHud() {
			_expandWeaponsButton = this["expandWeapons"];
			_expandWeaponsButton.addEventListener(MouseEvent.CLICK, onExpandWeapons, false, 0, true);
			
			_weaponsMenu = new WeaponsMenu();
			_weaponsMenu.addEventListener("HideWeaponsMenu", colapseWeaponsMenu, false, 0, true);
		}
		
		private function onExpandWeapons(e:MouseEvent):void
		{
			addChild(_weaponsMenu);
		}
		
		private function colapseWeaponsMenu(e:Event):void
		{
			removeChild(_weaponsMenu);
		}
	}
	
}
