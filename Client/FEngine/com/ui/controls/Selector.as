package com.ui.controls {
	import com.model.ListEvent;
	import com.model.ListModel;
	import com.model.ListState;
	import com.model.SelectionModel;
	import com.ui.core.Align;
	import com.ui.core.UIComponent;
	import com.ui.data.SelectorData;
	import com.ui.layout.GLayout;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import BZTC.core.Common;

	/**
	 * @version 20091215
	 * @author Cafe
	 */
	public class Selector extends UIComponent {

		protected var _data : SelectorData;

		protected var _label : Label;

		public var _prev_btn : Button;

		public var _next_btn : Button;

		protected var _content : UIComponent;

		protected var _selectionModel : SelectionModel;

		protected var _model : ListModel;
		
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
			_selectionModel = null;
			_model = null;
			super.dispose();
		}

		override protected function create() : void {
			var left : int = 0;
			if(_data.labelData) {
				_data.labelData.align = new Align(-1, -1, -1, -1, -1, 0);
				_label = new Label(_data.labelData);
				left = _label.width;
				addChild(_label);
			}
			_data.prev_buttonData.align = new Align(left, -1, -1, -1, -1, 0);
			addButtons();
			addContent();
		}

		private function addButtons() : void {
			_prev_btn = new Button(_data.prev_buttonData);
			addChild(_prev_btn);
			_next_btn = new Button(_data.next_buttonData);
			addChild(_next_btn);
		}

		private function addContent() : void {
			_content = new _data.content(_data.componentData);
			addChild(_content);
		}

		override protected function layout() : void {
			if(_label)GLayout.layout(_label);
			GLayout.layout(_prev_btn);
			GLayout.layout(_next_btn);
			layoutContent();
		}

		private function layoutContent() : void {
			var labelWidth : int = (_label ? _label.width : 0);
			_content.x = labelWidth + Math.floor((_width - labelWidth - _content.width) / 2);
			_content.y = Math.floor((_height - _content.height) / 2);
		}

		private function prevHandler(event : Event) : void {
			BztcModel.soundManager.playSound("MouseClickSound");
			if(_selectionModel.index > 0) {
				_selectionModel.index--;
			} else {
				_selectionModel.index = _model.size - 1;
			}
		}

		private function nextHandler(event : Event) : void {
			BztcModel.soundManager.playSound("MouseClickSound");
			if(_selectionModel.index < _model.size - 1) {
				_selectionModel.index++;
			} else {
				_selectionModel.index = 0;
			}
		}

		protected function addModelEvents() : void {
			_model.AddEventListenerEx(ListEvent.CHANGE,this, model_changeHandler);
		}

		protected function removeModelEvents() : void {
			_model.RemoveEventListenerEx(ListEvent.CHANGE,this, model_changeHandler);
		}

		protected function model_changeHandler(event : ListEvent) : void {
			switch(event.state) {
				case ListState.RESET:
					if(_selectionModel.index >= _model.size)_selectionModel.index = 0;
					reset();
					break;
				case ListState.ADDED:
					break;
				case ListState.REMOVED:
					if(event.index < _selectionModel.index) {
						_selectionModel.index -= 1;
					}else if(event.index == _selectionModel.index) {
						_selectionModel.index = -1;
					}
					if(_selectionModel.index == -1)_selectionModel.index = 0;
					reset();
					break;
				case ListState.UPDATE:
					break;
				case ListState.INSERT:
					if(event.index <= _selectionModel.index)_selectionModel.index += 1;
					if(_selectionModel.index == -1)_selectionModel.index = 0;
					reset();
					break;
			}
		}

		private function selection_changeHandler(event : Event) : void {
			reset();
		}

		private function reset() : void {
			_content.source = _model.getAt(_selectionModel.index);
			layoutContent();
		}

		override protected function onEnabled() : void {
			_prev_btn.enabled = _enabled;
			_next_btn.enabled = _enabled;
			_prev_btn.iconGray = !_enabled;
			_next_btn.iconGray = !_enabled;
		}

		public function Selector(data : SelectorData) {
			_data = data;
			super(data);
			_prev_btn.AddEventListenerEx(MouseEvent.CLICK,this, prevHandler);
			_next_btn.AddEventListenerEx(MouseEvent.CLICK,this, nextHandler);
			_selectionModel = new SelectionModel();
			_selectionModel.AddEventListenerEx(Event.CHANGE,this, selection_changeHandler);
			_model = new ListModel();
			addModelEvents();
			_selectionModel.AddEventListenerEx(Event.CHANGE,this, selection_changeHandler);
		}

		public function get selectionModel() : SelectionModel {
			return _selectionModel;
		}

		public function get model() : ListModel {
			return _model;
		}

		public function get selection() : Object {
			return _model.getAt(_selectionModel.index);
		}
	}
}
