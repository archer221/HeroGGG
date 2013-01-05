package com.effects 
{
	import com.effects.easing.GTween;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;

	import flash.events.TimerEvent;
	/**
	 * ...
	 * @author lizzardchen
	 */
	public class GPropertyEffect extends GTweenEffect 
	{
		private var _waitDelay : int;
		private var _wait : uint;
		protected var property : String;
		protected var _startvalue : Number;
		protected var _endvalue : Number;
		private var _bstoped : Boolean = true;
		public function GPropertyEffect(prop : String,dur : int,startv : Number,endvaule : Number,waitdeleay : int) 
		{
			super();
			property = prop;
			duration = dur;
			_waitDelay = waitdeleay;
			_startvalue = startv;
			_endvalue = endvaule;
		}
		public function SetInitValue( prop : String, dur :int, startv:Number, endv:Number )
		{
			property = prop;
			duration = dur;
			_startvalue = startv;
			_endvalue = endv;
		}
		
		override protected function timerHandler(event:TimerEvent):void 
		{
			if ( _bstoped )
			{
				_target[property] = _endvalue;
				return;
			}
			if(!_tween.isEnd) {
				_target[property] = _tween.next();
				return;
			}
			stop();
		}
		public function stop()
		{
			_timer.stop();
			dispatchEvent(new Event(END));
			_bstoped = true;
		}
		override public function start():void 
		{
			if(_target == null)return;
			if(_wait != 0) {
				clearTimeout(_wait);
				_wait = 0;
			}
			if(_timer.running) {
				_timer.stop();
			}
			if(_delay > 0) {
				_wait = setTimeout(starteffect, _waitDelay);
			} else {
				starteffect();
			}
		}
		
		public function starteffect()
		{
			if(_wait != 0) {
				clearTimeout(_wait);
				_wait = 0;
			}
			_tween.duration = _duration;
			_tween.init(_startvalue,_endvalue);
			_bstoped = false;
			_timer.start();
			
		}
		
	}

}