package com.ui.controls {
	import com.ui.cell.Cell;
	import com.ui.cell.CellData;
	import com.ui.containers.Panel;
	import com.ui.core.ScaleMode;
	import com.ui.data.AlertData;
	import com.ui.data.GirdData;
	import com.ui.data.TextInputData;
	import com.ui.drag.DragData;
	import com.ui.drag.DragModel;
	import com.ui.drag.DragState;
	import com.ui.drag.IDragItem;
	import com.ui.drag.IDragSource;
	import com.ui.drag.IDragTarget;
	import com.ui.layout.GLayout;
	import com.ui.manager.UIManager;
	import com.model.ListEvent;
	import com.model.ListModel;
	import com.model.ListState;
	import com.model.PageModel;
	import com.model.SelectionModel;

	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.ui.Mouse;

	/**
	 * Game Gird
	 * 
	 * @author Cafe
	 * @version 20100719
	 */
	public class Gird extends Panel implements IDragTarget {

		protected var _girdData : GirdData;

		protected var _dragModel : DragModel;

		protected var _selectionModel : SelectionModel;

		protected var _model : ListModel;

		protected var _pageModel : PageModel;

		protected var _cell : Class;

		protected var _cellWidth : int;

		protected var _cellHeight : int;

		protected var _cells : Array;

		protected var _selectedCells : Array;

		protected var _dragData : DragData;

		protected var _dragCell : Cell;

		protected var _dragImage : Icon;

		protected var _split_alert : Alert;

		protected var _remove_alert : Alert;

		protected var _refs : Array;

		override protected function init() : void {
			_cell = _girdData.cell;
			_cells = new Array();
			_selectedCells = new Array();
			_refs = new Array();
			super.init();
		}

		override protected function create() : void {
			super.create();
			var templet : Cell = new _cell(_girdData.cellData);
			_cellWidth = templet.width;
			_cellHeight = templet.height;
			if(_data.scaleMode == ScaleMode.AUTO_SIZE) {
				_width = _cellWidth * _girdData.columns + (_girdData.columns - 1) * _girdData.hgap + _girdData.padding * 2;
				_height = _cellHeight * _girdData.rows + (_girdData.rows - 1) * _girdData.vgap + _girdData.padding * 2;
			}
			initCells();
			if(_girdData.allowDrag)addAlerts();
		}

		protected function addAlerts() : void {
			//_remove_alert = new Alert(_girdData.alertData);
			//_remove_alert.AddEventListenerEx(Event.CLOSE,this,remove_closeHandler);
			var data : AlertData = _girdData.alertData.clone();
			data.labelData.text = "请输入拆分数量:";
			data.textInputData = new TextInputData();
			data.textInputData.width = 150;
			data.textInputData.restrict = "0-9";
			data.textInputData.maxChars = 2;
			data.flag = Alert.OK | Alert.CANCEL;
			_split_alert = new Alert(data);
			_split_alert.AddEventListenerEx(Event.CLOSE,this, split_closeHandler);
		}

		protected function initCells() : void {
			_cells = new Array();
			var index : int = 0;
			for(var row : int = 0;row < _girdData.rows;row++) {
				for(var column : int = 0;column < _girdData.columns;column++) {
					var data : CellData = _girdData.cellData.clone();
					data.x = column * (_cellWidth + _girdData.hgap);
					data.y = row * (_cellHeight + _girdData.vgap);
					data.width = _cellWidth;
					data.height = _cellHeight;
					data.enabled = false;
					if(_girdData.hotKeys != null && index < _girdData.hotKeys.length) {
						data.hotKey = _girdData.hotKeys[index];
					}
					if(_model != null && _model.max > 0 && _cells.length >= _model.max) {
						data.lock = true;
					}
					var cell : Cell = new _cell(data);
					cell.SetLogicParent(this);
					cell.InnerID = column + row * _girdData.columns;
					add(cell);
					_cells.push(cell);
					addCellEvents(cell);
					index++;
				}
			}
		}

		protected function updateCells(index : int = 0) : void {
			var start : int = _pageModel.getPageIndex(index);
			var end : int = Math.min(_cells.length, _pageModel.currentSize);
			var len : int = _cells.length;
			var cell : Cell;
			var base : int = _pageModel.base;
			for(var i : int = start;i < len;i++) {
				cell = _cells[i] as Cell;
				if(cell != null)cell.lock = (_model.max > 0 && (base + i) >= _model.max);
				if(i < end) {
					if(cell != null)cell.source = _model.getAt(base + i);
				} else {
					if(cell != null)cell.source = null;
				}
			}
		}

		protected function addCellEvents(cell : Cell) : void {
			if(_girdData.cellData.allowDoubleClick) {
				cell.AddEventListenerEx(Cell.DOUBLE_CLICK,this, cell_doubleClickHandler);
			}
			cell.AddEventListenerEx(Cell.SINGLE_CLICK,this, cell_singleClickHandler);
		}

		protected function removeCellEvents(cell : Cell) : void {
			if(_girdData.cellData.allowDoubleClick) {
				cell.RemoveEventListenerEx(Cell.DOUBLE_CLICK,this, cell_doubleClickHandler);
			}
			cell.RemoveEventListenerEx(Cell.SINGLE_CLICK,this, cell_singleClickHandler);
		}

		protected function cell_doubleClickHandler(event : Event) : void {
			var index : int = _cells.indexOf(event.target);
			if(index != -1)_selectionModel.index = _pageModel.base + index;
			dispatchEvent(event);
		}

		public function set canDrag(value : Boolean) : void
		{
			_girdData.allowDrag = value;
		}
		
		protected function cell_singleClickHandler(event : Event) : void {
			if (IsDrag == true) return;
			var index : int = _cells.indexOf(event.target);
			if(index != -1) {
				_selectionModel.index = _pageModel.base + index;
			}
			if(Cell(event.target).ctrlKey) {
				dispatchEvent(event);
				return;
			}
			if(_girdData.allowDrag) {
				_dragCell = Cell(event.target);
				if(_dragCell is IDragSource && _dragCell.source is IDragItem) {
					_dragData.reset(this, _dragCell.source);
					if(Cell(event.target).shiftKey) {
						if(_dragData.source.count > 1 && _dragData.source.max > 1) {
							_split_alert.inputText = (int(_dragData.source.count / 2)).toString();//"1";
							_split_alert.show();
							if (_split_alert.align == null)
								_split_alert.moveTo(stage.mouseX, stage.mouseY);
							return;
						}
					} else {
						dragStart();
					}
				}
			}
			dispatchEvent(event);
		}

		protected function stage_mouseMoveHandler(event : MouseEvent) : void {
			if(_dragImage != null) {
				_dragImage.x = int(event.stageX - _dragImage.width * 0.5);
				_dragImage.y = int(event.stageY - _dragImage.height * 0.5);
			}
		}
		
		public function getHitCell(hitTarget : DisplayObject) : Cell
		{
			if(UIManager.atParent(hitTarget, this)) {
				if(!_model.allowNull) {
					return null;
				}
				var c : int = _content.mouseX / (_girdData.cellData.width + _girdData.hgap);
				var r : int = _content.mouseY / (_girdData.cellData.height + _girdData.vgap);
				c = Math.max(0, Math.min(_girdData.columns - 1, c));
				r = Math.max(0, Math.min(_girdData.rows - 1, r));
				var index : int = _pageModel.base + r * _girdData.columns + c;
				return getCellBy(index);
			}
			return null;
		}

		override public function stage_mouseUpHandler(event : MouseEvent) : void {
			var hitTarget : DisplayObject = UIManager.hitTest(stage.mouseX, stage.mouseY);
			if(_dragImage != null) {
				if(UIManager.atParent(hitTarget, this)) {
					if(!_model.allowNull) {
						dragEnd();
						return;
					}
					var c : int = _content.mouseX / (_girdData.cellData.width + _girdData.hgap);
					var r : int = _content.mouseY / (_girdData.cellData.height + _girdData.vgap);
					c = Math.max(0, Math.min(_girdData.columns - 1, c));
					r = Math.max(0, Math.min(_girdData.rows - 1, r));
					var index : int = _pageModel.base + r * _girdData.columns + c;
					_dragData.t_place = _model.place;
					_dragData.t_gird = index;
					if(_model.max > 0 && index >= _model.max) {
						dragEnd();
						return;
					}
					var dragoncell : Cell = _cells[index];
					//if (dragoncell is FightItemBagItemCell) {
						//if (FightItemBagItemCell(dragoncell).Lock == true) {
							//dragEnd();
							//return;
						//}
					//}
					if ( dragoncell != null && dragoncell.source != null && !dragoncell.enabled )
					{
						dragEnd();
						return;
					}
					var target : IDragItem = IDragItem(_model.getAt(index));
					if(target == null) {
						//if(_dragData.split == null) {
							//_model.setAt(_dragData.s_gird, null);
							//_model.setAt(index, _dragData.source);
						//} else {
							//_model.setAt(index, _dragData.split);
						//}
					} else {
						if(target == _dragData.source) {
							dragEnd();
							return;
						}
						if(_dragData.splitCount == 0) {
							//if(target.merge(_dragData.source)) {
								//if(_dragData.source.count == 0) {
									//_model.setAt(_dragData.source.gird, null);
								//}
							//} else {
								//_model.setAt(_dragData.source.gird, target);
								//_model.setAt(index, _dragData.source);
							//}
						} else {
							if (!target.canmerge(_dragData.source, _dragData.splitCount)) {
								dragEnd();
								return;
								//if(_dragData.split.count > 0) {
									//_dragData.source.count += _dragData.split.count;
								//}else if(_dragData.source.count == 0) {
									//_model.setAt(_dragData.source.gird, null);
								//}
							} else {
								//_dragData.source.count += _dragData.split.count;
								//dragEnd();
								//return;
							}
						}
					}
				} else {
					_dragData.hitTarget = hitTarget;
					_dragData.stageX = stage.mouseX;
					_dragData.stageY = stage.mouseY;
					_dragModel.check(_dragData);
					if(_dragData.state == DragState.NEXT) {
						return;
					}
					if(_dragData.state == DragState.END) {
						dragEnd();
						return;
					}
					if(_dragData.state == DragState.REMOVE) {
						dragEnd();
						var count : int = (_dragData.splitCount == 0 ? _dragData.source.count : _dragData.splitCount);
						var slabel : String = "你真的要删除 [" + _dragData.source.name + "] " + count + "个?";
						_dragData.source.beginRemove(slabel);
						//var count : int = (_dragData.splitCount == 0 ? _dragData.source.count : _dragData.splitCount);
						//_remove_alert.label = "你真的要删除 [" + _dragData.source.name + "] " + count + "个?";
						//_remove_alert.show();
						//GLayout.layout(_remove_alert);
						return;
					}
					if(_dragData.state == DragState.MOVE) {
						//if(_dragData.split == null) {
							//_model.setAt(_dragData.s_gird, _dragData.target);
						//}
					}else if(_dragData.state == DragState.MERGE) {
						//if(_dragData.split == null && _dragData.source.count == 0) {
							//_model.setAt(_dragData.s_gird, null);
						//}
					}else if(_dragData.state == DragState.CANCEL) {
						//if(_dragData.split != null) {
							//_dragData.source.count += _dragData.split.count;
						//}
						dragEnd();
						return;
					}
				}
				dragEnd();
				_dragData.source.syncMove(_dragData.s_place, _dragData.s_gird, _dragData.t_place, _dragData.t_gird, _dragData.splitCount != 0, _dragData.splitCount);
			} else {
				if(!UIManager.atParent(hitTarget, this)) {
					var outside : Boolean = true;
					if(UIManager.atParent(hitTarget, _menuTrigger)) {
						outside = false;
					}
					if(outside) {
						hide();
					}
				}
			}
		}

		private function dragStart() : void {
			if (IsDrag == true) return;
			IsDrag = true;
			UIManager.dragModal = true;
			_dragCell.enabled = false;
			_dragImage = IDragSource(_dragCell).dragImage;
			_dragImage.x = int(stage.mouseX - _dragImage.width * 0.5);
			_dragImage.y = int(stage.mouseY - _dragImage.height * 0.5);
			stage.addChild(_dragImage);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, stage_mouseMoveHandler);
			//if(!stage.hasEventListener(MouseEvent.MOUSE_UP)) {
				stage.addEventListener(MouseEvent.MOUSE_UP, stage_mouseUpHandler);
			//}
			//Mouse.hide();
			MouseApp.Instance.hide();
		}
		private var IsDrag:Boolean = false;
		public var func : Function;
		protected function dragEnd() : void {
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, stage_mouseMoveHandler);
			if(stage.hasEventListener(MouseEvent.MOUSE_UP) && _menuTrigger == null) {
				stage.removeEventListener(MouseEvent.MOUSE_UP, stage_mouseUpHandler);
			}
			UIManager.dragModal = false;
			_dragImage.parent.removeChild(_dragImage);
			_dragImage = null;
			if(_dragCell.source != null && _refs.indexOf(_dragCell.source) == -1) {
				_dragCell.enabled = true;
			}
			IsDrag = false;
			if (func != null)
				func();
			//Mouse.show();
			MouseApp.Instance.show();
		}

		private function remove_closeHandler(ary : Array) : void {
			if (ary.length <= 0) return;
			var detail : uint = ary[0];
			if(detail == Alert.YES) {
				if(_dragData.splitCount == 0) {
					//_model.setAt(_selectionModel.index, null);
					IDragItem(_dragData.source).syncRemove();
				} else {
					IDragItem(_dragData.source).syncRemove(_dragData.splitCount);	
				}
			}else if(detail == Alert.NO) {
				//if(_dragData.split != null) {
					//_dragData.source.count += _dragData.split.count;
				//}
			}
		}

		private function split_closeHandler(event : Event) : void {
			var detail : uint = _split_alert.detail;
			if(detail == Alert.OK) {
				var count : int = int(_split_alert.inputText);
				count = Math.max(0, Math.min(_dragData.source.count, count));
				if(count <= 0) {
					return;
				} else if(count < _dragData.source.count) {
					//_dragData.split = _dragData.source.split(count);
					_dragData.splitCount = count;
					dragStart();
				} else {
					dragStart();
				}
			}
		}

		protected function model_changeHandler(event : ListEvent) : void {
			var cell : Cell;
			var state : int = event.state;
			var index : int = event.index;
			var item : Object = event.item;
			var oldItem : Object = event.oldItem;
			switch(state) {
				case ListState.RESET:
					updateCells();
					if(_selectionModel.index >= _model.size)_selectionModel.index = -1;
					break;
				case ListState.ADDED:
					if(!_pageModel.atCurrentPage(index))return;
					cell = _cells[_pageModel.getPageIndex(index)] as Cell;
					if(cell)cell.source = item;
					break;
				case ListState.REMOVED:
					if(!_pageModel.atCurrentPage(index))return;
					updateCells(index);
					if(index < _selectionModel.index) {
						_selectionModel.index -= 1;
					}else if(index == _selectionModel.index) {
						_selectionModel.index = -1;
					}
					break;
				case ListState.UPDATE:
					if(!_pageModel.atCurrentPage(index))return;
					cell = _cells[_pageModel.getPageIndex(index)] as Cell;
					if(cell != null) {
						cell.source = item;
						if(cell.source != null && _refs.indexOf(cell.source) != -1) {
							cell.enabled = false;
						}
					}
					var i : int = _refs.indexOf(oldItem);
					if(oldItem != null && i != -1) {
						_refs.splice(i, 1);
					}
					if(item == null && _selectionModel.index == index) {
						_selectionModel.index = -1;
					}
					break;
				case ListState.INSERT:
					if(!_pageModel.atCurrentPage(index))return;
					updateCells(index);
					if(index <= _selectionModel.index)_selectionModel.index += 1;
					break;
			}
		}

		protected function page_changeHandler(event : Event) : void {
			updateCells(_pageModel.base);
			resetSelected();
		}

		protected function selection_changeHandler(event : Event) : void {
			resetSelected();
		}

		protected function resetSelected() : void {
			var cell : Cell;
			for each(cell in _selectedCells) {
				cell.selected = false;
			}
			_selectedCells.splice(0);
			if(!_pageModel.atCurrentPage(_selectionModel.index))return;
			cell = _cells[_selectionModel.index] as Cell;
			if(cell) {
				cell.selected = true;
				_selectedCells.push(cell);
			}
		}

		protected function addModelEvents() : void {
			_model.AddEventListenerEx(ListEvent.CHANGE,this, model_changeHandler);
			if(_girdData.cellData.allowSelect) {
				_selectionModel.AddEventListenerEx(Event.CHANGE,this, selection_changeHandler);	
			}
		}

		protected function removeModelEvents() : void {
			_model.RemoveEventListenerEx(ListEvent.CHANGE,this, model_changeHandler);
			if(_girdData.cellData.allowSelect) {
				_selectionModel.RemoveEventListenerEx(Event.CHANGE,this, selection_changeHandler);	
			}
		}

		override public function dispose():void 
		{
			if ( stage != null )
			{
				stage.removeEventListener(MouseEvent.MOUSE_MOVE, stage_mouseMoveHandler);
				stage.removeEventListener(MouseEvent.MOUSE_UP, stage_mouseUpHandler);
			}
			

			if (_model != null)
			{
				_model.dispose();
			}
			if (_dragModel != null)
			{
				_dragModel.dispose();
			}
			if (_cells != null)
			{
				_cells.splice(0);
			}
			_model = null;
			_dragModel = null;
			_selectionModel = null;
			_pageModel = null;
			
			_cells = null;

			if (_selectedCells != null)
			{
				_selectedCells.splice(0);
			}
			_selectedCells = null;
			
			if (_dragData != null)
			{
				_dragData.dispose();
			}
			_dragData = null;

			_dragCell = null;

			_dragImage = null;

			_split_alert = null;

			_remove_alert = null;

			_refs = null;
			
			super.dispose();
			
		}
		
		public function Gird(data : GirdData) {
			_girdData = data;
			super(data);
			_selectionModel = new SelectionModel();
			_dragModel = new DragModel();
			_dragData = new DragData();
			_model = new ListModel(true, _girdData.rows * _girdData.columns);
			_pageModel = new PageModel(_girdData.rows * _girdData.columns, _model);
			_pageModel.AddEventListenerEx(PageModel.PAGE_CHANGE,this, page_changeHandler);
			addModelEvents();
		}

		public function get selectionModel() : SelectionModel {
			return _selectionModel;
		}

		public function get dragModel() : DragModel {
			return _dragModel;
		}

		public function get pageModel() : PageModel {
			return _pageModel;
		}

		public function set model(value : ListModel) : void {
			if(_model != null) {
				removeModelEvents();
			}
			_model = value;
			_pageModel.listModel = model;
			if(_model != null) {
				addModelEvents();
				_model.update();
			}
		}

		public function get model() : ListModel {
			return _model;
		}

		public function getCellBy(value : int) : Cell {
			return _cells[value];
		}
		
		//public function getSmithCellBy(value:int):SmithNormalBagItemCell
		//{
			//return _cells[value];
		//}

		public function indeOfCell(cell : Cell) : int {
			return _cells.indexOf(cell);
		}

		public function getCellSize() : int {
			return _cells.length;
		}

		public function get selectionCell() : Cell {
			return _cells[_selectionModel.index];
		}

		public function get selection() : Object {
			return _model.getAt(_selectionModel.index);
		}

		public function dragEnter(dragData : DragData) : Boolean {
			if(!UIManager.atParent(dragData.hitTarget, this)) {
				return false;	
			}
			var local : Point = globalToLocal(new Point(dragData.stageX, dragData.stageY));
			var c : int = (local.x - _girdData.padding) / (_girdData.cellData.width + _girdData.hgap);
			var r : int = (local.y - _girdData.padding) / (_girdData.cellData.height + _girdData.vgap);
			c = Math.max(0, Math.min(_girdData.columns - 1, c));
			r = Math.max(0, Math.min(_girdData.rows - 1, r));
			var index : int = _pageModel.base + r * _girdData.columns + c;
			dragData.t_place = _model.place;
			dragData.t_gird = index;
			if(_model.max != -1 && index >= _model.max) {
				dragData.state = DragState.CANCEL;
				return true;
			}
			var target : IDragItem = _model.getAt(index) as IDragItem;
			if(target == null) {
				dragData.state = DragState.MOVE;
				//_model.setAt(index, dragData.split == null ? dragData.source : dragData.split);
				return true;
			} else {
				if(dragData.splitCount == 0) {
					if(target.canmerge(dragData.source,dragData.source.count)) {
						dragData.state = DragState.MERGE;
						return true;
					}
					if(dragData.owner.canSwap(dragData.source, target)) {
						//_model.setAt(index, dragData.source);
						dragData.state = DragState.MOVE;
						dragData.target = target;
						return true;
					}
					dragData.state = DragState.CANCEL;
					return true;
				} else {
					if(target.canmerge(dragData.source,dragData.splitCount)) {
						dragData.state = DragState.MERGE;
						return true;
					}
					dragData.state = DragState.CANCEL;
					return true;
				}
			}
			return true;
		}

		public function canSwap(source : IDragItem,target : IDragItem) : Boolean {
			return true;
		}

		public function addRef(value : Object) : void {
			if(_refs.indexOf(value) != -1) {
				return;
			}
			_refs.push(value);
			var cell : Cell;
			cell = getCellBy(_model.indexOf(value));
			if(cell != null) {
				cell.enabled = false;
			}
		}

		public function removeRef(value : Object) : void {
			var index : int = _refs.indexOf(value);
			if(index == -1) {
				return;
			}
			_refs.splice(index, 1);
			var cell : Cell;
			cell = _cells[_model.indexOf(value)];
			if(cell != null) {
				cell.enabled = true;
			}
		}

		public function getRefs() : Array {
			return _refs;
		}
	}
}
