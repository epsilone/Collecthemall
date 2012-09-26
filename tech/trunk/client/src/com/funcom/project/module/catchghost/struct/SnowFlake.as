// SNOWSTORM IN 15 MINS!
// Author : Seb Lee-Delisle
// Blog : www.sebleedelisle.com
// Company : www.pluginmedia.net
//
// This work is licensed under a Creative Commons  2.0 License.

// Full details at 
// http://creativecommons.org/licenses/by/2.0/uk/

// You may re-use this code as you wish, but a credit would be 
// appreciated. And I'd love to see what you do with it! 
// mail me : seb@sebleedelisle.com

package com.funcom.project.module.catchghost.struct
{
	import flash.display.Sprite; 
	import flash.geom.Rectangle; 
	import flash.filters.BlurFilter; 
	
	public class SnowFlake extends Sprite
	{
		// the x and y velocity of the snowflake
		public var xVel:Number; 
		public var yVel:Number; 
		
		// the size of the snowflake
		public var size:Number ;
		
		// and the limits of the screen
		public var screenArea:Rectangle; 
		
		
		
		public function SnowFlake(screenarea:Rectangle)
		{
			
			// FIRST THINGS FIRST! 
			// let's draw a little dot.
			graphics.lineStyle(3,0xffffff); 
			graphics.moveTo(0,0); 
			graphics.lineTo(0.2,0.2); 
			//graphics.beginFill(0xffffff,1); 
			////graphics.drawCircle(0,0,1.5); 
			//graphics.endFill(); 
			
			// store the screenArea rectangle
			screenArea = screenarea; 
			
			// set the x position to a random position somewhere 
			// within the width of the screen area
			x = Math.random()*screenArea.width; 
			
			// and a notional z value for the 3D flake. 
			// this is merely used to calculate the size the 
			// flake should be. 
			
			// (we could just give it a random size but 
			// the distribution wouldn't look as nice)
			var z:Number = (Math.random()*600)-250; 
			
			// and calculate the size the flake would be 
			// if the flake was that z distance from the camera
			size = calculatePerspectiveSize(z);
			
			
			// let's scale up or down depending on how big we should be at
			// this distance
			scaleX = scaleY = size; 
			
			
			// if the z position is close to the camera
			// then let's give it a depth of field blur!
			// (z gets smaller as it moves towards the camera
			//  and the blur amount gets bigger)
			if(z<-150)
			{
				// z will never be less than -250 so if we add 150 to it we
				// should have a number between -100 and 0
				var bluramount:Number = z+150; 
				
				// so now if we divide by -100 we should have a number between 0 and 1
				bluramount /= -100;
				
				// so if we want a blur amount between 2 and 22, we now have to multiply by 20 
				// and add 2
				
				bluramount = (bluramount * 20) + 2;  
				
				// and now add a blur filter to the filters array with that blur amount
				filters = [new BlurFilter(bluramount, bluramount, 2)]; 
				
			}
			else 
			{
				// let's add a small blur filter to all the snowflakes anyway 
				// to make them look a bit fluffier
				filters = [new BlurFilter(2,2,2)]; 
			}
			
			// if we cache this sprite as a bitmap, the Flash players stores it
			// as a bitmap which renders MUCH faster. 
			
			// NB! If you rescale or rotate this sprite, then the Flash player 
			// will re-render it and then store the bitmap again, which is actually 
			// slower than not setting cacheAsBitmap! 
			
			cacheAsBitmap = true; 
			
			
			//We don't need mouse interaction on it
			mouseChildren = false;
			
			// now set a random x velocity between -1 and 1
			xVel = (Math.random()*2)-1; 
			
			// and a constant downward velocity of 3 (gravity)
			yVel = 3; 
			
			// now let's multiply the velocity by the scale, 
			// so that things in the foreground appear to move 
			// faster
			
			xVel*=size; 
			yVel*=size; 
			
		}
		
		public function update(wind:Number):void
		{
			
			// first let's add the x velocity to the x position
			x+=xVel; 
			y+=yVel;
			
			
			// the wind only affects the x position so let's add it to
			// the x position (multiply by size so foreground flakes
			// move faster!
		
			x += (wind*size);
			
			// now let's check that the flake is within the screen area
			// if not move it to the other side
			
			if(y>screenArea.bottom) y = screenArea.top; 
			if(x>screenArea.right) x = screenArea.left; 
			else if(x<screenArea.left) x = screenArea.right; 
			
			
		}
		
		public function calculatePerspectiveSize(z:Number) : Number
		{
			// an arbitrary field of view (ish)
			var fov:Number = 300; 
			
			// dodgy magic function to calculate the scale factor for
			// an object at the specified z position
			return fov/(z+fov); 
			
			
		}
		
		
	}
	
}