package com.ui.controls 
{
	import com.model.Map;
	import com.net.AssetData;
	import com.ui.manager.UIManager;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.ui.Mouse;
	/**
	 * ...
	 * @author ...
	 */
	public class MouseApp extends Sprite
	{
		public static const Instance : MouseApp = new MouseApp();
		
		private var _mouseUp_mc : Sprite;		//鼠标抬起图片
		private var _mouseDown_mc : Sprite;		//鼠标按下图片
		private var _mouse_mc : Sprite;   		//当前鼠标图片
		
		private var bUseDefinedMouse : Boolean = false;	//是否使用用户自定义图标
		
		private var bMouseDown : Boolean = false;		//鼠标当前是否按下
		private var specialMouseMap : Map = new Map();	//自定义特殊鼠标图片
		private var mousePhase : int = 0;				//当前使用鼠标图片是否特殊阶段的图片
		private var bMouseShow : Boolean = true;		//当前是否显示鼠标图片
		
		public function set UseDefinedMouse(value : Boolean) : void
		{
			if (value == bUseDefinedMouse) return;
			if (value && _mouseUp_mc == null) return;
			bUseDefinedMouse = value;
		}
		
		public function setSpecialMouse(phase : int, asset : AssetData) : void
		{
			if (specialMouseMap.containsKey(phase)) return;
			specialMouseMap.put(phase, UIManager.getUI(asset));
		}
		
		public function setNormalMouse(up : AssetData, down : AssetData) : void
		{
			_mouseUp_mc = UIManager.getUI(up);
			_mouseDown_mc = UIManager.getUI(down);
			if (_mouseUp_mc == null) return;
			_mouse_mc = _mouseUp_mc;
			addChild(_mouse_mc);
		}
		
		public function selectMousePhase(phase : int) : void
		{
			if (!bUseDefinedMouse) return;
			if (phase != mousePhase)
			{
				mousePhase = phase;
				if (_mouse_mc.parent != null)
					_mouse_mc.parent.removeChild(_mouse_mc);
				bMouseDown = false;
				if (phase == 0)
					_mouse_mc = _mouseUp_mc;
				else
				{
					var mousesprite : Sprite = specialMouseMap.getBy(phase);
					if (mousesprite == null)
						_mouse_mc = _mouseUp_mc;
					else
						_mouse_mc = mousesprite;
				}
				_mouse_mc.x = stage.mouseX;
				_mouse_mc.y = stage.mouseY;
				if (bMouseShow)
					stage.addChild(_mouse_mc);
			}
		}
		
		public function MouseApp() 
		{
			addEventListener(Event.ADDED_TO_STAGE, addToStageHandler);
			addEventListener(Event.REMOVED_FROM_STAGE, removeFromStageHandler);
		}
		
		private function addToStageHandler(event : Event) : void {
			if (bUseDefinedMouse)
			{
				stage.addEventListener(MouseEvent.MOUSE_MOVE, OnMouseMove);
				stage.addEventListener(MouseEvent.ROLL_OUT, OnMouseOut);
				stage.addEventListener(MouseEvent.MOUSE_DOWN, OnMouseDown);
				stage.addEventListener(MouseEvent.MOUSE_UP, OnMouseUp);
				stage.addEventListener(MouseEvent.MOUSE_MOVE, OnMouseOver);
			}
		}

		private function removeFromStageHandler(event : Event) : void {
			if (bUseDefinedMouse)
			{
				stage.removeEventListener(MouseEvent.MOUSE_MOVE, OnMouseMove);
				stage.removeEventListener(MouseEvent.ROLL_OUT, OnMouseOut);
				stage.removeEventListener(MouseEvent.MOUSE_DOWN, OnMouseDown);
				stage.removeEventListener(MouseEvent.MOUSE_UP, OnMouseUp);
				stage.removeEventListener(MouseEvent.MOUSE_UP,OnMouseOver);
			}
		}
		protected function OnMouseOver(event : Event) : void
		{
			if (!bUseDefinedMouse) return;
			bMouseDown = false;
			if (mousePhase == 0)
			{
				if (_mouse_mc.parent != null)
					_mouse_mc.parent.removeChild(_mouse_mc);
				_mouse_mc = _mouseUp_mc;
				_mouse_mc.x = stage.mouseX;
				_mouse_mc.y = stage.mouseY;
				if (bMouseShow)
					stage.addChild(_mouse_mc);
			}
		}
		
		protected function OnMouseOut(event : Event) : void
		{
			if (!bUseDefinedMouse) return;
			bMouseDown = false;
			if (mousePhase == 0)
			{
				if (_mouse_mc.parent != null)
					_mouse_mc.parent.removeChild(_mouse_mc);
				_mouse_mc = _mouseUp_mc;
				_mouse_mc.x = stage.mouseX;
				_mouse_mc.y = stage.mouseY;
				if (bMouseShow)
					stage.addChild(_mouse_mc);
			}
		}
		
		protected function OnMouseUp(event : Event) : void
		{
			if (!bUseDefinedMouse) return;
			bMouseDown = false;
			if (mousePhase == 0)
			{
				if (_mouse_mc.parent != null)
					_mouse_mc.parent.removeChild(_mouse_mc);
				_mouse_mc = _mouseUp_mc;
				_mouse_mc.x = stage.mouseX;
				_mouse_mc.y = stage.mouseY;
				if (bMouseShow)
					stage.addChild(_mouse_mc);
			}
		}
		
		protected function OnMouseDown(event : Event) : void
		{
			if (!bUseDefinedMouse) return;
			bMouseDown = true;
			if (mousePhase == 0 && _mouseDown_mc != null && bMouseShow)
			{
				if (_mouse_mc.parent != null)
					_mouse_mc.parent.removeChild(_mouse_mc);
				_mouse_mc = _mouseDown_mc;
				_mouse_mc.x = stage.mouseX;
				_mouse_mc.y = stage.mouseY;
				stage.addChild(_mouse_mc);
			}
			MouseEvent(event).updateAfterEvent();
		}
		
		protected function OnMouseMove(event : Event) : void
		{
			if (!bUseDefinedMouse) return;
			if (_mouse_mc != null && stage != null)
			{
				_mouse_mc.x = stage.mouseX;
				_mouse_mc.y = stage.mouseY;
			}
		}
		
		public function show() : void
		{
			if (bUseDefinedMouse)
			{
				if (_mouse_mc.parent == null)
					stage.addChild(_mouse_mc);
				bMouseShow = true;
			}
			else
			{
				Mouse.show();
			}
		}
		
		public function showPos(x : int,y : int) : void
		{
			show();
			if ( _mouse_mc != null )
			{
				_mouse_mc.x = stage.mouseX;
				_mouse_mc.y = stage.mouseY;
			}
		}
		
		public function hide() : void
		{
			if (bUseDefinedMouse)
			{
				bMouseShow = false;
				if (_mouse_mc.parent != null)
					_mouse_mc.parent.removeChild(_mouse_mc);
			}
			else
			{
				Mouse.hide();
			}
		}
		
	}

}