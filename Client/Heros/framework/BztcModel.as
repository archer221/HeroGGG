package framework 
{
	import Fight.SceneConfig.SceneTemplateContainer;
	
	import NotifyBody.LoadWaitBody;
	
	import com.EngFrameWork.EngMediator.IMediator;
	import com.EngFrameWork.EngObserver.Notification;
	import com.frame.FrameTimer;
	import com.frame.TimerManager;
	import com.model.LocalSO;
	import com.model.Map;
	import com.net.LibData;
	import com.net.LibsManager;
	import com.net.RESManager;
	import com.net.SWFLoader;
	import com.net.ServerLoadModel;
	import com.net.XMLLoader;
	import com.sound.SettingData;
	import com.ui.core.EventTargetCollect;
	import com.ui.manager.CallBackFuntion;
	import com.ui.manager.ThemeSkinManager;
	
	import control.GameControl;
	
	import core.TrickSleepModel;
	
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	
	import framework.FKPPInfoCode;
	
	import logic.LoginModel;
	
	import mx.core.ByteArrayAsset;
	
	import sound.SoundManager;

	/**
	 * ...
	 * @author ...
	 */
	public class BztcModel 
	{
		public static var Instance : BztcModel = new BztcModel();
		
		private var _res : RESManager;
		public static var soundManager : SoundManager = new SoundManager();
		public static var selectRoleIdx : int;
		public static var myWorldName : String = "";
		public static var settingData : SettingData = new SettingData();
		public static var lso :LocalSO  = new LocalSO("yongheros");
		public static var CurrentLobbyType : int = -1;	
		public static var bCanSuperMan : Boolean = false;
		public static var superSelectPoint : Point ;
		public static var shutuparr:Array = new Array();
		private var bFirstCreaterole: Boolean = false;
		public static var loginmodel : LoginModel = new LoginModel();
		public var gamecontrol :GameControl;
		public function BztcModel() 
		{
			//_GameMainUpdate = new GameMainUpdate();
		}
		public function get ResMgr():RESManager
		{
			return _res;
		}
		public function Init():void
		{
			_res = RESManager.instance;
			
			FrameTimer.add(_res);
			_res.CDNUrl = BztcFacade.Instance.bztcgame.cdnurl;
			initSetttings();
			initEventListener();
			initModels();
			gamecontrol = new GameControl();

		}
		private function initModels():void
		{
			TrickSleepModel.Intance.init();
			loginmodel.connectserver();
		}
		private function InitScene():void
		{

		}
		private function initEventListener():void
		{
			//loading
			BztcFacade.Instance.RegisterCommad(EventEnum.load_OK, new BSimpleCmd(this, OnLoadingOK));
			BztcFacade.Instance.RegisterCommad(EventEnum.load_Wait, new BSimpleCmd(this, OnLoadWaitExec));
			
			//FrameTimer.add(Adapter.tSrbComunicator.Server);

		}
		private function initSetttings():void
		{
			var lsobj : Object = lso.getAt("setting");
			if ( lsobj != null )
			{
				settingData.parseObj(lsobj);
			}
			soundManager.setSettinData(settingData);
			soundManager.reset();
		}
		private function libs_completeHandler( event : Event ):void
		{
			_res.removeEventListener(Event.COMPLETE, libs_completeHandler);
			_res.removeEventListener(RESManager.LoadFileFailed, libs_loadFaildHandler);
			_res.removeEventListener(ErrorEvent.ERROR, libs_errorHandler);
			BztcFacade.Instance.SendNotification(new Notification(EventEnum.load_Completed));
		}
		
		private function libs_errorHandler(event : ErrorEvent) : void {
			_res.removeEventListener(Event.COMPLETE, libs_completeHandler);
			_res.removeEventListener(RESManager.LoadFileFailed, libs_loadFaildHandler);
			_res.removeEventListener(ErrorEvent.ERROR, libs_errorHandler);
			BztcFacade.Instance.SendNotification(new Notification(EventEnum.load_faild));
		}
		private function libs_loadFaildHandler(event : Event):void
		{
			_res.removeEventListener(Event.COMPLETE, libs_completeHandler);
			_res.removeEventListener(RESManager.LoadFileFailed, libs_loadFaildHandler);
			_res.removeEventListener(ErrorEvent.ERROR, libs_errorHandler);
			BztcFacade.Instance.SendNotification(new Notification(EventEnum.load_faild));
		}
		
		private function OnLoadWaitExec(cmd : Notification) :int
		{
			var loadwaitbody : LoadWaitBody = cmd.getBody() as LoadWaitBody;
			if ( loadwaitbody != null )
			{
				return StartLoading(loadwaitbody._loadlibary, loadwaitbody._loadtype, loadwaitbody._callback);
			}
			return 1;
		}
		
		public function StartServerLoading(loadmodel : ServerLoadModel):int
		{
			if ( BztcFacade.Instance.Suspended )
			{
				BztcFacade.Instance.SendNotification(new Notification(EventEnum.load_Wait,
					new LoadWaitBody(new Array(),loadmodel.LoadType,null),null));
				return 0;
			}
			_callbackfunc = null;
			BztcFacade.Instance.bNeedSuspend = true;
			BztcFacade.Instance.Suspended = true;
			loadmodel.addEventListener(Event.COMPLETE, OnServerLoadModelCommplete);
			BztcFacade.Instance.SendNotification(new Notification(EventEnum.load_startLoading,loadmodel,null));
			return 0;
		}
		public function OnServerLoadModelCommplete(e : Event) :void
		{
			BztcFacade.Instance.SendNotification(new Notification(EventEnum.load_Completed));
		}
		
		private var _callbackfunc : CallBackFuntion;
		public function StartLoading(libsary : Array,loadtype : int,tcallback : CallBackFuntion):int
		{
			if ( BztcFacade.Instance.Suspended )
			{
				BztcFacade.Instance.SendNotification(new Notification(EventEnum.load_Wait,new LoadWaitBody(libsary,loadtype,tcallback),null));
				return 0;
			}
			if ( libsary == null || libsary.length <= 0 ) return -1;
			_callbackfunc = tcallback;
			for each( var libdata : LibData in libsary )
			{
				_res.add(libdata.Loader);
			}
			if ( loadtype <= LoadTypeEnum.WindScreenSuspendLoad )
			{
				BztcFacade.Instance.bNeedSuspend = true;
				BztcFacade.Instance.Suspended = true;
			}
			else
			{
				BztcFacade.Instance.bNeedSuspend = false;
				BztcFacade.Instance.Suspended = false;
			}
			_res.model.LoadType = loadtype;
			_res.addEventListener(Event.COMPLETE, libs_completeHandler);
			_res.addEventListener(RESManager.LoadFileFailed, libs_loadFaildHandler);
			BztcFacade.Instance.SendNotification(new Notification(EventEnum.load_startLoading));
			return 0;
		}
		
		public function OnLoadingOK(cmd :Notification):void
		{
			if( BztcFacade.Instance.bNeedSuspend && BztcFacade.Instance.Suspended )
				BztcFacade.Instance.Suspended = false;
			if ( _callbackfunc != null )
			{
				_callbackfunc.Exec();
			}
		}
		private var bdoFirstLoad : Boolean = false;
		public function SomeThingAfterFirstLoad():void
		{
			if ( bdoFirstLoad ) return;
			ThemeSkinManager.Init();
			SceneTemplateContainer.Instance.ParseXML();
			bdoFirstLoad = true;
		}
		
		public function OnFirstLoadingOK(ary : Array):void
		{
			SomeThingAfterFirstLoad();
			BztcFacade.Instance.SendNotification(new Notification(EventEnum.load_rolecreatorOK));
		}
		///////////////////////////////////game update////////////////////////////////////////////
		private var _curTime : int = 0;
		private var _pingelapsetime : int = 0;
		public function Update():void
		{
			var now : int = getTimer();
			if ( _curTime == 0 ) {
				_curTime = now;//_time.currentCount;
			}
			var elaptime : int = now - _curTime;
			_pingelapsetime += elaptime;
//			MediatorMgr.Instance.update(elaptime);
			_curTime = now;
		}
		//////////////////////////////////////////////////////////////////////////////////////////
		//////////////////////////////////////////////////////////////////////////////////////////
		///////////////////////////////////////////////Exception Function////////////////////////////////
	}

}
