package com.EngFrameWork.EngObserver
{
	public class Notification implements INotification
	{
		/**
		 * Constructor. 
		 * 
		 * @param name name of the <code>Notification</code> instance. (required)
		 * @param body the <code>Notification</code> body. (optional)
		 * @param type the type of the <code>Notification</code> (optional)
		 */
		public function Notification( name:String, body:Object=null, type:String=null )
		{
			this.name = name;
			this.body = body;
			this.type = type;
		}
		
		/**
		 * Get the name of the <code>Notification</code> instance.
		 * 
		 * @return the name of the <code>Notification</code> instance.
		 */
		public function getName():String
		{
			return name;
		}
		
		/**
		 * Set the body of the <code>Notification</code> instance.
		 */
		public function setBody( body:Object ):void
		{
			this.body = body;
		}
		
		/**
		 * Get the body of the <code>Notification</code> instance.
		 * 
		 * @return the body object. 
		 */
		public function getBody():Object
		{
			return body;
		}
		
		/**
		 * Set the type of the <code>Notification</code> instance.
		 */
		public function setType( type:String ):void
		{
			this.type = type;
		}
		
		/**
		 * Get the type of the <code>Notification</code> instance.
		 * 
		 * @return the type  
		 */
		public function getType():String
		{
			return type;
		}
		
		/**
		 * Get the string representation of the <code>Notification</code> instance.
		 * 
		 * @return the string representation of the <code>Notification</code> instance.
		 */
		public function toString():String
		{
			var msg:String = "Notification Name: "+getName();
			msg += "\nBody:"+(( body == null )?"null":body.toString());
			msg += "\nType:"+(( type == null )?"null":type);
			return msg;
		}
		
		// the name of the notification instance
		private var name			: String;
		// the type of the notification instance
		private var type			: String;
		// the body of the notification instance
		private var body			: Object;
		
	}
}