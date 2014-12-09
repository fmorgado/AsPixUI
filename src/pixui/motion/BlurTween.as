package pixui.motion {
	import flash.filters.BlurFilter;
	
	public class BlurTween extends DisplayTween {
		private var _filter:BlurFilter;
		private var _filters:Array;
		
		/**
		 * Constructor.
		 * @param  params  An object containing initial tween properties.
		 */
		public function BlurTween(params:Object = null) { super(params); }
		
		override protected function initialize():void {
			super.initialize();
			_filter = new BlurFilter();
			_filters = [_filter];
		}
		
		/** The <code>blurX</code> value at the start. @default 4.0 */
		public var blurXStart:Number = 4.0;
		/** The <code>blurX</code> value at the end. @default 4.0 */
		public var blurXEnd:Number = 4.0;
		/** The <code>blurY</code> value at the start. @default 4.0 */
		public var blurYStart:Number = 4.0;
		/** The <code>blurY</code> value at the end. @default 4.0 */
		public var blurYEnd:Number = 4.0;
		/** The number of times to apply the filter. @see flash.filters.BlurFilter#quality */
		public function get quality():int { return _filter.quality; }
		public function set quality(value:int):void { _filter.quality = value; }
		
		override protected function updateState():void {
			_filter.blurX = getProgressBetween(blurXStart, blurXEnd);
			_filter.blurY = getProgressBetween(blurYStart, blurYEnd);
			_displayTarget.filters = _filters;
		}
		
	}
}