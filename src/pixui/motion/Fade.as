package pixui.motion {
	
	public class Fade extends DisplayTween {
		
		/**
		 * Constructor.
		 * @param  params  An object containing initial tween properties.
		 */
		public function Fade(params:Object = null) { super(params); }
		
		/** The alpha value at the start. */
		public var startValue:Number = 0.0;
		
		/** The alpha value at the end. */
		public var endValue:Number = 1.0;
		
		override protected function updateState():void {
			if (_displayTarget != null)
				_displayTarget.alpha = _progress * (endValue - startValue) + startValue;
		}
		
	}
}