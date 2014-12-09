package pixui.paints {
	import flash.display.Graphics;
	
	import pixui.paints.styles.Style;
	
	public class BorderRoundRect extends Paint {
		private var _border:Number;
		private var _borderStyle:Style;
		private var _fillStyle:Style;
		private var _ellipseWidth:Number;
		private var _ellipseHeight:Number;
		private var _innerEllipseWidth:Number;
		private var _innerEllipseHeight:Number;
		
		public function BorderRoundRect(border:Number, borderStyle:Style,
										fillStyle:Style,
										ellipseWidth:Number,
										ellipseHeight:Number = NaN) {
			_border = border;
			_borderStyle = borderStyle;
			_fillStyle = fillStyle;
			_ellipseWidth = ellipseWidth;
			_ellipseHeight = isNaN(ellipseHeight) ? ellipseWidth : ellipseHeight;
			_innerEllipseWidth = _getInnerEllipse(ellipseWidth);
			_innerEllipseHeight = _getInnerEllipse(_ellipseHeight);
		}
		
		private function _getInnerEllipse(value:Number):Number {
			const borderX2:Number = 2 * _border;
			return value > borderX2 ? value - borderX2 : 0;
		}
		
		/** @inheritDoc */
		override public function draw(graphics:Graphics, width:Number, height:Number):void {
			const innerWidth:Number = width - 2 * _border;
			const innerHeight:Number = height - 2 * _border;
			_borderStyle.configure(graphics);
			graphics.drawRoundRect(0, 0, width, height, _ellipseWidth, _ellipseHeight);
			graphics.drawRoundRect(_border, _border, innerWidth, innerHeight, _innerEllipseWidth, _innerEllipseHeight);
			_fillStyle.configure(graphics);
			graphics.drawRoundRect(_border, _border, innerWidth, innerHeight, _innerEllipseWidth, _innerEllipseHeight);
		}
		
	}
}