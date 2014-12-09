package pixui.motion {
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	public class MaskTween extends DisplayTween {
		protected var mask:DisplayObject;
		
		/**
		 * Constructor.
		 * @param  params  An object containing initial tween properties.
		 */
		public function MaskTween(params:Object=null) { super(params); }
		
		override protected function clearDisplayTarget(target:DisplayObject):void {
			if (target.parent != null)
				_onTargetRemovedFromStage(null);
			target.removeEventListener(Event.ADDED_TO_STAGE, _onTargetAddedToStage);
			target.removeEventListener(Event.REMOVED_FROM_STAGE, _onTargetRemovedFromStage);
		}
		
		override protected function setDisplayTarget(target:DisplayObject):void {
			target.cacheAsBitmap = true;
			target.addEventListener(Event.ADDED_TO_STAGE, _onTargetAddedToStage);
			target.addEventListener(Event.REMOVED_FROM_STAGE, _onTargetRemovedFromStage);
			if (target.parent != null)
				_onTargetAddedToStage(null);
		}
		
		protected function setForwardState():void {}
		
		protected function setBackwardState():void {}
		
		override protected function updateState():void {
			if (_displayTarget == null) return;
			
			if (_reverse) {
				setBackwardState();
			} else {
				setForwardState();
			}
		}
		
		private function _onTargetAddedToStage(_:*):void {
			_displayTarget.parent.addChild(mask);
			_displayTarget.mask = mask;
			updateState();
		}
		
		private function _onTargetRemovedFromStage(_:*):void {
			_displayTarget.mask = null;
			mask.parent.removeChild(mask);
		}
		
	}
}