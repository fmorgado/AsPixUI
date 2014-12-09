package pixui.paints.styles {
	import flash.display.GradientType;
	import flash.display.Graphics;
	import flash.display.InterpolationMethod;
	import flash.display.SpreadMethod;
	import flash.geom.Matrix;
	
	public final class LinearGradientFill extends Style {
		
		private var _colors:Array;
		private var _alphas:Array;
		private var _ratios:Array;
		private var _matrix:Matrix;
		private var _spreadMethod:String;
		private var _interpolationMethod:String;
		
		/**
		 * Constructor.
		 * ...
		 */
		public function LinearGradientFill(
			colors:Array,
			alphas:Array,
			ratios:Array,
			matrix:Matrix = null,
			spreadMethod:String = SpreadMethod.PAD,
			interpolationMethod:String = InterpolationMethod.RGB
		) {
			_colors = colors;
			_alphas = alphas;
			_ratios = ratios;
			_matrix = matrix;
			_spreadMethod = spreadMethod;
			_interpolationMethod = interpolationMethod;
		}
		
		/** @inheritDoc */
		override public function configure(graphics:Graphics):void {
			graphics.beginGradientFill(
				GradientType.LINEAR,
				_colors,
				_alphas,
				_ratios,
				_matrix,
				_spreadMethod,
				_interpolationMethod);
		}
		
	}
}