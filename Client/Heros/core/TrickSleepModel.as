package core 
{
	import framework.BztcModel;
	import com.frame.FrameTimer;
	import com.frame.IFrame;
	import com.ibio8.debug.Debug;
	import com.net.AssetData;
	import com.net.LibsManager;
	import com.ui.layout.GLayout;
	import com.ui.manager.UIManager;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	/**
	 * ...
	 * @author 
	 */
	public class TrickSleepModel
	{
		public static const Intance : TrickSleepModel = new TrickSleepModel();
		
		public var m_bStageActivated : Boolean = true;
		
		public function TrickSleepModel() 
		{
			
		}
		
		public function init() : void
		{
			UIManager.root.addEventListener(Event.ACTIVATE, OnActive);
			UIManager.root.addEventListener(Event.DEACTIVATE, OnDeactive);
		}
		
		private function OnActive(event : Event) : void
		{
			m_bStageActivated = true;
		}
		
		private function OnDeactive(event : Event) : void
		{
			m_bStageActivated = false;
			BztcModel.Instance.gamecontrol.ClearKeyCode();
		}
	}

}