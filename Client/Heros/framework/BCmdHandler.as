package framework 
{
	import mx.core.ByteArrayAsset;
	/**
	 * ...
	 * @author ...
	 */
	public class BCmdHandler 
	{
		private var _obj : Object;
		private var _func : Function;
		public function BCmdHandler(obj : Object,func : Function) 
		{
			_obj = obj;
			_func = func;
		}
		
		public function get Obj():Object
		{
			return _obj;
		}
		public function get func():Object
		{
			return _func;
		}
		
		private var argary : Array = new Array();
		public function Exec(bcmd : BCommand):int
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