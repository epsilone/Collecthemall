package  {
	import flash.display.MovieClip;
	
	public class Ghost extends MovieClip{
		
		protected var _hitPoints:Number;
		//Visual 
		private var _hitPointsBar:HitPointsBar;
		private var _floatDamage:FloatDamage;

		public function Ghost() {
			_hitPointsBar = new HitPointsBar();
			_floatDamage = new FloatDamage();
			
			//Insivible by default
			_hitPointsBar.alpha = 0;
			_floatDamage.alpha = 0;
			
			addChild(_hitPointsBar);
			addChild(_floatDamage);
		}
		
		public function get hitPointsBar():HitPointsBar
		{
			return _hitPointsBar;
		}
		
		public function get floatDamage():FloatDamage
		{
			return _floatDamage;
		}

	}
	
}
