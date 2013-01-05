package com.ui.controls 
{
	import com.bd.BDFont;
	import com.model.PageModel;
	import com.ui.core.UIComponent;
	import com.ui.data.TogglePageData;
	import com.ui.group.GToggleGroup;
	import com.ui.layout.GLayout;
	import flash.events.Event;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author ...
	 */
	public class TogglePage extends UIComponent
	{
		protected var _data : TogglePageData;
		
		protected var _prev_btn : Button;

		protected var _page_lb : Label;

		protected var _next_btn : Button;

		protected var _model : PageModel;
		
		protected var toggleGroup : GToggleGroup;
		
		override public function dispose():void 
		{
			if ( _model != null )
			{
				_model.dispose();
			}
			if ( toggleGroup != null )
			{
				toggleGroup.dispose();
			}
			_model = null;
			toggleGroup = null;
			super.dispose();
		}
		
		
		override protected function create():void 
		{
			_prev_btn = new Button(_data.prev_buttonData);
			_next_btn = new Button(_data.next_buttonData);
			addChild(_prev_btn);
			addChild(_next_btn);
			initTogglePage();
		}
		
		protected function initTogglePage() : void
		{
			for (var i : int = 0; i < _data.maxPageShow; i++)
			{
				var toggleButton : ToggleBDFontButton = new ToggleBDFontButton(_data.toggleButtonData);
				toggleButton.setBDSkin(_data.bdFontAsset, _data.chars, _data.bdFontWidth, _data.bdFontHeight, _data.bdFontLeading);
				toggleButton.source = i + 1;
				toggleButton.PageText = i + 1;
				_data.ggridLayOut.add(toggleButton);
				addChild(toggleButton);
				toggleGroup.model.add(toggleButton);
			}
			_data.ggridLayOut.update();
		}
		
		override protected function layout():void 
		{
			GLayout.layout(_prev_btn);
			GLayout.layout(_page_lb);
			_data.ggridLayOut.update();
		}
		
		private function initView() : void {
			model = new PageModel();
		}

		private function initEvents() : void {
			_prev_btn.addEventListener(MouseEvent.CLICK, prev_clickHandler);
			_next_btn.addEventListener(MouseEvent.CLICK, next_clickHandler);
			toggleGroup.selectionModel.AddEventListenerEx(Event.CHANGE,this, toggleIndexChange_Handler);
		}
		
		public function TogglePage(data : TogglePageData) 
		{
			_data = data;
			toggleGroup = new GToggleGroup();
			super(_data);
			initView();
			initEvents();
		}
		
		private function toggleIndexChange_Handler(event : Event) : void
		{
			var toggleButton : ToggleButton = toggleGroup.selection as ToggleButton;
			var _isource : int = int(toggleButton.source);
			if (_isource != _model.currentPage)
			{
				_model.currentPage = _isource;
			}
		}
		
		private function prev_clickHandler(event : Event) : void {
			_model.prevPage();
		}

		private function next_clickHandler(event : Event) : void {
			_model.nextPage();
		}
		
		public function set model(value : PageModel) : void {
			if(_model != null) {
				_model.RemoveEventListenerEx(PageModel.PAGE_CHANGE,this, pageModel_pageChangeHandler);
				_model.RemoveEventListenerEx(PageModel.TOTAL_CHANGE,this, pageModel_totalChangeHandler);
			}
			_model = value;
			if(_model != null) {
				_model.AddEventListenerEx(PageModel.PAGE_CHANGE,this, pageModel_pageChangeHandler);
				_model.AddEventListenerEx(PageModel.TOTAL_CHANGE,this, pageModel_totalChangeHandler);
				reset();
			} else {
				_prev_btn.enabled = _next_btn.enabled = false;
			}
		}

		public function get model() : PageModel {
			return _model;
		}
		
		private function pageModel_pageChangeHandler(event : Event) : void {
			reset();
		}

		private function pageModel_totalChangeHandler(event : Event) : void {
			reset();
		}

		private function reset() : void {
			_prev_btn.enabled = _model.hasPrevPage;
			_next_btn.enabled = _model.hasNextPage;
			resetTogglePage();
		}
		
		private function resetTogglePage() : void
		{
			var beginPage : int = toggleGroup.model.getAt(0).source;
			if (_model.currentPage > beginPage + _data.maxPageShow / 2)
			{
				var index : int = (_model.currentPage + 1 - beginPage);
				var preMoveCount : int = 0;
				if (_model.totalPage >= _model.currentPage + ((_data.maxPageShow - index) + (index - (index - _data.maxPageShow / 2))))
					preMoveCount = index - (index - _data.maxPageShow / 2);
				else
					preMoveCount = _model.totalPage - (_model.currentPage + (_data.maxPageShow - index));
					
				if (preMoveCount > 0)
				{
					for each(var togglebutton : ToggleBDFontButton in toggleGroup.model.source)
					{
						if (togglebutton != null)
						{
							togglebutton.source = togglebutton.source + preMoveCount;
							togglebutton.PageText = (int(togglebutton));
						}
					}
					toggleGroup.selectionModel.index = toggleGroup.selectionModel.index - preMoveCount;
				}
				else
				{
					toggleGroup.selectionModel.index = (_model.currentPage - beginPage);
				}
			}
			else
			{
				toggleGroup.selectionModel.index = (_model.currentPage - beginPage);
			}
		}
	}

}