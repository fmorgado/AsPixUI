package pixui.views {
	//{ Imports
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import pixlib.motion.EnterFrameAnimator;
	import pixlib.motion.IAnimatable;
	import pixlib.motion.easing.quarticOut;
	import pixlib.utils.resolvers.resolveInstanceOf;
	
	import pixui.utils.layout.alignX;
	import pixui.utils.layout.alignY;
	//}
	
	public class Scroller extends View implements IAnimatable {
		//{ Static Stuff
		///////////////////////////////////////////////////////////////////////
		public static const FLAG_SCROLL:uint = 0x4000;
		
		public static const ANIMATION_START:String = 'animationStart';
		public static const ANIMATION_STOP:String = 'animationStop';
		public static const DRAG_START:String = 'dragStart';
		public static const DRAG_STOP:String = 'dragStop';
		
		public static const SCROLL_POLICY_AUTO:String = 'auto';
		public static const SCROLL_POLICY_OFF:String = 'off';
		public static const SCROLL_POLICY_ON:String = 'on';
		
		private static const MINIMUM_SPEED:Number = 0.2;
		private static const FRICTION:Number = 0.998;
		///////////////////////////////////////////////////////////////////////
		//}
		
		//{ Initialization & Members
		///////////////////////////////////////////////////////////////////////
		private var _shape:Shape;
		private var _rect:Rectangle = new Rectangle();
		
		override protected function initialize():void {
			super.initialize();
			
			addChild(_shape = new Shape());
			_shape.graphics.beginFill(0, 0);
			_shape.graphics.drawRect(0, 0, 10, 10);
			_shape.graphics.endFill();
			
			addMouseDownListener(_onTouchBegin);
			addTouchBeginListener(_onTouchBegin);
			addMouseUpListener(_onTouchEnd);
			addMouseReleaseOutsideListener(_onTouchEnd);
			addMouseWheelListener(_onMouseWheel);
		}
		
		override protected function onRemovedFromStage():void {
			super.onRemovedFromStage();
			_clearAnimation();
			_clearTouch();
		}
		
		private var _content:DisplayObject;
		private var _contentWidth:Number = 0;
		private var _contentHeight:Number = 0;
		/** The content container. */
		public final function get content():DisplayObject { return _content; }
		public final function set content(value:DisplayObject):void {
			if (_content != null) {
				_content.scrollRect = null;
				removeChild(_content);
				if (_contentMask != null) {
					_content.mask = null;
					removeChild(_contentMask);
				}
				_content = null;
			}
			
			if (value != null) {
				_content = value;
				addChildAt(value, background != null ? 1 : 0);
				_contentWidth = _content.width;
				_contentHeight = _content.height;
				
				if (_contentMask != null) {
					addChild(_contentMask);
					_content.mask = _contentMask;
					_content.cacheAsBitmap = true;
					_contentMask.cacheAsBitmap = true;
				}
			} else {
				_contentWidth = 0;
				_contentHeight = 0;
			}
			
			invalidateLayout();
		}
		
		private var _contentMask:DisplayObject;
		public function get contentMask():Object { return _contentMask; }
		public function set contentMask(value:Object):void {
			if (_contentMask != null) {
				if (_contentMask.parent != null) {
					_content.mask = null;
					removeChild(_contentMask);
				}
				_contentMask = null;
			}
			
			_contentMask = resolveInstanceOf(value, DisplayObject) as DisplayObject;
			if (_contentMask != null) {
				if (_content != null) {
					addChild(_contentMask);
					_content.mask = _contentMask;
					_content.cacheAsBitmap = true;
					_contentMask.cacheAsBitmap = true;
				}
				invalidateLayout();
			}
		}
		
		public var dragBeginOffset:Number = 20; 
		public var elasticity:Number = 100;
		public var elasticityDrag:Number = 400;
		
		private var _leftShadow:DisplayObject;
		public function get leftShadow():Object { return _leftShadow; }
		public function set leftShadow(value:Object):void {
			if (_leftShadow != null) {
				removeChild(_leftShadow);
				_leftShadow = null;
			}
			
			_leftShadow = resolveInstanceOf(value, DisplayObject) as DisplayObject;
			if (_leftShadow != null) {
				addChild(_leftShadow);
				invalidateLayout();
			}
		}
		
		private var _rightShadow:DisplayObject;
		public function get rightShadow():Object { return _rightShadow; }
		public function set rightShadow(value:Object):void {
			if (_rightShadow != null) {
				removeChild(_rightShadow);
				_rightShadow = null;
			}
			
			_rightShadow = resolveInstanceOf(value, DisplayObject) as DisplayObject;
			if (_rightShadow != null) {
				addChild(_rightShadow);
				invalidateLayout();
			}
		}
		
		private var _topShadow:DisplayObject;
		public function get topShadow():Object { return _topShadow; }
		public function set topShadow(value:Object):void {
			if (_topShadow != null) {
				removeChild(_topShadow);
				_topShadow = null;
			}
			
			_topShadow = resolveInstanceOf(value, DisplayObject) as DisplayObject;
			if (_topShadow != null) {
				addChild(_topShadow);
				invalidateLayout();
			}
		}
		
		private var _bottomShadow:DisplayObject;
		public function get bottomShadow():Object { return _bottomShadow; }
		public function set bottomShadow(value:Object):void {
			if (_bottomShadow != null) {
				removeChild(_bottomShadow);
				_bottomShadow = null;
			}
			
			_bottomShadow = resolveInstanceOf(value, DisplayObject) as DisplayObject;
			if (_bottomShadow != null) {
				addChild(_bottomShadow);
				invalidateLayout();
			}
		}
		
		public var shadowDistance:Number = 30;
		public var mouseWheelOffset:Number = 30;
		public var contentAlignH:Number = 0;
		public var contentAlignV:Number = 0;
		
		public function showHorizontalBounds(x:Number, width:Number):void {
			var currentX:Number = horizontalScrollPosition;
			if (currentX > x) {
				_animateScrollX(x);
			} else if (currentX + availableWidth < x + width) {
				_animateScrollX(x + width - availableWidth);
			}
		}
		
		public function showVerticalBounds(y:Number, height:Number):void {
			var currentY:Number = verticalScrollPosition;
			if (currentY > x) {
				_animateScrollY(y);
			} else if (currentY + availableHeight < y + height) {
				_animateScrollY(y + height - availableHeight);
			}
		}
		
		public function showBounds(x:Number, y:Number, width:Number, height:Number):void {
			showHorizontalBounds(x, width);
			showVerticalBounds(y, height);
		}
		
		private var _horizontalScrollPolicy:String = SCROLL_POLICY_AUTO;
		public function get horizontalScrollPolicy():String { return _horizontalScrollPolicy; }
		public function set horizontalScrollPolicy(value:String):void {
			_horizontalScrollPolicy = value;
			invalidateScroll();
		}
		
		private var _verticalScrollPolicy:String = SCROLL_POLICY_AUTO;
		public function get verticalScrollPolicy():String { return _verticalScrollPolicy; }
		public function set verticalScrollPolicy(value:String):void {
			_verticalScrollPolicy = value;
			invalidateScroll();
		}
		///////////////////////////////////////////////////////////////////////
		//}
		
		//{ Animation Handling
		///////////////////////////////////////////////////////////////////////
		public var animationMilliseconds:Number = 500;
		
		private var _isAnimating:Boolean = false;
		/** Indicates if the viewport is moving. */
		public final function get isAnimating():Boolean { return _isAnimating; }
		
		private function _setAnimating():void {
			if (! _isAnimating) {
				_isAnimating = true;
				EnterFrameAnimator.instance.add(this);
				dispatchEvent(new Event(ANIMATION_START));
			}
		}
		
		private var _animStartX:Number;
		private var _animEndX:Number;
		private var _animTimeX:Number;
		
		private var _animStartY:Number;
		private var _animEndY:Number;
		private var _animTimeY:Number;
		
		private function _clearAnimation():void {
			if (_isAnimating) {
				_isAnimating = false;
				EnterFrameAnimator.instance.remove(this);
				dispatchEvent(new Event(ANIMATION_STOP));
			}
		}
		
		private function _animateScrollX(x:Number):void {
			_setAnimating();
			
			if (! isNaN(x)) {
				if (x < 0) {
					x = 0;
				} else if (x >= _maxHorizontalScrollPosition) {
					x = _maxHorizontalScrollPosition;
				} else if (! isNaN(horizontalScrollStep)) {
					x = Math.round(x / horizontalScrollStep) * horizontalScrollStep;
				}
				
				_animStartX = _rect.x;
				_animEndX = x;
				_animTimeX = 0;
			}
		}
		
		private function _animateScrollY(y:Number):void {
			_setAnimating();
			
			if (! isNaN(y)) {
				if (y < 0) {
					y = 0;
				} else if (y >= _maxVerticalScrollPosition) {
					y = _maxVerticalScrollPosition;
				} else if (! isNaN(verticalScrollStep)) {
					y = Math.round(y / verticalScrollStep) * verticalScrollStep;
				}
				
				_animStartY = _rect.y;
				_animEndY = y;
				_animTimeY = 0;
			}
		}
		
		/** Advances the animation by the given amount of milliseconds. */
		public function advanceTime(milliseconds:Number):void {
			if (! isNaN(_animEndX)) {
				_animTimeX += milliseconds;
				if (_animTimeX > animationMilliseconds)
					_animTimeX = animationMilliseconds;
				_setHorizontalScrollPosition(quarticOut(_animTimeX / animationMilliseconds) * (_animEndX - _animStartX) + _animStartX);
				
				if (_animTimeX >= animationMilliseconds)
					_animEndX = NaN;
			}
			
			if (! isNaN(_animEndY)) {
				_animTimeY += milliseconds;
				if (_animTimeY > animationMilliseconds)
					_animTimeY = animationMilliseconds;
				_setVerticalScrollPosition(quarticOut(_animTimeY / animationMilliseconds) * (_animEndY - _animStartY) + _animStartY);
				
				if (_animTimeY >= animationMilliseconds)
					_animEndY = NaN;
			}
			
			if (isNaN(_animEndX) && isNaN(_animEndY))
				_clearAnimation();
		}
		///////////////////////////////////////////////////////////////////////
		//}
		
		//{ Touch Handling
		///////////////////////////////////////////////////////////////////////
		private var _isDragging:Boolean = false;
		/** Indicates if the user is dragging the viewport. */
		public final function get isDragging():Boolean { return _isDragging; }
		
		private var _lastMouseX:Number;
		private var _deltaListX:Vector.<int> = new <int>[0, 0, 0, 0];
		private var _deltaListXIndex:uint = 0;
		private var _lastMouseY:Number;
		private var _deltaListY:Vector.<int> = new <int>[0, 0, 0, 0];
		private var _deltaListYIndex:uint = 0;
		
		private function _getSpeedAverage(list:Vector.<int>):Number {
			return (list[0] + list[1] + list[2] + list[3]) / 4;
		}
		
		private function _addSpeed(index:uint, list:Vector.<int>, speed:int):uint {
			list[index++] = speed;
			return index >= list.length ? 0 : index;
		}
		
		private var _touchStartX:Number;
		private var _touchStartY:Number;
		private var _touchStartScrollX:Number;
		private var _touchStartScrollY:Number;
		
		private function _onMouseWheel(event:MouseEvent):void {
			var offset:Number;
			if (_isDragging) return;
			if (_maxVerticalScrollPosition > 0) {
				offset = event.delta * (isNaN(verticalScrollStep) ? mouseWheelOffset : verticalScrollStep);
				_animateScrollY(verticalScrollPosition - offset);
			} else if (_maxHorizontalScrollPosition > 0) {
				offset = event.delta * (isNaN(horizontalScrollStep) ? mouseWheelOffset : horizontalScrollStep);
				_animateScrollX(horizontalScrollPosition - offset);
			}
		}
		
		private function _clearTouch():void {
			if (_isDragging) {
				_isDragging = false;
				mouseChildren = true;
				removeEnterFrameListener(_onDraggingFrame);
				dispatchEvent(new Event(DRAG_STOP));
			}
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, _onTouchMove);
		}
		
		private function _onTouchBegin(event:Event):void {
			if (stage == null) return;
			
			_clearAnimation();
			
			_lastMouseX = mouseX;
			_lastMouseY = mouseY;
			
			_deltaListX[0] = _deltaListX[1] = _deltaListX[2] = _deltaListX[3] = 0;
			_deltaListY[0] = _deltaListY[1] = _deltaListY[2] = _deltaListY[3] = 0;
			
			_touchStartX = mouseX;
			_touchStartY = mouseY;
			_touchStartScrollX = _rect.x;
			_touchStartScrollY = _rect.y;
			
			stage.addEventListener(MouseEvent.MOUSE_MOVE, _onTouchMove);
		}
		
		public var speedFriction:Number = 0.80;
		public var speedLimit:Number = 0.05;
		
		private function _getSpeedDistance(speed:Number):Number {
			var sp:Number = speed >= 0 ? speed : -speed;
			var result:Number = 0;
			
			while (sp > speedLimit) {
				result += sp;
				sp *= speedFriction;
			}
			
			return speed < 0 ? - result : result;
		}
		
		private function _onTouchEnd(event:Event):void {
			if (stage == null) return;
			_clearTouch();
			
			_animateScrollX(
				_maxHorizontalScrollPosition > 0
					? _rect.x - _getSpeedDistance(_getSpeedAverage(_deltaListX))
					: NaN);
			_animateScrollY(
				_maxVerticalScrollPosition > 0
					? _rect.y - _getSpeedDistance(_getSpeedAverage(_deltaListY))
					: NaN);
		}
		
		private function _onDraggingFrame(event:Event):void {
			if (_maxHorizontalScrollPosition > 0) {
				_deltaListXIndex = _addSpeed(_deltaListXIndex, _deltaListX, mouseX - _lastMouseX);
			}
			if (_maxVerticalScrollPosition > 0) {
				_deltaListYIndex = _addSpeed(_deltaListYIndex, _deltaListY, mouseY - _lastMouseY);
			}
			
			_lastMouseX = mouseX;
			_lastMouseY = mouseY;
		}
		
		private function _onTouchMove(event:Event):void {
			if (mouseChildren) {
				if ((_contentWidth <= availableWidth || Math.abs(mouseX - _touchStartX) < dragBeginOffset) &&
						(_contentHeight <= availableHeight || Math.abs(mouseY - _touchStartY) < dragBeginOffset))
					return;
				mouseChildren = false;
				_isDragging = true;
				addEnterFrameListener(_onDraggingFrame);
				dispatchEvent(new Event(DRAG_START));
			}
			
			if (_contentWidth > availableWidth) {
				var scrollX:Number = _touchStartScrollX + _touchStartX - mouseX;
				if (scrollX < 0) {
					scrollX = -scrollX;
					if (scrollX > elasticityDrag)
						scrollX = elasticityDrag;
					scrollX = - quarticOut(scrollX / elasticityDrag) * elasticity;
				} else if (scrollX > _maxHorizontalScrollPosition) {
					scrollX = scrollX - _maxHorizontalScrollPosition;
					if (scrollX > elasticityDrag)
						scrollX = elasticityDrag;
					scrollX = quarticOut(scrollX / elasticityDrag) * elasticity + _maxHorizontalScrollPosition;
				}
				_setHorizontalScrollPosition(scrollX);
			}
			
			if (_contentHeight > availableHeight) {
				var scrollY:Number = _touchStartScrollY + _touchStartY - mouseY;
				if (scrollY < 0) {
					scrollY = -scrollY;
					if (scrollY > elasticityDrag)
						scrollY = elasticityDrag;
					scrollY = - quarticOut(scrollY / elasticityDrag) * elasticity;
				} else if (scrollY > _maxVerticalScrollPosition) {
					scrollY = scrollY - _maxVerticalScrollPosition;
					if (scrollY > elasticityDrag)
						scrollY = elasticityDrag;
					scrollY = quarticOut(scrollY / elasticityDrag) * elasticity + _maxVerticalScrollPosition;
				}
				_setVerticalScrollPosition(scrollY);
			}
		}
		///////////////////////////////////////////////////////////////////////
		//}
		
		//{ Invalidations Handling
		///////////////////////////////////////////////////////////////////////
		override protected function validateLayout():void {
			_shape.x = _left;
			_shape.y = _top;
			_shape.width = availableWidth;
			_shape.height = availableHeight;
			
			_rect.width = availableWidth;
			_rect.height = availableHeight;
			
			if (_contentWidth <= _rect.width) {
				_maxHorizontalScrollPosition = 0;
			} else {
				_maxHorizontalScrollPosition = _contentWidth - _rect.width;
			}
			if (_contentHeight <= _rect.height) {
				_maxVerticalScrollPosition = 0;
			} else {
				_maxVerticalScrollPosition = _contentHeight - _rect.height;
			}
			
			if (_content != null) {
				if (_maxHorizontalScrollPosition > 0)
					_content.x = _left;
				else
					alignX(_content, availableWidth, contentAlignH, _left);
				if (_maxVerticalScrollPosition > 0)
					_content.y = _top;
				else
					alignY(_content, availableHeight, contentAlignV, _top);
			}
			if (_contentMask != null) {
				_contentMask.x = _left;
				_contentMask.y = _top;
				_contentMask.width = availableWidth;
				_contentMask.height = availableHeight;
			}
			
			if (_leftShadow != null) {
				_leftShadow.x = _left;
				_leftShadow.y = _top;
				_leftShadow.height = availableHeight;
			}
			if (_rightShadow != null) {
				_rightShadow.x = _width - _right - _rightShadow.width;
				_rightShadow.y = _top;
				_rightShadow.height = availableHeight;
			}
			if (_topShadow != null) {
				_topShadow.x = _left;
				_topShadow.y = _top;
				_topShadow.width = availableWidth;
			}
			if (_bottomShadow != null) {
				_bottomShadow.x = _left;
				_bottomShadow.y = _height - _bottom - _bottomShadow.height;
				_bottomShadow.width = availableWidth;
			}
			
			invalidateScroll();
		}
		
		public final function invalidateScroll():void {
			invalidate(FLAG_SCROLL);
		}
		
		override protected function validateAfter():void {
			super.validateAfter();
			if (isInvalid(FLAG_SCROLL))
				validateScroll();
		}
		
		protected function validateScroll():void {
			if (_content != null)
				_content.scrollRect = _rect;
			
			if (_leftShadow != null) {
				if (_rect.x <= 0) {
					_leftShadow.alpha = 0;
				} else if (_rect.x >= shadowDistance) {
					_leftShadow.alpha = 1;
				} else {
					_leftShadow.alpha = _rect.x / shadowDistance;
				}
			}
			if (_rightShadow != null) {
				if (_rect.x >= _maxHorizontalScrollPosition) {
					_rightShadow.alpha = 0;
				} else if (_rect.x <= _maxHorizontalScrollPosition - shadowDistance) {
					_rightShadow.alpha = 1;
				} else {
					_rightShadow.alpha = (_maxHorizontalScrollPosition - _rect.x) / shadowDistance;
				}
			}
			if (_topShadow != null) {
				if (_rect.y <= 0) {
					_topShadow.alpha = 0;
				} else if (_rect.y >= shadowDistance) {
					_topShadow.alpha = 1;
				} else {
					_topShadow.alpha = _rect.y / shadowDistance;
				}
			}
			if (_bottomShadow != null) {
				if (_rect.y >= _maxVerticalScrollPosition) {
					_bottomShadow.alpha = 0;
				} else if (_rect.y <= _maxVerticalScrollPosition - shadowDistance) {
					_bottomShadow.alpha = 1;
				} else {
					_bottomShadow.alpha = (_maxVerticalScrollPosition - _rect.y) / shadowDistance;
				}
			}
			
			dispatchChangeEvent();
		}
		///////////////////////////////////////////////////////////////////////
		//}
		
		//{ Misc Scrolling Properties
		///////////////////////////////////////////////////////////////////////
		public var horizontalScrollStep:Number = NaN;
		public var verticalScrollStep:Number = NaN;
		
		/** Indicates if the scroller is currently scrolling with user interaction or animation. */
		public final function get isScrolling():Boolean { return _isDragging || _isAnimating; }
		///////////////////////////////////////////////////////////////////////
		//}
		
		//{ Core Scroll Properties
		///////////////////////////////////////////////////////////////////////
		private function _setHorizontalScrollPosition(value:Number):void {
			_rect.x = value;
			invalidateScroll();
		}
		
		private function _setVerticalScrollPosition(value:Number):void {
			_rect.y = value;
			invalidateScroll();
		}
		
		/** The current horizontal scroll position. */
		public function get horizontalScrollPosition():Number {
			return isNaN(_animEndX) ? _rect.x : _animEndX;
		}
		public function set horizontalScrollPosition(value:Number):void {
			if (value < 0)
				value = 0;
			else if (value > _maxHorizontalScrollPosition)
				value = _maxHorizontalScrollPosition;
			_animateScrollX(value);
		}
		
		/** The current vertical scroll position. */
		public function get verticalScrollPosition():Number {
			return isNaN(_animEndY) ? _rect.y : _animEndY;
		}
		public function set verticalScrollPosition(value:Number):void {
			if (value < 0)
				value = 0;
			else if (value > _maxVerticalScrollPosition)
				value = _maxVerticalScrollPosition;
			_animateScrollY(value);
		}
		
		private var _maxHorizontalScrollPosition:Number = 0;
		/** The maximum horizontal scroll position. */
		public final function get maxHorizontalScrollPosition():Number { return _maxHorizontalScrollPosition; }
		
		private var _maxVerticalScrollPosition:Number = 0;
		/** The maximum vertical scroll position. */
		public final function get maxVerticalScrollPosition():Number { return _maxVerticalScrollPosition; }
		///////////////////////////////////////////////////////////////////////
		//}
		
		//{ Events Handling
		///////////////////////////////////////////////////////////////////////
		/** Add a listener for the <code>DRAG_START</code> event. */
		public final function addDragStartListener(listener:Function):void {
			addEventListener(DRAG_START, listener);
		}
		/** Remove a listener for the <code>DRAG_START</code> event. */
		public final function removeDragStartListener(listener:Function):void {
			removeEventListener(DRAG_START, listener);
		}
		
		/** Add a listener for the <code>DRAG_STOP</code> event. */
		public final function addDragStopListener(listener:Function):void {
			addEventListener(DRAG_STOP, listener);
		}
		/** Remove a listener for the <code>DRAG_STOP</code> event. */
		public final function removeDragStopListener(listener:Function):void {
			removeEventListener(DRAG_STOP, listener);
		}
		
		/** Add a listener for the <code>ANIMATION_START</code> event. */
		public final function addAnimationStartListener(listener:Function):void {
			addEventListener(ANIMATION_START, listener);
		}
		/** Remove a listener for the <code>ANIMATION_START</code> event. */
		public final function removeAnimationStartListener(listener:Function):void {
			removeEventListener(ANIMATION_START, listener);
		}
		
		/** Add a listener for the <code>ANIMATION_STOP</code> event. */
		public final function addAnimationStopListener(listener:Function):void {
			addEventListener(ANIMATION_STOP, listener);
		}
		/** Remove a listener for the <code>ANIMATION_STOP</code> event. */
		public final function removeAnimationStopListener(listener:Function):void {
			removeEventListener(ANIMATION_STOP, listener);
		}
		///////////////////////////////////////////////////////////////////////
		//}
		
	}
}