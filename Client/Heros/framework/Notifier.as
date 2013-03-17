package framework
{
	import com.EngFrameWork.EngObserver.INotifier;
	import com.EngFrameWork.EngObserver.Notification;

	public class Notifier implements INotifier
	{
		/**
		 * Create and send an <code>INotification</code>.
		 * 
		 * <P>
		 * Keeps us from having to construct new INotification 
		 * instances in our implementation code.
		 * @param notificationName the name of the notiification to send
		 * @param body the body of the notification (optional)
		 * @param type the type of the notification (optional)
		 */ 
		public function sendNotification( notificationName:String, body:Object=null, type:String=null ):void 
		{
			facade.SendNotification(new Notification( notificationName, body, type ));
		}
		
		// Local reference to the Facade Singleton
		protected var facade:BztcFacade = BztcFacade.Instance;
	}
}