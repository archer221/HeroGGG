package loading 
{
	import com.net.AssetData;
	import com.net.LoadModel;
	import com.ui.controls.Label;
	import com.ui.controls.ProgressBar;
	import com.ui.core.Align;
	import com.ui.core.UIComponent;
	import com.ui.core.UIComponentData;
	import com.ui.data.IconData;
	import com.ui.data.LabelData;
	import com.ui.data.ProgressBarData;
	import com.ui.layout.GLayout;
	import com.ui.manager.UIManager;
	import com.ui.skin.SkinStyle;
	import com.utils.BDUtil;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	/**
	 * ...
	 * @author ...
	 */
	public class FKPPWindowLoadMonitor extends UIComponent
	{
		protected var _progressBar : ProgressBar;
		protected var _model : LoadModel;
		
		protected var bg : Sprite;
		protected var title : Bitmap;	//标题
		protected var track : Sprite;	//进度条底
		
		public function FKPPWindowLoadMonitor(parent : Sprite) 
		{
			var data : UIComponentData = new UIComponentData();
			data.align = Align.CENTER;
			data.width = 268;
			data.height = 82;
			data.parent = parent;
			super(data);
			
			initView();
		}
		
		override protected function onShow():void 
		{
			super.onShow();
			GLayout.layout(this);
		}
		
		private function initView() : void 
		{
			addbg();
			addProgressBars();
		}
		
		private function addbg():void
		{
			bg = UIManager.getUI(new AssetData("BG", "Loading")) ;
			bg.x = 0;
			bg.y = 0;
			addChild(bg);
			
			title = new Bitmap();
			title.bitmapData = BDUtil.getBD(new AssetData("Tips", "Loading"));
			title.x = 87;
			title.y = 1;
			addChild(title);
			
			track = UIManager.getUI(new AssetData("track", "Loading"));
			track.x = 33;
			track.y = 46;
			addChild(track);
		}
		
		private function addProgressBars() : void 
		{
			var data : ProgressBarData = new ProgressBarData();
			data.barAsset = new AssetData("bar", "Loading");
			data.trackAsset = new AssetData(SkinStyle.emptySkin);
			data.labelData.align = new Align(-1, -1, -1, -1, -30, 0);
			data.x = 37;
			data.y = 49;
			data.width = 193;
			data.height = 7;
			data.barMask = true;
			_progressBar = new ProgressBar(data);
			addChild(_progressBar);
		}
		
		private function initHandler(event : Event) : void 
		{
			_progressBar.value = 0;
			_progressBar.max = 100;
			changeHandler(null);
		}
		
		private function changeHandler(event : Event) : void 
		{
			_progressBar.value = (_model.Done / _model.total) * 100;//_model.LoadPercent;
		}
		
		private function completeHandler(event : Event) : void 
		{
			_progressBar.value = 100;
			//anime.x = _progressBar.value / max * _progressBar.width - anime.width +330;
		}
		
		private function addModelEvents() : void 
		{
			_model.addEventListener(Event.INIT, initHandler);
			_model.addEventListener(Event.CHANGE, changeHandler);
			_model.addEventListener(Event.COMPLETE, completeHandler);
		}

		private function removeModelEvents() : void 
		{
			_model.removeEventListener(Event.INIT, initHandler);
			_model.removeEventListener(Event.CHANGE, changeHandler);
			_model.removeEventListener(Event.COMPLETE, completeHandler);
		}
		
		public function set model(value : LoadModel) : void 
		{
			if(_model)removeModelEvents();
			_model = value;
			if (_model) addModelEvents();
			initHandler(null);
		}
		
	}

}