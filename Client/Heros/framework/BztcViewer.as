package framework 
{

	import framework.FKPPInfoCode;
	import com.model.Map;
	import com.net.AssetData;
	import com.net.RESManager;
	import com.net.ServerLoadModel;
	import com.ui.controls.Alert;
	import com.ui.controls.Poster;
	import com.ui.core.Align;
	import com.ui.core.UIComponentData;
	import com.ui.data.AlertData;
	import com.ui.manager.UIManager;
	import com.ui.mediator.IMediator;
	import com.utils.GStringUtil;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.external.ExternalInterface;
	import loading.FKPPLoadMonitor;
	/**
	 * 控制BztcUIManager和BztcFacade进行交互
	 * @author ...
	 */
	public class BztcViewer 
	{
		public static var instance : BztcViewer = new BztcViewer();
		
		private var _load_lm :FKPPLoadMonitor;
		private var _bg : Poster;
		public var mediatorMap : Map = new Map();
		
		public var IconLoading : Sprite;
		public var roleLoading : Sprite;
		public var avatarLoading : Sprite;
		public var info : Alert;
		//public var rolemenu : RoleMenu;
		
		public function BztcViewer() 
		{
			
		}
		private function InitInfo():void
		{
			var data : AlertData = new AlertData();
			data.padding =15;
			data.buttonData.width = 71;
			data.buttonData.height =32;
			data.buttonData.labelData.text = "";
			data.yesbuttonData.width = 71;
			data.yesbuttonData.height = 32;
			data.nobuttonData.width = 71;
			data.nobuttonData.height = 32;
			data.cancelbuttonData.width = 71;
			data.cancelbuttonData.height = 32;
			data.parent = UIManager.root;
			data.flag = Alert.OK;
			info = new Alert(data);
			data = data.clone();
			info.addEventListener(Event.CLOSE, OnClientAlertInfoClose_Handler);
			BztcFacade.Instance.AddCmdListener(EventEnum.EventInfo, new BCmdHandler(this, OnGameInfo));
			BztcFacade.Instance.AddCmdListener(EventEnum.HideInfo, new BCmdHandler(this, OnGameInfoHide));
		}
		protected function OnClientAlertInfoClose_Handler(event : Event) : void
		{
			var alert : Alert = event.target as Alert;
			if (alert == null) return;
			if ( curinfocmd != null )
			{
				if ( (((alert.detail & Alert.CANCEL)==0) && ((alert.detail & Alert.NO)==0) ))
				{
					if(curinfocmd._callback != null)
						curinfocmd._callback.Exec();
				}
			}
			//var _clientAlertInfo : DisplayAlertInfo = info.source as DisplayAlertInfo;
			//if (_clientAlertInfo == null || alert.Sender != _clientAlertInfo) return;
			//if ( _clientAlertInfo.CallBack != null)
			//{
				//_clientAlertInfo.CallBack(_clientAlertInfo, alert.detail);
				//info.source = null;
			//}
		}
		//private function InitRoleMenu():void
		//{
			//rolemenu = new RoleMenu(UIManager.root);
		//}
		public function Init()
		{
			InitInfo();
			//InitRoleMenu();
			InitBg();
			BztcFacade.Instance.AddCmdListener(EventEnum.load_startLoading, new BCmdHandler(this, OnStartLoading));
			BztcFacade.Instance.AddCmdListener(EventEnum.load_faild, new BCmdHandler(this, OnLoadFaild));
			BztcFacade.Instance.AddCmdListener(EventEnum.load_Completed, new BCmdHandler(this, OnLoadComplete));
		}
		
		public function InitBg():void
		{
			var data : UIComponentData = new UIComponentData();
			data.align = Align.CENTER;
			data.width = 1000;
			data.height = 600;
			_bg = new Poster(data);
			BztcFacade.Instance.bztcgame.addChild(_bg);
			_bg.model.source = [new AssetData("BlackBack", "system")];
		}
		public function OnStartLoading(cmd : BCommand):int
		{
			if ( _load_lm == null)
			{
				_load_lm = new FKPPLoadMonitor(BztcFacade.Instance.bztcgame);
			}
			if ( cmd is BServerLoadCommand )
			{
				_load_lm.model = (cmd as BServerLoadCommand)._loadmodel;
				_load_lm.show();
			}
			else
			{
				_load_lm.model = BztcModel.Instance.ResMgr.model;
				RESManager.instance.load( -1);
				if(BztcModel.Instance.ResMgr.model.LoadType != LoadTypeEnum.NoWindSuspendLoad)
				_load_lm.show();
			}
			return 0;
		}
		
		public function OnLoadFaild( cmd : BCommand ):int
		{
			var data : AlertData = new AlertData();
			data.padding =15;
			data.buttonData.width = 71;
			data.buttonData.height = 32;
			data.okLabel = "<b>确定</b>";
			data.parent = UIManager.root;
			data.flag = Alert.OK;
			var alert : Alert = new Alert(data);
			alert.label = FKPPInfoCode.InfoCodeArray[FKPPInfoCode.LoadFileFailed];
			alert.flag = Alert.OK;
			alert.show();
			alert.addEventListener(Event.CLOSE, OnLoadFiailed_CloseHandler);
			return 0;
		}
		
		private function OnLoadFiailed_CloseHandler(event : Event) : void
		{
			if (ExternalInterface.available) {
				ExternalInterface.call("eval", "location.reload();");
			}
		}
		
		private function OnLoadComplete( cmd : BCommand ):int
		{
			_load_lm.hide();
			if ( _load_lm.model is ServerLoadModel )
			{
				_load_lm.model.removeEventListener(Event.COMPLETE, BztcModel.Instance.OnServerLoadModelCommplete);
			}
			BztcFacade.Instance.AddCommand(new BCommand(EventEnum.load_OK));
			return 0;
		}
		/////////////////////////////////////////net error ui////////////////////////////////////////
		
		private function info_closeHandler(event : Event) : void {
			var alert : Alert = Alert(event.target);
			if ( (alert.Sender as HerosGame) == null) return;
			var detail : uint = alert.detail;
			if (detail == Alert.OK)
			{
				if (alert.source == FKPPInfoCode.LoginError ||
					alert.source == FKPPInfoCode.AccountNotExist ||
					alert.source == FKPPInfoCode.UnKnownError ||
					alert.source == FKPPInfoCode.ServerClosed
					)
				{
					logout();
					return;
				}
			}
			alert.source = FKPPInfoCode.NONE;
		}

		private function logout() : void {
			if(ExternalInterface.available) {
				ExternalInterface.call("eval", "location.reload();");
				//ExternalInterface.call("LogoutSnda");
				BztcViewer.instance.info.label = "正在重新加载游戏.....";
			} else {
				BztcViewer.instance.info.label = "请关闭此游戏!";
			}
			BztcViewer.instance.info.flag = Alert.NONE;
			BztcViewer.instance.info.source = FKPPInfoCode.NONE;
			BztcViewer.instance.info.show();
			BztcViewer.instance.info.Sender = this;
		}
		public function OnGameInfoHide(cmd : BCommand) :int
		{
			info.hide();
			return 0;
		}
		private var curinfocmd : BInfoCommand;
		public function OnGameInfo(cmd : BCommand) : int
		{
			var infocmd : BInfoCommand = cmd as BInfoCommand;
			if ( infocmd != null )
			{
				curinfocmd = infocmd;
				info.label = FKPPInfoCode.InfoCodeArray[infocmd._infocode];
				info.flag = infocmd._flag;//Alert.OK;
				
				if( infocmd._showtype == 0 )
				{
					info.show();
				}
				else if( infocmd._showtype == 1 )
				{
					info.showWait();
				}
				info.Sender = infocmd._sender;
			}
			return 0;
		}
		
		public function OnGameError( cmd : BCommand ):int
		{
			var svcmd : BSvErrorCmd = cmd as BSvErrorCmd;
			if ( svcmd != null )
			{
				GameError(svcmd.cmdcode);	
			}
			
			return 0;
		}
		private function GameError(value : int): void {
			var info : String = FKPPInfoCode.InfoCodeArray[value];
			BztcViewer.instance.info.label = info;
			BztcViewer.instance.info.source = value;
			BztcViewer.instance.info.flag = Alert.OK;
			BztcViewer.instance.info.Sender = BztcFacade.Instance.bztcgame;
			BztcViewer.instance.info.show();
		}
		//rolemenu
		//public function ShowRoleMenu(cmd : BCommand):int
		//{
			//var rolemenucmd : RoleMenuCmd = cmd as RoleMenuCmd;
			//if ( rolemenucmd  != null )
			//{
				//rolemenu.source = rolemenucmd._rolemenudata;
				//rolemenu.show();
			//}
			//return 0;
		//}
		//public function IsShowRoleMenu():Boolean
		//{
			//return (rolemenu.parent != null);
		//}
		//public function HideRoleMenu():void
		//{
			//rolemenu.hide();
		//}
		/////////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////logic////////////////////////////////////////////////////////
		
	}

}