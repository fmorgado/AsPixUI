package pixui.views {
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	public class ButtonBase extends View {
		
		// TODO touchDelay
		
		//{ Static constants
		///////////////////////////////////////////////////////////////////////
		/** The type dispatched when the button is triggered. */
		public static const TRIGGERED:String = 'triggered';
		/** The type dispatched when the button's <code>selected</code> property changes. */
		public static const SELECTED_CHANGE:String = 'selectedChange';
		
		/** The default state. */
		public static const STATE_DEFAULT:String  = 'default';
		/** The state when the mouse is over. */
		public static const STATE_OVER:String     = 'over';
		/** The state when the mouse button is down. */
		public static const STATE_DOWN:String     = 'down';
		///////////////////////////////////////////////////////////////////////
		//}
		
		//{ Initialization
		///////////////////////////////////////////////////////////////////////
		override protected function initialize():void {
			super.initialize();
			this.cacheAsBitmap = true;
			this.mouseChildren = false;
			this.tabChildren = false;
			
			addClickListener(_handleTrigger);
			addMouseDownListener(_setStateDown);
			addMouseOutListener(_setStateDefault);
			addMouseUpListener(_setStateOver);
			addMouseOverListener(_setStateOver);
			addTouchBeginListener(_setStateDown);
			addTouchEndListener(_setStateDefault);
		}
		
		override protected function onAddedToStage():void {
			super.onAddedToStage();
			setState(STATE_DEFAULT);
		}
		
		override protected function onRemovedFromStage():void {
			super.onRemovedFromStage();
			_clearAutoRepeatTimer();
		}
		
		protected function onTriggered():void {
			if (willTrigger(TRIGGERED))
				dispatchEvent(new Event(TRIGGERED));
			if (_selectable)
				selected = ! _selected;
		}
		///////////////////////////////////////////////////////////////////////
		//}
		
		//{ Properties
		///////////////////////////////////////////////////////////////////////
		private var _selectable:Boolean = false;
		/** Indicates if the button may be selected. */
		public final function get selectable():Boolean { return _selectable; }
		public final function set selectable(value:Boolean):void {
			if (value == _selectable) return;
			_selectable = value;
			if (! value && _selected != false)
				selected = false;
		}
		
		private var _selected:Object = false;
		/**
		 * Indicates if the button is selected.
		 * This property may only be true if <code>selectable</code> is true.
		 * If <code>threeStates</code> is true, 
		 */
		public final function get selected():Object { return _selected; }
		public final function set selected(value:Object):void {
			 if (value == _selected) return;
			 if (value != false) {
				 if (! _selectable)
					 throw new ArgumentError(this + ' is not selectable!');
				 if (value == null && ! _threeStates)
					 throw new ArgumentError(this + ' does not support three states!');
				 else if (! (value is Boolean))
					 throw new ArgumentError('Invalid "selected" value:  ' + value);
			 }
			 _selected = value;
			 if (willTrigger(SELECTED_CHANGE))
				 dispatchEvent(new Event(SELECTED_CHANGE));
			 invalidateState();
		}
		
		protected var _threeStates:Boolean = false;
		/** Indicates if the <code>selected</code> value supports a third state (null). */
		public final function get threeStates():Boolean { return _threeStates; }
		public final function set threeStates(value:Boolean):void {
			if (value == _threeStates) return;
			_threeStates = value;
			if (! value && _selected == null)
				selected = false;
		}
		
		protected var _state:String;
		/**
		 * Get or set the state of the button.
		 * @see <code>STATE_*</code> constants.
		 */
		public final function get state():String { return _state; }
		private final function setState(value:String):void {
			if (value == _state) return;
			_state = value;
			invalidateState();
		}
		
		/**
		 * Indicates if the <code>TRIGGERED</code> event must keep firing as
		 * the button stays down.
		 * @see autoRepeatDelay
		 * @see autoRepeatInterval
		 */
		public final function get autoRepeat():Boolean {
			return _autoRepeatTimer != null;
		}
		public final function set autoRepeat(value:Boolean):void {
			if (value == autoRepeat) return;
			if (value) {
				_autoRepeatTimer = new Timer(_autoRepeatDelay, 0);
			} else {
				_clearAutoRepeatTimer();
				_autoRepeatTimer = null;
			}
		}
		
		private var _autoRepeatDelay:Number = 200;
		public final function get autoRepeatDelay():Number { return _autoRepeatDelay; }
		public final function set autoRepeatDelay(value:Number):void { _autoRepeatDelay = value; }
		
		private var _autoRepeatInterval:Number = 20;
		public final function get autoRepeatInterval():Number { return _autoRepeatInterval; }
		public final function set autoRepeatInterval(value:Number):void { _autoRepeatInterval = value; }
		///////////////////////////////////////////////////////////////////////
		//}
		
		//{ AutoRepeat Timer Handling
		///////////////////////////////////////////////////////////////////////
		private var _autoRepeatTimer:Timer;
		
		private function _clearAutoRepeatTimer():void {
			if (_autoRepeatTimer != null && _autoRepeatTimer.running) {
				_autoRepeatTimer.reset();
				_autoRepeatTimer.removeEventListener(TimerEvent.TIMER, _onAutoRepeatDelay);
				_autoRepeatTimer.removeEventListener(TimerEvent.TIMER, _onAutoRepeatInterval);
			}
		}
		
		private function _startAutoRepeatTimer():void {
			_clearAutoRepeatTimer();
			_autoRepeatTimer.delay = _autoRepeatDelay;
			_autoRepeatTimer.addEventListener(TimerEvent.TIMER, _onAutoRepeatDelay);
			_autoRepeatTimer.start();
			onTriggered();
		}
		
		private function _onAutoRepeatDelay(event:TimerEvent):void {
			_autoRepeatTimer.removeEventListener(TimerEvent.TIMER, _onAutoRepeatDelay);
			_autoRepeatTimer.addEventListener(TimerEvent.TIMER, _onAutoRepeatInterval);
			_autoRepeatTimer.delay = _autoRepeatInterval;
			onTriggered();
		}
		
		private function _onAutoRepeatInterval(event:TimerEvent):void {
			onTriggered();
		}
		///////////////////////////////////////////////////////////////////////
		//}
		
		//{ Mouse/Touch Events
		///////////////////////////////////////////////////////////////////////
		override protected function enabledChange():void {
			super.enabledChange();
			_setStateDefault(null);
			this.mouseEnabled = _enabled;
		}
		
		private function _setStateDefault(_):void {
			setState(STATE_DEFAULT);
			if (autoRepeat)
				_clearAutoRepeatTimer();
		}
		
		private function _setStateOver(_):void {
			setState(STATE_OVER);
			if (autoRepeat)
				_clearAutoRepeatTimer();
		}
		
		private function _setStateDown(_):void {
			setState(STATE_DOWN);
			if (autoRepeat)
				_startAutoRepeatTimer();
		}
		
		private function _handleTrigger(_):void {
			if (! autoRepeat) onTriggered();
		}
		///////////////////////////////////////////////////////////////////////
		//}
		
		//{ Events Handling
		///////////////////////////////////////////////////////////////////////
		/** Add an listener for the <code>TRIGGERED</code> event. */
		public final function addTriggeredListener(listener:Function):void {
			this.addEventListener(TRIGGERED, listener);
		}
		/** Remove a listener for the <code>TRIGGERED</code> event. */
		public final function removeTriggeredListener(listener:Function):void {
			this.removeEventListener(TRIGGERED, listener);
		}
		
		/** Add an listener for the <code>SELECTED_CHANGE</code> event. */
		public final function addSelectedChangeListener(listener:Function):void {
			this.addEventListener(SELECTED_CHANGE, listener);
		}
		/** Remove a listener for the <code>SELECTED_CHANGE</code> event. */
		public final function removeSelectedChangeListener(listener:Function):void {
			this.removeEventListener(SELECTED_CHANGE, listener);
		}
		///////////////////////////////////////////////////////////////////////
		//}
		
	}
}