package com.effects 
{
	import com.effects.easing.GTween;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	import flash.utils.Timer;

	import flash.events.TimerEvent;
	/**
	 * ...
	 * @author lizzardchen
	 */
	public class GGlowEffect extends GTweenEffect 
	{
		
		private var _waitDelay : int;
		private var _wait : uint;
		protected var glowwidth : int = 0;
		private var _startglow : int  = 0;
		private var _endglow : int = 0;
		
		private var _bstoped : Boolean = true;
		
		public function GGlowEffect(glowW : int ,outertimer : Timer) 
		{
			glowwidth = glowW;
			_startglow = 0;
			_endglow = glowW;
			super(outertimer);
			duration = 20;
			_waitDelay = 0;
			if ( outertimer != null )
			{
				_boutertimer = true;
			}
			else
			{
				_boutertimer = false;
			}
		}
		
		override protected function timerHandler(event:TimerEvent):void 
		{
			if ( _bstoped )
			{
				_target["GlowWidth"] = 0;
				return;
			}
			if(!_tween.isEnd) {
				_target["GlowWidth"] = _tween.next();
				return;
			}
			if ( _target["GlowWidth"] == glowwidth )
			{
				_startglow = glowwidth;
				_endglow = 0;
			}
			else
			{
				_startglow = 0;
				_endglow = glowwidth;
			}
			start();
		}
		public function stop()
		{
			_timer.stop();
			dispatchEvent(new Event(END));
			_bstoped = true;
			if ( _target != null )
			{
				_target["GlowWidth"] = 0;
			}
		}
		override public function start():void 
		{
			if(_target == null)return;
			if(_wait != 0) {
				clearTimeout(_wait);
				_wait = 0;
			}
			if(!_boutertimer&&_timer.running) {
				_timer.stop();
			}

			StartGlow();
		}
		
		public function StartGlow()
		{
			if(_wait != 0) {
				clearTimeout(_wait);
				_wait = 0;
			}
			_tween.duration = _duration;
			_tween.init(_startglow, _endglow);
			_bstoped = false;
			if( !_boutertimer )
				_timer.start();
			
		}
	}

}