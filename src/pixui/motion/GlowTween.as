package pixui.motion {
	import flash.filters.GlowFilter;
	
	import pixlib.utils.Color;
	
	public class GlowTween extends DisplayTween {
		private var _filter:GlowFilter;
		private var _filters:Array;
		
		/**
		 * Constructor.
		 * @param  params  An object containing initial tween properties.
		 */
		public function GlowTween(params:Object = null) { super(params); }
		
		override protected function initialize():void {
			super.initialize();
			_filter = new GlowFilter();
			_filter.strength;
			_filters = [_filter];
		}
		
		public var alphaStart:Number = 1.0;
		public var alphaEnd:Number = 1.0;
		
		public var blurXStart:Number = 6.0;
		public var blurXEnd:Number = 6.0;
		
		public var blurYStart:Number = 6.0;
		public var blurYEnd:Number = 6.0;
		
		public var colorStart:uint = 0xFF0000;
		public var colorEnd:uint = 0xFF0000;
		
		public var strengthStart:Number = 2;
		public var strengthEnd:Number = 2;
		
		/** The transparency of the glow. @default 1 */
		public function get alpha():Number { return alphaStart; }
		public function set alpha(value:Number):void { alphaStart = alphaEnd = value; }
		
		/** The amount of horizontal blur. @default 6.0 */
		public function get blurX():Number { return blurXStart; }
		public function set blurX(value:Number):void { blurXStart = blurXEnd = value; }
		
		/** The amount of vertical blur. @default 6.0 */
		public function get blurY():Number { return blurYStart; }
		public function set blurY(value:Number):void { blurYStart = blurYEnd = value; }
		
		/** The color of the glow. @default 0xFF0000 (red) */
		public function get color():uint { return colorStart; }
		public function set color(value:uint):void { colorStart = colorEnd = _filter.color = value; }
		
		/** Specifies whether the glow is an inner glow. @default false */
		public function get inner():Boolean { return _filter.inner; }
		public function set inner(value:Boolean):void { _filter.inner = value; }
		
		/** Specifies whether the glow is an inner glow. @default false */
		public function get knockout():Boolean { return _filter.knockout; }
		public function set knockout(value:Boolean):void { _filter.knockout = value; }
		
		/** The number of times to apply the filter. @default 1 @see flash.filters.GlowFilter#quality */
		public function get quality():int { return _filter.quality; }
		public function set quality(value:int):void { _filter.quality = value; }
		
		/** The strength of the imprint or spread. @default 2 */
		public function get strength():Number { return strengthStart; }
		public function set strength(value:Number):void { strengthStart = strengthEnd = value; }
		
		override protected function updateState():void {
			_filter.alpha = getProgressBetween(alphaStart, alphaEnd);
			_filter.blurX = getProgressBetween(blurXStart, blurXEnd);
			_filter.blurY = getProgressBetween(blurYStart, blurYEnd);
			_filter.strength = getProgressBetween(strengthStart, strengthEnd);
			if (colorStart != colorEnd)
				_filter.color = Color.interpolateColor(colorStart, colorEnd, _progress);
			_displayTarget.filters = _filters;
		}
		
	}
}