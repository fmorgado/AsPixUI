package pixui.views {
	import flash.display.DisplayObject;
	
	import pixlib.utils.resolvers.resolveInstanceOf;
	
	import pixui.utils.layout.fitHeight;
	
	public class ProgressBar extends View {
		
		protected var _bar:DisplayObject;
		public function get bar():Object { return _bar; }
		public function set bar(value:Object):void {
			if (_bar != null)
				removeChild(_bar);
			
			_bar = resolveInstanceOf(value, DisplayObject) as DisplayObject;
			if (_bar != null) {
				addChild(_bar);
				invalidateLayout();
			}
		}
		
		override protected function validateLayout():void {
			if (_bar != null) {
				_bar.x = _left;
				_bar.width = Math.round(_progress * availableWidth);
				fitHeight(_bar, availableHeight, _top);
			}
		}
		
		protected var _progress:Number = 0;
		public function get progress():Number { return _progress; }
		public function set progress(value:Number):void {
			_progress = value;
			invalidateLayout();
		}
		
	}
}