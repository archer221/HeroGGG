package com.ui.controls 
{
	import com.utils.GFilterUtil;
	import com.RichTextArea.RichTextField;
	import com.ui.core.UIComponent;
	import com.ui.data.RichTextInputData;
	import com.ui.manager.UIManager;
	import com.utils.GStringUtil;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.TextEvent;
	import flash.system.Capabilities;
	import flash.system.IME;
	import flash.ui.Keyboard;
	/**
	 * ...
	 * @author 
	 */
	public class RichTextInput extends UIComponent
	{
		
		public static const ENTER : String = "enter";

		protected var _data : RichTextInputData;

		protected var _borderSkin : Sprite;

		protected var _disabledSkin : Sprite;

		protected var _textField : RichTextField;

		protected var _current : Sprite;
		
		public static const _textinputEventChange : String = "textinputEventChange";

		override protected function create() : void {
			_borderSkin = UIManager.getUI(_data.borderAsset);
			_disabledSkin = UIManager.getUI(_data.borderAsset);//UIManager.getUI(_data.disabledAsset);
			_disabledSkin.filters = [GFilterUtil.GrayFilter()];
			_current = _borderSkin;
			_textField = new RichTextField(_data.width, _data.height);
			_textField.configXML = _data.configXML;
			_textField.textField = UIManager.getInputTextField();
			_textField.defaultTextFormat = _data.textFormat;
			_textField.textField.condenseWhite = true;
			_textField.textField.textColor = _data.textColor;
			_textField.textField.filters = _data.textFieldFilters;
			_textField.textField.maxChars = _data.maxChars;
			_textField.textField.displayAsPassword = _data.displayAsPassword;
			if(_data.restrict.length > 0) {
				_textField.textField.restrict = _data.restrict;
			}
			_textField.richText = _data.text;
			_textField.x = 3;
			addChild(_borderSkin);
			addChild(_textField);
		}
		
		override public function dispose():void 
		{
			if ( _textField != null )
			{
				_textField.dispose();
			}
			_textField = null;
			_borderSkin = null;
			_disabledSkin = null;
			super.dispose();
		}
		
		override protected function layout() : void {
			_borderSkin.width = _width;
			_borderSkin.height = _height;
			_disabledSkin.width = _width;
			_disabledSkin.height = _height;
			_textField.y = Math.floor((_height - _textField.textField.textHeight - 4) / 2);
			//_textField.width = _width - 4;
			_textField.textField.width = _width - 4;
		}

		override protected function onEnabled() : void {
			if(_enabled) {
				swap(_current, _borderSkin);
				_current = _borderSkin;
				_textField.textField.textColor = _data.textColor;
			} else {
				swap(_current, _disabledSkin);
				_current = _disabledSkin;
				_textField.textField.textColor = _data.disabledColor;
			}
		}

		override protected function onShow() : void {
			if(Capabilities.hasIME) {
				IME.enabled = _data.allowIME;
			}
			_textField.textField.addEventListener(TextEvent.TEXT_INPUT, textInputHandler);
			addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
			if(_data.maxChars > 0) {
				_textField.textField.addEventListener(TextEvent.TEXT_INPUT, textInputHandler);
			}
			_textField.textField.addEventListener(FocusEvent.FOCUS_IN, focusInHandler);
			_textField.textField.addEventListener(FocusEvent.FOCUS_OUT, focusOutHandler);
			_textField.textField.addEventListener(Event.CHANGE, OnTextChange);
		}
		protected function OnTextChange(e:Event):void {
			dispatchEvent(new Event(_textinputEventChange));
		}

		override protected function onHide() : void {
			_textField.textField.removeEventListener(TextEvent.TEXT_INPUT, textInputHandler);
			removeEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
			if(_data.maxChars > 0) {
				_textField.textField.removeEventListener(TextEvent.TEXT_INPUT, textInputHandler);
			}
			_textField.textField.removeEventListener(FocusEvent.FOCUS_IN, focusInHandler);
			_textField.textField.removeEventListener(FocusEvent.FOCUS_OUT, focusOutHandler);
			if(Capabilities.hasIME) {
				IME.enabled = false;
			}
			if(stage.focus == _textField.textField) {
				stage.focus = null;
			}
		}

		private function textInputHandler(event : TextEvent) : void {
			if(_data.maxChars > 0 && GStringUtil.getDwordLength(_textField.richText) >= _data.maxChars) {
				event.preventDefault();
				return;
			}
			event.stopImmediatePropagation();
			var newEvent : TextEvent = new TextEvent(TextEvent.TEXT_INPUT, false, true);
			newEvent.text = event.text;
			dispatchEvent(newEvent);
			if (newEvent.isDefaultPrevented())event.preventDefault();
		}

		private function focusInHandler(event : FocusEvent) : void {
			if(Capabilities.hasIME) {
				IME.enabled = _data.allowIME;
			}
			dispatchEvent(event);
		}

		private function focusOutHandler(event : FocusEvent) : void {
			if(Capabilities.hasIME) {
				IME.enabled = false;
			}
			dispatchEvent(event);
		}

		private function keyDownHandler(event : KeyboardEvent) : void {
			if(event.keyCode == Keyboard.ENTER) {
				if(stage.focus == _textField.textField) {
					dispatchEvent(new Event(TextInput.ENTER));
				}
			}
		}

		public function RichTextInput(data : RichTextInputData) {
			_data = data;
			super(data);
		}

		public function selectAll() : void {
			if(_textField.richText.length < 1)return;
			_textField.textField.setSelection(0, _textField.textField.text.length);
		}

		public function setFocus(focus : Boolean = true) : void {
			if(focus) {
				if(UIManager.root.stage.focus != _textField.textField) {
					UIManager.root.stage.focus = _textField.textField;
				}
			} else {
				if(UIManager.root.stage.focus == _textField.textField) {
					UIManager.root.stage.focus = null;
				}
			}
		}

		public function isFocus() : Boolean {
			return UIManager.root.stage.focus == _textField.textField;
		}

		public function set htmltext(value : String) : void {
			_textField.richText = value;
		}

		public function get htmltext() : String {
			return _textField.richText;
		}
		
		public function get text() : String {
			return _textField.Text;
		}
		
		public function appendText(str : String) : void
		{
			_textField.appendRichText(str);
		}

		public function get textField() : RichTextField {
			return _textField;
		}

		public function clear() : void {
			_textField.clear();
		}
		
	}

}