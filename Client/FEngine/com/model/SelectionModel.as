﻿package com.model {
	import com.ui.core.EventDispatcherEx;
	import flash.events.Event;
	import flash.events.EventDispatcher;

	/**
	 * Selection Model
	 * @author Cafe
	 * @version 20100430
	 */
	public class SelectionModel extends EventDispatcherEx {

		private var _index : int;

		public function SelectionModel() {
			_index = -1;
		}
		public function dispose():void
		{
			ClearEvents();
		}
		public function set index(value : int) : void {
			if(_index == value)return;
			_index = value;
			dispatchEvent(new Event(Event.CHANGE));
		}

		public function get index() : int {
			return _index;
		}

		public function get isSelected() : Boolean {
			return _index != -1;
		}
	}
}