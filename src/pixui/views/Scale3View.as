package pixui.views {
	import flash.display.DisplayObject;
	
	import pixlib.utils.resolvers.resolveInstanceOf;
	
	public class Scale3View extends View {
		
		private var _first:DisplayObject;
		private var _second:DisplayObject;
		private var _third:DisplayObject;
		
		public function Scale3View(
			first:Object,
			second:Object,
			third:Object,
			horizontal:Boolean = true
		) {
			_first = resolveInstanceOf(first, DisplayObject) as DisplayObject;
			_second = resolveInstanceOf(second, DisplayObject) as DisplayObject;
			_third = resolveInstanceOf(third, DisplayObject) as DisplayObject;
			_horizontal = horizontal;
			super();
		}
		
		override protected function initialize():void {
			super.initialize();
			addChild(_first);
			addChild(_second);
			addChild(_third);
		}
		
		private var _horizontal:Boolean;
		public function get horizontal():Boolean { return _horizontal; }
		public function set horizontal(value:Boolean):void {
			if (value == _horizontal) return;
			_horizontal = value;
			invalidateLayout();
		}
		
		override protected function validateLayout():void {
			_first.scaleX = _first.scaleY = _third.scaleX = _third.scaleY = 1;
			
			if (_horizontal) {
				var minWidth:Number = _first.width + _third.width;
				if (minWidth > _width) {
					_second.width = 0;
					var ratio:Number = _first.width / minWidth;
					_first.width = ratio * _width;
					_third.width = _width - _first.width;
					
				} else {
					_second.width = _width - _first.width - _third.width;
				}
				
				_first.x = 0;
				_second.x = _first.width;
				_third.x = _second.x + _second.width;
				
				_first.height = _second.height = _third.height = _height;
				
			} else {
				var minHeight:Number = _first.height + _third.height;
				if (minHeight > _height) {
					_second.height = 0;
					var ratio2:Number = _first.height / minHeight;
					_first.height = ratio2 * _height;
					_third.height = _height - _first.height;
					
				} else {
					_second.height = _height - _first.height - _third.height;
				}
				
				_first.y = 0;
				_second.y = _first.height;
				_third.y = _second.y + _second.height;
				
				_first.width = _second.width = _third.width = _width;
			}
		}
		
	}
}