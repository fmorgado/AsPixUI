package pixui.views {
	//{ Imports
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.events.Event;
	import flash.media.Video;
	
	import pixlib.media.VideoController;
	import pixlib.media.VideoState;
	import pixlib.utils.resolvers.resolveInstanceOf;
	
	import pixui.utils.layout.alignXY;
	import pixui.utils.layout.fitSizeWithPolicy;
	import pixui.utils.layout.ScalePolicy;
	//}
	
	public class VideoView extends View {
		//{ Initialization & Misc Members
		///////////////////////////////////////////////////////////////////////
		private var _video:Video;
		private var _icon:DisplayObject;
		
		override protected function initialize():void {
			super.initialize();
			
			this.mouseChildren = false;
			this.addClickListener(_onClick);
			
			addChild(_video = new Video());
			_video.smoothing = true;
			_video.visible = false;
		}
		
		private function _onClick(event:Event):void {
			if (togglePlayingOnClick && _controller.state == VideoState.OPEN) {
				_controller.playing = ! _controller.playing;
			}
		}
		///////////////////////////////////////////////////////////////////////
		//}
		
		//{ Controller Handling
		///////////////////////////////////////////////////////////////////////
		private var _controller:VideoController;
		/** The video controller to use. */
		public final function get controller():VideoController { return _controller; }
		public final function set controller(value:VideoController):void {
			if (value == _controller) return;
			
			if (_controller != null) {
				_video.attachNetStream(null);
				_controller.removeStateChangeListener(_onControllerStateChange);
				_controller.removePlayingChangeListener(_onControllerPlayingChange);
			}
			
			_controller = value;
			if (value != null) {
				value.addStateChangeListener(_onControllerStateChange);
				value.addPlayingChangeListener(_onControllerPlayingChange);
				_video.attachNetStream(value.stream);
			}
			
			invalidateState();
		}
		
		private function _onControllerStateChange(_):void {
			invalidateState();
		}
		
		private function _onControllerPlayingChange(_):void {
			if (_controller.playing) {
				_clearIcon();
			} else {
				_setIcon(playIcon);
			}
		}
		///////////////////////////////////////////////////////////////////////
		//}
		
		//{ Validation Handling
		///////////////////////////////////////////////////////////////////////
		override protected function validateState():void {
			super.validateState();
			
			if (_controller == null) {
				_video.visible = false;
				_clearIcon();
			} else {
				switch (_controller.state) {
					case VideoState.UNINITIALIZED:
						_video.visible = false;
						_clearIcon();
						break;
					case VideoState.INITIALIZING:
						_video.visible = false;
						_setIcon(initializingIcon);
						break;
					case VideoState.ERROR:
						_video.visible = false;
						_setIcon(errorIcon);
						break;
					case VideoState.BUFFERING:
						_video.visible = false;
						_setIcon(bufferingIcon);
						break;
					//case VideoState.OPEN:
					default:
						_video.visible = true;
						_onControllerPlayingChange(null);
						invalidateLayout();
						break;
				}
			}
		}
		
		override protected function validateLayout():void {
			if (_video.visible)
				fitSizeWithPolicy(this, _video, _scalePolicy, _alignX, _alignY, _video.videoWidth, _video.videoHeight);
			
			if (_icon != null)
				alignXY(_icon, _width, _height, 0.5, 0.5);
		}
		///////////////////////////////////////////////////////////////////////
		//}
		
		//{ Icon Handling
		///////////////////////////////////////////////////////////////////////
		private function _clearIcon():void {
			if (_icon != null) {
				removeChild(_icon);
				_icon = null;
			}
		}
		
		private function _setIcon(value:Object):void {
			_clearIcon();
			
			if (value == null) return;
			
			_icon = resolveInstanceOf(value, DisplayObject) as DisplayObject;
			if (_icon != null) {
				if (_icon is InteractiveObject) {
					var icon:InteractiveObject = _icon as InteractiveObject;
					icon.mouseEnabled = false;
				}
				addChild(_icon);
				invalidateLayout();
			}
		}
		///////////////////////////////////////////////////////////////////////
		//}
		
		//{ Public Members
		///////////////////////////////////////////////////////////////////////
		private var _alignX:Number = 0.5;
		/** The image horizontal alignment, a value between 0 and 1. Default is 0.5. */
		public final function get alignX():Number { return _alignX; }
		public final function set alignX(value:Number):void {
			_alignX = value;
			invalidateLayout();
		}
		
		private var _alignY:Number = 0.5;
		/** The image vertical alignment, a value between 0 and 1. Default is 0.5. */
		public final function get alignY():Number { return _alignY; }
		public final function set alignY(value:Number):void {
			_alignY = value;
			invalidateLayout();
		}
		
		private var _scalePolicy:String = ScalePolicy.NONE;
		/** Indicates how the image must be scaled. @see pixui.utils.layout.ScalePolicy */
		public final function get scalePolicy():String { return _scalePolicy; }
		public final function set scalePolicy(value:String):void {
			_scalePolicy = value;
			invalidateLayout();
		}
		
		/** The original width of the video. */
		public final function get originalSourceWidth():Number { return _video.videoWidth; }
		/** The original height of the video. */
		public final function get originalSourceHeight():Number { return _video.videoHeight; }
		
		/** Specifies whether the video should be smoothed (interpolated) when it is scaled.
		 *  @see flash.media.Video#smoothing */
		public final function get smoothing():Boolean { return _video.smoothing; }
		public final function set smoothing(value:Boolean):void { _video.smoothing = value; }
		
		/** Indicates the type of filter applied to decoded video as part of post-processing.
		 *  ee flash.media.Video#deblocking */
		public final function get deblocking():int { return _video.deblocking; }
		public final function set deblocking(value:int):void { _video.deblocking = value; }
		
		/** The icon to display when an error occurred. */
		public var errorIcon:Object;
		
		/** The icon to display when the video is paused. */
		public var playIcon:Object;
		
		/** The icon to display when the video is initializing. */
		public var initializingIcon:Object;
		
		/** The icon to display when the video is buffering. */
		public var bufferingIcon:Object;
		
		/** Indicates if the video is resumed/paused when the view is clicked. */
		public var togglePlayingOnClick:Boolean = true;
		///////////////////////////////////////////////////////////////////////
		//}
		
	}
}