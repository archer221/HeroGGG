package framework 
{
	import com.EngFrameWork.EngObserver.Notification;
	
	import mx.core.ByteArrayAsset;

	/**
	 * ...
	 * @author ...
	 */
	public class BSimpleCmd extends ICommand
	{
		private var _obj : Object;
		private var _func : Function;
		public function BSimpleCmd(obj : Object,func : Function) 
		{
			super(obj);
			_func = func;
		}
		
		public function get Obj():Object
		{
			return _owner;
		}
		public function get func():Object
		{
			return _func;
		}
		
		private var argary : Array = new Array();
		override public function Exec(bcmd :Notification):int
		{
			var result : int = 0;
			if ( _obj != null && _func != null )
			{
				argary.splice(0);
				argary.push(bcmd);
				result = _func.apply(_obj,argary);
			}
			return result;
		}
		
	}

}