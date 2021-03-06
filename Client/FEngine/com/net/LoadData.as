package com.net {
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.getTimer;

	/**
	 * @version 20090718
	 * @author Cafe
	 */
	public class LoadData extends EventDispatcher {

		private var _bytesLoaded : uint;

		private var _bytesTotal : uint;

		private var _startTime : int;

		private var _percent : int;
		
		private var _key : String;
		
		public function get Key() : String
		{
			return _key;
		}
		
		public function set Key(value : String) : void
		{
			_key = value;
		}

		public function LoadData() {
		}

		public function reset() : void {
			_percent = 0;
			_startTime = getTimer();
		}

		public function get bytes() : String {
			return int(_bytesLoaded / 1024) + "KB/" + int(_bytesTotal / 1024) + "KB";
		}

		public function get speed() : int {
			return _bytesLoaded / 1024 / (getTimer() - _startTime) * 1000;
		}

		public function calc(bytesLoaded : uint,bytesTotal : uint) : void {
			if(isNaN(bytesTotal) || bytesTotal == 0)return;
			_bytesLoaded = bytesLoaded;
			_bytesTotal = bytesTotal;
			var percent : int = 100 * (_bytesLoaded / _bytesTotal);
			if(_percent == percent)return;
			_percent = percent;
			dispatchEvent(new Event(Event.CHANGE));
		}

		public function get percent() : int {
			return _percent;
		}
	}
}
