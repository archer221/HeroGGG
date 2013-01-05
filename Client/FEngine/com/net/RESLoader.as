package com.net {
	import com.utils.GStringUtil;
	import flash.errors.IOError;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import flash.net.URLStream;
	import flash.net.URLVariables;
	import flash.utils.ByteArray;


	com.utils.GStringUtil;



	/**
	 * @version 20100115
	 * @author Cafe
	 */
	public class RESLoader extends ALoader {

		protected var _stream : URLStream;

		protected var _byteArray : ByteArray;

		private function addStreamEvents() : void {
			_stream.addEventListener(ProgressEvent.PROGRESS, progressHandler);
			_stream.addEventListener(Event.COMPLETE, completeHandler);
			_stream.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
		}

		private function removeStreamEvents() : void {
			_stream.removeEventListener(ProgressEvent.PROGRESS, progressHandler);
			_stream.removeEventListener(Event.COMPLETE, completeHandler);
			_stream.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
		}

		private function ioErrorHandler(event : IOErrorEvent) : void {
			totalElaptime = 0;
			onError(event.text);
		}

		private function progressHandler(event : ProgressEvent) : void {
			totalElaptime = 0;
			trace(_libData.url + "  Loading : " + event.bytesLoaded + "Total : " + event.bytesTotal);
			try {
				_loadData.calc(event.bytesLoaded, event.bytesTotal);
			}
			catch( e : Error )
			{
				
			}
			
		}

		private function completeHandler(event : Event) : void {
			totalElaptime = 0;
			removeStreamEvents();
			_byteArray = new ByteArray();
			var length : int = _stream.bytesAvailable;
			_stream.readBytes(_byteArray, 0, length);
			_stream.close();
			onComplete();
		}

		protected function onComplete() : void {
			_isLoadding = false;
			_isLoaded = true;
			//Logger.info(this, GStringUtil.format("load {0} complete", _libData.url));
			dispatchEvent(new Event(Event.COMPLETE));
		}

		protected function onError(message : String) : void {
			removeStreamEvents();
			_isLoadding = _isLoaded = false;
			//Logger.error(GStringUtil.format("load {0} error!message={1}", _libData.url, message));
			var event : ErrorEvent = new ErrorEvent(ErrorEvent.ERROR);
			event.text = message; 
			dispatchEvent(event);
		}

		public function RESLoader(data : LibData) {
			super(data);
		}
		override public function load() : void {
			if(_isLoadding)return;
			if(_isLoaded)return;
			_isLoadding = true;
			_stream = new URLStream();
			addStreamEvents();
			_loadData.reset();
			var request : URLRequest = new URLRequest(cndurl + _libData.url);
			request.data = new URLVariables("version=" + _libData.version);
			try {
				_stream.load(request);
			}catch(e : IOError) {
				onError(e.message);
			}catch(e : SecurityError) {
				onError(e.message);
			}
		}

		public function getByteArray() : ByteArray {
			return _byteArray;
		}
		
		override public function Dispose():void 
		{
			if (_stream.connected)
			{
				removeStreamEvents();
				_stream.close();
			}
		}
		private var totalElaptime : int = 0;
		override public function update(elapsetime : int):void {
			if ( totalElaptime > 10000 )
			{
				onError("Can't DownLoad ,becase process equal 0");
				totalElaptime = 0;
			}
			totalElaptime += elapsetime;
		}
	}
}