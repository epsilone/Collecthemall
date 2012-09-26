package com.funcom.buddyworld.ui 
{
	import com.funcom.buddyworld.IDestroyable;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	/**
	 * The Component class is the base class for all UI objects. It provides support for Live Preview
	 * as well as some basic features common to components.
	 * 
	 * @author Kevin Fields
	 */
	public class Component extends Sprite implements IDestroyable
	{
		/************************************************************************************************************
		* Static/Constant variables																					*
		************************************************************************************************************/

		/************************************************************************************************************
		* Member Variables																							*
		************************************************************************************************************/
		private var _id:String;
		private var _tag:*;
		private var _width:Number;
		private var _height:Number;
		private var _rotation:Number;
		
		/************************************************************************************************************
		* Constructor / Init / Dispose																				*	
		************************************************************************************************************/
		public function Component(aWidth:Number = NaN, aHeight:Number = NaN) 
		{
			_rotation = rotation;
			rotation = 0.0;
			
			_width = isNaN(aWidth) ? super.width : aWidth;
			_height = isNaN(aHeight) ? super.height : aHeight;
			
			scaleX = scaleY = 1;
			
			// The avatar is no longer required
			onConstructed();
			setSize(_width, _height);
		}
		
		public function destroy():void
		{
			
		}
		
		/************************************************************************************************************
		* Public Methods																							*
		************************************************************************************************************/
		/**
		 * Called exclusively by the IDE, this method is what's used to support Live Preview within Flash, for
		 * custom components.
		 * 
		 * @param	w new width of the component
		 * @param	h new height of the component
		 */
		public final function setSize(aWidth:Number, aHeight:Number):void
		{
			_width = aWidth;
			_height = aHeight;
			draw();
		}
		
		public final function drawNow():void
		{
			draw();
		}
		
		/************************************************************************************************************
		* Private Methods																							*
		************************************************************************************************************/

		/************************************************************************************************************
		* Handler Methods																							*
		************************************************************************************************************/
		protected function onConstructed():void
		{
		}
		
		protected final function draw():void
		{
			rotation = _rotation;
			
			// Custom code may need to be done here, so the class should provide a custom onDraw method that
			// derived classes will override.
			onDraw();
		}
		
		/**
		 * Method called during resizing of the component while in Live Preview, or when a property has changed
		 * that affects the visual placement of the component's internal clips.
		 */
		protected function onDraw():void
		{
		}

		/************************************************************************************************************
		* Getter/Setter Methods																						*
		************************************************************************************************************/
		//{ region Accessors/Mutators
		public final function get id():String 
		{
			return _id;
		}
		/**
		 * @private
		 */
		public final function set id(value:String):void 
		{
			_id = value;
		}
		
		public override final function get width():Number 
		{
			return _width;
		}
		
		public override final function set width(value:Number):void 
		{
			_width = value;
			draw();
		}
		
		public override final function get height():Number 
		{
			return _height;
		}
		
		public override final function set height(value:Number):void 
		{
			_height = value;
			draw();
		}
		
		/**
		 * A tag, in C# terms, is a piece of custom data that can be attached to an object for the developer's
		 * own purpose.
		 */
		public final function get tag():* 
		{
			return _tag;
		}
		/**
		 * @private
		 */
		public final function set tag(value:*):void 
		{
			_tag = value;
		}
	}
}