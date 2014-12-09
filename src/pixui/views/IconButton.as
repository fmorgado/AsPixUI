package pixui.views {
	import flash.display.DisplayObject;
	
	import pixlib.utils.resolvers.resolveInstanceOf;
	
	import pixui.utils.layout.alignCenterMiddle;
	
	public final class IconButton extends ButtonBase {
		
		protected var _icon:DisplayObject;
		public function get icon():Object { return _icon; }
		public function set icon(value:Object):void {
			if (_icon != null) {
				removeChild(_icon);
				_icon = null;
			}
			
			_icon = resolveInstanceOf(value, DisplayObject) as DisplayObject;
			if (_icon != null) {
				addChild(_icon);
				invalidateLayout();
			}
		}
		
		override protected function validateLayout():void {
			super.validateLayout();
			if (_icon != null)
				alignCenterMiddle(_icon, availableWidth, availableHeight, _left, _top);
		}
		
	}
}