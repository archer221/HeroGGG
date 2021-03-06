package com.net
{
	import com.lib.LIBDecoder;
	import flash.events.Event;
	
	/**
	 * @version 20090712
	 * @author Cafe
	 */	
	public class LIBLoader extends RESLoader
	{
		private var _decoder:LIBDecoder;
		
		override protected function onComplete():void{
			_decoder=new LIBDecoder(_byteArray);
			_decoder.addEventListener(Event.COMPLETE,onLIBDecoderComplete);
		}
		
		private function onLIBDecoderComplete(event:Event):void{
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		public function LIBLoader(data:LibData){
			super(data);
		}
		
		public function get decoder():LIBDecoder{
			return _decoder;
		}
	}
}