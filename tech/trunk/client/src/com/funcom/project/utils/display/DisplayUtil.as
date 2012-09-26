/**
* @author Keven Poulin
* @compagny Funcom
*/
package com.funcom.project.utils.display
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.InteractiveObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.BitmapFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.getQualifiedClassName;

	public class DisplayUtil
	{
		public static function DisableInteractiveProperties(aTarget:DisplayObject):void
		{
			if (aTarget is MovieClip)
			{
				var m:MovieClip = aTarget as MovieClip;
				m.enabled = false;
				m.buttonMode = false;
				m.useHandCursor = false;
				m.tabChildren = false;
				m.mouseChildren = false;
				m.doubleClickEnabled = false;
				m.mouseEnabled = false;
				m.tabEnabled = false;
			}
			else if (aTarget is Sprite)
			{
				var s:Sprite = aTarget as Sprite;
				s.buttonMode = false;
				s.useHandCursor = false;
				s.tabChildren = false;
				s.mouseChildren = false;
				s.doubleClickEnabled = false;
				s.mouseEnabled = false;
				s.tabEnabled = false;
			}
			else if (aTarget is DisplayObjectContainer)
			{
				var d:DisplayObjectContainer = aTarget as DisplayObjectContainer;
				d.tabChildren = false;
				d.mouseChildren = false;
				d.doubleClickEnabled = false;
				d.mouseEnabled = false;
				d.tabEnabled = false;
			}
			else if (aTarget is InteractiveObject)
			{
				var i:InteractiveObject = aTarget as InteractiveObject;
				i.doubleClickEnabled = false;
				i.mouseEnabled = false;
				i.tabEnabled = false;
			}
		}
		
		public static function GetDisplayObjectRectangle(aContainer:DisplayObjectContainer, aProcessFilters:Boolean):Rectangle 
		{
			if (!aContainer is DisplayObjectContainer)
			{
				return new Rectangle();
			}
			
			var finalBounds:Rectangle = ProcessDisplayObjectContainerBounds(aContainer, aProcessFilters);
		   
			// translate to local
			var localPoint:Point = aContainer.globalToLocal(new Point(finalBounds.x, finalBounds.y));
			finalBounds = new Rectangle(localPoint.x, localPoint.y, finalBounds.width, finalBounds.height);			   
			
			return finalBounds;
		}
		
		private static function ProcessDisplayObjectContainerBounds(aContainer:DisplayObjectContainer, aProcessFilters:Boolean):Rectangle 
		{
			var resultBounds:Rectangle = null;				   
			
			// Process if container exists
			if (aContainer != null) 
			{
				var displayObject:DisplayObject;
				var children:int = aContainer.numChildren;								   
				
				// Process each child DisplayObject
				for (var childIndex:int = 0; childIndex < children; childIndex++)
				{
					displayObject = aContainer.getChildAt(childIndex);
				  
					//If we are recursing all children, we also get the rectangle of children within these children.
					if (displayObject is DisplayObjectContainer) 
					{
						// Let's drill into the structure till we find the deepest DisplayObject
						var currentBounds:Rectangle = ProcessDisplayObjectContainerBounds(displayObject as DisplayObjectContainer, aProcessFilters);
						
						// Now, stepping out, uniting the result creates a rectangle that surrounds siblings
						if (resultBounds == null)
						{ 
							resultBounds = currentBounds.clone(); 
						} 
						else 
						{
							resultBounds = resultBounds.union(currentBounds);
						}                         
					}                                               
			   }
			   
				// Get bounds of current container, at this point we're stepping out of the nested DisplayObjects
				var containerBounds:Rectangle = aContainer.getBounds(aContainer.stage);
			   
				if (resultBounds == null)
				{ 
					resultBounds = containerBounds.clone(); 
				}
				else 
				{
					resultBounds = resultBounds.union(containerBounds);
				}
			   
				// Include all filters if requested and they exist
				if ((aProcessFilters == true) && (aContainer.filters.length > 0))
				{
					var filterBounds:Rectangle = new Rectangle(0, 0, resultBounds.width, resultBounds.height);
					var bitmapData:BitmapData = new BitmapData(resultBounds.width, resultBounds.height, true, 0x00000000);
					
					var minimumX:Number = 0;
					var minimumY:Number = 0;
					
					var filter:BitmapFilter;
					var currentFilterBounds:Rectangle;
					
					var filtersLength:int = aContainer.filters.length;
					for (var filtersIndex:int = 0; filtersIndex < filtersLength; filtersIndex++) 
					{                          
						filter = aContainer.filters[filtersIndex];
						
						currentFilterBounds = bitmapData.generateFilterRect(filterBounds, filter);
						
						minimumX = minimumX + currentFilterBounds.x;
						minimumY = minimumY + currentFilterBounds.y;
						
						filterBounds = currentFilterBounds.clone();
						filterBounds.x = 0;
						filterBounds.y = 0;
						
						bitmapData.dispose();
						
						bitmapData = new BitmapData(filterBounds.width, filterBounds.height, true, 0x00000000);                                              
					}
					
					// Reposition filter_rectangle back to global coordinates
					currentFilterBounds.x = resultBounds.x + minimumX;
					currentFilterBounds.y = resultBounds.y + minimumY;
					
					resultBounds = currentFilterBounds.clone();
			   }                               
		   }
		   
		   return resultBounds;
		}
	   
		public static function EnableMouseProperties(aTarget:InteractiveObject, aMouseEventType:String):void
		{
			if (aTarget != null)
			{
				switch (aMouseEventType)
				{
					case MouseEvent.DOUBLE_CLICK:
					{
						aTarget.doubleClickEnabled = true;
					}
					case MouseEvent.CLICK:
					case MouseEvent.MOUSE_DOWN:
					case MouseEvent.MOUSE_UP:
					case MouseEvent.MOUSE_OVER:
					case MouseEvent.MOUSE_OUT:
					case MouseEvent.MOUSE_MOVE:
					case MouseEvent.MOUSE_WHEEL:
					case MouseEvent.ROLL_OVER:
					case MouseEvent.ROLL_OUT:
					{
						aTarget.mouseEnabled = true;
						if (aTarget is DisplayObjectContainer)
						{
							(aTarget as DisplayObjectContainer).mouseChildren = false;
						}
						break;
					}
					default:
						break;
				}
			}
		}
		
		public static function TraceDisplayList(aTarget:DisplayObjectContainer, aLevel:int = 0):void
		{
			//TODO : Externalize this when we have someplace to externalize to
			var tabbing:String = "";
			var d:DisplayObjectContainer;
			var len:int = aTarget.numChildren;
			
			for (var i:int = 0; i < aLevel; i++)
			{
				tabbing += "\t";
			}
			for (i = 0; i < len; i++)
			{
				trace(tabbing + aTarget.name);
				d = aTarget.getChildAt(i) as DisplayObjectContainer;
				
				if (d != null)
				{
					TraceDisplayList(d, ++aLevel);
				}
			}
		}
		
		public static function TraceAncestors(aTarget:DisplayObject):void
		{
			//TODO : Externalize this when we have someplace to externalize to
			if (aTarget != null)
			{
				trace("[" + getQualifiedClassName(aTarget), aTarget.name + "]");
				TraceAncestors(aTarget.parent);
			}
		}
		
		public static function TraceDescendants(aTarget:DisplayObject, aPrefix:String = ""):void
		{
			//TODO : Externalize this when we have someplace to externalize to
			trace(aPrefix + "[" + getQualifiedClassName(aTarget), aTarget.name + "]");
			aPrefix += " ";
			
			var d:DisplayObjectContainer = aTarget as DisplayObjectContainer;
			if (d)
			{
				var len:int = d.numChildren;
				for (var i:int = 0; i < len; i++)
				{
					TraceDescendants(d.getChildAt(i), aPrefix);
				}
			}
		}
		
		public static function StopAnimRecursive(aTarget:DisplayObjectContainer, aFrame:int = 1):void
		{
			var m:MovieClip = aTarget as MovieClip;
			var d:DisplayObjectContainer;
			
			if (m)
			{
				m.gotoAndStop(aFrame);
			}
			
			// don't iterate on a "frozen" children count (var len:int = aTarget.numChildren)
			// because child can be remove while looping
			for (var i:int = 0; i < aTarget.numChildren; i++)
			{
				d = aTarget.getChildAt(i) as DisplayObjectContainer;
				if (d != null)
				{
					StopAnimRecursive(d, aFrame);
				}
			}
		}
		
		// FASTER
		public static function GetParentOffset(aTarget:DisplayObject):Point
		{
			var offset:Point = new Point(0, 0);
			if (aTarget != null)
			{
				if (aTarget.parent != null)
				{
					var bounds:Rectangle = aTarget.getBounds(aTarget.parent);
					offset.x = bounds.x;
					offset.y = bounds.y;
					
					var d:DisplayObjectContainer = aTarget as DisplayObjectContainer;
					if (d && d.numChildren > 0)
					{
						var child:DisplayObject = d.getChildAt(0);
						offset.x += child.x;
						offset.y += child.y;
					}
					
					return (offset);
				}
			}
			
			return (offset);
		}
		
		public static function StopAll(aContainer:DisplayObjectContainer):void
		{
			var dispObj:DisplayObject;
			var dispArr:Array = new Array();
			dispArr[dispArr.length] = aContainer;
			
			do
			{
				var container:DisplayObjectContainer = dispArr.pop();
				if (container is MovieClip)
				{
					(container as MovieClip).stop();
				}
				for (var i:uint = 0; i < container.numChildren; i++)
				{
					dispObj = container.getChildAt(i);
					if (dispObj is DisplayObjectContainer)
					{
						dispArr[dispArr.length] = dispObj;
					}
				}
			}
			while (dispArr.length > 0);
		}
		
		public static function RemoveAllChildren(aContainer:DisplayObjectContainer):void
		{
			while (aContainer.numChildren)
			{
				aContainer.removeChildAt(0);
			}
		}
		
		public static function AlignRight(aObjectToAlign:DisplayObject, aReferenceObject:DisplayObject, aOffset:Number = 0):void
		{
			var toAlignBounds:Rectangle = aObjectToAlign.getBounds(aObjectToAlign.stage);
			var referenceBounds:Rectangle = aReferenceObject.getBounds(aReferenceObject.stage);
			
			var toAlignMaxRight:Number = toAlignBounds.x + toAlignBounds.width;
			var referenceMaxRight:Number = referenceBounds.x + referenceBounds.width;
			
			var difference:Number = referenceMaxRight - toAlignMaxRight + aOffset;
			
			aObjectToAlign.x += difference;
		}
		
		public static function AlignLeft(aObjectToAlign:DisplayObject, aReferenceObject:DisplayObject, aOffset:Number = 0):void
		{
			var toAlignBounds:Rectangle = aObjectToAlign.getBounds(aObjectToAlign.stage);
			var referenceBounds:Rectangle = aReferenceObject.getBounds(aReferenceObject.stage);
			
			var toAlignMaxLeft:Number = toAlignBounds.x;
			var referenceMaxLeft:Number = referenceBounds.x;
			
			var difference:Number = referenceMaxLeft - toAlignMaxLeft + aOffset;
			
			aObjectToAlign.x += difference;
		}
		
		public static function AlignBottom(aObjectToAlign:DisplayObject, aReferenceObject:DisplayObject, aOffset:Number = 0):void
		{
			var toAlignBounds:Rectangle = aObjectToAlign.getBounds(aObjectToAlign.stage);
			var referenceBounds:Rectangle = aReferenceObject.getBounds(aReferenceObject.stage);
			
			var toAlignLowest:Number = toAlignBounds.y + toAlignBounds.height;
			var referenceLowest:Number = referenceBounds.y + referenceBounds.height;
			
			var difference:Number = referenceLowest - toAlignLowest + aOffset;
			
			aObjectToAlign.y += difference;
		}
		
		public static function AlignTop(aObjectToAlign:DisplayObject, aReferenceObject:DisplayObject, aOffset:Number = 0):void
		{
			var toAlignBounds:Rectangle = aObjectToAlign.getBounds(aObjectToAlign.stage);
			var referenceBounds:Rectangle = aReferenceObject.getBounds(aReferenceObject.stage);
			
			var toAlignHighest:Number = toAlignBounds.y;
			var referenceHighest:Number = referenceBounds.y;
			
			var difference:Number = referenceHighest - toAlignHighest + aOffset;
			
			aObjectToAlign.y += difference;
		}
		
		public static function AlignCenterHorizontal(aObjectToAlign:DisplayObject, aReferenceObject:DisplayObject):void
		{
			var toAlignBounds:Rectangle = aObjectToAlign.getBounds(aObjectToAlign.stage);
			var referenceBounds:Rectangle = aReferenceObject.getBounds(aReferenceObject.stage);
			
			var middlePoint:Number = referenceBounds.x + (referenceBounds.width / 2);
			var difference:Number = middlePoint - toAlignBounds.x - (toAlignBounds.width / 2);
			aObjectToAlign.x += difference;
		}
		
		public static function AlignCenterVertical(aObjectToAlign:DisplayObject, aReferenceObject:DisplayObject):void
		{
			var toAlignBounds:Rectangle = aObjectToAlign.getBounds(aObjectToAlign.stage);
			var referenceBounds:Rectangle = aReferenceObject.getBounds(aReferenceObject.stage);
			
			var middlePoint:Number = referenceBounds.y + (referenceBounds.height / 2);
			var difference:Number = middlePoint - toAlignBounds.y - (toAlignBounds.height / 2);
			
			aObjectToAlign.y += difference;
		}
	}
}