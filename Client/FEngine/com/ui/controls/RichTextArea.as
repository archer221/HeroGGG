package com.ui.controls 
{
	import com.RichTextArea.RichTextField;
	import com.ui.core.UIComponent;
	import com.ui.data.RichTextAreaData;
	import com.ui.data.ScrollBarData;
	import com.ui.events.GScrollBarEvent;
	import com.ui.manager.UIManager;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.GlowFilter;
	import flash.text.TextFieldType;
	/**
	 * ...
	 * @author 
	 */
	public class RichTextArea extends UIComponent
	{	
		protected var _data : RichTextAreaData;

		protected var _backgroundSkin : Sprite;

		protected var _textField : RichTextField;

		protected var _vScrollBar : ScrollBar;

		protected var _hScrollBar : ScrollBar;

		protected var _textWidth : Number;

		protected var _textHeight : Number;

		protected var _lock : Boolean = false;

		override public function dispose():void 
		{
			if (_textField != null)
			{
				_textField.dispose();
			}
			super.dispose();
			_textField = null;
		}
		
		override protected function create() : void {
			_backgroundSkin = UIManager.getUI(_data.backgroundAsset);
			_textField = new RichTextField(_data.width, _data.height);
			_textField.x = _textField.y = _data.padding;
			_textField.configXML = _data.configXML;
			_textField.textField.multiline = true;
			_textField.textField.wordWrap = true;
			_textField.textField.condenseWhite = true;
			_textField.textField.maxChars = _data.maxChars;
			_textField.defaultTextFormat = _data.textFormat;
			_textField.textField.textColor = _data.textColor;
			_textField.textField.filters = _data.textFieldFilters;
			if(_data.editable) {
				_textField.textField.styleSheet = null;
				_textField.textField.type = TextFieldType.INPUT;
			} else {
				_textField.textField.type = TextFieldType.DYNAMIC;
				_textField.textField.styleSheet = _data.styleSheet;
			}
			_textField.textField.selectable = _data.selectable;
			
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
			
			//_textField.width = _width - _data.padding * 2;
			//_textField.height = _height - _data.padding * 2;
			_textField.textField.width = _width - _data.padding * 2;
			_textField.textField.height = _height - _data.padding * 2;
			_vScrollBar.x = _width - _data.padding- _vScrollBar.width;
			_vScrollBar.y = _data.padding;
			_hScrollBar.x = _data.padding;
			_hScrollBar.y = _height - _data.padding - _hScrollBar.height;
			reset();
		}

		override protected function onShow() : void {
			reset();
			_textField.textField.addEventListener(Event.SCROLL, textFieldScrollHandler);
		}

		override protected function onHide() : void {
			if( _textField != null )
			_textField.textField.removeEventListener(Event.SCROLL, textFieldScrollHandler);
		}

		protected function reset() : void {
			var needHScroll : Boolean = _textField.textField.maxScrollH > 0;
			var needVScroll : Boolean = vScrollMax > 0;
			var newWidth : int = _width - (needVScroll ? _vScrollBar.width : 0);
			var newHeight : int = _height - (needHScroll ? _hScrollBar.height : 0);
			_textField.textField.width = newWidth - _data.padding * 2;
			_textWidth = _textField.textField.textWidth;
			_textField.textField.height = newHeight - _data.padding * 2;
			_textHeight = _textField.textField.textHeight;
			if(needVScroll) {
				_vScrollBar.x = _width - _vScrollBar.width;
				_vScrollBar.height = newHeight;
				_vScrollBar.resetValue(_textField.textField.bottomScrollV - _textField.textField.scrollV + 1, 0, vScrollMax, _textField.textField.scrollV - 1);
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
				_hScrollBar.resetValue(_textField.textField.width, 0, _textField.textField.maxScrollH, Math.min(_textField.textField.maxScrollH, _textField.textField.scrollH));
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
			_textField.textField.type = (_enabled ? (_data.editable ? TextFieldType.INPUT : TextFieldType.DYNAMIC) : TextFieldType.DYNAMIC);
		}

		protected function get vScrollMax() : int {
			var max : int = _textField.textField.numLines - _textField.textField.bottomScrollV + _textField.textField.scrollV - 1;
			return Math.min(max, _textField.textField.maxScrollV - 1);
		}

		protected function scrollHandler(event : GScrollBarEvent) : void {
			if(event.direction == ScrollBarData.VERTICAL) {
				_textField.textField.scrollV = event.position + 1;
			} else {
				_textField.textField.scrollH = event.position;
			}
		}

		protected function textFieldScrollHandler(event : Event) : void {
			reset();
		}

		public function RichTextArea(data : RichTextAreaData) {
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
			var restoreScrollv : int = _textField.textField.scrollV;
			if (_data.maxLines > 0) {
				var htmltext : String = _textField.richText;
				htmltext += value;
				var lines : Array = htmltext.split(_data.edlim);
				if(lines.length - 1 > _data.maxLines) {
					_textField.richText = htmltext.slice(String(lines[0]).length + _data.edlim.length);
				}
				else
					_textField.appendRichText(value);
			}
			else
				_textField.appendRichText(value);
			if(!_lock) {
				_textField.textField.scrollV = vScrollMax + 1;
			}
			else
				_textField.textField.scrollV = restoreScrollv;
		}

		public function set htmlText(value : String) : void {
			_textField.richText = value;
			if(!_lock) {
				_textField.textField.scrollV = vScrollMax + 1;
			}
		}

		public function get htmlText() : String {
			return _textField.richText;
		}

		public function get textField() : RichTextField {
			return _textField;
		}
		
		public function set text(str:String):void
		{
			_textField.textFieldtext = str;
		}

		public function clear() : void {
			_textField.clear();
		}

		public function upScroll() : void {
			_lock = true;
			if(_textField.textField.scrollV > 0) {
				_textField.textField.scrollV--;
			}
		}

		public function downScroll() : void {
			_lock = true;
			if(_textField.textField.scrollV < vScrollMax + 1) {
				_textField.textField.scrollV++;
			}
		}

		public function scrollToBottom() : void {
			_lock = false;
			_textField.textField.scrollV = vScrollMax + 1;
			reset();
		}
		
		public function scrollToTop():void {
			_lock = false;
			_textField.textField.scrollV = 1;
			reset();
		}
		
	}

}