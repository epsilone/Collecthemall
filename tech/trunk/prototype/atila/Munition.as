package  {
	import flash.display.MovieClip;
	
	public class Munition extends MovieClip{
		
		private var _munitionId:uint;
		private var _munitionName:String;
		
		private var _minDamage:uint;
		private var _maxDamage:uint;
		
		private var _range:uint;
		
		public function Munition() {
			
		}
		
		public function set munitionId(value:uint):void
		{
			_munitionId = value;
		}
		
		public function get munitionId():uint
		{
			return _munitionId;
		}
		
		public function set munitionName(value:String):void
		{
			_munitionName = value;
		}
		
		public function get munitionName():String
		{
			return _munitionName;
		}
		
		public function set minDamage(value:uint):void
		{
			_minDamage = value;
		}
		
		public function get minDamage():uint
		{
			return _minDamage;
		}
		
		public function set maxDamage(value:uint):void
		{
			_maxDamage = value;
		}
		
		public function get maxDamage():uint
		{
			return _maxDamage;
		}
		
		public function set range(value:uint):void
		{
			_range = value;
		}
		
		public function get range():uint
		{
			return _range;
		}

	}
	
}
