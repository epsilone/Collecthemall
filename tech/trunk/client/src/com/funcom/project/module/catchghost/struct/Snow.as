package com.funcom.project.module.catchghost.struct 
{
	import flash.display.Sprite;
	import flash.events.Event; 
	import flash.geom.Rectangle; 
	
	/**
	 * ...
	 * @author Atila
	 */
	public class Snow extends Sprite
	{		
		// first make an array to put all our snowflakes in
		private var snowFlakes:Array; 

		// and decide the maxium number of flakes we want
		private var numFlakes:uint = 500; 

		// and define a rectangle to store the screen dimensions in. 
		private var screenArea:Rectangle; 
	
		public function Snow(stageWidth:Number, stageHeight:Number) 
		{
			snowFlakes = new Array();
			screenArea = new Rectangle(0, 0, stageWidth, stageHeight); 
			
			this.addEventListener(Event.ENTER_FRAME, frameLoop, false, 0, true); 
		}
		
		private function frameLoop(e:Event):void
		{
			
			var snowflake : SnowFlake; 
			
			// if we don't have the maximum number of flakes... 
			if(snowFlakes.length<numFlakes)
			{
				// then make a new one!
				snowflake = new SnowFlake(screenArea); 
				
				// add it to the array of snowflakes
				snowFlakes.push(snowflake); 
				
				// and add it to the stage
				this.addChild(snowflake); 
				
			}
			
			// now calculate the wind factor by looking at the x position 
			// of the mouse relative to the centre of the screen
			var wind : Number = ((screenArea.width/2) - mouseX);
			
			// and divide by 60 to make it smaller
			wind /=60; 
			
			// now loop through every snowflake
			for(var i:uint = 0; i<snowFlakes.length; i++)
			{
				
				snowflake = snowFlakes[i]; 
				
				// and update it
				snowflake.update(wind); 
			}
			
		}
		
	}

}