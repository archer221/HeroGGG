package com.bd {
	import com.effects.GPropertyEffect;
	import com.net.AssetData;
	import com.utils.BDUtil;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Point;


	/**
	 * @version 20091201
	 * @author Cafe
	 */
	public class BDFont extends Sprite {

		private var _chars : Array;

		private var _width : int;

		private var _height : int;

		private var _leading : int;

		private var _bdData : BDData;

		private var _bitmap : Bitmap;

		private var _source : Object;
		
		public function BDFont(source : AssetData,chars : Array,width : int,height : int,leading : int = 0) {
			_chars = chars;
			_width = width;
			_height = height;
			_leading = leading;
			_bdData = BDUtil.cutBDData(source, _width, _height);
			_bitmap = new Bitmap();
			addChild(_bitmap);
		}

		public function set text(value : String) : void {
			var width : int = _width + _leading;
			var bd : BitmapData = BDUtil.BitmapCreator(value.length * width - _leading, _height, true, 0);
			for(var i : int = 0;i < value.length;i++) {
				var unit : String = value.charAt(i);
				var index : int = _chars.indexOf(unit);
				if(index != -1) {
					var cut : BitmapData = _bdData.getBDUnit(index).bd;
					bd.copyPixels(cut, cut.rect, new Point(i * width, 0), null, null, true);
				}
			}
			_bitmap.bitmapData = bd;
		}

		override public function get width() : Number {
			return _bitmap.width;
		}

		override public function get height() : Number {
			return _bitmap.height;	
		}

		public function set source(value : *) : void {
			_source = value;
		}

		public function get source() : * {
			return _source;
		}

		public var gproperEffect : GPropertyEffect;
		private var _fntscale : Number = 0.8;
		private var _backscale : Number = 0.8;
		private var _backX : Number;
		private var _backY : Number;
		public function set FontScale(scale : Number):void
		{
			_fntscale = scale;
			scaleX = _fntscale;
			scaleY = _fntscale;
			this.x = _backX - (scaleX - _backscale) * width * 0.5;
			this.y = _backY - (scaleY - _backscale) * height * 0.5;
		}
		public function get FontScale():Number
		{
			return _fntscale;
		}
		protected var _bstarted :Boolean = false;
		public function HaveStartEffect():Boolean
		{
			return _bstarted;
		}
		public function StopEffect():void
		{
			if ( gproperEffect != null )
			{
				gproperEffect.stop();
			}
			FontScale = 1;
			_bstarted = false;
		}
		public function StartEffect(startscale : Number):void
		{
			if ( gproperEffect == null )
			{
				gproperEffect = new GPropertyEffect("FontScale", 18, startscale, _backscale, 0);
				_backX = this.x;
				_backY = this.y;
			}
			else
			{
				gproperEffect.SetInitValue("FontScale", 18, startscale,_backscale);
			}
			gproperEffect.target = this;
			gproperEffect.start();
			_bstarted = true;
		}
		
		public function clear() : void {
			if(_bitmap.bitmapData) {
				_bitmap.bitmapData.dispose();
				_bitmap.bitmapData = null;
			}
		}
	}
}
