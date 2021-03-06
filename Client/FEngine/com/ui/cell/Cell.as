﻿package com.ui.cell {
	import com.utils.GFilterUtil;
	import com.bd.BDData;
	import com.bd.BDUnit;
	import com.ui.controls.Icon;
	import com.ui.controls.Label;
	import com.ui.core.Align;
	import com.ui.core.PhaseState;
	import com.ui.core.ScaleMode;
	import com.ui.core.UIComponent;
	import com.ui.data.LabelData;
	import com.ui.layout.GLayout;
	import com.ui.manager.UIManager;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;


	/**
	 * Game Cell
	 * 
	 * @author Cafe
	 * @version 20100730
	 */
	public class Cell extends UIComponent {

		public static const SELECT : String = "select";

		public static const SINGLE_CLICK : String = "singleClick";

		public static const DOUBLE_CLICK : String = "doubleClick";
		
		public static const CELL_RESIZE : String = "cellResize";

		protected var _data : CellData;

		protected var _upSkin : Sprite;

		protected var _overSkin : Sprite;

		protected var _selected_upSkin : Sprite;

		protected var _selected_overSkin : Sprite;

		protected var _disabledSkin : Sprite;

		protected var _lockIcon : Icon;

		protected var _key_lb : Label;

		protected var _selected : Boolean = false;

		protected var _current : Sprite;

		protected var _timer : Timer;

		protected var _count : int;

		protected var _ctrlKey : Boolean = false;

		protected var _shiftKey : Boolean = false;

		protected var _phase : int = PhaseState.UP;

		protected var _rollOver : Boolean = false;
		
		protected var _innerID : int;
		
		protected var _logicparent : UIComponent;
		
		public function set InnerID( iid : int ): void {
			_innerID = iid;
		}
		
		public function get InnerID():int {
			return _innerID;
		}

		public function SetLogicParent(p : UIComponent):void
		{
			_logicparent = p;
		}
		
		override protected function create() : void {
			_upSkin = UIManager.getUI(_data.upAsset);
			_overSkin = UIManager.getUI(_data.overAsset);
			_selected_upSkin = UIManager.getUI(_data.selected_upAsset);
			_selected_overSkin = UIManager.getUI(_data.selected_overAsset);
			_disabledSkin = UIManager.getUI(_data.upAsset);//UIManager.getUI(_data.disabledAsset);
			_disabledSkin.filters = [GFilterUtil.GrayFilter()];
			_current = _upSkin;
			addChild(_current);
			_data.lockIconData.parent = this;
			_lockIcon = new Icon(_data.lockIconData);
			addKeyLabel();
			switch(_data.scaleMode) {
				case ScaleMode.SCALE_WIDTH:
					_height = _upSkin.height;
					break;
				case ScaleMode.SCALE_NONE:
					_width = _upSkin.width;
					_height = _upSkin.height;
					break;
			}
		}

		protected function addKeyLabel() : void {
			if(_data.hotKey == null)return;
			var data : LabelData = new LabelData();
			data.text = _data.hotKey;
			data.textColor = 0xFFFFFF;
			data.textFieldFilters = UIManager.getEdgeFilters(0x000000, 0.9);
			data.align = new Align(-1, 3, 2, -1, -1, -1);
			_key_lb = new Label(data);
			addChild(_key_lb);
		}

		override protected function layout() : void {
			_upSkin.width = _width;
			_upSkin.height = _height;
			if(_overSkin != null) {
				_overSkin.width = _width;
				_overSkin.height = _height;
			}
			if(_selected_upSkin != null) {
				_selected_upSkin.width = _width;
				_selected_upSkin.height = _height;
			}
			if(_selected_overSkin != null) {
				_selected_overSkin.width = _width;
				_selected_overSkin.height = _height;
			}
			if(_disabledSkin != null) {
				_disabledSkin.width = _width;
				_disabledSkin.height = _height;
			}
			GLayout.layout(_key_lb);
		}

		override protected function onEnabled() : void {
			if(!_enabled && _timer.running)_timer.stop();
			viewSkin();
		}

		override protected function onShow() : void {
			if(_data.allowDoubleClick) {
				_count = 0;
				_timer.addEventListener(TimerEvent.TIMER, timerHandler);
				addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
				addEventListener(MouseEvent.CLICK, clickHandler);
			} else {
				addEventListener(MouseEvent.CLICK, singleClickHandler);
			}
			addEventListener(MouseEvent.ROLL_OVER, rollOverHandler);
			addEventListener(MouseEvent.ROLL_OUT, rollOutHandler);
			addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
		}

		override protected function onHide() : void {
			if(_data.allowDoubleClick) {
				if(_timer.running)_timer.stop();
				_timer.removeEventListener(TimerEvent.TIMER, timerHandler);
				removeEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
				removeEventListener(MouseEvent.CLICK, clickHandler);
			} else {
				removeEventListener(MouseEvent.CLICK, singleClickHandler);
			}
			removeEventListener(MouseEvent.ROLL_OVER, rollOverHandler);
			removeEventListener(MouseEvent.ROLL_OUT, rollOutHandler);
			removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			_phase = PhaseState.UP;
			viewSkin();
		}

		protected function viewSkin() : void {
			if (!_enabled) {
				if(selected) {
				} else {
					_current = swap(_current, _disabledSkin);
				}
			}else if(_phase == PhaseState.UP) {
				if(_selected) {
					_current = swap(_current, _selected_upSkin);
				} else {
					_current = swap(_current, _upSkin);
				}
			}else if (_phase == PhaseState.OVER) {
				if(_selected) {
					_current = swap(_current, _selected_overSkin);
				} else {
					_current = swap(_current, _overSkin);
				}
			}else if(_phase == PhaseState.DOWN) {
				if(_selected) {
				} else {
				}
			}
			dispatchEvent(new Event(Cell.SELECT));
		}

		protected function rollOverHandler(event : MouseEvent) : void {
			if(!_enabled)return;
			_rollOver = true;
			_phase = PhaseState.OVER;
			viewSkin();
		}

		protected function rollOutHandler(event : MouseEvent) : void {
			if(!_enabled)return;
			_rollOver = false;
			_phase = PhaseState.UP;
			viewSkin();
		}

		protected function mouseUpHandler(event : MouseEvent) : void {
			if(!_enabled)return;
			_phase = (_rollOver ? PhaseState.OVER : PhaseState.UP);
			viewSkin();
		}

		protected function timerHandler(event : TimerEvent) : void {
			if (!_timer.running) return;
			_count = 0;
			onSingleClick();
		}

		protected function mouseDownHandler(event : MouseEvent) : void {
			if(!_enabled)return;
			if(_timer.running)_timer.stop();
		}

		protected function clickHandler(event : MouseEvent) : void {
			_ctrlKey = event.ctrlKey;
			_shiftKey = event.shiftKey;
			if (_count == 1) {
				if(_timer.running) {
					_timer.stop();
				}
				onDoubleClick();
				_count = 0;
				
			} else {
				_count++;
				_timer.reset();
				_timer.start();
			}
		}

		protected function singleClickHandler(event : MouseEvent) : void {
			_ctrlKey = event.ctrlKey;
			_shiftKey = event.shiftKey;
			onSingleClick();
		}

		protected function onSingleClick() : void {
			if(_data.allowSelect && _data.clickSelect) {
				if(!_selected) {
					selected = true;
				}
			}
			dispatchEvent(new Event(Cell.SINGLE_CLICK));
		}

		protected function onDoubleClick() : void {
			if(_data.allowSelect && _data.clickSelect) {
				if(!_selected) {
					selected = true;
				}
			}
			//onSingleClick();
			dispatchEvent(new Event(Cell.DOUBLE_CLICK));
		}

		protected function onSelected() : void {
			// this is abstract function
		}

		public function Cell(data : CellData) {
			_timer = new Timer(150, 1);
			_data = data;
			super(data);
			lock = _data.lock;
		}

		public function set selected(value : Boolean) : void {
			if(_selected == value)return;
			_selected = value;
			viewSkin();
			onSelected();
			if(_selected)dispatchEvent(new Event(Cell.SELECT));
		}

		public function get selected() : Boolean {
			return _selected;
		}

		public function set lock(value : Boolean) : void {
			if(value) {
				_lockIcon.show();
				GLayout.layout(_lockIcon);
			} else {
				_lockIcon.hide();
			}
		}
		
		public function get isLocked() : Boolean
		{
			return _lockIcon != null && _lockIcon.parent != null;
		}

		public function get ctrlKey() : Boolean {
			return _ctrlKey;
		}

		public function get shiftKey() : Boolean {
			return _shiftKey;
		}

		public function get data() : CellData {
			return _data;
		}

		public function clone() : Cell {
			var cell : Cell = new Cell(_data.clone());
			cell.source = _source;
			return cell;
		}
		
		public function OnScrollRectShow():void
		{
			if ( _source == null ) return;
		}
	}
}
