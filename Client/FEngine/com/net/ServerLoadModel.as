package com.net 
{
	import com.frame.ExactTimer;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.getTimer;
	import framework.LoadTypeEnum;
	/**
	 * ...
	 * @author ...
	 */
	public class ServerLoadModel extends LoadModel 
	{
		private var _timer : ExactTimer;
		public function ServerLoadModel(tick : int = 50000) 
		{
			super();
			LoadType = LoadTypeEnum.ServerLoad;
			_total = tick;
			_timer = new ExactTimer(50, 100);
			_timer.addEventListener(TimerEvent.TIMER, changeHandler);
		}
		
		private var _nowtime : int = 0;
		private var _elapsetime : int = 0;
		override protected function changeHandler(event :Event) : void {
			var nowtime : int = getTimer();
			if (_nowtime == 0)
			{
				_nowtime = nowtime;
			}
			var elapstime : int = nowtime - _nowtime;
			
			_speed = elapstime;
			_progress = _elapsetime;
			_elapsetime += elapstime;
			_nowtime = nowtime;
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		override public function hasFree() : Boolean {
			return _list.length < MAX;
		}

		override public function add(data : LoadData) : void {
			if(_list.length >= MAX)return;
			_list.push(data);
			data.addEventListener(Event.CHANGE, changeHandler);
		}

		override public function remove(data : LoadData) : void {
			data.removeEventListener(Event.CHANGE, changeHandler);
			var index : uint = _list.indexOf(data);
			if (index != -1)
			{
				_list.splice(index, 1);
				_done++;
			}
		}

		override public function reset(value : int) : void {
			_progress = 0;
			_total = value;
			_done = 0;
			_list.splice(0);
			_speed = 0;
			dispatchEvent(new Event(Event.INIT));
			if ( _timer != null )
			{
				_timer.start();
			}
		}

		override public function end() : void {
			_done = 1;
			if ( _timer != null )
			{
				_timer.stop();
				_timer.removeEventListener(TimerEvent.TIMER, changeHandler);
			}
			dispatchEvent(new Event(Event.COMPLETE));
		}

		override public function get progress() : int {
			return _progress;
		}

		override public function get speed() : int {
			return _speed;
		}

		override public function get total() : int {
			return _total;
		}
		
		override public function isEmpty() : Boolean
		{
			return _elapsetime > _total;
		}
		
		override public function get LoadingFile() : String
		{
			return "";
		}
		
		override public function get Done() : int 
		{
			return _done;
		}
		
		override public function get LoadPercent() : int
		{
			if (isEmpty()) return 100;
			return (progress / _total) * 100;
		}
		
	}

}