package pixui.paints.styles {
	import flash.display.GradientType;
	import flash.display.Graphics;
	import flash.display.InterpolationMethod;
	import flash.display.SpreadMethod;
	import flash.geom.Matrix;
	
	public final class RadialGradientFill extends Style {
		private var _colors:Array;
		private var _alphas:Array;
		private var _ratios:Array;
		private var _matrix:Matrix;
		private var _spreadMethod:String;
		private var _interpolationMethod:String;
		private var _focalPointRatio:Number;
		
		/**
		 * Constructor.
		 * ...
		 */
		public function RadialGradientFill(
			colors:Array,
			alphas:Array,
			ratios:Array,
			matrix:Matrix = null,
			spreadMethod:String = SpreadMethod.PAD,
			interpolationMethod:String = InterpolationMethod.RGB,
			focalPointRatio:Number = 0.0
		) {
			_colors = colors;
			_alphas = alphas;
			_ratios = ratios;
			_matrix = matrix;
			_spreadMethod = spreadMethod;
			_interpolationMethod = interpolationMethod;
			_focalPointRatio = focalPointRatio;
		}
		
		/** @inheritDoc */
		override public function configure(graphics:Graphics):void {
			graphics.beginGradientFill(
				GradientType.RADIAL,
				_colors,
				_alphas,
				_ratios,
				_matrix,
				_spreadMethod,
				_interpolationMethod,
				_focalPointRatio);
		}
		
	}
}