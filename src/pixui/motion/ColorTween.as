package pixui.motion {
	
	public class ColorTween extends ColorTweenBase {
		
		public var redOffsetStart:Number = 0;
		public var redOffsetEnd:Number = 0;
		
		public var greenOffsetStart:Number = 0;
		public var greenOffsetEnd:Number = 0;
		
		public var blueOffsetStart:Number = 0;
		public var blueOffsetEnd:Number = 0;
		
		public var alphaOffsetStart:Number = 0;
		public var alphaOffsetEnd:Number = 0;
		
		/**
		 * Constructor.
		 * @param  params  An object containing initial tween properties.
		 */
		public function ColorTween(params:Object = null) { super(params); }
		
		override protected function updateState():void {
			color.redOffset = getProgressBetween(redOffsetStart, redOffsetEnd);
			color.greenOffset = getProgressBetween(greenOffsetStart, greenOffsetEnd);
			color.blueOffset = getProgressBetween(blueOffsetStart, blueOffsetEnd);
			color.alphaOffset = getProgressBetween(alphaOffsetStart, alphaOffsetEnd);
			super.updateState();
		}
		
	}
}