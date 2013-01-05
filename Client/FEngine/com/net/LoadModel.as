package com.net {
	import flash.events.Event;
	import flash.events.EventDispatcher;

	public class LoadModel extends EventDispatcher {

		public static const MAX : int = 5;

		protected var _list : Array;

		protected var _done : int;

		protected var _total : int;

		protected var _speed : int;

		protected var _progress : int;
		
		public var LoadType : int = 0;

		protected function changeHandler(event : Event) : void {
			var count : int = 0;
			var speed : int = 0;
			for each(var data:LoadData in _list) {
				count += data.percent;
				speed += data.speed;
			}
			var progress : int = count + _done * 100;
			if(_progress == progress)return;
			_progress = progress;
			_speed = speed / _list.length;
			dispatchEvent(new Event(Event.CHANGE));
		}

		public function LoadModel() {
			_list = new Array();
		}

		public function hasFree() : Boolean {
			return _list.length < MAX;
		}

		public function add(data : LoadData) : void {
			if(_list.length >= MAX)return;
			_list.push(data);
			data.addEventListener(Event.CHANGE, changeHandler);
		}

		public function remove(data : LoadData) : void {
			data.removeEventListener(Event.CHANGE, changeHandler);
			var index : uint = _list.indexOf(data);
			if (index != -1)
			{
				_list.splice(index, 1);
				_done++;
			}
		}

		public function reset(value : int) : void {
			_progress = 0;
			_total = value;
			_done = 0;
			_list.splice(0);
			_speed = 0;
			dispatchEvent(new Event(Event.INIT));
		}

		public function end() : void {
			dispatchEvent(new Event(Event.COMPLETE));
		}

		public function get progress() : int {
			return _progress;
		}

		public function get speed() : int {
			return _speed;
		}

		public function get total() : int {
			return _total * 100;
		}
		
		public function isEmpty() : Boolean
		{
			return _list.length == 0;
		}
		
		public function get LoadingFile() : String
		{
			if (isEmpty()) return "";
			return _list[0].Key;
		}
		
		public function get Done() : int 
		{
			return _done;
		}
		
		public function get LoadPercent() : int
		{
			if (isEmpty()) return 100;
			return _list[0].percent;
		}
	}
}