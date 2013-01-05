package com.ui.core 
{
	/**
	 * ...
	 * @author lizzardchen
	 */
	public class EventTargetCollect 
	{
		public var alistener : Object;
		public var func : Function;
		public var etype : String;
		public function EventTargetCollect(e : String,a : Object,f : Function) 
		{
			alistener = a;
			func = f;
			etype = e;
		}
		
	}

}