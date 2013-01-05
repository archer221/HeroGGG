package loading 
{
	import framework.LoadTypeEnum;
	import com.bd.BDData;
	import com.net.AssetData;
	import com.net.LoadModel;
	import com.ui.containers.Panel;
	import com.ui.controls.BDPlayer;
	import com.ui.controls.Label;
	import com.ui.controls.ProgressBar;
	import com.ui.core.Align;
	import com.ui.core.UIComponent;
	import com.ui.core.UIComponentData;
	import com.ui.data.IconData;
	import com.ui.data.LabelData;
	import com.ui.data.PanelData;
	import com.ui.data.ProgressBarData;
	import com.ui.layout.GLayout;
	import com.ui.monitor.LoadMonitor;
	import com.utils.BDUtil;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import com.ui.manager.UIManager;
	import com.ui.skin.SkinStyle;
	/**
	 * ...
	 * @author 
	 */
	public class FKPPLoadMonitor extends UIComponent
	{
		protected var _model : LoadModel;
		protected var m_fullScreenLoadMonitor : FKPPFullScreeLoadMonitor;
		protected var m_windowLoadMonitor : FKPPWindowLoadMonitor;
		
		override protected function onShow() : void 
		{
			if (_model.LoadType == LoadTypeEnum.FullScreenSuspendLoad)
			{
				m_fullScreenLoadMonitor.show();
				m_windowLoadMonitor.hide();
			}
			else if (_model.LoadType == LoadTypeEnum.WindScreenSuspendLoad)
			{
				m_fullScreenLoadMonitor.hide();
				m_windowLoadMonitor.show();
			}
			super.onShow();
			GLayout.layout(this);
		}
		override protected function onHide():void 
		{
			m_fullScreenLoadMonitor.hide();
			m_windowLoadMonitor.hide();
			super.onHide();
		}
		private function initView() : void 
		{
			m_fullScreenLoadMonitor = new FKPPFullScreeLoadMonitor(this);
			m_windowLoadMonitor = new FKPPWindowLoadMonitor(this);
		}
		
		public function FKPPLoadMonitor(parent : Sprite) 
		{
			var data : UIComponentData = new UIComponentData();
			data.align = new Align( -1, -1, -1, -1, 0, 0);
			data.width = 1000;
			data.height = 600;
			data.parent = parent;
			super(data);
			initView();
		}
		public function get model():LoadModel
		{
			return _model;
		}
		public function set model(value : LoadModel) : void 
		{
			_model = value;
			if (_model.LoadType == LoadTypeEnum.FullScreenSuspendLoad)
				m_fullScreenLoadMonitor.model = value;
			else if (_model.LoadType == LoadTypeEnum.WindScreenSuspendLoad)
				m_windowLoadMonitor.model = value;
		}
	}

}