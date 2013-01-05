package  
{
	import com.net.LibData;
	import com.net.LibsManager;
	import com.net.RESManager;
	import com.net.SWFLoader;
	import com.net.XMLLoader;
	import com.project.Game;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.system.Security;
	import framework.BztcFacade;
	
	/**
	 * ...
	 * @author YiXiuTing
	 */
	[SWF(width=1000,height=600,backgroundColor=0x000000,frameRate=40)]
	public class HerosGame extends Game 
	{
		public var _ticket : String="";
		public var _digitalAccount : String ="";
		public var _PullByFriendName : String;
		public var _PullServer : String;
		public var clientip : String = "";
		public var cdnurl:String = "";
		public var Serverhost: String = "";
		//public var Serverport : String = "";
		public function HerosGame() 
		{
			Security.allowDomain("*");
		}
		
		override protected function initGame():void 
		{
			_ticket = loaderInfo.parameters["vticket"];
			_digitalAccount = loaderInfo.parameters["vaccountid"];
			_PullByFriendName = loaderInfo.parameters["pullfriend"];
			_PullServer = loaderInfo.parameters["pullserver"];
			clientip = loaderInfo.parameters["clienip"];
			Serverhost = loaderInfo.parameters["Serverhost"];
			Serverhost = "http://127.0.0.1/amfphp/gateway.php";
			_digitalAccount = "1";
			_ticket = "1";
			//Serverport = loaderInfo.parameters["Serverport"];
			cdnurl = "";//loaderInfo.parameters["cdnurl"];
			InitServer();
			PreLoadSth();
		}
		private function InitServer():void
		{
			NetFacade.Instance.start(Serverhost);
			//NetFacade.Instance.CallRemote("helloworld.hi", onnettest, onfaild);
		}
		//public function onnettest(o:Object):void
		//{
			//trace(o);
		//}
		//public function onfaild(obj:Object):void
		//{
			//trace(obj);
		//}
		private function PreLoadSth():void
		{
			_res.add( new SWFLoader(new LibData("assets/loading.swf", "Loading","swf")));
			_res.add( new XMLLoader(new LibData(LibsManager.libsvalue,LibsManager.libskey,"xml")));
			_res.addEventListener(Event.COMPLETE, libs_PreLoadCompleted);
			_res.addEventListener(ErrorEvent.ERROR, libs_errorHandler);
			_res.load(-1);
		}
		private function libs_PreLoadCompleted(event : Event) : void {
			_res.removeEventListener(Event.COMPLETE, libs_PreLoadCompleted);
			_res.removeEventListener(ErrorEvent.ERROR, libs_errorHandler);
			LibsManager.Instance.LoadLibs();
			BztcFacade.Instance.Init(this);
			//BztcFacade.Instance.AddCommand(new BCommand(EventEnum.Server_StartLogin));
		}
		private function libs_errorHandler(event : ErrorEvent) : void {
			_res.removeEventListener(Event.COMPLETE, libs_PreLoadCompleted);
			_res.removeEventListener(RESManager.LoadFileFailed, libs_loadFaildHandler);
			_res.removeEventListener(ErrorEvent.ERROR, libs_errorHandler);
		}
		private function libs_loadFaildHandler(event : Event):void
		{
			_res.removeEventListener(Event.COMPLETE, libs_PreLoadCompleted);
			_res.removeEventListener(RESManager.LoadFileFailed, libs_loadFaildHandler);
			_res.removeEventListener(ErrorEvent.ERROR, libs_errorHandler);
		}
		
	}

}