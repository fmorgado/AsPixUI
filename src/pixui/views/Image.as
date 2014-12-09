package pixui.views {
	//{ Imports
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	
	import pixlib.commands.Command;
	import pixlib.logging.logger;
	import pixlib.motion.Tween;
	import pixlib.net.ImageLoader;
	import pixlib.net.loadQueue;
	import pixlib.utils.resolvers.resolveInstance;
	import pixlib.utils.resolvers.resolveInstanceOf;
	
	import pixui.paints.Paint;
	import pixui.paints.SimpleRect;
	import pixui.utils.layout.alignCenterMiddle;
	import pixui.utils.layout.fitSizeWithPolicy;
	import pixui.utils.layout.ScalePolicy;
	//}
	
	public class Image extends View {
		
		//{ Constructor & Initialization
		///////////////////////////////////////////////////////////////////////
		/**
		 * Constructor.
		 * @param  source  The source of the image. Optional.
		 */
		public function Image(source:Object = null) {
			super();
			if (source != null)
				this.source = source;
		}
		
		/** @inheritDoc */
		override protected function initialize():void {
			super.initialize();
			addChild(_imageContainer = new Sprite());
			_imageContainer.cacheAsBitmap = true;
		}
		///////////////////////////////////////////////////////////////////////
		//}
		
		//{ Public Properties
		///////////////////////////////////////////////////////////////////////
		/** The icon to use when loading. */
		public var loadIcon:Object;
		
		/** The icon to use when an error occured. */
		public var errorIcon:Object;
		
		private var _smoothing:Boolean = true;
		public final function get smoothing():Boolean { return _smoothing; }
		public final function set smoothing(value:Boolean):void {
			if (value == _smoothing) return;
			_smoothing = true;
			_applySmoothing();
		}
		
		private var _scalePolicy:String = ScalePolicy.NONE;
		/** Indicates how the image must be scaled. @see pixui.utils.layout.ScalePolicy */
		public final function get scalePolicy():String { return _scalePolicy; }
		public final function set scalePolicy(value:String):void {
			_scalePolicy = value;
			invalidateLayout();
		}
		
		private var _imageAlignX:Number = 0.5;
		/** The image horizontal alignment, a value between 0 and 1. Default is 0.5. */
		public final function get imageAlignX():Number { return _imageAlignX; }
		public final function set imageAlignX(value:Number):void {
			_imageAlignX = value;
			invalidateLayout();
		}
		
		private var _imageAlignY:Number = 0.5;
		/** The image vertical alignment, a value between 0 and 1. Default is 0.5. */
		public final function get imageAlignY():Number { return _imageAlignY; }
		public final function set imageAlignY(value:Number):void {
			_imageAlignY = value;
			invalidateLayout();
		}
		
		private var _tween:Tween;
		/** The tween to use on the image when it is loaded. */
		public function get tween():Tween { return _tween; }
		public function set tween(value:Tween):void {
			if (_tween != null) {
				_tween.target = null;
				_tween = null;
			}
			
			if (value != null) {
				value.target = _imageContainer;
				_tween = value;
			}
		}
		///////////////////////////////////////////////////////////////////////
		//}
		
		//{ State Clearing
		///////////////////////////////////////////////////////////////////////
		private function _clearState():void {
			_clearCommand();
			_clearImage();
			_clearIconInstance();
		}
		///////////////////////////////////////////////////////////////////////
		//}
		
		//{ Command Handling
		///////////////////////////////////////////////////////////////////////
		private var _command:ImageLoader;
		
		private function _createCommand(request:Object):void {
			_command = new ImageLoader(request);
			_command.onComplete(_onCommandComplete);
			_command.onError(_onCommandError);
			_command.onProgress(_onCommandProgress);
			loadQueue.add(_command);
		}
		
		private function _clearCommand():void {
			if (_command != null) {
				loadQueue.remove(_command);
				_command.dispose();
				_command = null;
			}
		}
		
		private function _onCommandComplete(command:ImageLoader):void {
			var image:DisplayObject = command.data as DisplayObject;
			_clearCommand();
			_setImage(image);
			if (_tween != null)
				_tween.start();
			if (willTrigger(Event.COMPLETE))
				dispatchEvent(new Event(Event.COMPLETE));
		}
		
		private function _onCommandError(command:ImageLoader):void {
			logger.log(command.error);
			_clearCommand();
		}
		
		private function _onCommandProgress(command:ImageLoader):void {
			if (willTrigger(ProgressEvent.PROGRESS))
				dispatchEvent(new ProgressEvent(ProgressEvent.PROGRESS, false, false, command.progress, command.progressTotal));
		}
		///////////////////////////////////////////////////////////////////////
		//}
		
		//{ Icon Handling
		///////////////////////////////////////////////////////////////////////
		private var _iconInstance:DisplayObject;
		private function _clearIconInstance():void {
			if (_iconInstance != null) {
				this.removeChild(_iconInstance);
				_iconInstance = null;
			}
		}
		private function _setIconInstance(value:*):void {
			_clearState();
			
			_iconInstance = resolveInstanceOf(value, DisplayObject) as DisplayObject;
			if (_iconInstance != null) {
				this.addChild(_iconInstance);
				invalidateLayout();
			}
		}
		///////////////////////////////////////////////////////////////////////
		//}
		
		//{ Image Handling
		///////////////////////////////////////////////////////////////////////
		private var _imageContainer:Sprite;
		private var _imageInstance:DisplayObject;
		
		private function _clearImage():void {
			if (_imageInstance != null) {
				_imageContainer.removeChild(_imageInstance);
				_imageInstance = null;
			}
		}
		
		private function _applySmoothing():void {
			if (_imageInstance == null) return;
			
			if (_imageInstance is Bitmap) {
				(_imageInstance as Bitmap).smoothing = _smoothing;
			} else if (_imageInstance is Loader && (_imageInstance as Loader).content is Bitmap) {
				((_imageInstance as Loader).content as Bitmap).smoothing = _smoothing;
			}
		}
		
		private function _setImage(value:DisplayObject):void {
			_clearState();
			
			if (value != null) {
				_imageInstance = value;
				_imageContainer.addChild(value);
				invalidateLayout();
				_applySmoothing();
			}
		}
		///////////////////////////////////////////////////////////////////////
		//}
		
		//{ Source Handling
		///////////////////////////////////////////////////////////////////////
		private var _source:Object;
		
		/** The source of the image. */
		public function get source():Object { return _source; }
		public function set source(value:Object):void {
			_clearState();
			_source = value;
			
			if ((value is URLRequest) || (value is String)) {
				_createCommand(value);
			} else {
				_setImage(resolveInstanceOf(value, DisplayObject) as DisplayObject);
			}
		}
		///////////////////////////////////////////////////////////////////////
		//}
		
		//{ Mask Handling
		///////////////////////////////////////////////////////////////////////
		private var _imageMask:DisplayObject;
		
		public final function get imageMask():* { return _imageMask; }
		public final function set imageMask(value:*):void {
			if (_imageMask != null) {
				_imageContainer.mask = null;
				this.removeChild(_imageMask);
				_imageMask = null;
			}
			
			value = resolveInstance(value);
			if (value != null) {
				if (value is Number) {
					_imageMask = View.fromPaint(new SimpleRect(value as Number));
				} else if (value is Paint) {
					_imageMask = View.fromPaint(value as Paint);
				} else if (value is DisplayObject) {
					_imageMask = value as DisplayObject;
				} else {
					logger.error('Invalid mask reference:  ' + value, null, this);
					return;
				}
				
				_imageMask.cacheAsBitmap = true;
				this.addChild(_imageMask);
				_imageContainer.mask = _imageMask;
				invalidateLayout();
			}
		}
		///////////////////////////////////////////////////////////////////////
		//}
		
		//{ Original size Handling
		///////////////////////////////////////////////////////////////////////
		/** The original width of the source. */
		public final function get originalSourceWidth():Number {
			return _imageInstance != null ? _imageInstance.width : 0;
		}
		
		/** The original height of the source. */
		public final function get originalSourceHeight():Number {
			return _imageInstance != null ? _imageInstance.height : 0;
		}
		///////////////////////////////////////////////////////////////////////
		//}
		
		//{ Layout Handling
		///////////////////////////////////////////////////////////////////////
		override protected final function validateLayout():void {
			super.validateLayout();
			
			if (_imageMask != null) {
				_imageMask.x = _left;
				_imageMask.y = _top;
				_imageMask.width = availableWidth;
				_imageMask.height = availableHeight;
			}
			
			if (_iconInstance != null) {
				validateIconLayout(_iconInstance);
			} else if (_imageInstance != null) {
				fitSizeWithPolicy(this, _imageContainer, _scalePolicy, _imageAlignX, _imageAlignY, originalSourceWidth, originalSourceHeight);
			}
		}
		
		protected function validateIconLayout(icon:DisplayObject):void {
			alignCenterMiddle(_iconInstance, _width, _height);
		}
		///////////////////////////////////////////////////////////////////////
		//}
		
		//{ Events Handling
		///////////////////////////////////////////////////////////////////////
		/** Add a listener for the <code>Event.COMPLETE</code> event. */
		public final function addCompleteListener(listener:Function):void {
			addEventListener(Event.COMPLETE, listener);
		}
		/** Remove a listener for the <code>Event.COMPLETE</code> event. */
		public final function removeCompleteListener(listener:Function):void {
			removeEventListener(Event.COMPLETE, listener);
		}
		
		/** Add a listener for the <code>Command.ERROR</code> event. */
		public final function addErrorListener(listener:Function):void {
			addEventListener(Command.ERROR, listener);
		}
		/** Remove a listener for the <code>Command.ERROR</code> event. */
		public final function removeErrorListener(listener:Function):void {
			removeEventListener(Command.ERROR, listener);
		}
		
		/** Add a listener for the <code>ProgressEvent.PROGRESS</code> event. */
		public final function addProgressListener(listener:Function):void {
			addEventListener(ProgressEvent.PROGRESS, listener);
		}
		/** Remove a listener for the <code>ProgressEvent.PROGRESS</code> event. */
		public final function removeProgressListener(listener:Function):void {
			removeEventListener(ProgressEvent.PROGRESS, listener);
		}
		///////////////////////////////////////////////////////////////////////
		//}
		
	}
}