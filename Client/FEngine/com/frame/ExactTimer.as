package com.frame {
	import com.ui.core.EventDispatcherEx;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.utils.getTimer;

	/**
	 * @author BrightLi
	 * @version 20100401
	 */
	public class ExactTimer extends EventDispatcherEx {

		public var _timer : Timer;

		private var _repeat : int;

		private var _currentCount : int;

		private var _time : int;

		private var _offset : int;

		public var _tick : int;
		
		public var _bHoldOffset : Boolean = false;
		
		public function dispose():void
		{
			ClearEvents();
			stop();
		}
		
		protected function GetFrameCount() : int
		{
			var frameCount : int = 1;
			var time : int = getTimer();
			var delta : int = time - _time;
			_offset += delta;
			frameCount = _offset / _tick;
			frameCount = frameCount != 0 ? frameCount : 1;
			_time = getTimer();
			return frameCount;
		}

		private function timerHandler(event : TimerEvent) : void {
			var frames = GetFrameCount();
			
			while ( frames > 0 )
			{
				if (_offset >= _tick) {
					_offset -= _tick;
					_currentCount++;
					if(_repeat > 0 && _currentCount > _repeat) {
						stop();
						return;
					}
					dispatchEvent(new TimerEvent(TimerEvent.TIMER));
				}
				frames--;
			}
		}

		public function ExactTimer(delay : int,tick : int,repeat : int = 0,bHoldOffset : Boolean = false) {
			_repeat = repeat;
			_timer = new Timer(delay);
			_tick = tick;
			_bHoldOffset = bHoldOffset;
			//TimerManager.Register(this);
		}

		public function get running() : Boolean {
			return _timer.running;
		}

		public function get currentCount() : int {
			return _currentCount;
		}

		public function start() : void {
			if(_timer.running)return;
			_offset = 0;
			_time = getTimer();
			_timer.addEventListener(TimerEvent.TIMER, timerHandler);
			_currentCount = 0;
			_timer.reset();
			_timer.start();
		}

		public function stop() : void {
			if(!_timer.running)return;
			_timer.removeEventListener(TimerEvent.TIMER, timerHandler);
			_timer.stop();
		}
	}
}
