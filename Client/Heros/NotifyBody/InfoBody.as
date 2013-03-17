package NotifyBody
{
	import com.EngFrameWork.EngObserver.INotifyBody;
	import com.ui.manager.CallBackFuntion;
	
	public class InfoBody implements INotifyBody
	{
		public var _infocode : int;
		public var _sender : Object;
		public var _flag : int;
		public var _showtype : int;
		public var _callback:CallBackFuntion;
		public var _sInfo : String = null;
		public function InfoBody(iinfocode : int,sender: Object,tflag: int,tshowtype : int,callbackfunc:CallBackFuntion)
		{
			_infocode = iinfocode;
			_sender = sender;
			_flag = tflag;
			_showtype = tshowtype;
			_callback = callbackfunc;
		}
		
		public function Init():void
		{
		}
	}
}