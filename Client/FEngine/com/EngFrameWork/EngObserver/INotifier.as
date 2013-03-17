package com.EngFrameWork.EngObserver
{
	public interface INotifier
	{
		/**
		 * Send a <code>INotification</code>.
		 * 
		 * <P>
		 * Convenience method to prevent having to construct new 
		 * notification instances in our implementation code.</P>
		 * 
		 * @param notificationName the name of the notification to send
		 * @param body the body of the notification (optional)
		 * @param type the type of the notification (optional)
		 */ 
		function sendNotification( notificationName:String, body:Object=null, type:String=null ):void; 
		
	}
}