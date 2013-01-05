package com.ui.controls {
	import com.model.ListModel;
	import com.model.SelectionModel;
	import com.net.AssetData;
	import com.ui.core.UIComponent;
	import com.ui.core.UIComponentData;
	import com.ui.layout.GLayout;
	import com.utils.BDUtil;
	import com.utils.GDrawUtil;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;


	/**
	 * @version 20100115
	 * @author Cafe
	 */
	public class Poster extends UIComponent {

		protected var _bitmap : Bitmap;

		protected var _border : Sprite;

		protected var _selectionModel : SelectionModel;

		protected var _model : ListModel;
		
		public static var _BackBack : BitmapData = BDUtil.BitmapCreator(1000, 600, true, 0xFF000000);;

		override public function dispose():void 
		{
			if ( _model != null )
			{
				_model.dispose();
			}
			if ( _selectionModel != null )
			{
				_selectionModel.dispose();
			}
			if ( _BackBack != null )
			{
				_BackBack.dispose();
			}
			_BackBack = null;
			_bitmap = null;
			_border = null;
			_selectionModel = null;
			_model = null;
			super.dispose();
		}
		
		override protected function create() : void {
			_bitmap = new Bitmap();
			addChild(_bitmap);
			_border = new Sprite();
			_border.mouseEnabled = _border.mouseEnabled = false;
			addChild(_border);
		}

		override protected function layout() : void {
			redrawBorder(_width, _height);
		}

		private function redrawBorder(w : int,h : int) : void {
			var g : Graphics = _border.graphics;
			g.clear();
			//GDrawUtil.drawFillBorder(g, 0x000000, 1, 0, 0, w, h);
		}

		private function selection_changeHandler(event : Event) : void {
			var bd : BitmapData = _model.getAt(_selectionModel.index) as BitmapData;
			if (bd == null)
			{
				var bgast : AssetData = _model.getAt(_selectionModel.index) as AssetData;
				if ( bgast != null )
				{
					if ( bgast.libId == "system" )
					{
						if (bgast.key == "BlackBack_system")
						{
							if ( _BackBack == null )
							{
								_BackBack = BDUtil.BitmapCreator(_width, _height, true, 0xFF000000);
							}
							bd = _BackBack;
						}
					}
					else
					{
						bd = BDUtil.cutBDData(bgast,_width,_height).getBDUnit(0).bd;
					}
				}
				else
				{
					return;
				}
			}
			_bitmap.bitmapData = BDUtil.getResizeBD(bd, _width, _height);
			_bitmap.smoothing = true;
		}

		override protected function onShow() : void {
			GLayout.layout(this);
		}

		public function Poster(base : UIComponentData) {
			super(base);
			_selectionModel = new SelectionModel();
			_selectionModel.AddEventListenerEx(Event.CHANGE,this, selection_changeHandler);
			_model = new ListModel();
		}

		public function get selectionModel() : SelectionModel {
			return _selectionModel;
		}

		public function get model() : ListModel {
			return _model;
		}
	}
}