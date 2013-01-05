package com.ui.containers {
	import com.ui.controls.Tab;
	import com.ui.core.UIComponent;
	import com.ui.data.TabbedPanelData;
	import com.ui.data.TabData;
	import com.ui.group.GToggleGroup;
	import flash.events.Event;
	//import BZTC.core.Common;

	/**
	 * @version 20091215
	 * @author Cafe
	 */
	public class TabbedPanel extends UIComponent {

		protected var _data : TabbedPanelData;

		protected var _group : GToggleGroup;

		protected var _viewStack : ViewStack;

		override protected function create() : void {
			_group = new GToggleGroup();
			_viewStack = new ViewStack(_data.viewStackData);
			addChild(_viewStack);
		}

		override protected function layout() : void {
			_viewStack.x = 0;
			_viewStack.y = _data.tabData.height - 1;
		}

		private function initEvents() : void {
			_group.selectionModel.AddEventListenerEx(Event.CHANGE,this, group_changeHandler);
		}

		private function group_changeHandler(event : Event) : void {
			//BztcModel.soundManager.playSound("open");
			_viewStack.selectionModel.index = _group.selectionModel.index;
			_width = _viewStack.width;
			_height = _data.tabData.height + _viewStack.height - 1;
		}

		public function TabbedPanel(data : TabbedPanelData) {
			_data = data;
			super(_data);
			initEvents();
		}
		override public function dispose():void 
		{
			if ( _group != null )
			{
				_group.dispose();
			}
			_data = null;
			
			_group = null;

			_viewStack = null;
			super.dispose();
		}
		
		public function get Index():int {
			return _group.selectionModel.index;
		}
		public function get selection() : UIComponent {
			return _viewStack.selection;
		}

		public function get group() : GToggleGroup {
			return _group;
		}
		public function getTablePanel( idx : int ):UIComponent
		{
			return _viewStack.getAt(idx);
		}
		public function addTab(title : String, component : UIComponent, tDataTab : TabData = null) : void {
			var vtabData:TabData = tDataTab;
			if ( vtabData == null ) {
				vtabData = _data.tabData;
			}
			var tab : Tab = new Tab(vtabData);
			tab.text = title;
			var lastTab : Tab = _group.model.getLast() as Tab;
			if (lastTab) 
			{
				if ( !_data.hvType )
				{
					tab.x = lastTab.x + lastTab.width - 1 + vtabData.padding;
					tab.y = 0;
				}
				else
				{
					tab.x = 0;
					tab.y = lastTab.y + lastTab.height - 1 + vtabData.padding;
				}
			}
			addChild(tab);
			_group.model.add(tab);
			_viewStack.add(component);
		}
	}
}
