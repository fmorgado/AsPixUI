package pixui.motion {
	import pixlib.utils.Color;
	
	public class ColorTweenBase extends DisplayTween {
		protected var color:Color;
		
		/**
		 * Constructor.
		 * @param  params  An object containing initial tween properties.
		 */
		public function ColorTweenBase(params:Object = null) {
			super(params);
			color = new Color();
		}
		
		override protected function updateState():void {
			if (_displayTarget != null)
				_displayTarget.transform.colorTransform = color;
		}
		
	}
}