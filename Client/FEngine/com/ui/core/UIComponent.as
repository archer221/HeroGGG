package com.ui.core {
	import com.effects.GEffect;
	import com.effects.IGEffect;
	import com.ui.controls.Alert;
	import com.ui.controls.ToolTip;
	import com.ui.manager.GToolTipManager;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import com.ui.layout.GLayout;
	

	public class UIComponent extends Sprite {

		public var _base : UIComponentData;

		protected var _width : int;

		protected var _height : int;

		protected var _enabled : Boolean = true;

		protected var _source : *;

		protected var _toolTip : ToolTip;
		
		protected var isOnShow:int = 0;
		
		
		protected var NeedShow:Boolean = false;
		
		protected var NeedHide:Boolean = false;
		
		public static const ONSHOW :String = "onshow";
		public static const ONHIDE :String = "onhide";
		
		public function dispose():void
		{
			ClearEvents();
			disposeChildren();

		}
		
		protected function disposeChildren():void
		{
			while ( numChildren > 0 )
			{
				var child : Object = this.getChildAt(numChildren - 1);
				var childuicmt : UIComponent = child as UIComponent;
				if ( childuicmt != null )
				{
					childuicmt.dispose();
				}
				else if ( (child as Sprite) != null && ((child as MovieClip ) == null) )
				{
					var childsprite : Sprite = child as Sprite;
					disposeSpriteChild( childsprite );
				}
				removeChildAt(numChildren - 1);
			}
		}
		protected function disposeSpriteChild(chid : Sprite):void
		{
			if ( chid == null ) return;
			while ( chid.numChildren > 0 )
			{
				var subchild : Object = chid.getChildAt(chid.numChildren - 1);
				var childuicmt : UIComponent = subchild as UIComponent;
				if ( childuicmt != null )
				{
					childuicmt.dispose();
				}
				else if ( ((subchild as Sprite) != null) && ((subchild as MovieClip ) == null) )
				{
					var childsprite : Sprite = subchild as Sprite;
					disposeSpriteChild( childsprite );
				}
				chid.removeChildAt(chid.numChildren - 1);
			}
		}
		
		protected var m_EventDispatcher : EventDispatcherEx = new EventDispatcherEx();

		public function AddEventListenerEx( e : String, b : Object, fun : Function )
		{
			m_EventDispatcher.AddEventListenerEx(e, b, fun);
		}
		public function RemoveEventListenerEx(e : String ,b : Object, fun : Function)
		{
			m_EventDispatcher.RemoveEventListenerEx(e,b,fun);
		}
		public function AddTargetListener( e : String, alistener : Object, fun : Function)
		{
			m_EventDispatcher.AddTargetListener(e, alistener, fun);
		}
		public function ClearEvents()
		{
			m_EventDispatcher.ClearEvents();
		}
		public function ClearEvent(obj : Object)
		{
			m_EventDispatcher.ClearEvent(obj);
		}
		
		private function addToStageHandler(event : Event) : void {
			onShow();
			dispatchEvent(new Event(UIComponent.ONSHOW));
		}

		private function removeFromStageHandler(event : Event) : void {
			dispatchEvent(new Event(UIComponent.ONHIDE));
			onHide();
		}

		protected function init() : void {
			moveTo(_base.x, _base.y);
			_width = _base.width;
			_height = _base.height;
			alpha = _base.alpha;
			visible = _base.visible;
			if(_base.hideEffect) {
				_base.hideEffect.target = this;
			}
			if ( _base.showEffect )
			{
				_base.showEffect.target = this;
			}
			if(_base.toolTipData) {
				_toolTip = new _base.toolTip(_base.toolTipData);
				GToolTipManager.registerToolTip(this,_base.toolTipData.busemousemove);
			}
			create();
			layout();
		}

		protected function create() : void {
			
				
		}

		protected function layout() : void {
			if ( _base.align != null ) {
				GLayout.layout(this, _base.align);
			}
		}

		protected function swap(source : Sprite,target : Sprite) : Sprite {
			if(source == null || source.parent == null || target == null || source == target) {
				return source;
			}
			var index : int = source.parent.getChildIndex(source);
			var parent : DisplayObjectContainer = source.parent;
			source.parent.removeChild(source);
			parent.addChildAt(target, index);
			return target;
		}

		protected function onShow() : void {
		}

		protected function onHide() : void {
		}

		protected function onEnabled() : void {
		}
		
		protected function effect_ShowendHandler(event : Event) : void {
			var effect : GEffect = GEffect(event.target);
			effect.removeEventListener(GEffect.END, effect_ShowendHandler);
			alpha = 1;
			isOnShow = 0;
			if (NeedHide == true)
			{
				NeedHide = false;
				hide();
			}
		}	
		protected function effect_endHandler(event : Event) : void {
			var effect : GEffect = GEffect(event.target);
			effect.removeEventListener(GEffect.END, effect_endHandler);
			if (parent != null)
				parent.removeChild(this);
			alpha = 1;
			isOnShow = 0;
			if (NeedShow == true)
			{
				NeedShow = false;
				show();
			}
		}

		public function UIComponent(base : UIComponentData) {
			m_EventDispatcher.SetParent(this);
			_base = base;
			init();
			enabled = _base.enabled;
			filters = _base.filters;
			addEventListener(Event.ADDED_TO_STAGE, addToStageHandler);
			addEventListener(Event.REMOVED_FROM_STAGE, removeFromStageHandler);
		}

		public function set align(value : Align) : void {
			_base.align = value;
		}

		public function get align() : Align {
			return _base.align;
		}

		public function moveTo(newX : int,newY : int) : void {
			x = newX;
			y = newY;
		}

		public function set position(value : Point) : void {
			x = value.x;
			y = value.y;
		}

		public function get position() : Point {
			return new Point(x, y);
		}

		public function setSize(w : int,h : int) : void {
			if(_base.scaleMode == ScaleMode.SCALE_NONE)return;
			var newWidth : int = Math.max(_base.minWidth, Math.min(_base.maxWidth, w));
			var newHeight : int = Math.max(_base.minHeight, Math.min(_base.maxHeight, h));
			if(_width == newWidth && _height == newHeight)return;
			switch(_base.scaleMode) {
				case ScaleMode.SCALE_WIDTH:
					_width = newWidth;
					break;
				default:
					_width = newWidth;
					_height = newHeight;
					break;
			}
			layout();
			dispatchEvent(new Event(Event.RESIZE));
		}

		override public function set width(value : Number) : void {
			if(_base.scaleMode == ScaleMode.SCALE_NONE)return;
			var newWidth : int = Math.max(_base.minWidth, Math.min(_base.maxWidth, Math.floor(value)));
			if(_width == newWidth)return;
			_width = newWidth;
			layout();
			dispatchEvent(new Event(Event.RESIZE));
		}

		override public function get width() : Number {
			return _width;
		}

		override public function set height(value : Number) : void {
			if(_base.scaleMode == ScaleMode.SCALE_NONE)return;
			if(_base.scaleMode == ScaleMode.SCALE_WIDTH)return;
			var newHeight : int = Math.max(_base.minHeight, Math.min(_base.maxHeight, Math.floor(value)));
			if(_height == newHeight)return;
			_height = newHeight;
			layout();
			dispatchEvent(new Event(Event.RESIZE));
		}

		override public function get height() : Number {
			return _height;
		}

		public function set enabled(value : Boolean) : void {
			if(_enabled == value)return;
			_enabled = value;
			mouseEnabled = mouseChildren = _enabled;
			onEnabled();
		}

		public function get enabled() : Boolean {
			return _enabled;
		}

		public function show() : void {
			if (_base.parent == null) return;
			var haveshowalert : Boolean = false;
			if(parent != null&&isOnShow==0) {
				var depth : int = parent.getChildIndex(this);
				var target : int = parent.numChildren - 1;
				var child : DisplayObject = parent.getChildAt(target);
				if ( child is Alert && parent.numChildren > 1)
				{
					target = parent.numChildren - 2;
				}
				if(depth < target) {
					parent.swapChildrenAt(depth, target);
				}
				return;
			}
			
			_base.parent.addChild(this);
			if (parent != null && parent.numChildren > 1 && parent.parent == stage)
			{
				var target : int = parent.numChildren - 2;
				for( var target : int = parent.numChildren - 2; target >= 0; target-- )
				{
					var child : DisplayObject = parent.getChildAt(target);
					if ( child is Alert )
					{
						parent.removeChild(child);
						parent.addChild(child);
						break;
					}
				}
				
			}
			
			
			if (_base.showEffect)
			{
				if(isOnShow==0){
					isOnShow = 1;
					this.alpha = 0;
					_base.showEffect.start();
					_base.showEffect.addEventListener(GEffect.END, effect_ShowendHandler);
				}else {
					NeedShow = true;
				}
			}			
		}

		public function hide() : void {
			if(parent == null)return;
			if (_base.hideEffect) {
				if (isOnShow == 0){
					isOnShow = -1;
					_base.hideEffect.start();
					_base.hideEffect.addEventListener(GEffect.END, effect_endHandler);
				}else {
					NeedHide = true;
				}
			} else {
				if(_base.parent == null) {
					_base.parent = parent;
				}
				parent.removeChild(this);
			}
		}

		public function get toolTip() : ToolTip {
			return _toolTip as ToolTip;
		}

		public function set source(value : *) : void {
			_source = value;
		}

		public function get source() : * {
			return _source;
		}
		
		public function SetShowEffect(effet: GEffect):void
		{
			_base.showEffect = effet;
			if ( effet != null )
			{
				_base.showEffect.target = this;
			}
			
		}
		public function SetHideEffect(effect : GEffect):void
		{
			_base.hideEffect = effect;
			if ( effect != null )
			{
				_base.hideEffect.target = this;
			}
		}
		
		public function initToolTip() : void
		{
			
		}
		
		public function clearToolTip() : void
		{
			
		}
	}
}
