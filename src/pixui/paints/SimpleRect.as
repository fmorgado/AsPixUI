package pixui.paints {
	import flash.display.Graphics;
	
	public class SimpleRect extends Paint {
		private var _color:uint;
		private var _alpha:Number;
		
		/**
		 * Constructor.
		 * @param  color  The color of the rectangle.
		 * @param  alpha  The transparency of the rectangle. Default is 1.
		 */
		public function SimpleRect(color:uint, alpha:Number = 1) {
			_color = color;
			_alpha = alpha;
		}
		
		/** @inheritDoc */
		override public function draw(graphics:Graphics, width:Number, height:Number):void {
			graphics.beginFill(_color, _alpha);
			graphics.drawRect(0, 0, width, height);
			graphics.endFill();
		}
	}
}