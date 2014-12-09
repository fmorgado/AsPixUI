package pixui.paints {
	import flash.display.Graphics;
	import pixui.paints.styles.Style;
	
	public final class Rect extends Paint {
		private var _style:Style;
		
		/**
		 * Constructor.
		 * @param  style  The style of rectangle.
		 */
		public function Rect(style:Style) {
			_style = style;
		}
		
		/** @inheritDoc */
		override public function draw(graphics:Graphics, width:Number, height:Number):void {
			_style.configure(graphics);
			graphics.drawRect(0, 0, width, height);
		}
	}
}