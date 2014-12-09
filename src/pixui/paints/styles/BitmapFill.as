package pixui.paints.styles {
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.geom.Matrix;
	
	public final class BitmapFill extends Style {
		private var _bitmap:BitmapData;
		private var _matrix:Matrix;
		private var _repeat:Boolean;
		private var _smooth:Boolean;
		
		/**
		 * Constructor.
		 * @param  bitmap  The bitmap to draw.
		 * @param  matrix  An optional matrix transformation object.
		 * @param  repeat  If true, the bitmap image repeats in a tiled pattern.
		 *                 If false, the bitmap image does not repeat, and the
		 *                 edges of the bitmap are used for any fill area that
		 *                 extends beyond the bitmap.
		 * @param  smooth  If false, upscaled bitmap images are rendered by
		 *                 using a nearest-neighbor algorithm and look pixelated.
		 *                 If true, upscaled bitmap images are rendered by using
		 *                 a bilinear algorithm. Rendering by using the nearest
		 *                 neighbor algorithm is faster.
		 */
		public function BitmapFill(
			bitmap:BitmapData,
			matrix:Matrix = null,
			repeat:Boolean = true,
			smooth:Boolean = false
		) {
			_bitmap = bitmap;
			_matrix = matrix;
			_repeat = repeat;
			_smooth = smooth;
		}
		
		/** @inheritDoc */
		override public function configure(graphics:Graphics):void {
			graphics.beginBitmapFill(_bitmap, _matrix, _repeat, _smooth);
		}
		
	}
}