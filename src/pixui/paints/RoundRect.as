package pixui.paints {
	import flash.display.Graphics;
	
	import pixui.paints.styles.Style;
	
	public final class RoundRect extends Paint {
		private var _style:Style;
		private var _ellipseWidth:Number;
		private var _ellipseHeight:Number;
		
		/**
		 * Constructor.
		 * @param  style          The style of the round rectangle.
		 * @param  ellipseWidth   The width of the ellipse used to draw the rounded corners (in pixels).
		 * @param  ellipseHeight  The height of the ellipse used to draw the rounded corners (in pixels).
		 *                        Optional; if no value is specified, the default value matches that provided for the ellipseWidth parameter.
		 */
		public function RoundRect(style:Style, ellipseWidth:Number, ellipseHeight:Number = NaN) {
			_style = style;
			_ellipseWidth = ellipseWidth;
			_ellipseHeight = ellipseHeight;
		}
		
		override public function draw(graphics:Graphics, width:Number, height:Number):void {
			_style.configure(graphics);
			graphics.drawRoundRect(0, 0, width, height, _ellipseWidth, _ellipseHeight);
		}
	}
}