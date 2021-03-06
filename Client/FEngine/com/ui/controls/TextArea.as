﻿package com.ui.controls {
	import com.ui.core.UIComponent;
	import com.ui.data.ScrollBarData;
	import com.ui.data.TextAreaData;
	import com.ui.events.GScrollBarEvent;
	import com.ui.manager.UIManager;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.system.Capabilities;
	import flash.system.IME;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFieldType;
    import com.net.AssetData;
    import com.ui.core.ScaleMode;
	import com.ui.skin.SkinStyle;
	/**
	 * Game Text Area
	 * 
	 * @author Cafe
	 * @version 20100727
	 */
	public class TextArea extends UIComponent {

		protected var _data : TextAreaData;

		protected var _backgroundSkin : Sprite;

		protected var _textField : TextField;

		protected var _vScrollBar : ScrollBar;

		protected var _hScrollBar : ScrollBar;

		protected var _textWidth : Number;

		protected var _textHeight : Number;

		protected var _lock : Boolean = false;

		override protected function create() : void {
			_backgroundSkin = UIManager.getUI(_data.backgroundAsset);
			_textField = UIManager.getTextField();
			_textField.x = _textField.y = _data.padding;
			_textField.multiline = true;
			_textField.wordWrap = true;
			_textField.condenseWhite = true;
			_textField.maxChars = _data.maxChars;
			_textField.defaultTextFormat = _data.textFormat;
			_textField.textColor = _data.textColor;
			_textField.filters = _data.textFieldFilters;
			if(_data.editable) {
				_textField.styleSheet = null;
				_textField.type = TextFieldType.INPUT;
			} else {
				_textField.type = TextFieldType.DYNAMIC;
				_textField.styleSheet = _data.styleSheet;
			}
			_textField.selectable = _data.selectable;
			
			
			var data : ScrollBarData = _data.scrooldata.clone();
			
			data.visible = false;
			data.direction = ScrollBarData.VERTICAL;
			_vScrollBar= new ScrollBar(data);
			data = _data.scrooldata.clone();
			data.direction = ScrollBarData.HORIZONTAL;
			data.visible = false;
			_hScrollBar = new ScrollBar(data);
			addChild(_backgroundSkin);
			addChild(_textField);
			addChild(_vScrollBar);
			addChild(_hScrollBar);
		}
 
		override protected function layout() : void {
			_backgroundSkin.width = _width;
			_backgroundSkin.height = _height;
			
			_textField.width = _width - _data.padding * 2;
			_textField.height = _height - _data.padding * 2;
			_vScrollBar.x = _width - _data.padding- _vScrollBar.width;
			_vScrollBar.y = _data.padding;
			_hScrollBar.x = _data.padding;
			_hScrollBar.y = _height - _data.padding - _hScrollBar.height;
			reset();
		}

		override protected function onShow() : void {
			reset();
			_textField.addEventListener(Event.SCROLL, textFieldScrollHandler);
			_textField.addEventListener(FocusEvent.FOCUS_IN, focusInHandler);
			_textField.addEventListener(FocusEvent.FOCUS_OUT, focusOutHandler);
		}

		override protected function onHide() : void {
			_textField.removeEventListener(Event.SCROLL, textFieldScrollHandler);
			_textField.removeEventListener(FocusEvent.FOCUS_IN, focusInHandler);
			_textField.removeEventListener(FocusEvent.FOCUS_OUT, focusOutHandler);
		}

				
		private function focusInHandler(event : FocusEvent) : void {
			if(Capabilities.hasIME) {
				IME.enabled = true;
			}
			dispatchEvent(event);
		}

		private function focusOutHandler(event : FocusEvent) : void {
			if(Capabilities.hasIME) {
				IME.enabled = false;
			}
			dispatchEvent(event);
		}

		
		protected function reset() : void {
			var needHScroll : Boolean = _textField.maxScrollH > 0;
			var needVScroll : Boolean = vScrollMax > 0;
			var newWidth : int = _width - (needVScroll ? _vScrollBar.width : 0);
			var newHeight : int = _height - (needHScroll ? _hScrollBar.height : 0);
			_textField.width = newWidth - _data.padding * 2;
			_textWidth = _textField.textWidth;
			_textField.height = newHeight - _data.padding * 2;
			_textHeight = _textField.textHeight;
			if(needVScroll) {
				_vScrollBar.x = _width - _vScrollBar.width;
				_vScrollBar.height = newHeight;
				_vScrollBar.resetValue(_textField.bottomScrollV - _textField.scrollV + 1, 0, vScrollMax, _textField.scrollV - 1);
				if(!_vScrollBar.visible) {
					_vScrollBar.visible = true;
					_vScrollBar.addEventListener(GScrollBarEvent.SCROLL, scrollHandler, false, 0, true);
				}
			}else if(_vScrollBar.visible) {
				_vScrollBar.removeEventListener(GScrollBarEvent.SCROLL, scrollHandler, false);
				_vScrollBar.visible = false;
			}
			if(needHScroll) {
				_hScrollBar.y = _height - _hScrollBar.height;
				_hScrollBar.width = newWidth;
				_hScrollBar.resetValue(_textField.width, 0, _textField.maxScrollH, Math.min(_textField.maxScrollH, _textField.scrollH));
				if(!_hScrollBar.visible) {
					_hScrollBar.visible = true;
					_hScrollBar.addEventListener(GScrollBarEvent.SCROLL, scrollHandler, false, 0, true);
				}
			}else if(_hScrollBar.visible) {
				_hScrollBar.removeEventListener(GScrollBarEvent.SCROLL, scrollHandler, false);
				_hScrollBar.visible = false;
			}
		}

		override protected function onEnabled() : void {
			_textField.type = (_enabled ? (_data.editable ? TextFieldType.INPUT : TextFieldType.DYNAMIC) : TextFieldType.DYNAMIC);
		}

		protected function get vScrollMax() : int {
			var max : int = _textField.numLines - _textField.bottomScrollV + _textField.scrollV - 1;
			return Math.min(max, _textField.maxScrollV - 1);
		}

		protected function scrollHandler(event : GScrollBarEvent) : void {
			if(_textField.scrollV==_data.maxLines)return;
			if(event.direction == ScrollBarData.VERTICAL) {
				_textField.scrollV = event.position + 1;
			} else {
				_textField.scrollH = event.position;
			}
		}

		protected function textFieldScrollHandler(event : Event) : void {
			if(_data.lockScroll==true)return;
			reset();
		}

		public function TextArea(data : TextAreaData) {
			_data = data;
			super(data);
		}
			

		public function showEdge(color : uint = 0x000000) : void {
			_textField.filters = [new GlowFilter(color, 1, 2, 2, 17, 1, false, false)];
		}

		public function hideEdge() : void {
			_textField.filters = null;
		}

		public function appendHtmlText(value : String) : void {
			_textField.htmlText += value;
			if(_data.maxLines > 0) {
				var lines : Array = _textField.htmlText.split(_data.edlim);
				if(lines.length - 1 > _data.maxLines) {
					_textField.htmlText = _textField.htmlText.slice(String(lines[0]).length + _data.edlim.length);
				}
			}
			if(!_lock) {
				_textField.scrollV = vScrollMax + 1;
			}
		}

		public function appendText(value : String,color : uint = 0xCCCCCC) : void {
			var begin : int = _textField.text.length;
			_textField.appendText(value);
			_data.textFormat.color = color;
			_textField.setTextFormat(_data.textFormat, begin, _textField.text.length);
			_textField.scrollV = vScrollMax + 1;
		}

		public function set htmlText(value : String) : void {
			_textField.htmlText = value;
			if(!_lock) {
				_textField.scrollV = vScrollMax + 1;
			}
		}

		public function get htmlText() : String {
			return _textField.htmlText;
		}

		public function set text(value : String) : void {
			_textField.text = value;
			if(!_lock) {
				_textField.scrollV = vScrollMax + 1;
			}
		}

		public function get text() : String {
			return _textField.text;
		}

		public function get textField() : TextField {
			return _textField;
		}

		public function clear() : void {
			_textField.text = "";
		}

		public function upScroll() : void {
			_lock = true;
			if(_textField.scrollV > 0) {
				_textField.scrollV--;
			}
		}

		public function downScroll() : void {
			_lock = true;
			if(_textField.scrollV < vScrollMax + 1) {
				_textField.scrollV++;
			}
		}

		public function scrollToBottom() : void {
			_lock = false;
			_textField.scrollV = vScrollMax + 1;
		}
		
	}
}
