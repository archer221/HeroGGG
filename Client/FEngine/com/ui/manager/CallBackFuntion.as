package com.ui.manager 
{
	/**
	 * ...
	 * @author ...
	 */
	public class CallBackFuntion 
	{
		private var _loadOKFunc : Function;
		private var _paramary : Array = new Array();
		private var _obj : Object;
		public var result : *
		public function CallBackFuntion(func : Function ,obj : Object,ary : Array) 
		{
			_loadOKFunc = func;
			_paramary.push(ary);
			_obj = obj;
		}
		public function setparam( ary : Array ):void 
		{
			_paramary.splice(0);
			_paramary.push(ary);
		}
		public function Exec():void
		{
			if ( _loadOKFunc != null )
			{
				if ( _obj != null )
				{
					_loadOKFunc.apply(_obj, _paramary);
				}
				else
				{
					_loadOKFunc.call(_paramary);
				}
			}
		}
		public function ExecR():*
		{
				if ( _obj != null )
				{
					return _loadOKFunc.apply(_obj, _paramary);
				}
				else
				{
					return _loadOKFunc.call(_paramary);
				}
			return null;
		}
		
	}

}