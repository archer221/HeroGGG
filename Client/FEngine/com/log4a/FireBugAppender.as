package com.log4a
{
	import flash.external.ExternalInterface;
	
	public final class FireBugAppender extends Appender
	{
		public function FireBugAppender(){
			_formatter=new SimpleLogFormatter();
		}
		
		override public function append(data:LoggingData):void{
			if(!ExternalInterface.available)return;
			var methodName:String=data.level.name.toString().toLowerCase();
			if(methodName=="fatal")methodName="error";
			var message:String=_formatter.format(data);
			ExternalInterface.call("console."+methodName,message);
		}
	}
}