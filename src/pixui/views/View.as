package pixui.views {
	//{ Imports
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.events.TouchEvent;
	import flash.geom.Rectangle;
	
	import pixlib.logging.logger;
	import pixlib.managers.StyleManager;
	import pixlib.utils.resolvers.resolveInstance;
	
	import pixui.layout.Layout;
	import pixui.layout.LayoutData;
	import pixui.paints.Paint;
	import pixui.paints.SimpleRect;
	//}
	
	public class View extends Sprite {
		
		//{ Static Utilities
		///////////////////////////////////////////////////////////////////////
		/** Create a view with the given paint as background. */
		public static function fromPaint(paint:Paint):View {
			var result:View = new View();
			result.background = paint;
			return result;
		}
		///////////////////////////////////////////////////////////////////////
		//}
		
		//{ Static Render Handling
		///////////////////////////////////////////////////////////////////////
		private static const _views:Vector.<View> = new <View>[];
		private static var _stage:Stage;
		
		private static function _onStageRender(event:Event):void {
			do {
				for (var index:uint = 0; index < _views.length; index++) {
					var view:View = _views[index];
					if (view == null) break;
					_views[index] = null;
					view.validateNow();
				}
			} while (_views[0] != null);
			
			_stage.removeEventListener(Event.RENDER, _onStageRender);
			_stage = null;
		}
		
		private static function registerForRender(view:View, stage:Stage):void {
			if (_stage == null) {
				_stage = stage;
				stage.addEventListener(Event.RENDER, _onStageRender);
				stage.invalidate();
			}
			
			var length:uint = _views.length;
			for (var index:uint = 0; index < length; index++) {
				if (_views[index] == null) {
					_views[index] = view;
					return;
				}
			}
			_views[length] = view;
		}
		///////////////////////////////////////////////////////////////////////
		//}
		
		//{ Constants
		///////////////////////////////////////////////////////////////////////
		/** The overall invalidation flag. */
		public static const FLAG_ALL:uint         = 0xFFFFFFFF;
		/** The background invalidation flag. */
		public static const FLAG_BACKGROUND:uint  = 0x01;
		/** The layout invalidation flag. */
		public static const FLAG_LAYOUT:uint      = 0x02;
		/** The state invalidation flag. */
		public static const FLAG_STATE:uint       = 0x04;
		/** The data invalidation flag. */
		public static const FLAG_DATA:uint        = 0x08;
		
		/** The type of the event dispatched when the view is moved. */
		public static const EVENT_MOVE:String = 'move';
		/** The type of the event dispatched when the data has changed. */
		public static const EVENT_DATA_CHANGE:String = 'dataChange';
		///////////////////////////////////////////////////////////////////////
		//}
		
		//{ Constructor & Initialization
		///////////////////////////////////////////////////////////////////////
		/** Constructor. */
		public function View() {
			super();
			initialize();
			StyleManager.style(this);
			initializeAfterStyles();
		}
		
		/**
		 * Called on construction, before style are set.
		 * Override this method to add adicional initialization.
		 * Always call <code>super.initialize()</code> at the
		 * top of the overriding method.
		 */
		protected function initialize():void {
			this.addEventListener(Event.ADDED_TO_STAGE, _onAddedToStage);
			this.addEventListener(Event.REMOVED_FROM_STAGE, _onRemovedFromStage);
		}
		
		/** Similar to <code>initialize</code>, but called after styles are set. */
		protected function initializeAfterStyles():void {}
		
		private function _onAddedToStage(event:Event):void {
			// Layout and LayoutData invalidate listeners are only added
			// when the view is on the stage, so layouts may be shared
			// among many views without leaking them.
			
			if (_layout != null) {
				_layout.addInvalidateListener(_onLayoutInvalidate);
				if (_layout.isInvalid)
					_onLayoutInvalidate(_layout);
			}
			
			if (_layoutData != null) {
				_layoutData.addInvalidateListener(_onLayoutDataInvalidate);
				if (_layoutData.isInvalid)
					_onLayoutDataInvalidate(_layoutData);
			}
				
			if (_invalidations != 0)
				registerForRender(this, stage);
			
			onAddedToStage();
		}
		
		/** This method is called when the view is added to the stage. */
		protected function onAddedToStage():void {}
		
		private function _onRemovedFromStage(event:Event):void {
			onRemovedFromStage();
		}
		
		/** This method is called when the view is removed from the stage. */
		protected function onRemovedFromStage():void {}
		///////////////////////////////////////////////////////////////////////
		//}
		
		//{ Properties
		///////////////////////////////////////////////////////////////////////
		/**
		 * This method is called when the <code>enabled</code> property changes.
		 * Override this to change dependent properties.
		 */
		protected function enabledChange():void {}
		
		protected var _enabled:Boolean = true;
		/** Indicate if the view is enabled. */
		public final function get enabled():Boolean { return _enabled; }
		public final function set enabled(value:Boolean):void {
			if (value == _enabled) return;
			_enabled = value;
			enabledChange();
			invalidateState();
		}
		
		private var _clipContent:Boolean = false;
		/** Indicates if the content muts be clipped to the size of the view. */
		public final function get clipContent():Boolean { return _clipContent; }
		public final function set clipContent(value:Boolean):void {
			_clipContent = value;
			if (value) {
				invalidate(FLAG_BACKGROUND);
			} else {
				this.scrollRect = null;
			}
		}
		
		public function get rect():Rectangle { return new Rectangle(x, y, _width, _height); }
		///////////////////////////////////////////////////////////////////////
		//}
		
		//{ Focus Handling
		///////////////////////////////////////////////////////////////////////
		private var _focusEnabled:Boolean = false;
		public final function get focusEnabled():Boolean { return _focusEnabled; }
		public final function set focusEnabled(value:Boolean):void {
			if (value == _focusEnabled) return;
			
			_focusEnabled = value;
			if (value) {
				this.addEventListener(FocusEvent.FOCUS_IN, _onFocusIn);
				this.addEventListener(FocusEvent.FOCUS_OUT, _onFocusOut);
			} else {
				this.removeEventListener(FocusEvent.FOCUS_IN, _onFocusIn);
				this.removeEventListener(FocusEvent.FOCUS_OUT, _onFocusOut);
				if (_focused) _onFocusOut(null);
			}
		}
		
		private var _focused:Boolean = false;
		/** Indicates if the view has input focus. */
		public final function get focused():Boolean { return _focused; }
		public function set focused(value:Boolean):void {
			if (stage == null)
				throw new Error('Cannot apply focus, not added to stage!');
			stage.focus = this;
		}
		
		private function _onFocusIn(_):void {
			_focused = true;
			invalidateState();
			onFocusIn();
		}
		
		/**
		 * This method is called when the view gains focus.
		 * <code>focusEnabled</code> must be true.
		 */ 
		protected function onFocusIn():void {}
		
		private function _onFocusOut(_):void {
			_focused = false;
			invalidateState();
		}
		
		/**
		 * This method is called when the view looses focus.
		 * <code>focusEnabled</code> must be true.
		 */ 
		protected function onFocusOut():void {}
		///////////////////////////////////////////////////////////////////////
		//}
		
		//{ Layout Handling
		///////////////////////////////////////////////////////////////////////
		protected var _layout:Layout;
		/** The layout of the view. */
		public final function get layout():Layout { return _layout; }
		public final function set layout(value:Layout):void {
			if (_layout != null && stage != null)
				_layout.removeInvalidateListener(_onLayoutInvalidate);
			
			_layout = value;
			
			if (value != null && stage != null) {
				value.addInvalidateListener(_onLayoutInvalidate);
				invalidateLayout();
			}
		}
		
		private function _onLayoutInvalidate(layout:Layout):void {
			
		}
		
		protected var _layoutData:LayoutData;
		/** The layout properties of this view. */
		public final function get layoutData():LayoutData { return _layoutData; }
		public final function set layoutData(value:LayoutData):void {
			if (_layoutData != null && stage != null)
				_layoutData.removeInvalidateListener(_onLayoutDataInvalidate);
			
			_layoutData = value;
			
			if (value != null && stage != null) {
				value.addInvalidateListener(_onLayoutDataInvalidate);
				invalidateLayout();
			}
		}
		
		private function _onLayoutDataInvalidate(layoutData:LayoutData):void {
			
		}
		
		/** Invalidate the layout of the view. */
		public final function invalidateLayout():void {
			invalidate(FLAG_LAYOUT);
		}
		
		/** This method is called automatically when the layout must be validated. */
		protected function validateLayout():void {
			if (_layout != null) {
				if (_layoutChildren == null)
					_layoutChildren = new <View>[];
				
				// TODO layout validation implemention
			}
		}
		
		/**
		 * Invalidate the parent container's layout, if possible.
		 * Call this method when the size of the view changes dynamically.
		 */
		protected final function invalidateParentLayout():void {
			if (parent != null && parent is View)
				(parent as View).invalidateLayout();
		}
		///////////////////////////////////////////////////////////////////////
		//}
		
		//{ Layout Children Handling
		///////////////////////////////////////////////////////////////////////
		private var _layoutChildren:Vector.<View>;
		
		/** The number of layout children. */
		public final function get numLayoutChildren():uint {
			return _layoutChildren == null ? 0 : _layoutChildren.length;
		}
		
		public final function addLayoutChild(child:View):View {
			if (_layoutChildren == null)
				_layoutChildren = new <View>[];
			
			if (_layoutChildren.indexOf(child) < 0) {
				
			}
			
			return child;
		}
		
		public final function addLayoutChildAt(child:View, index:uint):View {
			return child;
		}
		
		public final function removeLayoutChild(child:View):View {
			if (_layoutChildren != null) {
				
			}
			return child;
		}
		
		public final function removeLayoutChildAt(index:uint):View {
			if (_layoutChildren != null) {
				
			}
			return null;
		}
		///////////////////////////////////////////////////////////////////////
		//}
		
		//{ Invalidation Handling
		///////////////////////////////////////////////////////////////////////
		private var _invalidations:uint = FLAG_ALL;
		/** @private Indicates we're currently inside <code>validateNow</code>. */
		private var _validating:Boolean = false;
		public final function get validating():Boolean { return _validating; }
		
		/**
		 * Indicates if the given type has been invalidated.
		 * @param  type  The type of invalidation to check for.
		 * @return  True if the view is invalid for the given type,
		 *          false otherwise.
		 */
		protected final function isInvalid(type:uint):Boolean {
			return (_invalidations & type) > 0;
		}
		
		/** Invalidate for the view for the given invalidation type. */
		protected final function invalidate(type:uint):void {
			const mustRegister:Boolean = (_invalidations == 0);
			_invalidations |= type;
			if (! _validating && mustRegister && stage)
				registerForRender(this, stage);
		}
		
		/** Validate the view immediately. */
		public final function validateNow():void {
			if (_invalidations == 0) return;
			_validating = true;
			
			validateBefore();
			
			if (isInvalid(FLAG_DATA))
				validateData();
			if (isInvalid(FLAG_STATE))
				validateState();
			if (isInvalid(FLAG_LAYOUT))
				validateLayout();
			if (isInvalid(FLAG_BACKGROUND)) {
				if (_clipContent)
					this.scrollRect = new Rectangle(0, 0, _width, _height);
				validateBackground();
			}
			
			validateAfter();
			
			_invalidations = 0;
			_validating = false;
		}
		
		/**
		 * This method is called automatically before the internal state is validated.
		 * Override this to provide custom validation.
		 */
		protected function validateBefore():void {}
		
		/**
		 * This method is called automatically after the internal state is validated.
		 * Override this to provide custom validation.
		 */
		protected function validateAfter():void {}
		
		private var _stateHandler:Function;
		/** A function that is invoked when the state is changes. */
		public final function get stateHandler():Function { return _stateHandler; }
		public final function set stateHandler(value:Function):void {
			_stateHandler = value;
			invalidateState();
		}
		
		/** This method is called when the state must be validated. */
		protected function validateState():void {
			if (_stateHandler != null)
				_stateHandler(this);
		}
		
		/** Invalidate the state of the view. */
		protected final function invalidateState():void {
			invalidate(FLAG_STATE);
		}
		///////////////////////////////////////////////////////////////////////
		//}
		
		//{ Size Handling
		///////////////////////////////////////////////////////////////////////
		protected var _width:Number = 100;
		/** Get or set the width of the view. */
		override public function get width():Number { return _width; }
		override public function set width(value:Number):void {
			if (value == _width) return;
			_width = value;
			invalidate(FLAG_BACKGROUND | FLAG_LAYOUT);
			dispatchResizeEvent();
		}
		
		protected var _height:Number = 100;
		/** Get or set the height of the view. */
		override public function get height():Number { return _height; }
		override public function set height(value:Number):void {
			if (value == _height) return;
			_height = value;
			invalidate(FLAG_BACKGROUND | FLAG_LAYOUT);
			dispatchResizeEvent();
		}
		
		/**
		 * Set the size of the view.
		 * @param  width   The new width of the view.
		 * @param  height  The new height of the view.
		 */
		public function setSize(width:Number, height:Number):void {
			if (width == _width && height == _height) return;
			_width = width;
			_height = height;
			invalidate(FLAG_BACKGROUND | FLAG_LAYOUT);
			dispatchResizeEvent();
		}
		///////////////////////////////////////////////////////////////////////
		//}
		
		//{ Background Handling
		///////////////////////////////////////////////////////////////////////
		private var _background:Object;
		private var _backgroundInstance:Object;
		
		/**
		 * Get the background of the view.
		 * The value returned may not be the same as the one passed to the setter.
		 */
		public final function get background():Object { return _background; }
		/**
		 * Set the background of the view.
		 * If <code>value</code> is a function, it is called and the result is
		 * used as background.
		 * If <code>value</code> is a class, it is instantiated and the instance
		 * is used as background.
		 * The value may be an instance of <code>DisplayObject</code>, in which
		 * case it is added to the display list at index 0, an instance of
		 * <code>Paint</code>, in which case it will be used to draw the
		 * on the view's <code>graphics</code> property, or an integer, in which
		 * case it will be converted to a <code>SimpleRect</code>.
		 * @see pixui.paints.Paint
		 */
		public final function set background(value:Object):void {
			if (value == _background) return;
			_background = value;
			
			// Clear previous background
			if (_backgroundInstance != null) {
				if (_backgroundInstance is DisplayObject)
					this.removeChild(_backgroundInstance as DisplayObject);
				else // back is Paint
					this.graphics.clear();
				_backgroundInstance = null;
			}
			
			// Create new background
			if (value != null) {
				_backgroundInstance = resolveInstance(value);
				
				if (_backgroundInstance is DisplayObject) {
					addChildAt(_backgroundInstance as DisplayObject, 0);
				} else if (_backgroundInstance is Paint) {
					// Nothing to do
				} else if (_backgroundInstance is Number) {
					// Number matches all of int, uint and Number
					_backgroundInstance = new SimpleRect(uint(_backgroundInstance));
				} else {
					logger.error('Invalid background instance:  ' + _backgroundInstance, null, this);
					_backgroundInstance = null;
					return;
				}
				invalidate(FLAG_BACKGROUND);
			}
		}
		
		private function validateBackground():void {
			if (_backgroundInstance != null) {;
				if (_backgroundInstance is DisplayObject) {
					const display:DisplayObject = _backgroundInstance as DisplayObject;
					display.width = width;
					display.height = height;
				} else { // back is Paint
					const paint:Paint = _backgroundInstance as Paint;
					graphics.clear();
					paint.draw(graphics, width, height);
				}
			}
		}
		///////////////////////////////////////////////////////////////////////
		//}
		
		//{ Position Handling
		///////////////////////////////////////////////////////////////////////
		override public function set x(value:Number):void {
			super.x = value;
			dispatchMoveEvent();
		}
		
		override public function set y(value:Number):void {
			super.y = value;
			dispatchMoveEvent();
		}
		
		/**
		 * Move the view.
		 * @param  x  The new X coordinate.
		 * @param  y  The new Y coordinate.
		 */
		public final function move(x:Number, y:Number):void {
			this.x = x;
			this.y = y;
			dispatchMoveEvent();
		}
		///////////////////////////////////////////////////////////////////////
		//}
		
		//{ Padding Handling
		///////////////////////////////////////////////////////////////////////
		protected var _left:Number = 0;
		/** The left padding. */
		public final function get left():Number { return _left; }
		public final function set left(value:Number):void {
			_left = value;
			invalidateLayout();
		}
		
		protected var _top:Number = 0;
		/** The top padding. */
		public final function get top():Number { return _top; }
		public final function set top(value:Number):void {
			_top = value;
			invalidateLayout();
		}
		
		protected var _right:Number = 0;
		/** The right padding. */
		public final function get right():Number { return _right; }
		public final function set right(value:Number):void {
			_right = value;
			invalidateLayout();
		}
		
		protected var _bottom:Number = 0;
		/** The bottom padding. */
		public final function get bottom():Number { return _bottom; }
		public final function set bottom(value:Number):void {
			_bottom = value;
			invalidateLayout();
		}
		
		/** Set the left, top, right and bottom paddings to the same value. */
		public final function set padding(value:Number):void {
			_left = _top = _right = _bottom = value;
			invalidateLayout();
		}
		
		/**
		 * Set the padding values.
		 * @param  left    The left padding.
		 * @param  top     The top padding.
		 * @param  right   The right padding.
		 * @param  bottom  The bottom padding.
		 */
		public final function setPaddings(left:Number, top:Number, right:Number, bottom:Number):void {
			_left = left;
			_top = top;
			_right = right;
			_bottom = bottom;
			invalidateLayout();
		}
		
		/** Get the available layout width. */
		public final function get availableWidth():Number {
			var result:Number = _width - _left - _right;
			return result >= 0 ? result : 0;
		}
		
		/** Get the available layout height. */
		public final function get availableHeight():Number {
			var result:Number = _height - _top - _bottom;
			return result >= 0 ? result : 0;
		}
		///////////////////////////////////////////////////////////////////////
		//}
		
		//{ Data Handling
		///////////////////////////////////////////////////////////////////////
		protected var _data:Object;
		
		/** The data associated to this view. */
		public function get data():Object { return _data; }
		public function set data(value:Object):void {
			_data = value;
			invalidateData();
			if (willTrigger(EVENT_DATA_CHANGE))
				dispatchEvent(new Event(EVENT_DATA_CHANGE));
		}
		
		public final function invalidateData():void {
			invalidate(FLAG_DATA);
		}
		
		/** This method is called automatically when the data must be validated. */
		protected function validateData():void {}
		///////////////////////////////////////////////////////////////////////
		//}
		
		//{ Events Handling
		///////////////////////////////////////////////////////////////////////
		/**
		 * Add a listener for the <code>EVENT_MOVE</code> event.
		 * @param  listener  The listener to add.
		 */
		public final function addMoveListener(listener:Function):void {
			this.addEventListener(EVENT_MOVE, listener);
		}
		/**
		 * Remove a listener for the <code>EVENT_MOVE</code> event.
		 * @param  listener  The listener to remove.
		 */
		public final function removeMoveListener(listener:Function):void {
			this.removeEventListener(EVENT_MOVE, listener);
		}
		
		private function dispatchMoveEvent():void {
			if (willTrigger(EVENT_MOVE))
				this.dispatchEvent(new Event(EVENT_MOVE));
		}
		
		/**
		 * Add a listener for the <code>Event.RESIZE</code> event.
		 * @param  listener  The listener to add.
		 */
		public final function addResizeListener(listener:Function):void {
			this.addEventListener(Event.RESIZE, listener);
		}
		/**
		 * Remove a listener for the <code>Event.RESIZE</code> event.
		 * @param  listener  The listener to remove.
		 */
		public final function removeResizeListener(listener:Function):void {
			this.removeEventListener(Event.RESIZE, listener);
		}
		
		private function dispatchResizeEvent():void {
			if (willTrigger(Event.RESIZE))
				this.dispatchEvent(new Event(Event.RESIZE));
		}
		
		/**
		 * Add a listener for the <code>Event.CHANGE</code> event.
		 * @param  listener  The listener to add.
		 */
		public final function addChangeListener(listener:Function):void {
			this.addEventListener(Event.CHANGE, listener);
		}
		/**
		 * Remove a listener for the <code>Event.CHANGE</code> event.
		 * @param  listener  The listener to remove.
		 */
		public final function removeChangeListener(listener:Function):void {
			this.removeEventListener(Event.CHANGE, listener);
		}
		
		/** Dispatch an <code>Event.CHANGE</code> event. */
		protected final function dispatchChangeEvent():void {
			if (willTrigger(Event.CHANGE))
				dispatchEvent(new Event(Event.CHANGE));
		}
		
		/**
		 * Add a listener for the <code>EVENT_DATA_CHANGE</code> event.
		 * @param  listener  The listener to add.
		 */
		public final function addDataChangeListener(listener:Function):void {
			this.addEventListener(EVENT_DATA_CHANGE, listener);
		}
		/**
		 * Remove a listener for the <code>EVENT_DATA_CHANGE</code> event.
		 * @param  listener  The listener to remove.
		 */
		public final function removeDataChangeListener(listener:Function):void {
			this.removeEventListener(EVENT_DATA_CHANGE, listener);
		}
		
		/**
		 * Add a listener for the <code>Event.ENTER_FRAME</code> event.
		 * @param  listener  The listener to add.
		 */
		public final function addEnterFrameListener(listener:Function):void {
			this.addEventListener(Event.ENTER_FRAME, listener);
		}
		/**
		 * Remove a listener for the <code>Event.ENTER_FRAME</code> event.
		 * @param  listener  The listener to remove.
		 */
		public final function removeEnterFrameListener(listener:Function):void {
			this.removeEventListener(Event.ENTER_FRAME, listener);
		}
		
		/**
		 * Add a listener for when the view is clicked.
		 * @param  listener  The listener to add.
		 */
		public final function addClickListener(listener:Function):void {
			this.addEventListener(MouseEvent.CLICK, listener);
			this.addEventListener(TouchEvent.TOUCH_TAP, listener);
		}
		/**
		 * Remove a listener for when the view is clicked.
		 * @param  listener  The listener to remove.
		 */
		public final function removeClickListener(listener:Function):void {
			this.removeEventListener(MouseEvent.CLICK, listener);
			this.removeEventListener(TouchEvent.TOUCH_TAP, listener);
		}
		
		/**
		 * Add a listener for the <code>MouseEvent.MOUSE_OVER</code> event.
		 * @param  listener  The listener to add.
		 */
		public final function addMouseOverListener(listener:Function):void {
			this.addEventListener(MouseEvent.MOUSE_OVER, listener);
		}
		/**
		 * Remove a listener for the <code>MouseEvent.MOUSE_OVER</code> event.
		 * @param  listener  The listener to remove.
		 */
		public final function removeMouseOverListener(listener:Function):void {
			this.removeEventListener(MouseEvent.MOUSE_OVER, listener);
		}
		
		/**
		 * Add a listener for the <code>MouseEvent.MOUSE_OUT</code> event.
		 * @param  listener  The listener to add.
		 */
		public final function addMouseOutListener(listener:Function):void {
			this.addEventListener(MouseEvent.MOUSE_OUT, listener);
		}
		/**
		 * Remove a listener for the <code>MouseEvent.MOUSE_OUT</code> event.
		 * @param  listener  The listener to remove.
		 */
		public final function removeMouseOutListener(listener:Function):void {
			this.removeEventListener(MouseEvent.MOUSE_OUT, listener);
		}
		
		/**
		 * Add a listener for the <code>MouseEvent.MOUSE_DOWN</code> event.
		 * @param  listener  The listener to add.
		 */
		public final function addMouseDownListener(listener:Function):void {
			this.addEventListener(MouseEvent.MOUSE_DOWN, listener);
		}
		/**
		 * Remove a listener for the <code>MouseEvent.MOUSE_DOWN</code> event.
		 * @param  listener  The listener to remove.
		 */
		public final function removeMouseDownListener(listener:Function):void {
			this.removeEventListener(MouseEvent.MOUSE_DOWN, listener);
		}
		
		/**
		 * Add a listener for the <code>MouseEvent.MOUSE_UP</code> event.
		 * @param  listener  The listener to add.
		 */
		public final function addMouseUpListener(listener:Function):void {
			this.addEventListener(MouseEvent.MOUSE_UP, listener);
		}
		/**
		 * Remove a listener for the <code>MouseEvent.MOUSE_UP</code> event.
		 * @param  listener  The listener to remove.
		 */
		public final function removeMouseUpListener(listener:Function):void {
			this.removeEventListener(MouseEvent.MOUSE_UP, listener);
		}
		
		/**
		 * Add a listener for the <code>MouseEvent.RELEASE_OUTSIDE</code> event.
		 * @param  listener  The listener to add.
		 */
		public final function addMouseReleaseOutsideListener(listener:Function):void {
			this.addEventListener(MouseEvent.RELEASE_OUTSIDE, listener);
		}
		/**
		 * Remove a listener for the <code>MouseEvent.RELEASE_OUTSIDE</code> event.
		 * @param  listener  The listener to remove.
		 */
		public final function removeMouseReleaseOutsideListener(listener:Function):void {
			this.removeEventListener(MouseEvent.RELEASE_OUTSIDE, listener);
		}
		
		/**
		 * Add a listener for the <code>MouseEvent.MOUSE_WHEEL</code> event.
		 * @param  listener  The listener to add.
		 */
		public final function addMouseWheelListener(listener:Function):void {
			this.addEventListener(MouseEvent.MOUSE_WHEEL, listener);
		}
		/**
		 * Remove a listener for the <code>MouseEvent.MOUSE_WHEEL</code> event.
		 * @param  listener  The listener to remove.
		 */
		public final function removeMouseWheelListener(listener:Function):void {
			this.removeEventListener(MouseEvent.MOUSE_WHEEL, listener);
		}
		
		/**
		 * Add a listener for the <code>TouchEvent.TOUCH_BEGIN</code> event.
		 * @param  listener  The listener to add.
		 */
		public final function addTouchBeginListener(listener:Function):void {
			this.addEventListener(TouchEvent.TOUCH_BEGIN, listener);
		}
		/**
		 * Remove a listener for the <code>TouchEvent.TOUCH_BEGIN</code> event.
		 * @param  listener  The listener to remove.
		 */
		public final function removeTouchBeginListener(listener:Function):void {
			this.removeEventListener(TouchEvent.TOUCH_BEGIN, listener);
		}
		
		/**
		 * Add a listener for the <code>TouchEvent.TOUCH_END</code> event.
		 * @param  listener  The listener to add.
		 */
		public final function addTouchEndListener(listener:Function):void {
			this.addEventListener(TouchEvent.TOUCH_END, listener);
		}
		/**
		 * Remove a listener for the <code>TouchEvent.TOUCH_END</code> event.
		 * @param  listener  The listener to remove.
		 */
		public final function removeTouchEndListener(listener:Function):void {
			this.removeEventListener(TouchEvent.TOUCH_END, listener);
		}
		
		/**
		 * Add a listener for the when the view is pressed.
		 * @param  listener  The listener to add.
		 */
		public final function addDownListener(listener:Function):void {
			addMouseDownListener(listener);
			addTouchBeginListener(listener);
		}
		/**
		 * Remove a listener for the when the view is pressed.
		 * @param  listener  The listener to remove.
		 */
		public final function removeDownListener(listener:Function):void {
			removeMouseDownListener(listener);
			removeTouchBeginListener(listener);
		}
		
		/**
		 * Add a listener for the when the view is released.
		 * @param  listener  The listener to add.
		 */
		public final function addUpListener(listener:Function):void {
			addMouseUpListener(listener);
			addMouseReleaseOutsideListener(listener);
			addTouchEndListener(listener);
		}
		/**
		 * Remove a listener for the when the view is released.
		 * @param  listener  The listener to remove.
		 */
		public final function removeUpListener(listener:Function):void {
			removeMouseUpListener(listener);
			removeMouseReleaseOutsideListener(listener);
			removeTouchEndListener(listener);
		}
		///////////////////////////////////////////////////////////////////////
		//}
		
	}
}