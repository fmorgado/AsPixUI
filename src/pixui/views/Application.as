package pixui.views {
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	
	import pixlib.utils.Metric;
	
	public class Application extends View {
		
		/** @inheritDoc */
		override protected function onAddedToStage():void {
			super.addedToStage();
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.stageFocusRect = false;
			
			Metric.screen(stage);
			
			stage.addEventListener(Event.RESIZE, _onStageResize);
			stage.addEventListener(Event.ACTIVATE, _onStageActivate);
			stage.addEventListener(Event.DEACTIVATE, _onStageDeactivate);
			
			_onStageResize(null);
		}
		
		private function _onStageResize(_):void {
			this.setSize(stage.stageWidth, stage.stageHeight);
		}
		
		private function _onStageActivate(event:Event):void {
			Metric.activate();
			onStageActivate();
		}
		
		private function _onStageDeactivate(event:Event):void {
			Metric.deactivate();
			onStageDeactivate();
		}
		
		/** This method is called when the stage is activated. */
		protected function onStageActivate():void {}
		
		/** This method is called when the stage is deactivated. */
		protected function onStageDeactivate():void {}
		
	}
}