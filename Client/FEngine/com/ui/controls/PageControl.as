package com.ui.controls {
	import com.model.PageModel;
	import com.ui.containers.Panel;
	import com.ui.core.UIComponent;
	import com.ui.data.PageControlData;
	import com.ui.drag.DragData;
	import com.ui.drag.DragState;
	import com.ui.drag.IDragItem;
	import com.ui.drag.IDragTarget;
	import com.ui.layout.GLayout;
	import com.ui.manager.UIManager;
	import flash.events.Event;
	import flash.events.MouseEvent;


	/**
	 * Page Control
	 * @author Cafe
	 * @version 20100505
	 */
	public class PageControl extends UIComponent implements IDragTarget {

		public static const PrePageButtonClick : String = "prepagebtnclick";
		public static const NextPageButtonClick : String = "Nextpagebtnclick";
		
		protected var _data : PageControlData;

		protected var _prev_btn : Button;

		protected var _page_lb : Label;

		protected var _next_btn : Button;

		protected var _model : PageModel;

		override public function dispose():void 
		{
			if ( _model != null )
			{
				_model.dispose();
			}
			super.dispose();
		}
		
		override protected function create() : void {
			_prev_btn = new Button(_data.prev_buttonData);
			_next_btn = new Button(_data.next_buttonData);
			_page_lb = new Label(_data.labelData);
			addChild(_prev_btn);
			addChild(_next_btn);
			addChild(_page_lb);
		}

		override protected function layout() : void {
			GLayout.layout(_prev_btn);
			GLayout.layout(_page_lb);
			GLayout.layout(_next_btn);
		}

		private function pageModel_pageChangeHandler(event : Event) : void {
			reset();
		}

		private function pageModel_totalChangeHandler(event : Event) : void {
			reset();
		}

		private function reset() : void {
			_page_lb.text = _model.currentPage + "/" + _model.totalPage;
			//GLayout.layout(_page_lb);
			_prev_btn.enabled = _model.hasPrevPage;
			_next_btn.enabled = _model.hasNextPage;
		}

		private function initView() : void {
			model = new PageModel();
		}

		private function initEvents() : void {
			_prev_btn.AddEventListenerEx(MouseEvent.CLICK,this, prev_clickHandler);
			_next_btn.AddEventListenerEx(MouseEvent.CLICK,this, next_clickHandler);
		}

		private function prev_clickHandler(event : Event) : void {
			_model.prevPage();
			dispatchEvent(new Event(PageControl.PrePageButtonClick));
		}

		private function next_clickHandler(event : Event) : void {
			_model.nextPage();
			dispatchEvent(new Event(PageControl.NextPageButtonClick));
		}

		public function PageControl(data : PageControlData) {
			_data = data;
			super(_data);
			initView();
			initEvents();
		}

		public function get label() : Label {
			return _page_lb;
		}
		
		public function get prebtn():Button
		{
			return _prev_btn;
		}
		
		public function get nextbtn():Button
		{
			return _next_btn;
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
				_page_lb.text = "1/1";
				GLayout.layout(_page_lb);
				_prev_btn.enabled = _next_btn.enabled = false;
			}
		}

		public function get model() : PageModel {
			return _model;
		}

		public function dragEnter(dragData : DragData) : Boolean {
			if(UIManager.atParent(dragData.hitTarget, _prev_btn)) {
				_model.prevPage();
				dragData.state = DragState.NEXT;
				return true;
			}
			if(UIManager.atParent(dragData.hitTarget, _next_btn)) {
				_model.nextPage();
				dragData.state = DragState.NEXT;
				return true;
			}
			return false;
		}

		public function canSwap(source : IDragItem,target : IDragItem) : Boolean {
			return true;
		}
	}
}