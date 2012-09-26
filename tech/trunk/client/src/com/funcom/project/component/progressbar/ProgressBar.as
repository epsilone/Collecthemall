package com.funcom.project.component.progressbar 
{
	import com.funcom.buddyworld.ui.Component;
	import com.funcom.buddyworld.utils.flash.MathUtil;
	import flash.display.Sprite;
	import flash.text.TextField;
	
	/**
	 * @author Kevin Fields
	 */
	public class ProgressBar extends Component 
	{
		/************************************************************************************************************
		* Static/Constant variables																					*
		************************************************************************************************************/

		/************************************************************************************************************
		* Member Variables																							*
		************************************************************************************************************/
		public var textField:TextField;
		public var bar:Sprite;
		public var background:Sprite;
		
		private var _value:Number;
		private var _maxValue:Number;
		
		/************************************************************************************************************
		* Constructor / Init / Dispose																				*	
		************************************************************************************************************/		
		public function ProgressBar() 
		{
			
		}
		
		/************************************************************************************************************
		* Public Methods																							*
		************************************************************************************************************/
		
		/************************************************************************************************************
		* Private Methods																							*
		************************************************************************************************************/

		/************************************************************************************************************
		* Handler Methods																							*
		************************************************************************************************************/
		override protected function onDraw():void 
		{
			textField.text = _value.toString();
			const scale:Number = (_value / _maxValue);
			bar.scaleX = scale;
		}
		
		/************************************************************************************************************
		* Getter/Setter Methods																						*
		************************************************************************************************************/
		public function get value():Number 
		{
			return _value;
		}
		
		public function set value(value:Number):void 
		{
			_value = MathUtil.clampNumber(value, 0, _maxValue);
			draw();
		}
		
		public function get maxValue():Number 
		{
			return _maxValue;
		}
		
		public function set maxValue(value:Number):void 
		{
			_maxValue = (value > 0.0 ? value : 0.0);
			draw();
		}
	}
}