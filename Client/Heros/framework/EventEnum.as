package framework 
{
	/**
	 * ...
	 * @author chenzhou
	 */
	public class EventEnum 
	{
		
		public function EventEnum() 
		{
			
		}
		//loading
		public static const load_startLoading : String = "10001";
		public static const load_faild		  : String = "10002";
		public static const load_Completed	  : String = "10003";
		public static const load_OK			  : String = "10004";
		public static const load_rolecreatorOK: String = "10005";
		public static const load_mainwindowOK : String = "10006";
		public static const load_Wait 	 	  : String = "10007";
		
		//system
		public static const SystemStopSuspend : String = "50001";
		public static const EventInfo : String = "50002";
		public static const HideInfo : String = "50003";
	}

}