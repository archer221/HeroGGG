package framework 
{
	import com.ui.manager.CallBackFuntion;
	/**
	 * ...
	 * @author ...
	 */
	public class BInfoCommand extends BCommand 
	{
		public var _infocode : int;
		public var _sender : Object;
		public var _flag : int;
		public var _showtype : int;
		public var _callback:CallBackFuntion;
		public var _sInfo : String = null;
		public function BInfoCommand(tcmd:String,iinfocode : int,sender: Object,tflag: int,tshowtype : int,callbackfunc:CallBackFuntion) 
		{
			super(tcmd);
			_infocode = iinfocode;
			_sender = sender;
			_flag = tflag;
			_showtype = tshowtype;
			_callback = callbackfunc;
		}
	}

}