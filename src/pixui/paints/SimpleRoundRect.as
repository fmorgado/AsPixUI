package pixui.paints {
	import flash.display.Graphics;
	
	public class SimpleRoundRect extends Paint {
		private var _color:uint;
		private var _alpha:Number;
		private var _ellipseWidth:Number;
		private var _ellipseHeight:Number;
		
		/**
		 * Constructor.
		 * @param  color  The color of the rectangle.
		 * @param  alpha  The transparency of the rectangle. Default is 1.
		 */
		public function SimpleRoundRect(color:uint, ellipseWidth:Number, ellipseHeight:Number = NaN, alpha:Number = 1) {
			_color = color;
			_alpha = alpha;
			_ellipseWidth = ellipseWidth;
			_ellipseHeight = ellipseHeight;
		}
		
		/** @inheritDoc */
		override public function draw(graphics:Graphics, width:Number, height:Number):void {
			graphics.beginFill(_color, _alpha);
			graphics.drawRoundRect(0, 0, width, height, _ellipseWidth, _ellipseHeight);
			graphics.endFill();
		}
		
	}
}