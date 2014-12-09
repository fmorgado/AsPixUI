package pixui.motion {
	
	public class BrightnessTween extends ColorTweenBase {
		
		/**
		 * Constructor.
		 * @param  params  An object containing initial tween properties.
		 */
		public function BrightnessTween(params:Object = null) { super(params); }
		
		/** The start value. @defaul 0 */
		public var startValue:Number = 0;
		
		/** The end value. @default 1 */
		public var endValue:Number = 1;
		
		override protected function updateState():void {
			color.brightness = getProgressBetween(startValue, endValue);
			super.updateState();
		}
		
	}
}