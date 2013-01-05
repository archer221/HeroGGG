package com.effects {
	import flash.display.Sprite;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	/**
	 * @version 20100115
	 * @author Cafe
	 */
	public class GEffect extends EventDispatcher implements IGEffect {

		public static const END : String = "end";

		protected var _delay : int;

		protected var _duration : int;

		protected var _target : Sprite;

		protected var _timer : Timer;
		
		protected var _boutertimer : Boolean = false;

		protected function onChangeTarget() : void {
		}

		protected function timerHandler(event : TimerEvent) : void {
		}

		public function GEffect(delay : int = 50,outertimer : Timer=null) {
			_delay = delay;
			if ( outertimer == null )
			{
				_timer = new Timer(_delay);
				_boutertimer = false;
			}
			else
			{
				_timer = outertimer;
				_boutertimer = true;
			}
			
			_duration = 0;
		}

		public function set target(value : Sprite) : void {
			_target = value;
			onChangeTarget();
		}

		public function set duration(value : int) : void {
			_duration = value;
		}

		public function start() : void {
			if(!_timer.running) {
				_timer.addEventListener(TimerEvent.TIMER, timerHandler);
				_timer.start();
			}
		}

		public function end() : void {
			if(_timer.running) {
				_timer.removeEventListener(TimerEvent.TIMER, timerHandler);
				_timer.stop();
			}
		}

		public function dispose() : void {
		}
	}
}
