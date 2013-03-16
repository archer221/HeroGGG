package com.ui.controls {
	import com.ui.manager.CallBackFuntion;
	import com.frame.ExactTimer;
	import com.net.AssetData;
	import com.net.LibsManager;
	import com.net.RESManager;
	import com.ui.core.ScaleMode;
	import com.ui.core.UIComponent;
	import com.ui.data.IconData;
	import com.ui.manager.UIManager;
	import com.utils.BDUtil;
	import com.utils.ColorMatrixUtil;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.Point;
	import com.effects.CDEffect;

	/**
	 * @version 20100402
	 * @author Cafe
	 */
	public class Icon extends UIComponent {
		protected var _data : IconData;
		protected var _bitmap : Bitmap;
		protected var _bd : BitmapData;
		protected var _flipH : Boolean = false;
		protected var _offset : Point = new Point(0, 0);
		private var _cdEffect : CDEffect;
		private var _loadtimer : ExactTimer;
		private var _loadingsprite : Sprite;
		
		override public function dispose():void 
		{
			if ( _cdEffect != null )
			{
				_cdEffect.dispose();
			}
			_data = null;
			bitmapdata = null;
			_bitmap = null;
			_cdEffect = null;
			super.dispose();
		}
		
		override protected function create() : void {
			_bitmap = new Bitmap();
			var createbd : BitmapData;
			if (_data.asset) {
				createbd = BDUtil.getBD(_data.asset);
			} else {
				createbd = _data.bitmapData;
			}
			addChild(_bitmap);
			bitmapdata = createbd;
			_cdEffect = new CDEffect();
			_cdEffect.setSize(_data.width, _data.height);
			addChild(_cdEffect);
			_cdEffect.visible = false;
		}

		public function Icon(data : IconData) {
			_data = data;
			super(data);
		}
		
		public function ShowCD(bshow : Boolean):void
		{
			_cdEffect.visible = bshow;
		}
		
		public function SetCDRange(ivalue:int,imin:int, imax:int):void
		{
			_cdEffect.model.resetRange(ivalue, imin, imax);
			if ( ivalue < imax )
			{
				enabled = false;
			}
			else
			{
				enabled = true;
			}
		}
		
		public function SetCDValue(ivalue:int):void
		{
			_cdEffect.model.value = ivalue;
			if ( ivalue < _cdEffect.model.max )
			{
				enabled = false;
			}
			else
			{
				enabled = true;
			}
		}

		private var curloadasset : AssetData; 
		public function bitmapData(assetdata : AssetData):void
		{
			if ( _loadtimer == null )
			{
				_loadtimer = new ExactTimer(40,100);
			}
			curloadasset = assetdata;
			
			if (RESManager.IsLoaded(assetdata.libId))
			{
				bitmapdata = BDUtil.getBD(assetdata);
			}
			else
			{
				if ( _data.loadingsprte != null )
				{
					_loadingsprite = UIManager.getUI(_data.loadingsprte);
					addChild(_loadingsprite);
					
					var loadmc : MovieClip = _loadingsprite as MovieClip;
					if ( loadmc != null )
					{
						loadmc.play();
					}
				}

				
				RESManager.instance.add(LibsManager.Instance.GetLibData(curloadasset.libId).Loader);
				RESManager.instance.load( -1);
				_loadtimer.AddEventListenerEx(TimerEvent.TIMER,this, OnTimer);
				_loadtimer.start();
			}
		}
		
		private var callbackFun : CallBackFuntion;
		public function bitmmapDataCallback( asetdata : AssetData, callbackfunc : CallBackFuntion ):void
		{
			callbackFun = callbackfunc;
			if ( _loadtimer == null )
			{
				_loadtimer = new ExactTimer(40,100);
			}
			curloadasset = asetdata;
			
			if (RESManager.IsLoaded(asetdata.libId))
			{
				bitmapdata = callbackFun.ExecR();
			}
			else if (LibsManager.Instance.GetLibData(curloadasset.libId) != null)
			{
				if ( _data.loadingsprte != null )
				{
					_loadingsprite = UIManager.getUI(_data.loadingsprte);
					addChild(_loadingsprite);
					
					var loadmc : MovieClip = _loadingsprite as MovieClip;
					if ( loadmc != null )
					{
						loadmc.play();
					}
				}

				
				RESManager.instance.add(LibsManager.Instance.GetLibData(curloadasset.libId).Loader);
				RESManager.instance.load( -1);
				_loadtimer.AddEventListenerEx(TimerEvent.TIMER,this, OnTimer);
				_loadtimer.start();
			}
		}
		
		private function OnTimer(e : Event):void
		{
			if (RESManager.IsLoaded(curloadasset.libId))
			{
				if( _loadingsprite!= null )
					removeChild(_loadingsprite);
				if ( callbackFun != null )
				{
					bitmapdata = callbackFun.ExecR() as BitmapData;
				}
				else
				{
					bitmapdata = BDUtil.getBD(curloadasset);
				}
				
				_loadtimer.stop();
				_loadtimer.RemoveEventListenerEx(TimerEvent.TIMER,this, OnTimer);
			}
		}
		
		public function get bitmapdata():BitmapData
		{
			return _bd;
		}
		public function set bitmapdata(value : BitmapData) : void {
			_bd = value;
			if (_bd != null) {
				_bitmap.bitmapData = _bd;
				_bitmap.smoothing = true;
				if (_data.scaleMode == ScaleMode.AUTO_SIZE) {
					_width = _bd.width - 1;
					_height = _bd.height - 1;
				} else {
					_bitmap.width = _width;
					_bitmap.height = _height;
				}
			} else {
				_bitmap.bitmapData = null;
			}
			var scaleX : Number = (_bitmap.scaleX > 0 ? _bitmap.scaleX : -_bitmap.scaleX);
			if (_flipH) {
				_bitmap.scaleX = -scaleX;
				_bitmap.x = _offset.x + _bitmap.width;
			} else {
				_bitmap.scaleX = scaleX;
				_bitmap.x = _offset.x;
			}
		}

		public function set gray(value : Boolean) : void {
			filters = (value ? [new ColorMatrixFilter(ColorMatrixUtil.GRAY)] : null);
		}

		public function set offset(offset : Point) : void {
			_offset = offset.clone();
			_cdEffect.x = _bitmap.x = (_flipH ? _offset.x + _bitmap.width : _offset.x);
			_cdEffect.y = _bitmap.y = _offset.y;
		}

		public function setFlipH(value : Boolean) : void {
			_flipH = value;
		}

		public function clone() : Icon {
			var data : IconData = _data.clone();
			data.bitmapData = _bd;
			var icon : Icon = new Icon(data);
			return icon;
		}
	}
}