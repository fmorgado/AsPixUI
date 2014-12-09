package pixui.views {
	import pixlib.data.ListController;
	import pixlib.data.ListEvent;
	import pixlib.data.MapController;
	import pixlib.data.MapEvent;
	
	public class List extends View {
		
		override protected function initialize():void {
			super.initialize();
			
			_rendererProperties = new MapController();
			_rendererProperties.addChangeListener(_onRendererPropertiesChange);
		}
		
		override protected function validateData():void {
			
		}
		
		override protected function validateLayout():void {
			
		}
		
		//{ ItemRenderers Handling
		///////////////////////////////////////////////////////////////////////
		private var _rendererFactory:Object;
		public final function get rendererFactory():Object { return _rendererFactory; }
		public final function set rendererFactory(value:Object):void {
			
		}
		
		private var _rendererProperties:MapController;
		public final function get rendererProperties():MapController { return _rendererProperties; }
		
		private function _onRendererPropertiesChange(event:MapEvent):void {}
		
		private var _renderers:Vector.<View> = new <View>[];
		///////////////////////////////////////////////////////////////////////
		//}
		
		//{ Data Handling
		///////////////////////////////////////////////////////////////////////
		private function _clearList():void {
			var list:ListController = _data as ListController;
			if (list != null) {
				list.removeChangeListener(_onListChange);
				_data = null;
			}
			invalidateData();
		}
		
		private function _setList(value:ListController):void {
			_clearList();
			_data = value;
			value.addChangeListener(_onListChange);
		}
		
		override public function set data(value:Object):void {
			if (value == null) {
				_clearList();
				
			} else if (value is Array) {
				_setList(new ListController(value as Array));
				
			} else if (value is ListController) {
				_setList(value as ListController);
				
			} else {
				throw new Error('Invalid data type:  ' + value);
			}
		}
		
		private function _onListChange(event:ListEvent):void {
			
		}
		///////////////////////////////////////////////////////////////////////
		//}
		
	}
}