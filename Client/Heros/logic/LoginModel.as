package logic 
{
	import flash.events.Event;
	import framework.BztcFacade;
	/**
	 * ...
	 * @author chenzhou
	 */
	public class LoginModel 
	{
		
		public function LoginModel() 
		{
			
		}
		public function connectserver():void
		{
			NetFacade.Instance.CallRemote("HeroService/logincontroller.Loginheros", OnLogin, onloginfaild, BztcFacade.Instance.bztcgame._digitalAccount, BztcFacade.Instance.bztcgame._ticket,"20130101");
		}
		public function OnLogin(str : Object):void
		{
			trace(str);
		}
		public function onloginfaild(e:Object):void
		{
			trace("login failed");
		}
		
	}

}