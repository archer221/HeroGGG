package framework 
{
	import com.EngFrameWork.EngObserver.INotifier;
	import com.EngFrameWork.EngObserver.Notification;

	/**
	 * ...
	 * @author ...
	 */
	public class ICommand extends Notifier
	{
		public var _owner :Object;
		public function ICommand(owner:Object) 
		{
			
		}
		
		public function Exec(bcmd :Notification):int
		{
			return 0;
		}
	}

}