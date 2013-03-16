package com.ui.controls {
	import com.ui.manager.CallBackFuntion
	import com.bd.BDData;
	import com.bd.BDUnit;
	import com.core.IDispose;
	import com.frame.ExactTimer;
	import com.net.AssetData;
	import com.net.LibData;
	import com.net.LibsManager;
	import com.net.RESManager;
	import com.ui.core.UIComponent;
	import com.ui.core.UIComponentData;
	import com.ui.manager.UIManager;
	import flash.display.Bitmap;
	import flash.display.BlendMode;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;


	/**
	 * BD Player
	 * 
	 * @author Cafe
	 * @version 20100726
	 */
	public class BDPlayer extends UIComponent implements IDispose {

		private var _bitmap : Bitmap;

		private var _data : BDData;

		private var _timer : ExactTimer;

		private var _frame : int;

		private var _frames : Array;

		private var _index : int;

		private var _count : int;

		private var _loop : int;
		private var _backBlendMode : String;
		
		private var _loadsprite : Sprite;
		
		public var loadasset : AssetData;
		
		private var _loadtimer : ExactTimer;
		
		public function get bdData() : BDData
		{
			return _data;
		}

		override protected function create() : void {
			_bitmap = new Bitmap();
			addChild(_bitmap);
			_backBlendMode = _bitmap.blendMode;
		}

		override protected function onHide() : void {
			super.onHide();
			stop();
		}
		
		public function SetBlendMode( smode: String ) : void
		{
			if ( _bitmap != null )
			{
				_bitmap.blendMode = smode;
			}
		}
		public function PopBlendMode():void
		{
			if ( _bitmap != null )
			{
				_bitmap.blendMode = _backBlendMode;
			}
		}
		
		private function timerHandler(event : TimerEvent) : void {
			if(_index == _frames.length) {
				_index = 0;
				if(_loop > 0) {
					_count++;
					if(_count == _loop) {
						_timer.stop();
						_timer.removeEventListener(TimerEvent.TIMER, timerHandler);
						dispatchEvent(new Event(Event.COMPLETE));
						return;
					}
				}
			}
			goto(_frames[_index]);
			_index++;
		}

		private function goto(frame : int) : void {
			if(frame < 0 || frame >= _data.total) {
				_frame = -1;
				_bitmap.bitmapData = null;
				return;
			}
			if(_frame == frame)return;
			_frame = frame;
			var unit : BDUnit = _data.getBDUnit(_frame);
			_bitmap.x = unit.offset.x;
			_bitmap.y = unit.offset.y;
			_bitmap.bitmapData = unit.bd;
			_bitmap.smoothing = true;
		}

		public function BDPlayer(base : UIComponentData) {
			super(base);
			_timer = new ExactTimer(80, 80);
			_frame = -1;
		}

		override public function dispose() : void {
			stop();
			if(_data != null) {
				_data.dispose();
			}
		}
		public function setbdData( data : BDData):void
		{
			setBDData(data);
		}
		private var callbackFun : CallBackFuntion;
		private var tobeloadAsetary : Array;
		private var bloadOK : Boolean = true;
		public function setbdAssetArray( asetary : Array,callbackfunc : CallBackFuntion):void
		{
			bloadOK = false;
			callbackFun = callbackfunc;
			tobeloadAsetary = asetary;
			var tobeloadlib : Array = new Array();
			for each( var aset : AssetData in tobeloadAsetary )
			{
				tobeloadlib.push(aset.libId);
			}
			tobeloadAsetary.splice(0);
			tobeloadAsetary = RESManager.instance.CheckLoad(tobeloadlib);
			if ( tobeloadAsetary.length > 0 )
			{
				for each( var libdata : LibData in tobeloadAsetary )
				{
					RESManager.instance.add(libdata.Loader);
				}
				RESManager.instance.load( -1);
				
				if ( _base.loadingsprte != null )
				{
					_loadsprite = UIManager.getUI(_base.loadingsprte);
					addChild(_loadsprite);	
					var loadmc : MovieClip = _loadsprite as MovieClip;
					if( loadmc != null )
						loadmc.play();
				}
				
				
				if ( _loadtimer == null )
				{
					_loadtimer = new ExactTimer(40, 100);
				}
				_loadtimer.AddEventListenerEx(TimerEvent.TIMER, this, OnTimer);
				_loadtimer.start();
			}
			else
			{
				if ( callbackFun != null )
				{
					setBDData(callbackFun.ExecR() as BDData);
					bloadOK = true;
				}
				
			}
		}
		
		private function OnTimer(e : Event) :void
		{
			if ( tobeloadAsetary == null ) 
			{
				bloadOK = true;
				_loadtimer.stop();
				_loadtimer.RemoveEventListenerEx(TimerEvent.TIMER, this, OnTimer);
				return;
			}
			var loadok : Boolean = true;
			for each( var asetdata : LibData in tobeloadAsetary )
			{
				var curres : Boolean = RESManager.IsLoaded(asetdata.key);
				loadok = loadok && curres;
			}
			if ( loadok )
			{
				bloadOK = true;
				_loadtimer.stop();
				_loadtimer.RemoveEventListenerEx(TimerEvent.TIMER, this, OnTimer);
				if ( callbackFun != null )
				{
					setBDData(callbackFun.ExecR() as BDData);
					play(loadbackdelay, loadbackframes, loadbackloop, loadbackistart);
				}
				
			}
		}
		
		private function setBDData(data : BDData) : void {
			_data = data;
			_frame = -1;
			_bitmap.bitmapData = null;
			if ( _data == null )
			{
				_timer.stop();
			}
		}

		/**
		 * play bd
		 * 
		 * @delay int default=80(0.08s)
		 * @frames Array
		 * @loop int 0 n
		 */
		private var loadbackdelay : int = 0;
		private var loadbackframes : Array;
		private var loadbackloop : int;
		private var loadbackistart : int;
		private var bstartback : Boolean = false;
		public function play(delay : int = 80, frames : Array = null, loop : int = 1, istart: int = 0) : void {
			if ( !bloadOK )
			{
				loadbackdelay = delay;
				loadbackframes = frames;
				loadbackloop = loop;
				loadbackistart = istart;
				bstartback = true;
				return;
			}
			bstartback = false;
			if(_data == null) {
				return;
			}
			stop();
			_frames = frames;
			if(_frames == null) {
				_frames = new Array();
				for(var i : int = 0;i < _data.total;i++) {
					_frames.push(i);
				}
			}
			if(_frames.length < 2) {
				frame = _frames[0];
			} else {
				if ( istart >= _frames.length || istart < 0 )
				{
					istart = 0;
				}
				_index = istart;
				_count = 0;
				_loop = loop;
				_timer._timer.delay = delay;
				_timer._tick = delay;
				goto(_frames[_index++]);
				_timer.addEventListener(TimerEvent.TIMER, timerHandler);
				//_timer.reset();
				_timer.start();
			}
		}

		public function stop() : void {
			if(_timer.running) {
				_timer.stop();
				_timer.removeEventListener(TimerEvent.TIMER, timerHandler);
			}
		}

		public function set frame(frame : int) : void {
			if(_data == null)return;
			stop();
			goto(frame);
		}

		public function get frame() : int {
			return _frame;
		}

		public function get total() : int {
			return _data.total;
		}

		public function set flipH(value : Boolean) : void {
			scaleX = (value ? -1 : 1);
		}

		public function get hasNext() : Boolean {
			if(!_data)return false;
			return (_frame < _data.total - 1);
		}

		public function next() : void {
			frame = _frame + 1;
		}

		public function clone() : BDPlayer {
			var data : UIComponentData = _base.clone();
			var bd : BDPlayer = new BDPlayer(data);
			bd.moveTo(x, y);
			bd.scaleX = scaleX;
			bd.rotation = rotation;
			bd.setBDData(_data);
			bd.frame = 0;
			return bd;
		}
	}
}