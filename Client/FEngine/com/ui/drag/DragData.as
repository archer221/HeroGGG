package com.ui.drag {
	import flash.display.DisplayObject;

	/**
	 * @version 20091215
	 * @author Cafe
	 */
	public class DragData {

		private var _owner : IDragTarget;

		private var _source : IDragItem;

		public var state : int;

		public var s_place : int;

		public var s_gird : int;

		public var target : IDragItem;

		public var t_place : int;

		public var t_gird : int;

		public var splitCount : int;

		public var hitTarget : DisplayObject;

		public var stageX : int;

		public var stageY : int;

		public function DragData() {
		}

		public function dispose():void
		{
			 _owner = null;

			 _source  = null;
			
			 target = null;

			hitTarget = null;
		}
		
		public function reset(owner : IDragTarget,source : IDragItem) : void {
			_owner = owner;
			_source = source;
			s_place = source.place;
			s_gird = source.gird;
			target = null;
			t_place = -1;
			t_gird = -1;
			splitCount = 0;
			state = DragState.REMOVE;
		}

		public function get owner() : IDragTarget {
			return _owner;
		}

		public function get source() : IDragItem {
			return _source;
		}
	}
}
