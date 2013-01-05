package com.net {
	import flash.events.EventDispatcher;

	/**
	 * @version 20000719
	 * @author thinkpad
	 */
	public class ALoader extends EventDispatcher {

		protected var _libData : LibData;

		protected var _loadData : LoadData;

		protected var _isLoadding : Boolean = false;

		protected var _isLoaded : Boolean = false;
		
		private var _Loadtick : int = 5;
		
		private var _cdnurl : String = "";
		public function set cndurl( cdn : String ):void
		{
			_cdnurl = cdn;
		}
		public function get cndurl():String
		{
			return _cdnurl;
		}

		public function reduceLoadTick():int
		{
			_Loadtick--;
			return _Loadtick;
		}
		
		public function ALoader(data : LibData) {
			_libData = data;
			_loadData = new LoadData();
			_loadData.Key = _libData.key;
		}

		public function get isLoaded() : Boolean {
			return _isLoaded;
		}
		public function get Seria() : int
		{
			return _libData.seria;
		}
		
		public function get libData():String
		{
			return _libData.url;
		}
		public function AddLibdataVersion():void
		{
			_libData.AddVersion();
		}

		public function get key() : String {
			return _libData.key;
		}

		public function get loadData() : LoadData {
			return _loadData;
		}
		
		public function load():void{
		}
		
		public function Dispose() : void {
		}
		public function update(elapsetime : int):void {
			
		}
	}
}
