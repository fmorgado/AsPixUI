package pixui.motion {
	import flash.display.DisplayObject;
	
	import pixlib.motion.Tween;
	
	public class DisplayTween extends Tween {
		
		/**
		 * Constructor.
		 * @param  params  An object containing initial tween properties.
		 */
		public function DisplayTween(params:Object = null) { super(params); }
		
		/** This method is called when the current target is removed. */
		protected function clearDisplayTarget(target:DisplayObject):void {}
		
		/** This method is called when the target is set. */
		protected function setDisplayTarget(target:DisplayObject):void {}
		
		protected var _displayTarget:DisplayObject;
		/** @inheritDoc */
		override public function get target():Object { return _displayTarget; }
		override public function set target(value:Object):void {
			if (_displayTarget != null) {
				clearDisplayTarget(_displayTarget);
				_displayTarget = null;
			}
			
			if (value != null) {
				if (value is DisplayObject) {
					_displayTarget = value as DisplayObject;
					setDisplayTarget(_displayTarget);
				} else {
					throw new ArgumentError('target must be an instance of DisplayObject');
				}
			}
		}
	}
}