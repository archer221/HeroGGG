package loading 
{
	import com.bd.BDData;
	import com.net.AssetData;
	import com.net.LoadModel;
	import com.ui.controls.BDPlayer;
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
	import com.utils.GStringUtil;
	import com.utils.MathUtil;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	/**
	 * ...
	 * @author ...
	 */
	public class FKPPFullScreeLoadMonitor extends UIComponent
	{
		protected var operation : Label;	//操作指南
		protected var tips : Label;			//加载提示

		protected var _progressBar : ProgressBar;

		protected var _model : LoadModel;
		
		protected var bg : Bitmap;
		
		protected var operationStrAry : Array = new Array();
		
		protected var m_Timer : Timer;
		
		override protected function onShow() : void 
		{
			m_ranIdx = MathUtil.random(0, operationStrAry.length - 1);
			operation.text = operationStrAry[m_ranIdx];
			if (m_Timer.running) m_Timer.stop();
			m_Timer.start();
			super.onShow();
			GLayout.layout(this);
		}
		override protected function onHide():void 
		{
			if (m_Timer.running) m_Timer.stop();
			super.onHide();
		}
		private function addbg():void
		{
			bg = new Bitmap();
			bg.bitmapData = BDUtil.getBD(new AssetData("FullScreenTrack", "Loading")) ;
			bg.x = 146;
			bg.y = 500;
			addChild(bg);
		}
		private function initView() : void 
		{
			addbg();
			addLabels();
			addProgressBars();
		}
		
		private function addLabels() : void 
		{
			var data : LabelData = new LabelData();
			data.iconData = new IconData();
			data.textColor = 0xFFFF00;
			data.x = 300;
			data.y = 480;
			operation = new Label(data);
			
			var data : LabelData = new LabelData();
			data.iconData = new IconData();
			data.textColor = 0xFFFF00;
			data.x = 350;
			data.y = 550;
			tips = new Label(data);
			
			tips.text = "       第一次打开游戏时，加载内容较多，请耐心等待\n若加载不成功，请刷新页面或者清空缓存后重新登录游戏";
			
			addChild(operation);
			addChild(tips);
		}

		private function addProgressBars() : void 
		{
			var data : ProgressBarData = new ProgressBarData();
			data.barAsset = new AssetData("FullScreenBar", "Loading");
			data.trackAsset = new AssetData(SkinStyle.emptySkin);
			data.labelData.align = new Align(-1, -1, -1, -1, -30, 0);
			data.x = 153;
			data.y = 504;
			data.width = 690;
			data.height = 26;
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
			_progressBar.value = _model.LoadPercent;
			_progressBar.text = GStringUtil.format("正在加载[{0}]:{1}/{2}		{3}%", _model.LoadingFile, _model.Done + 1, _model.total / 100, _model.LoadPercent);
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
		
		public function FKPPFullScreeLoadMonitor(parent : Sprite) 
		{
			var data : UIComponentData = new UIComponentData();
			data.align = new Align( -1, -1, -1, -1, 0, 0);
			data.width = 1000;
			data.height = 600;
			data.parent = parent;
			super(data);
			initView();
			
			m_Timer = new Timer(10000);
			m_Timer.addEventListener(TimerEvent.TIMER, OnTimer);
			operationStrAry.push("操作指南1：A键控制角色向左移动；   D键控制角色向右移动。");
			operationStrAry.push("操作指南2：Q键控制角色后空翻（跳的更高）；  E键控制角色跳跃（跳的更远）");
			operationStrAry.push("操作指南3：W键控制角色抬高武器的射击角度；  S键控制角色降低武器的射击角度");
			operationStrAry.push("操作指南4：按下空格键蓄力，蓄力越久炮弹的射程越远，松开空格键时发射炮弹。");
		}
		
		private var m_ranIdx : int = 0;
		private function OnTimer(event : Event) : void
		{
			m_ranIdx++;
			m_ranIdx = m_ranIdx % operationStrAry.length;
			operation.text = operationStrAry[m_ranIdx];
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