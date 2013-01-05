package framework 
{
	/**
	 * ...
	 * @author chenzhou
	 */
	public class FKPPInfoCode 
	{
		
		public function FKPPInfoCode() 
		{
			
		}

		//Global System Info
		public static var SystemSkipEvent : int = 			  10001; 
		public static var SystemWaitSuspend : int =		  	  10002;
		public static var SystemStopSuspend : int =			  10003;
		public static var SystemIgnoreSuspend : int =	      10004;
		public static var LoadFileFailed : int = 			  10005;
		
		public static var NONE : int =                        0;
		public static var LoginError : int = 				  1;
		public static var AccountNotExist : int = 			  2;
		public static var PwdError : int = 					  3;
		public static var UnKnownError : int =                4;
		public static var ServerClosed:int = 				  5;
		
		public static var InfoCodeArray : Array = new Array();
		public static function Init():void
		{
			
		}
	}

}