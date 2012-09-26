package com.funcom.buddyworld.ui 
{
	import com.funcom.project.manager.console.enum.ELogType;
	import com.funcom.project.manager.console.Logger;
	import com.funcom.buddyworld.ui.Component;
	import com.funcom.buddyworld.ui.event.ScrollEvent;
	import com.funcom.buddyworld.utils.flash.MathUtil;
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * @author Kevin Fields
	 */
	public class ScrollBar extends Component 
	{
		/************************************************************************************************************
		* Static/Constant variables																					*
		************************************************************************************************************/
		public static const VERTICAL:int = 0;
		public static const HORIZONTAL:int = 1;
		
		/************************************************************************************************************
		* Member Variables																							*
		************************************************************************************************************/
		public var bar:Button;
		public var minButton:Button;
		public var maxButton:Button;
		public var background:Sprite;
		
		private var _minimum:int;
		private var _maximum:int;
		private var _value:int;
		private var _orientation:int;
		private var _lineIncrement:int = 1;
		private var _pageIncrement:int = 10;
		private var _visibleAmount:int;
		private var _isAdjusting:Boolean;
		
		/************************************************************************************************************
		* Constructor / Init / Dispose																				*	
		************************************************************************************************************/
		public function ScrollBar() 
		{
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			_orientation = VERTICAL;
			setValues(0, 10, 0, 100);
		}
		
		/************************************************************************************************************
		* Public Methods																							*
		************************************************************************************************************/
		public function setValues(aValue:int, aVisibleAmount:int, aMinimum:int, aMaximum:int)
		{
			var oldValue:int;
			
			if (aMinimum == int.MAX_VALUE) 
			{
				aMinimum = int.MAX_VALUE - 1;
			}
			
			if (aMaximum <= aMinimum) 
			{
				aMaximum = aMinimum + 1;
			}

			var difference:int = aMaximum - aMinimum;
			if (difference > int.MAX_VALUE) 
			{
				difference = int.MAX_VALUE;
				aMaximum = aMinimum + difference;
			}
			
			if (aVisibleAmount > difference) {
				aVisibleAmount = difference;
			}
			
			if (aVisibleAmount < 1) 
			{
				aVisibleAmount = 1;
			}

			if (aValue < aMinimum) 
			{
				aValue = aMinimum;
			}
			
			if (aValue > aMaximum - aVisibleAmount) {
				aValue = aMaximum - aVisibleAmount;
			}

			oldValue = _value;
			_value = aValue;
			_visibleAmount = aVisibleAmount;
			_minimum = aMinimum;
			_maximum = aMaximum;
			
			draw();
			dispatchEvent(new ScrollEvent(oldValue, _value));
		}
		
		/************************************************************************************************************
		* Private Methods																							*
		************************************************************************************************************/

		/************************************************************************************************************
		* Handler Methods																							*
		************************************************************************************************************/
		
		private function onAddedToStage(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
		}
		
		override protected function onDraw():void 
		{
			super.onDraw();
			// TODO: Resize the bar based on the amounts
			
			
			// TODO: Potentially reorient the buttons, bar and background
		}
		
		/************************************************************************************************************
		* Getter/Setter Methods																						*
		************************************************************************************************************/
		public function get minimum():int 
		{
			return _minimum;
		}
		
		public function set minimum(aMinimum:int):void 
		{
			setValues(_value, _visibleAmount, aMinimum, _maximum);
		}
		
		public function get maximum():int 
		{
			return _maximum;
		}
		
		public function set maximum(aMaximum:int):void 
		{
			if (aMaximum == int.MIN_VALUE)
			{
				aMaximum = int.MIN_VALUE + 1;
			}
			
			if (_minimum > aMaximum)
			{
				_minimum = aMaximum - 1;
			}
			
			setValues(_value, _visibleAmount, _minimum, aMaximum);
		}
		
		public function get value():int 
		{
			return _value;
		}
		
		public function set value(aValue:int):void 
		{
			setValues(aValue, _visibleAmount, _minimum, _maximum);
		}
		
		public function get orientation():int 
		{
			return _orientation;
		}
		
		public function set orientation(aOrientation:int):void 
		{
			switch (aOrientation)
			{
				case VERTICAL:
				case HORIZONTAL:
				{
					_orientation = aOrientation;
					break;
				}
				
				default:
				{
					Logger.log(ELogType.CRITICAL, "ScrollBar", "set orientation", "Attempted to set an unknown orientation of [ " + aOrientation + " ]");
					break;
				}
			}
			
			setValues(_value, _visibleAmount, _minimum, _maximum);
		}
		
		public function get isAdjusting():Boolean 
		{
			return _isAdjusting;
		}
		
		public function set isAdjusting(aIsAdjusting:Boolean):void 
		{
			_isAdjusting = aIsAdjusting;
		}
	}
}