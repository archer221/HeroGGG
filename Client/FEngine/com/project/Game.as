package com.project {
	import com.log4a.LocalAppender;
	import com.log4a.Logger;
	import com.log4a.TraceAppender;
	import com.net.AssetData;
	import com.net.RESManager;
	import com.ui.manager.UIManager;
	import com.ui.skin.ASSkin;
	import com.ui.theme.BlackTheme;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import com.ibio8.debug.Debug;


	public class Game extends Sprite {

		protected var _res : RESManager;

		private function addedToStageHandler(event : Event) : void {
			
			removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.quality = StageQuality.HIGH;
			stage.frameRate = 48;
			stage.showDefaultContextMenu = false;
			Debug.initialize(stage);
			Logger.addAppender(new TraceAppender());
			Logger.addAppender(new LocalAppender());
			ASSkin.setTheme(AssetData.AS_LIB, new BlackTheme());
			UIManager.setRoot(this);
			_res = RESManager.instance;
			Debug.clear();
			//Debug.dump("test connect to idebuger ...", 2);
			initGame();
		}

		protected function initGame() : void {
		}

		public function Game() {
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		}
	}
}