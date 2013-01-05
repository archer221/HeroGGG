package com.key {
	import BZTC.UI.BztcUIManager;
	import com.model.Map;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.utils.Dictionary;

	/**
	 * @author Cafe
	 * @version 20100331
	 */
	public class HotKey {

		public static const K_A : uint = 65;

		public static const K_D : uint = 68;

		public static const K_W : uint = 87;

		public static const K_S : uint = 83;

		public static const K_E : uint = 69;

		public static const K_Q : uint = 81;

		public static const K_Z : uint = 90;

		public static const K_X : uint = 88;

		public static const K_C : uint = 67;
		
		public static const K_R : uint = 82;
		
		public static const K_V : uint = 86;
		
		public static const K_B : uint = 66;
		
		public static const K_N : uint = 78;

		public static const K_1 : uint = 49;

		public static const K_2 : uint = 50;

		public static const K_3 : uint = 51;

		public static const K_4 : uint = 52;

		public static const K_5 : uint = 53;

		public static const K_6 : uint = 54;

		public static const K_7 : uint = 55;

		public static const K_8 : uint = 56;
		
		public static const K_229 : uint = 229;
		
		public static const K_T : uint = 84;
		
		public static const K_Y : uint = 89;
		
		public static const K_U : uint = 85;
		
		public static const K_I : uint = 73;
		
		public static const K_O : uint = 79;
		
		public static const K_P : uint = 80;

		private var _owner : Stage;

		private var _active : Boolean;

		private var _filter : IKeyFliter;

		private var _dict : Dictionary;
		
		public var keyStateMap : Map = new Map();
		
		public function clearKeyState() : void
		{
			keyStateMap.clear();
			for each(var keydata : KeyData in _dict)
			{
				keydata.reset();
			}
		}

		private function keyDownHandler(event : KeyboardEvent) : void {
			//加入教程中关闭对话框事件！
			//if (event.keyCode == Keyboard.SPACE&&BztcUIManager.instance.IsShow("tutorial")) {
				//BztcUIManager.tutorial.hideTask();
			//}
			var keyCode : uint = _filter.convertKeyCode(event.keyCode);
			if (!keyStateMap.containsKey(keyCode))
				keyStateMap.put(keyCode, keyCode);
			var filter : Boolean = _filter.keyDownFliter(keyCode);
			var keyData : KeyData = _dict[keyCode];
			if(keyData == null || !keyData.active)return;
			keyData.onKeyDown(filter);
		}

		private function keyUpHandler(event : KeyboardEvent) : void {
			var keyCode : uint = _filter.convertKeyCode(event.keyCode);
			if (keyStateMap.containsKey(keyCode)) keyStateMap.removeBy(keyCode);
			var filter : Boolean = _filter.keyDownFliter(keyCode);
			var keyData : KeyData = _dict[keyCode];
			if(keyData == null || !keyData.active )return;
			keyData.onKeyUp(filter);
		}

		private function deactivateHandler(event : Event) : void {
			for each(var keyData:KeyData in _dict) {
				keyData.onKeyUp(false);
			}
		}

		public function HotKey(stage : Stage,filter : IKeyFliter) {
			_owner = stage;
			_filter = filter;
			_active = false;
			_dict = new Dictionary(false);
		}

		public function reset(keyCode : uint) : void {
			var data : KeyData = _dict[keyCode];
			if(data == null)return;
			data.reset();
		}

		public function set active(value : Boolean) : void {
			if(_active == value)return;
			_active = value;
			if(_active) {
				_owner.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
				_owner.addEventListener(KeyboardEvent.KEY_UP, keyUpHandler);
				_owner.addEventListener(Event.DEACTIVATE, deactivateHandler);
			} else {
				_owner.removeEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
				_owner.removeEventListener(KeyboardEvent.KEY_UP, keyUpHandler);
				_owner.removeEventListener(Event.DEACTIVATE, deactivateHandler);
			}
		}

		public function setHotKey(keyCode : uint,callback : Function,mode : int = 0) : void {
			if(callback == null) {
				delete _dict[keyCode];
			} else {
				_dict[keyCode] = new KeyData(keyCode, callback, mode);
			}
		}

		public function isKeyDown(keyCode : uint) : Boolean {
			var keyData : KeyData = _dict[keyCode];
			if(keyData == null)return false;
			return keyData.isKeyDown;
		}

		public function setActive(keyCode : uint,active : Boolean) : void {
			var keyData : KeyData = _dict[keyCode];
			if(keyData == null)return;
			keyData.active = active;
		}

		public function getActive(keyCode : uint) : Boolean {
			var keyData : KeyData = _dict[keyCode];
			if(keyData == null)return false;
			return keyData.active;
		}
	}
}