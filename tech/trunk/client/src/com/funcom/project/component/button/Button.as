/**
* @author Victor Obretin
*/
package com.funcom.project.component.button 
{
	import flash.display.DisplayObject;
	import flash.display.FrameLabel;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.utils.getDefinitionByName;
	import flash.utils.setTimeout;
	
	
	public class Button extends MovieClip 
	{
		/************************************************************************************************************
		* Static/Constant variables																					*
		************************************************************************************************************/
		
		private const UP:String = "Up";
		private const OVER:String = "Over";
		private const OUT:String = "Out";
		private const OUT_OVER:String = "OutOver";
		private const DOWN:String = "Down";
		private const SELECTED:String = "Selected";
		private const CLICK_INTERVAL:Number = 10;

		/************************************************************************************************************
		* Member Variables																							*
		************************************************************************************************************/
		
		public var textField:TextField;
		
		private var _label:String = "Text Button";
		private var _toggleMode:Boolean = false;
		private var _selected:Boolean = false;
		private var _animated:Boolean = false;
		private var _icon:DisplayObject;
		private var _iconPadding:Number = 0;

		/************************************************************************************************************
		* Constructor / Init / Dispose																				*	
		************************************************************************************************************/		
		public function Button() 
		{
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		/************************************************************************************************************
		* Public Methods																							*
		************************************************************************************************************/
		
		/************************************************************************************************************
		* Private Methods																							*
		************************************************************************************************************/
		private function hasFrameLabel(aName:String):Boolean
		{
			var currentLabelsCount = currentLabels.length;
			var frameLabel:FrameLabel;
			
			for (var i:int; i < currentLabelsCount; i++)
			{
				frameLabel = currentLabels[i] as FrameLabel;
				
				if (frameLabel.name == aName)
				{
					return true;
				}
			}
			
			return false;
		}
		
		private function refreshTextField():void
		{
			if (textField != null)
			{
				textField.text = _label;
				textField.scaleY = textField.scaleX * this.scaleX / this.scaleY;
				
				if (_icon != null)
				{
					textField.width = 0;
					textField.width = this.width - _icon.width - _iconPadding;
					textField.x = _icon.width + _iconPadding;
					
					_icon.x = textField.x +  Math.round((textField.width - textField.textWidth) / 2) - _icon.width - _iconPadding;
					_icon.y = Math.round( textField.y + (textField.textHeight - _icon.height) / 2 );
				}
				else
				{
					textField.width = this.width;
					textField.x = 0;
				}
			}
		}
		
		/************************************************************************************************************
		* Handler Methods																							*
		************************************************************************************************************/

		private function onAddedToStage(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			buttonMode = true;
			mouseChildren = false;
			
			gotoAndStop(UP);
			refreshTextField();
			
			addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			addEventListener(MouseEvent.CLICK, onMouseClick);
		}

		private function onMouseOver(mouseEvent:MouseEvent):void 
		{
			if (!(_toggleMode && _selected))
			{
				if (_animated)
				{
					gotoAndPlay(OVER);
					addEventListener(Event.ENTER_FRAME, onEnterFrame);
				}
				else
				{
					gotoAndStop(OVER);
				}
				
				textField.text = _label;
			}
		}
		
		private function onMouseDown(mouseEvent:MouseEvent):void 
		{
			if (!(_toggleMode && _selected))
			{
				gotoAndStop(DOWN);
				textField.text = _label;
			}
		}
		
		private function onMouseUp(mouseEvent:MouseEvent):void 
		{
			if (!(_toggleMode && _selected))
			{
				gotoAndStop(_animated ? OUT : OVER);
				textField.text = _label;
			}
		}
		
		private function onMouseOut(mouseEvent:MouseEvent):void 
		{
			if (!(_toggleMode && _selected))
			{
				if (_animated)
				{
					gotoAndPlay(OUT);
					addEventListener(Event.ENTER_FRAME, onEnterFrame);
				}
				else
				{
					gotoAndStop(UP);
				}
				
				textField.text = _label;
			}
		}
		
		private function onMouseClick(mouseEvent:MouseEvent):void 
		{
			if (!_toggleMode)
			{
				gotoAndStop(DOWN);
				textField.text = _label;
				setTimeout(onMouseUp, CLICK_INTERVAL, mouseEvent);
			}
			else
			{
				selected = !_selected;
			}
		}
		
		private function onEnterFrame(event:Event):void
		{
			if (currentFrameLabel == OUT || 
				currentFrameLabel == OUT_OVER)
			{
				stop();
				textField.text = _label;
				removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			}
		}
		
		override protected function onDraw():void 
		{
			refreshTextField();
		}
		
		/************************************************************************************************************
		* Getter/Setter Methods																						*
		************************************************************************************************************/
		public function get label():String 
		{
			return _label;
		}
		
		public function set label(value:String):void 
		{
			_label = value;
			draw();
		}
		
		public function get toggleMode():Boolean 
		{
			return _toggleMode;
		}
		
		public function set toggleMode(value:Boolean):void 
		{
			_toggleMode = value;
		}
		
		public function get selected():Boolean 
		{
			return _selected;
		}
		
		public function set selected(value:Boolean):void 
		{
			_selected = value;
			gotoAndStop( _selected ? SELECTED : UP );
			textField.text = _label;
		}
		
		public function get animated():Boolean 
		{
			return _animated;
		}
		
		public function set animated(value:Boolean):void 
		{
			if (hasFrameLabel(OUT) && 
				hasFrameLabel(OUT_OVER))
			{
				_animated = value;
			}
			else
			{
				_animated = false;
			}
		}
		
		public function set icon(aClassName:String):void 
		{
			if (_icon != null)
			{
				removeChild(_icon);
			}
			
			if (aClassName == "none")
			{
				return;
			}
			
			var iconClass:Class = getDefinitionByName(aClassName) as Class;
			
			if (iconClass == null)
			{
				return;
			}
			
			_icon = new iconClass() as DisplayObject;
			addChild (_icon);
			
			draw();
		}
		
		public function set iconPadding(value:Number):void 
		{
			_iconPadding = value;
			
			draw();
		}
	}
}