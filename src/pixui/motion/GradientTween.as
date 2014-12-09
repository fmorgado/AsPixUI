package pixui.motion {
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	import pixui.motion.GradientTweenCenterMask;
	import pixui.motion.GradientTweenLeftMask;
	import pixui.motion.GradientTweenRightMask;
	
	public class GradientTween extends MaskTween {
		private static const VERTICAL_OFFSET:Number = 10;
		
		private var _targetWidth:Number = NaN;
		private var _targetHeight:Number = NaN;
		private var _left:DisplayObject;
		private var _right:DisplayObject;
		private var _center:DisplayObject;
		
		/**
		 * Constructor.
		 * @param  params  An object containing initial tween properties.
		 */
		public function GradientTween(params:Object=null) {
			super(params);
		}
		
		override protected function initialize():void {
			super.initialize();
			
			_left = new GradientTweenLeftMask();
			_center = new GradientTweenCenterMask();
			_right = new GradientTweenRightMask();
			
			var mask:Sprite = new Sprite();
			mask.cacheAsBitmap = true;
			mask.addChild(_left);
			mask.addChild(_center);
			mask.addChild(_right);
			this.mask = mask;
		}
		
		override protected function clearDisplayTarget(target:DisplayObject):void {
			super.clearDisplayTarget(target);
			_targetWidth = NaN;
			_targetHeight = NaN;
		}
		
		private function _setMaskSize():void {
			if (_displayTarget.width != _targetWidth || _displayTarget.height != _targetHeight) {
				_targetWidth = _displayTarget.width;
				_targetHeight = _displayTarget.height;
				
				_left.scaleX = _left.scaleY = _right.scaleX = _right.scaleY = 1;
				
				_center.width = _targetWidth;
				_center.height = _targetHeight + 2 * VERTICAL_OFFSET;
				
				var ratio:Number = _left.width / _left.height;
				_left.height = _center.height;
				_left.width = ratio * _left.height;
				
				ratio = _right.width / _right.height;
				_right.height = _center.height;
				_right.width = ratio * _right.height;
				
				_center.x = Math.floor(_left.width);
				_right.x = Math.floor(_center.x + _center.width);
			}
		}
		
		override protected function setForwardState():void {
			_setMaskSize();
			mask.x = -((1 - _progress) * (_targetWidth + _left.width) + _right.width) + _displayTarget.x;
			mask.y = _displayTarget.y - VERTICAL_OFFSET;
		}
		
		override protected function setBackwardState():void {
			_setMaskSize();
			mask.x = ((1 - _progress) * (_targetWidth + _left.width) - _right.width) + _displayTarget.x;
			mask.y = _displayTarget.y - VERTICAL_OFFSET;
		}
		
	}
}