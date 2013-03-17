package NotifyBody
{
	import com.EngFrameWork.EngObserver.INotifyBody;
	import com.ui.manager.CallBackFuntion;
	
	public class LoadWaitBody implements INotifyBody
	{
		public var _loadlibary :Array;
		public var _loadtype : int;
		public var _callback :CallBackFuntion;
		public function LoadWaitBody(libsary :Array,loadtype : int,tcallback : CallBackFuntion)
		{
			_loadlibary = libsary;
			_loadtype = loadtype;
			_callback = tcallback;
		}
		
		public function Init():void
		{
		}
	}
}