package com.net {
	import com.frame.IFrame;
	import com.utils.DictionaryUtil;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.media.Sound;
	import flash.sampler.NewObjectSample;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	import flash.utils.Timer;
	import mx.core.ByteArrayAsset;

	com.utils.DictionaryUtil;


	/**
	 * @version 20100115
	 * @author Cafe
	 */
	public class RESManager extends EventDispatcher implements IFrame  {
		public static const SWF_TYPE : int = 0;

		public static const XML_TYPE : int = 1;
		
		public static const LoadFileFailed : String = "LOADFILEFAILED";

		private static var _creating : Boolean = false;

		private static var _instance : RESManager;

		private static var _list : Array = new Array;

		private static var _wait : Dictionary = new Dictionary(true);

		private static var _loaded : Dictionary = new Dictionary(true);

		private var _model : LoadModel;
		
		public var CDNUrl : String = "";

		private function init() : void {
			_model = new LoadModel();
		}
		
		public static function IsLoaded( keystr : String ):Boolean
		{
			if ( _loaded[ keystr ] == null )
			{
				return false;
			}
			return true;
		}

		private function HaveNoCurStepInWait():Boolean
		{
			if ( loadstep == -1 )
			{
				return DictionaryUtil.isEmpty(_wait);
			}
			else
			{
				for each( var loader : ALoader in _wait )
				{
					if ( loader.Seria == loadstep )
					{
						return false;
					}
				}
			}
			return true;
		}
		
		private function HaveNoCurStep():Boolean
		{
			if ( loadstep == -1 ) 
			{
				if ( _list.length > 0 )
				{
					return false;
				}
				return true;	
			}
			else
			{
				for each( var loader : ALoader in _list )
				{
					if ( loader.Seria == loadstep )
					{
						return false;
					}
				}
			}
			
			return true;
		}
		private var lasttime : int = 0;
		public function action():void
		{	
			var now : int = getTimer();
			if ( lasttime == 0 )
			{
				lasttime = now;
			}
			Update(now - lasttime);
			lasttime = now;
		}
		public  function Update(elapsetime : int) :void
		{
			for each( var loader : ALoader in currentLoadDict )
			{
				loader.update(elapsetime);
			}
		}
		private var currentLoadDict : Dictionary = new Dictionary(true);
		private function loadNext() : void {
			var loader : ALoader;
			while(_model.hasFree()) {
				if (_list.length == 0) return;
				if ( HaveNoCurStep() ) return;
				loader = ALoader(_list.shift());
				if ( loader.Seria != loadstep && loadstep != -1)
				{
					_list.push(loader);
					continue;
				}
				var str:String = loader.libData.toString();
				trace(str + "加载开始");
				_model.add(loader.loadData);
				currentLoadDict[str] = loader;
				loader.addEventListener(Event.COMPLETE, completeHandler);
				loader.addEventListener(ErrorEvent.ERROR, errorHandler);
				loader.load();
			}
		}

		private function completeHandler(event : Event) : void {
			var loader : ALoader = ALoader(event.target);
			loader.removeEventListener(Event.COMPLETE, completeHandler);
			loader.removeEventListener(ErrorEvent.ERROR, errorHandler);
			var str:String = loader.libData.toString();
			delete currentLoadDict[str];
			trace(str + "加载完成");
			_model.remove(loader.loadData);
			delete _wait[loader.key];
			_loaded[loader.key] = loader;
			if( (loadstep == -1 && _list.length > 0) || (loadstep != -1 &&!HaveNoCurStep())) {
				loadNext();
			}else if((loadstep == -1&&DictionaryUtil.isEmpty(_wait)) || (loadstep != -1&&HaveNoCurStepInWait())) {
				_model.end();
				//Logger.info("RESManager load all done");
				dispatchEvent(new Event(Event.COMPLETE));
			}
		}
		private var loadstatics : int = 0;
		private function errorHandler(event : ErrorEvent) : void {
			loadstatics++;
			var loader : ALoader = ALoader(event.target);
			var leftTick : int = loader.reduceLoadTick();
			loader.removeEventListener(Event.COMPLETE, completeHandler);
			loader.removeEventListener(ErrorEvent.ERROR, errorHandler);
			var str:String = loader.libData.toString();
			delete currentLoadDict[str];
			_model.remove(loader.loadData);
			delete _wait[loader.key];
			if ( leftTick > 0 )
			{
				add( loader );
				if (_list.length > 0) {
					loader.AddLibdataVersion();
					loadNext();
				}else if((loadstep == -1&&DictionaryUtil.isEmpty(_wait)) || (loadstep != -1&&!HaveNoCurStep())) {
					_model.end();
					//Logger.info("RESManager load all done");
					dispatchEvent(new Event(Event.COMPLETE));
				}
			}
			else
			{
				dispatchEvent(new Event(LoadFileFailed));
			}
		}

		public function RESManager() {
			if(!_creating) {
			}
			init();
		}

		public static function get instance() : RESManager {
			if(_instance == null) {
				_creating = true;
				_instance = new RESManager();
				_creating = false;
			}
			return _instance;
		}

		public static function getMC(asset : AssetData) : MovieClip {
			var loader : SWFLoader = _loaded[asset.libId] as SWFLoader;
			if(!loader) {
				return null;
			}
			return loader.getMovieClip(asset.className);
		}
		
		public static function getSound(asset:AssetData):Sound{
			var loader : SWFLoader = _loaded[asset.libId] as SWFLoader;
			if(loader==null) {
				return null;
			}
			return loader.getSound(asset.className);
		}

		public static function getXML(key : String) : XML {
			var loader : XMLLoader = _loaded[key] as XMLLoader;
			if(loader == null)return null;
			return loader.getXML();
		}

		public static function getMp3(key : String) : Sound {
			var loader : MP3Loader = _loaded[key] as MP3Loader;
			if(loader == null)return null;
			return loader.getSound();
		}

		public static function getByteArray(key : String) : ByteArray {
			var loader : RESLoader = _loaded[key] as RESLoader;
			if(loader == null)return null;
			return loader.getByteArray();
		}

		public function add(loader : ALoader) : void {
			var key : String = loader.key;
			loader.cndurl = CDNUrl;
			if(loader.isLoaded) {
				_loaded[key] = loader;
				return;
			}
			if(_loaded[key] != null)return;
			if(_wait[key] != null)return;
			_list.push(loader);
			_wait[key] = loader;
			return;
		}

		public function get model() : LoadModel {
			return _model;
		}
		protected function get CurLoadLenth():int 
		{
			if ( loadstep == -1 ) 
			{
				return _list.length;
			}
			else
			{
				var loadlen : int = 0;
				for each( var loader : ALoader in _list )
				{
					if ( loader.Seria == loadstep )
					{
						loadlen++;
					}
				}
				return loadlen;
			}
			return 0;
		}
		protected var loadstep : int = -1;
		public function load(step : int) : void {
			loadstep = step;
			if((_list.length == 0 || HaveNoCurStep()) && _model.isEmpty()) {
				_model.end();
				dispatchEvent(new Event(Event.COMPLETE));
				return;
			}
			_model.reset(CurLoadLenth);
			loadNext();
		}
		
		public static function disposeLoader(key : String) : void
		{
			var loader : ALoader = _loaded[key] as ALoader;
			if (loader == null) return;
			instance._model.remove(loader.loadData);
			loader.removeEventListener(Event.COMPLETE, instance.completeHandler);
			loader.removeEventListener(ErrorEvent.ERROR, instance.errorHandler);
			loader.Dispose();
			delete _loaded[key];
			_loaded[key] = null;
		}
		
		public function CheckLoad( loadary : Array ):Array
		{
			if ( loadary.length <= 0 ) return new Array();
			var notloadary : Array = new Array();
			for each( var lname : String in loadary )
			{
				if ( !RESManager.IsLoaded(lname) )
				{
					var libdata : LibData = LibsManager.Instance.GetLibData(lname);
					if( libdata != null )
						notloadary.push(libdata);
				}
			}
			return notloadary;
		}
	}
}