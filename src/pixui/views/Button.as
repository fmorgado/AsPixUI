package pixui.views {
	import flash.display.DisplayObject;
	
	import pixlib.utils.resolvers.resolveInstanceOf;
	
	import pixui.utils.layout.alignCenter;
	import pixui.utils.layout.alignCenterMiddle;
	import pixui.utils.layout.alignMiddle;
	
	public class Button extends ButtonBase {
		
		/** Indicates the icon is at the top. */
		public static const ICON_TOP:String = 'top';
		/** Indicates the icon is on the left. */
		public static const ICON_LEFT:String = 'left';
		/** Indicates the icon is on the right. */
		public static const ICON_RIGHT:String = 'right';
		/** Indicates the icon is at the bottom. */
		public static const ICON_BOTTOM:String = 'bottom';
		/** Indicates the icon is under the label. */
		public static const ICON_UNDER:String = 'under';
		/** Indicates the icon is over the label. */
		public static const ICON_OVER:String = 'over';
		
		/**
		 * Constructor.
		 * @param  label  An optional label.
		 * @param  icon   An optional icon.
		 */
		public function Button(label:String = null, icon:* = null) {
			super();
			if (label != null) this.label = label;
			if (icon != null) this.icon = icon;
		}
		
		/** @inheritDoc */
		override protected function initialize():void {
			super.initialize();
			_labelInstance = new Label();
		}
		
		private var _icon:DisplayObject;
		/**
		 * Get or set the icon of the button. Supports a <code>Function</code>,
		 * a <code>Class</code> or an instance of <code>DisplayObject</code>.
		 * The getter always returns null or a display object, not
		 * necessarily the same value passed to the setter.
		 */
		public final function get icon():Object { return _icon; }
		public final function set icon(value:Object):void {
			// Clear previous icon
			if (_icon != null) {
				removeChild(_icon);
				_icon = null;
			}
			
			// Create new icon
			if (value != null) {
				_icon = resolveInstanceOf(value, DisplayObject) as DisplayObject;
				if (_icon != null)
					addChild(_icon);
			}
			
			invalidateLayout();
		}
		
		private var _labelStyle:Function;
		public final function set labelStyle(value:Function):void {
			_labelStyle = value;
			if (_labelInstance != null && _labelStyle != null)
				_labelStyle(_labelInstance);
		}
		
		private var _labelInstance:Label;
		public final function get labelInstance():Label { return _labelInstance; }
		
		/** Get or set the label. */
		public final function get label():String { return _labelInstance.text; }
		public final function set label(value:String):void {
			if (value == '') {
				if (_labelInstance.parent != null)
					removeChild(_labelInstance);
				invalidateLayout();
			} else {
				if (_labelInstance.parent == null)
					addChild(_labelInstance);
				_labelInstance.text = value;
				invalidateLayout();
			}
		}
		
		private var _iconPlacement:String;
		/**
		 * Indicates how the icon is placed, relative to the label.
		 * @see ICON_* constants
		 */
		public final function get iconPlacement():String { return _iconPlacement; }
		public final function set iconPlacement(value:String):void {
			if (value == _iconPlacement) return;
			_iconPlacement = value;
			invalidateLayout();
		}
		
		private var _iconGap:Number = 0;
		/** The gap between the label and the icon, in pixels. @default 0 */
		public final function get iconGap():Number { return _iconGap; }
		public final function set iconGap(value:Number):void {
			if (value == _iconGap) return;
			_iconGap = value;
			invalidateLayout();
		}
		
		override protected function validateLayout():void {
			super.validateLayout();
			
			if (_icon == null) {
				if (_labelInstance != null)
					alignCenterMiddle(_labelInstance, availableWidth, availableHeight, _left, _top);
				
			} else if (_labelInstance == null) {
				alignCenterMiddle(_icon, availableWidth, availableHeight, _left, _top);
				
			} else {
				var maxWidth:Number;
				var left:Number;
				var maxHeight:Number;
				var top:Number;
				
				switch (_iconPlacement) {
					case ICON_TOP:
						maxHeight = _icon.height + _labelInstance.height + _iconGap;
						top = Math.round((availableHeight - maxHeight) * 0.5 + _top);
						_icon.y = top;
						_labelInstance.y = _icon.y + _icon.height + _iconGap;
						alignCenter(_icon, availableWidth, _left);
						alignCenter(_labelInstance, availableWidth, _left);
						break;
					
					case ICON_BOTTOM:
						maxHeight = _icon.height + _labelInstance.height + _iconGap;
						top = Math.round((availableHeight - maxHeight) * 0.5 + _top);
						_labelInstance.y = top;
						_icon.y = _labelInstance.y + _labelInstance.height + _iconGap;
						alignCenter(_icon, availableWidth, _left);
						alignCenter(_labelInstance, availableWidth, _left);
						break;
					
					case ICON_LEFT:
						maxWidth = _icon.width + _labelInstance.width + _iconGap;
						left = Math.round((availableWidth - maxWidth) * 0.5 + _left);
						_icon.x = left;
						_labelInstance.x = _icon.x + _icon.width + _iconGap;
						alignMiddle(_icon, availableHeight, _top);
						alignMiddle(_labelInstance, availableHeight, _top);
						break;
					
					case ICON_RIGHT:
						maxWidth = _icon.width + _labelInstance.width + _iconGap;
						left = Math.round((availableWidth - maxWidth) * 0.5 + _left);
						_labelInstance.x = left;
						_icon.x = _labelInstance.x + _labelInstance.width + _iconGap;
						alignMiddle(_icon, availableHeight, _top);
						alignMiddle(_labelInstance, availableHeight, _top);
						break;
					
					case ICON_UNDER:
						if (getChildIndex(_icon) > getChildIndex(_labelInstance))
							swapChildren(_icon, _labelInstance);
						alignCenterMiddle(_labelInstance, availableWidth, availableHeight, _left, _top);
						alignCenterMiddle(_icon, availableWidth, availableHeight, _left, _top);
						break;
					
					//case ICON_OVER:
					default:
						if (getChildIndex(_icon) < getChildIndex(_labelInstance))
							swapChildren(_icon, _labelInstance);
						alignCenterMiddle(_labelInstance, availableWidth, availableHeight, _left, _top);
						alignCenterMiddle(_icon, availableWidth, availableHeight, _left, _top);
						break;
				}
			}
		}
		
	}
}