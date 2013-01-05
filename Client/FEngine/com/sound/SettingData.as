package com.sound {

	/**
	 * Setting Data
	 * 
	 * @author 
	 * @version 20100712
	 */
	public class SettingData {

		private var _musicIsOpen : Boolean;

		private var _musicVolume : Number;

		private var _soundIsOpen : Boolean;

		private var _soundVolume : Number;

		public function SettingData() {
			_musicIsOpen = true;
			_musicVolume = 0.3;
			_soundIsOpen = true;
			_soundVolume = 0.6;
		}

		public function set musicIsOpen(value : Boolean) : void {
			_musicIsOpen = value;
		}

		public function get musicIsOpen() : Boolean {
			return _musicIsOpen;
		}

		public function set musicVolume(value : Number) : void {
			_musicVolume = value;
		}

		public function get musicVolume() : Number {
			return _musicVolume;
		}

		public function set soundIsOpen(value : Boolean) : void {
			_soundIsOpen = value;
		}

		public function get soundIsOpen() : Boolean {
			return _soundIsOpen;
		}

		public function set soundVolume(value : Number) : void {
			_soundVolume = value;
		}

		public function get soundVolume() : Number {
			return _soundVolume;
		}

		public function toObject() : Object {
			var result : Object = new Object();
			result.musicIsOpen = _musicIsOpen;
			result.musicVolume = _musicVolume;
			result.soundIsOpen = _soundIsOpen;
			result.soundVolume = _soundVolume;
			return result;
		}

		public function parseObj(value : Object) : void {
			if(value == null)return;
			_musicIsOpen = value.musicIsOpen;
			_musicVolume = value.musicVolume;
			_soundIsOpen = value.soundIsOpen;
			_soundVolume = value.soundVolume;
		}
	}
}
