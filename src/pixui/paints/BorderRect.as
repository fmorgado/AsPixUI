package pixui.paints {
	import flash.display.Graphics;
	
	import pixui.paints.styles.Style;

	public class BorderRect extends Paint {
		private var _border:Number;
		private var _borderStyle:Style;
		private var _fillStyle:Style;
		
		public function BorderRect(border:Number, borderStyle:Style, fillStyle:Style) {
			_border = border;
			_borderStyle = borderStyle;
			_fillStyle = fillStyle;
		}
		
		/** @inheritDoc */
		override public function draw(graphics:Graphics, width:Number, height:Number):void {
			const innerWidth:Number = width - 2 * _border;
			const innerHeight:Number = height - 2 * _border;
			_borderStyle.configure(graphics);
			graphics.drawRect(0, 0, width, height);
			graphics.drawRect(_border, _border, innerWidth, innerHeight);
			_fillStyle.configure(graphics);
			graphics.drawRect(_border, _border, innerWidth, innerHeight);
		}
		
	}
}