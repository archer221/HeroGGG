package com.net {
	import com.utils.GStringUtil;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.Event;


	com.utils.GStringUtil;


	public class PNGLoader extends RESLoader {

		private var _loader : Loader;

		override protected function onComplete() : void {
			_loader = new Loader();
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, completeHandler);
			_loader.loadBytes(_byteArray);
		}

		private function completeHandler(event : Event) : void {
			//Logger.info(this, GStringUtil.format("{0} load complete.", _libData.url));
			_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, completeHandler);
			_isLoadding = false;
			_isLoaded = true;
			dispatchEvent(new Event(Event.COMPLETE));
		}

		public function PNGLoader(data : LibData) {
			super(data);
		}

		public function getBitmapData() : BitmapData {
			var bitmap : Bitmap = _loader.contentLoaderInfo.content as Bitmap;
			return (bitmap == null) ? null : bitmap.bitmapData;
		}
	}
}