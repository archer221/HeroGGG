package framework 
{
	import com.ui.manager.CallBackFuntion;
	/**
	 * ...
	 * @author ...
	 */
	public class LoadWaitCmd extends BCommand
	{
		public var _loadlibary : Array;
		public var _loadtype : int;
		public var _callback :CallBackFuntion;
		public function LoadWaitCmd(cmd:String,libsary :Array,loadtype : int,tcallback : CallBackFuntion) 
		{
			super(cmd);
			_loadlibary = libsary;
			_loadtype = loadtype;
			_callback = tcallback;
		}
		
	}

}