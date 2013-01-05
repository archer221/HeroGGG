package com.sound {
	import com.log4a.Logger;
	import flash.events.EventDispatcher;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;

	/**
	 * Sound Item
	 * 
	 * @author BrightLi
	 * @version 20100712
	 */
	public final class SoundItem extends EventDispatcher {

		private var _sound : Sound;

		private var _channel : SoundChannel;

		private var _volume : Number;

		private var _time : Number;

		private function soundCompleteHandler(event : Event) : void {
			_channel = null;
			_time = 0;
			dispatchEvent(new Event(Event.SOUND_COMPLETE));
		}

		public function SoundItem(sound : Sound = null) : void {
			_sound = (sound == null ? new Sound() : sound);
			_time = 0;
		}

		public function get channel() : SoundChannel {
			return _channel;
		}

		public function get url() : String {
			return _sound.url;
		}

		public function load(stream : URLRequest) : void {
			if(_channel != null) {
				stop();
			}
			_sound = new Sound();
			_sound.addEventListener(IOErrorEvent.IO_ERROR, OnIOError);
			_sound.load(stream);
			
		}
		
		private function OnIOError(event : Event) : void
		{
			
		}

		public function play(value : Number = -1) : void {
			if(_channel != null || _sound == null)return;
			_channel = _sound.play(_time);
			volume = (value == -1 ? _volume : value);
			if ( _channel != null )
			{
				_channel.addEventListener(Event.SOUND_COMPLETE, soundCompleteHandler);	
				_channel.addEventListener(IOErrorEvent.IO_ERROR, OnIOError);
			}
			
		}

		public function pause() : void {
			if(_channel == null)return;
			_channel.removeEventListener(Event.SOUND_COMPLETE, soundCompleteHandler);
			_channel.removeEventListener(IOErrorEvent.IO_ERROR, OnIOError);
			_channel.stop();
			_time = _channel.position;
			_channel = null;
		}

		public function stop() : void {
			if(_channel == null) {
				return;
			}
			_channel.removeEventListener(Event.SOUND_COMPLETE, soundCompleteHandler);
			_channel.removeEventListener(IOErrorEvent.IO_ERROR, OnIOError);
			_channel.stop();
			_channel = null;
			if (_sound.url != null) {
				try
				{
					if (_sound.bytesLoaded < _sound.bytesTotal)
						_sound.close();
				}
				catch (e : Error)
				{
					Logger.debug("sound close error!");
				}
			}
			_sound = null;
			_time = 0;
			
		}

		public function set volume(value : Number) : void {
			_volume = value;
			if(_channel == null) {
				return;
			}
			var transform : SoundTransform = _channel.soundTransform;
			transform.volume = _volume;
			_channel.soundTransform = transform;
		}

		public function get volume() : Number {
			return _volume;
		}
	}
}
