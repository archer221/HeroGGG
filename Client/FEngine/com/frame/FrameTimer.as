package com.frame {
	import flash.events.TimerEvent;

	/**
	 * Frame Timer
	 * @author wingox
	 * @version 20100531
	 */
	public class FrameTimer {

		private static var _timer : ExactTimer = new ExactTimer(20, 60, 0,true);

		private static var _list : Array = new Array();

		private static function timerHandler(event : TimerEvent) : void {
			if(_list.length == 0) {
				_timer.removeEventListener(TimerEvent.TIMER, timerHandler);
				_timer.stop();
				return;
			}
			for each(var frame:IFrame in _list) {
				frame.action();
			}
			event.updateAfterEvent();
			//FRateLimiter.limitFrame(16);
		}
		
		public static function clear() : void
		{
			_list.splice(0);
			if(_timer.running) {
				_timer.removeEventListener(TimerEvent.TIMER, timerHandler);
				_timer.stop();
			}
		}

		public static function add(frame : IFrame) : void {
			var index : int = _list.indexOf(frame);
			if(index == -1) {
				_list.push(frame);
				if(!_timer.running) {
					_timer.addEventListener(TimerEvent.TIMER, timerHandler);
					_timer.start();
				}
			}
		}
		
		public static function moveFront(frame : IFrame) : void
		{
			var index : int = _list.indexOf(frame);
			if (index != -1)
			{
				_list.splice(index, 1);
			}
			_list.unshift(frame);
		}

		public static function remove(frame : IFrame) : void {
			var index : int = _list.indexOf(frame);
			if(index == -1)return;
			_list.splice(index, 1);
			if(_list.length == 0 ) {
				if(_timer.running) {
					_timer.removeEventListener(TimerEvent.TIMER, timerHandler);
					_timer.stop();
				}
			}
		}

		public static function get running() : Boolean {
			return _timer.running ? true : _list.length > 0;
		}
	}
}
