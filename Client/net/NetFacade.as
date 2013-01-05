package  
{
	import com.ui.core.EventDispatcherEx;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.net.Responder;
	/**
	 * ...
	 * @author ...
	 */
	public class NetFacade extends EventDispatcherEx
	{
		private static var _instance:NetFacade = new NetFacade();
		private var netclient : NetClient = new NetClient();
		private var _serverhost : String;
		public static function get Instance():NetFacade
		{
			return _instance;
		}
		
		public function NetFacade() 
		{
			
		}
		
		public function start( serverhost:String ):void
		{
			_serverhost = serverhost;
			netclient.AddEventListenerEx(IOErrorEvent.IO_ERROR, this, OnIoError);
			netclient.connect(serverhost, OnNetStatus);
		}
		public function OnNetStatus(event:NetStatusEvent):void
		{
			  switch (event.info.code) 
			  {
                case "NetConnection.Connect.Success":
                    trace(_serverhost + "Connect OK!!");
                    break;
                case "NetStream.Play.StreamNotFound":
                    trace("Stream not found: " + _serverhost);
                    break;
				default:
				{
					trace(event.info.code);
					break;
				}
            }

		}
		public function OnIoError(ioerror : IOErrorEvent):void
		{
			trace(ioerror);
		}
		
		public function CallRemote( scmd:String,retsucessfunc : Function,reterroFunc : Function,...rest):void
		{
			
			var responder : Responder = new Responder(retsucessfunc, reterroFunc);
			netclient.Call(scmd, responder,rest);
		}
		
	}

}