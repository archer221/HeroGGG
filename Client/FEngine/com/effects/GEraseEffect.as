package com.effects 
{
	import flash.geom.Rectangle;
	import com.effects.easing.GTween;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;

	/**
	 * ...
	 * @author lizzardchen
	 */
	public class GEraseEffect extends GTweenEffect 
	{
		protected var iAnchorPnt : int = 0;
		protected var bFadeIn : Boolean = false;
		protected var StartWidth : int = 0;
		protected var EndWidth : int = 0;
		protected var _wait : int = 0;
		protected var _iTargetWidth : int = 0;
		protected var _iTargetHeight : int = 0;
		protected var _x : int = 0;
		protected var _y : int = 0;
		
		public function GEraseEffect(tancorPnt : int , istart : int,iend : int ,iTargetwidth : int ,itargetheight : int,fadein:Boolean,xoffset : int = 0,yoffset:int = 0,duration : int = 20) 
		{
			super();
			iAnchorPnt = tancorPnt;
			bFadeIn = fadein;
			StartWidth = istart;
			EndWidth = iend;
			_duration = duration;
			_iTargetHeight = itargetheight;
			_iTargetWidth = iTargetwidth;
			_x = xoffset;
			_y = yoffset;
			_tween = new GTween();
		}
		
		
		private function startFade() : void {
			if(_wait != 0) {
				clearTimeout(_wait);
				_wait = 0;
			}
			_tween.duration = _duration;
			
			_target.scrollRect = new Rectangle(0, 0, _iTargetWidth, _iTargetHeight);
			
			switch( iAnchorPnt )
			{
				case 0://center
				{
					break;
				}
				case 1://left;
				{
					_target.scrollRect = new Rectangle(_x, _y, StartWidth, _iTargetHeight);
					break;
				}
				case 2://top
				{
					_target.scrollRect = new Rectangle(_x, _y, _iTargetWidth, StartWidth);
					break;
				}
				case 3://right
				{
					_target.scrollRect = new Rectangle(EndWidth-_x, -_y, StartWidth, _iTargetHeight);
					break;
				}
				case 4://bottom
				{
					_target.scrollRect = new Rectangle(-_x, EndWidth-_y, _iTargetWidth, StartWidth);
					break;
				}
			}
			
			_target.alpha = 1;
			
			_tween.init(StartWidth, EndWidth);
			_timer.start();
		}
		
		override public function start() : void {
			if(_target == null)return;
			if(_wait != 0) {
				clearTimeout(_wait);
				_wait = 0;
			}
			if(_timer.running) {
				_timer.stop();
			}
			if(_delay > 0) {
				_wait = setTimeout(startFade, 100);
			} else {
				startFade();
			}
		}
		
		
		override protected function timerHandler(event : TimerEvent) : void {
			if (!_tween.isEnd) {
				switch( iAnchorPnt )
				{
					case 1:
					{
						_target.scrollRect = new Rectangle(_x +_iTargetWidth - _tween.next(), _y, _tween.next(), _iTargetHeight);
						break;
					}
					case 3:
					{
						_target.scrollRect = new Rectangle(-_iTargetWidth + _tween.next()-_x, -_y, _tween.next(), _iTargetHeight);
						break;
					}
					case 2:
					{
						_target.scrollRect = new Rectangle(_x, _y+_iTargetWidth - _tween.next(),_iTargetWidth,_tween.next());
						break;
					}
					case 4:
					{
						_target.scrollRect = new Rectangle(-_x,  _tween.next() - _iTargetHeight -_y,_iTargetWidth,_tween.next());
						break;
					}
				}
				
				return;
			}
			_target.scrollRect = null;
			if ( bFadeIn )
			{
				
				_target.alpha = 1;
			}
			else
			{
				_target.alpha = 0;
			}
			_timer.stop();
			dispatchEvent(new Event(END));
		}
		
	}

}