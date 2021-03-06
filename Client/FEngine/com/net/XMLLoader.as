package com.net {
	import com.utils.GStringUtil;
	import flash.events.Event;
	import flash.system.System;


	com.utils.GStringUtil;


	/**
	 * @version 20100115
	 * @author Cafe
	 */
	public class XMLLoader extends RESLoader {

		private var _xml : XML;

		override protected function onComplete() : void {
			try {
				var s : String = _byteArray.readUTFBytes(_byteArray.length);
				_xml = new XML(s);
				_isLoadding = false;
				_isLoaded = true;
				_byteArray.clear();
				//Logger.info(this, GStringUtil.format("load {0} complete", _libData.url));
				dispatchEvent(new Event(Event.COMPLETE));
			}catch(e : TypeError) {
				onError(e.message);
			}
		}

		public function XMLLoader(data : LibData) {
			super(data);
		}

		public function getXML() : XML {
			return _xml;
		}
		
		override public function Dispose():void 
		{
			super.Dispose();
			if ( _xml != null )
			{
				System.disposeXML(_xml);
			}
		}
	}
}