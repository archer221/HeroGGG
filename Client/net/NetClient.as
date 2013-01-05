package  
{
	import com.ui.core.EventDispatcherEx;
	import flash.events.IOErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.net.NetConnection;
	import flash.net.ObjectEncoding;
	import flash.net.Responder;
	/**
	 * ...
	 * @author ...
	 */
	public class NetClient extends EventDispatcherEx
	{
		private var netconnnetion:NetConnection = new NetConnection();
		public function NetClient() 
		{
			
		}
		public function connect(phpurl:String,OnNetStatus:Function):void
		{
			netconnnetion.objectEncoding = ObjectEncoding.AMF3;
			netconnnetion.addEventListener(NetStatusEvent.NET_STATUS, OnNetStatus);
			netconnnetion.addEventListener(IOErrorEvent.IO_ERROR, OnNetIOError);
			netconnnetion.connect(phpurl);
		}
		
		public function Call(scommand:String, responder:Responder,paramary:Array):void
		{
			if ( paramary == null || paramary.length <= 0 )
			{
				netconnnetion.call(scommand, responder);
			}
			else {
				switch( paramary.length )
				{
					case 1:
						{
							netconnnetion.call(scommand, responder,paramary[0]);
							break;
							
						}
					case 2:
						{
							netconnnetion.call(scommand, responder, paramary[0],
							paramary[1]);
							break;
						}
					case 3:
						{
							netconnnetion.call(scommand, responder, paramary[0],
							paramary[1],
							paramary[2]);
							break;
						}
					case 4:
						{
							netconnnetion.call(scommand, responder, paramary[0],
							paramary[1],
							paramary[2],
							paramary[3]);
							break;
						}
					case 5:
						{
							netconnnetion.call(scommand, responder, paramary[0],
							paramary[1],
							paramary[2],
							paramary[3],
							paramary[4]);
							break;
						}
					case 6:
						{
							netconnnetion.call(scommand, responder, paramary[0],
							paramary[1],
							paramary[2],
							paramary[3],
							paramary[4],
							paramary[5]);
							break;
						}
					case 7:
						{
							netconnnetion.call(scommand, responder, paramary[0],
							paramary[1],
							paramary[2],
							paramary[3],
							paramary[4],
							paramary[5],
							paramary[6]);
							break;
						}
					case 8:
						{
							netconnnetion.call(scommand, responder, paramary[0],
							paramary[1],
							paramary[2],
							paramary[3],
							paramary[4],
							paramary[5],
							paramary[6],
							paramary[7]);
							break;
						}
					case 9:
						{
							netconnnetion.call(scommand, responder, paramary[0],
							paramary[1],
							paramary[2],
							paramary[3],
							paramary[4],
							paramary[5],
							paramary[6],
							paramary[7],
							paramary[8]);
							break;
						}
					case 10:
						{
							netconnnetion.call(scommand, responder, paramary[0],
							paramary[1],
							paramary[2],
							paramary[3],
							paramary[4],
							paramary[5],
							paramary[6],
							paramary[7],
							paramary[8],
							paramary[9]);
							break;
						}
					default:
						{
							netconnnetion.call(scommand, responder,"paramerror");
							break;
						}
				}
			}
			
		}
		public function OnNetIOError(ioerror : IOErrorEvent):void
		{
			dispatchEvent(ioerror);
		}
	}

}