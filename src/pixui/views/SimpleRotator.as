package pixui.views {
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	public final class SimpleRotator extends View {
		
		public var iconClass:Class;
		public var frameRotation:Number = 10;
		
		private var _rotation:Number = 0;
		private var _icon:DisplayObject;
		
		override protected function initializeAfterStyles():void {
			if (iconClass == null)
				throw new Error('iconClass must be set in ' + this);
			
			addChild(_icon = new iconClass());
			_icon.x = Math.round(_icon.width / 2);
			_icon.y = Math.round(_icon.height / 2);
			
			addEnterFrameListener(_onEnterFrame);
		}
		
		private function _onEnterFrame(event:Event):void {
			_rotation += frameRotation;
			if (rotation > 360) rotation -= 360;
			_icon.rotation = _rotation;
		}
		
	}
}