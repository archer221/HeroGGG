package com.ui.controls {
	import com.net.AssetData;
	import com.ui.containers.Panel;
	import com.ui.core.Align;
	import com.ui.data.AlertData;
	import com.ui.data.ButtonData;
	import com.ui.layout.GLayout;
	import com.ui.manager.UIManager;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.clearInterval;
	import flash.utils.setTimeout;


	/**
	 * Game Alert
	 * 
	 * @author Cafe
	 * @version 20100727
	 */
	public class Alert extends Panel {

		public static const NONE : uint = 0x0000;

		public static const OK : uint = 0x0004;

		public static const CANCEL : uint = 0x0008;

		public static const YES : uint = 0x0001;

		public static const NO : uint = 0x0002;
		
		public static const NoModalshow : int = 0;
		
		public static const Modalshow : int = 1;
		
		private var _alertData : AlertData;

		private var _label : Label;

		public var _textInput : TextInput;

		private var _buttons : Array;

		private var _timeout : int = 0;

		private var _detail : uint;
		private var _thisBg:Sprite; 

		private function initView() : void {
			addLabels();
			addTextInput();
			addButtons();
			autoSize();
		}

		private function addLabels() : void {
			_label = new Label(_alertData.labelData);
			add(_label);
		}

		private function addTextInput() : void {
			if(_alertData.textInputData) {
				_alertData.textInputData.align = Align.HCENTER;
				_textInput = new TextInput(_alertData.textInputData);
				add(_textInput);
			}
		}

		private function addButtons() : void {
			_buttons = new Array();
			if (_alertData.flag == NONE) return;
			var data : ButtonData;
			var button : Button;
			if(_alertData.flag & OK) {
				data = _alertData.buttonData.clone();
				data.labelData.text = _alertData.okLabel;
				button = new Button(data);
				button.source = OK;
				_buttons.push(button);
			}
			if (_alertData.flag & YES) {
				data = _alertData.yesbuttonData.clone();
				data.labelData.text = _alertData.yesLabel;
				button = new Button(data);
				button.source = YES;
				_buttons.push(button);
			}
			if(_alertData.flag & NO) {
				data = _alertData.nobuttonData.clone();
				data.labelData.text = _alertData.noLabel;
				button = new Button(data);
				button.source = NO;
				_buttons.push(button);
			}
			if(_alertData.flag & CANCEL) {
				data = _alertData.cancelbuttonData.clone();
				data.labelData.text = _alertData.cancelLabel;
				button = new Button(data);
				button.source = CANCEL;
				_buttons.push(button);
			}
			for each(button in _buttons) {
				button.AddEventListenerEx(MouseEvent.CLICK,this, clickHandler);
				add(button);
			}
		}

		private function clickHandler(event : MouseEvent) : void {
			var source : uint = Button(event.currentTarget).source;
			trace("source              " + source);
			if (source == YES) {
				_detail = YES;
			}else if (source == NO) {
				_detail = NO;
			}else if (source == OK) {
				_detail = OK;
			}else if (source == CANCEL) {
				_detail = CANCEL;
			} else {
				_detail = NONE;
			}
			hide();
			dispatchEvent(new Event(Event.CLOSE));
		}

		protected function autoSize() : void {
			var numButtons : int = Math.max(_buttons.length, 1);
			var labelWidth : int = _label.width + _data.padding * 2;
			var labelHeight : int = _label.height + (_alertData.flag == Alert.NONE ? 0 : _alertData.vgap);
			var textInputWidth : int = (_textInput ? _textInput.width + _data.padding * 2 : 0);
			var textInputHeight : int = (_textInput ? _textInput.height + _alertData.vgap : 0);
			var buttonWidth : int = (_alertData.flag == Alert.NONE ? 0 : numButtons * _alertData.buttonData.width + (numButtons - 1) * _alertData.hgap + _data.padding * 2);
			var buttonHeight : int = (_alertData.flag == Alert.NONE ? 0 : _alertData.buttonData.height);
			_width = Math.max(_data.minWidth, labelWidth, textInputWidth, buttonWidth);
			_height = Math.max(_data.minHeight, labelHeight + textInputHeight + buttonHeight + _data.padding * 2) + 40;
			_label.x = int((_width - labelWidth) * 0.5);
			if(_alertData.flag != Alert.NONE)
				_label.y = int((_height - labelHeight - textInputHeight - buttonHeight - _data.padding * 2) * 0.5+15);
			else
				_label.y = int((_height - labelHeight - textInputHeight - buttonHeight - _data.padding * 2) * 0.5-10);
			if(_textInput) {
				_textInput.x = int((_width - textInputWidth) * 0.5);
				_textInput.y = _label.y + _label.height + _alertData.vgap + 5;
				GLayout.layout(_textInput);
			}
			if(_alertData.flag != Alert.NONE) {
				var newY : int = _height - buttonHeight - _data.padding * 2;
				var newWidth : int = _buttons.length * (_alertData.buttonData.width + _alertData.hgap) - _alertData.hgap;
				var newX : int = Math.floor((_width - newWidth - _data.padding * 2) * 0.5);
				for each(var button:Button in _buttons) {
					button.moveTo(newX, newY);
					newX += button.width + _alertData.hgap;
				}
			}
			super.layout();
		}

		protected function initEvents() : void {
			if(_textInput) {
				_textInput.AddEventListenerEx(TextInput.ENTER,this, textInput_enterHandler);
			}
		}

		private function textInput_enterHandler(event : Event) : void {
			/*var source : uint = Button(event.currentTarget).source;
			if (source == YES) {
				_detail = YES;
			}else if (source == NO) {
				_detail = NO;
			}else if (source == OK) {
				_detail = OK;
			}else if (source == CANCEL) {
				_detail = CANCEL;
			} else {
				_detail = NONE;
			}*/
			_detail = OK;
			hide();
			dispatchEvent(new Event(Event.CLOSE));
		}

		override protected function onShow() : void {
			super.onShow();
			if(_timeout != 0) {
				clearInterval(_timeout);
				_timeout = 0;
			}
			if(_textInput != null) {
				_textInput.setFocus();
				_textInput.selectAll();
			}
			GLayout.layout(this);
		}
		
		private var _sender : Object;
		public function set Sender(obj : Object):void
		{
			_sender = obj;
		}
		public function get Sender():Object
		{
			return _sender;
		}

		public function Alert(data : AlertData) {
			_alertData = data;
			super(data);
			initView();
			initEvents();
		}

		override public function hide() : void {
			super.hide();
			if (_thisBg != null) {
				removeChild(_thisBg);
			}
			if(_timeout != 0) {
				clearInterval(_timeout);
				_timeout = 0;
			}
		}

		public function set flag(flag : uint) : void {
			if(_alertData.flag == flag)return;
			_alertData.flag = flag;
			for each(var button:Button in _buttons) {
				button.hide();
			}
			addButtons();
			autoSize();
			GLayout.layout(this);
		}

		public function showWait(delay : int = 500) : void {
			if(_timeout != 0) {
				clearInterval(_timeout);
				_timeout = 0;
			}
			_timeout = setTimeout(show, delay);
		}
		
		public function set bgAssdata(value:AssetData):void {
			if(_thisBg==null){
				_thisBg = UIManager.getUI(value);
			}
				addChild(_thisBg);
		}

		public function set label(value : String) : void {
			_label.text = value;
			autoSize();
		}

		public function set inputText(value : String) : void {
			if(_textInput != null) {
				_textInput.text = String(value);
			}
		}

		public function get inputText() : String {
			if(_textInput) {
				return _textInput.text;
			}
			return "";
		}

		public function get detail() : uint {
			return _detail;
		}
	}
}
