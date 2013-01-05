package com.pool {
	import com.log4a.Logger;
	import com.utils.GStringUtil;

	import flash.events.TimerEvent;
	import flash.utils.Dictionary;
	import flash.utils.Timer;

	/**
	 * CallPool
	 * 
	 * @author wingox
	 * @version 20100719
	 */
	public class CallPool {

		private var _callbacks : Dictionary;

		private var _list : Array;

		private var _timer : Timer;

		private function timerHandler(event : TimerEvent) : void {
			if(_list.length == 0) {
				_timer.stop();
				return;
			} else {
				execute(_list.shift());
			}
		}

		private function findAt(method : String,callback : Function) : int {
			var calls : Array = _callbacks[method];
			if(calls == null)return -1;
			var index : int = 0;
			for each(var call:Function in calls) {
				if(call == callback)return index;
				index++;
			}
			return -1;
		}

		private function execute(request : RequestData) : void {
			var calls : Array = _callbacks[request.method];
			if(calls == null || calls.length == 0) {
				Logger.warn(GStringUtil.format("{0} not found callbacks", request.method));
				return;
			}
			for each(var callback:Function in calls) {
				try {
					callback.apply(null, request.args);
				}catch(e : Error) {
					Logger.warn(request.toString(), request.args, e.getStackTrace());
				}
			}
		}

		public function CallPool() {
			_callbacks = new Dictionary(true);
			_list = new Array();
			_timer = new Timer(30);
			_timer.addEventListener(TimerEvent.TIMER, timerHandler);
		}

		public function getCallback(method : String) : Array {
			return _callbacks[method];
		}

		public function addCallback(method : String,callback : Function) : void {
			if(_callbacks[method] == null) {
				_callbacks[method] = [];
			}
			var index : int = findAt(method, callback);
			if(index == -1) {
				_callbacks[method].push(callback);
			}
		}

		public function removeCallback(method : String,callback : Function) : void {
			var index : int = findAt(method, callback);
			if(index != -1) {
				_callbacks[method].splice(index, 1);
			}
		}

		public function addRequest(request : RequestData) : void {
			if(request == null)return;
			_list.push(request);
			if(!_timer.running)_timer.start();
		}

		public function dispose() : void {
			while(_list.length > 0) {
				execute(_list.shift());
			}
			if(_timer.running) {
				_timer.stop();
			}
		}

		public function get messageSize() : int {
			return _list.length;
		}
	}
}