package com.frame 
{
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author 
	 */
	public class TimerManager 
	{
		public static var timerList : Dictionary = new Dictionary(true);
		
		public static function Register(timer : ExactTimer) : void
		{
			timerList[timer] = 0;
		}
	}

}