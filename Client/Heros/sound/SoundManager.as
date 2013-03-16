package sound {
	import com.model.Map;
	import com.net.AssetData;
	import com.net.RESManager;
	import com.sound.SettingData;
	import com.sound.SoundItem;
	import com.utils.MathUtil;
	import flash.utils.getTimer;
	import com.net.LibsManager;
	import flash.events.Event;
	import flash.media.Sound;
	import flash.net.URLRequest;
	import framework.*;

	/**
	 * ...
	 * @author cYiXiuTing
	 */
	public class SoundManager {

		public static const MUSIC_IDS : Array = [0,1,2,3,4,5,6,7,8,9,10];

		private var _music : SoundItem;

		private var _list : Array;

		private var _check : Boolean;

		private var _musicIsOpen : Boolean;

		private var _soundIsOpen : Boolean;
		
		private var _soundKeyMap : Map = new Map();

		private var settindata :SettingData;
		
		private var soundlibkey : String;
		
		public var CDNUrl:String = "";
		
		private function music_completeHandler(event : Event) : void {
			loadAndPlayMusic();
		}

		private function sound_completeHandler(event : Event) : void {
			var soundItem : SoundItem = SoundItem(event.target);
			var index : int = _list.indexOf(soundItem);
			if(index != -1) {
				_list.splice(index, 1);
			}
		}
		
		public function setSettinData( setdata : SettingData ):void
		{
			settindata = setdata;
		}
		
		public function setSoundLibKey( key : String ):void
		{
			soundlibkey = key;
		}
		
		public function SoundManager() {
			_music = new SoundItem();
			_music.addEventListener(Event.SOUND_COMPLETE, music_completeHandler);
			_list = new Array();
			_check = true;
		}

		public function reset() : void {
			_musicIsOpen = settindata.musicIsOpen;
			_soundIsOpen = settindata.soundIsOpen;
		}

		public function set check(value : Boolean) : void {
			_check = value;
		}

		public function loadAndPlayMusic() : void {
			if(_check && !settindata.musicIsOpen) {
				return;
			}else if(!_musicIsOpen) {
				return;
			}
			if(_music.channel != null) {
				return;
			}
			//var id : int = MUSIC_IDS[MathUtil.random(0, MUSIC_IDS.length - 1)];
			//_music.load(new URLRequest("musics/" + id + ".mp3"));
			_music.play(settindata.musicVolume);
		}
		
		public function PlayMusic(url : String) : void
		{
			if (url == null) {
				_music.stop();
				return;
			}
			if (_check && !settindata.musicIsOpen) {
				return;
			}else if(!_musicIsOpen) {
				return;
			}
			if(_music.channel != null) {
				_music.stop();
			}
			_music.load(new URLRequest(CDNUrl + url));
			_music.play(settindata.musicVolume);
		}

		public function get music() : SoundItem {
			return _music;
		}

		public function playSound(key : String, volumePercent : Number = 1.0) : SoundItem {
			if(_check && !settindata.soundIsOpen) {
				return null;
			}
			if(!_soundIsOpen) {
				return null;
			}
			var sound : Sound = RESManager.getSound(new AssetData(key, LibsManager.Instance.soundsLib.key));
			if(sound == null) {
				return null;
			}
			if (!_soundKeyMap.containsKey(key))
				_soundKeyMap.put(key, 0);
			var nowPlayTime : int = getTimer();
			if ((nowPlayTime - _soundKeyMap.getBy(key)) < 400) return null;
			_soundKeyMap.put(key, nowPlayTime);
			var item : SoundItem = new SoundItem(sound);
			item.play(BztcModel.settingData.soundVolume * volumePercent);
			item.addEventListener(Event.SOUND_COMPLETE, sound_completeHandler);
			_list.push(item);
			return item;
		}

		public function set musicIsOpen(value : Boolean) : void {
			_musicIsOpen = value;
			if(_musicIsOpen) {
				if(_music.url == null) {
					loadAndPlayMusic();
				} else {
					_music.play();
				}
			} else {
				_music.pause();
			}
		}

		public function set soundIsOpen(value : Boolean) : void {
			_soundIsOpen = value;
			for each(var soundItem:SoundItem in _list) {
				if(value) {
					soundItem.play();
				} else {
					soundItem.stop();
				}
			}
		}

		public function set soundVolume(value : Number) : void {
			for each(var soundItem:SoundItem in _list) {
				soundItem.volume = value;
			}
		}
	}
}
