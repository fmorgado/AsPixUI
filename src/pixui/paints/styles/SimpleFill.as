package pixui.paints.styles {
	import flash.display.Graphics;
	
	public final class SimpleFill extends Style {
		private var _color:uint;
		private var _alpha:Number;
		
		/**
		 * Constructor.
		 * @param  argb   The color of the fill.
		 */
		public function SimpleFill(color:uint, alpha:Number = 1) {
			_color = color;
			_alpha = alpha;
		}
		
		/** @inheritDoc */
		override public function configure(graphics:Graphics):void {
			graphics.beginFill(_color, _alpha);
		}
		
	}
}