package com.ui.controls {
	import com.RichTextArea.TextButtonInfo;
	import com.utils.GFilterUtil;
	import com.ui.core.PhaseState;
	import com.ui.core.ScaleMode;
	import com.ui.core.UIComponent;
	import com.ui.data.ButtonData;
	import com.ui.layout.GLayout;
	import com.ui.manager.UIManager;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;


	/**
	 * Game Button
	 * 
	 * @author Cafe
	 * @version 20100708
	 */
	public class Button extends UIComponent {

		protected var _data : ButtonData;

		protected var _upSkin : Sprite;

		protected var _overSkin : Sprite;

		protected var _downSkin : Sprite;

		protected var _disabledSkin : Sprite;

		protected var _label : Label;

		protected var _current : Sprite;

		protected var _phase : int = PhaseState.UP;
		
		//protected var _DoMouseOffset : Boolean = false;
		//
		protected static const WRONGPOS : int = -10000;
		protected var MouseDownBackX : int = WRONGPOS;
		protected var MouseDownBackY : int = WRONGPOS;

		override protected function create() : void {
			_upSkin = UIManager.getUI(_data.upAsset);
			_overSkin = UIManager.getUI(_data.overAsset);
			_downSkin = UIManager.getUI(_data.downAsset);
			_disabledSkin = UIManager.getUI(_data.upAsset);//UIManager.getUI(_data.disabledAsset);
			_disabledSkin.filters = [GFilterUtil.GrayFilter()];
			_current = _upSkin;
			addChild(_current);
			_label = new  Label(_data.labelData);
			addChild(_label);
			switch(_data.scaleMode) {
				case ScaleMode.SCALE_WIDTH:
					_height = _upSkin.height;
					break;
				case ScaleMode.SCALE_NONE:
					_width = _upSkin.width;
					_height = _upSkin.height;
					break;
			}
		}

		override protected function layout() : void {
			GLayout.layout(_label);
			_upSkin.width = _width;
			_upSkin.height = _height;
			if(_overSkin != null) {
				_overSkin.width = _width;
				_overSkin.height = _height;
			}
			if(_downSkin != null) {
				_downSkin.width = _width;
				_downSkin.height = _height;
			}
			if(_disabledSkin != null) {
				_disabledSkin.width = _width;
				_disabledSkin.height = _height;
			}
		}

		override protected function onEnabled() : void {
			_label.enabled = _enabled;
			viewSkin();
		}

		override protected  function onShow() : void {
			super.onShow();
			addEventListener(MouseEvent.ROLL_OVER, rollOverHandler);
			addEventListener(MouseEvent.ROLL_OUT, rollOutHandler);
			addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			addEventListener(MouseEvent.CLICK, OnMouseClick);
		}
		protected function OnMouseClick(e:Event):void
		{
			trace( "MouseClick" );
		}

		override protected function onHide() : void {
			super.onHide();
			removeEventListener(MouseEvent.ROLL_OVER, rollOverHandler);
			removeEventListener(MouseEvent.ROLL_OUT, rollOutHandler);
			removeEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
		}

		protected function rollOverHandler(event : MouseEvent) : void {
			if (!_enabled) return;
			_phase = PhaseState.OVER;
			viewSkin();
		}

		protected function rollOutHandler(event : MouseEvent) : void {
			if (!_enabled) return;
			if ( _phase == PhaseState.DOWN && (MouseDownBackX != Button.WRONGPOS && MouseDownBackY != Button.WRONGPOS))
			{
				MovePicTo(-_data.xMouseDnOffset,-_data.yMouseDnOffset);
				//moveTo(MouseDownBackX, MouseDownBackY);
			}
			_phase = PhaseState.UP;
			viewSkin();
		}
		private var bMovedPic = false;
		protected function MovePicTo(xoffset : int , yoffset : int)
		{
			if ( xoffset < 0 && !bMovedPic )
			{
				return;
			}
			if ( xoffset > 0 && bMovedPic )
			{
				return;
			}
			if ( xoffset > 0 )
			{
				bMovedPic = true;
			}
			else
			{
				bMovedPic = false;
			}
			if (scaleX == 1)
			{
				if (_upSkin != null)
				{
					_upSkin.x += xoffset;
					_upSkin.y += yoffset;
				}
				
				if( _overSkin != null )
				{
					_overSkin.x += xoffset;
					_overSkin.y += yoffset;
				}
				
				if (_downSkin!= null)
				{
					_downSkin.x += xoffset;
					_downSkin.y += yoffset;
				}
				
				if( _disabledSkin != null )
				{
					_disabledSkin.x += xoffset;
					_disabledSkin.y += yoffset;
				}
			}
			else if (scaleX == -1)
			{
				if (_upSkin != null)
				{
					_upSkin.x -= xoffset;
					_upSkin.y += yoffset;
				}
				
				if( _overSkin != null )
				{
					_overSkin.x -= xoffset;
					_overSkin.y += yoffset;
				}
				
				if (_downSkin!= null)
				{
					_downSkin.x -= xoffset;
					_downSkin.y += yoffset;
				}
				
				if( _disabledSkin != null )
				{
					_disabledSkin.x -= xoffset;
					_disabledSkin.y += yoffset;
				}
			}
			
			
			//if ( _label != null )
			//{
				//_label.x += xoffset;
				//_label.y += yoffset;
			//}
		}
		
		protected function mouseDownHandler(event : MouseEvent) : void {
			if (!_enabled) return;
			if ( _data.DoMouseOffset && _phase!= PhaseState.DOWN )
			{
				if (MouseDownBackX == Button.WRONGPOS && MouseDownBackY == Button.WRONGPOS)
				{
					MouseDownBackX = x;
					MouseDownBackY = y;
				}
				trace("MouseDown : " + event.target);
				MovePicTo(_data.xMouseDnOffset, _data.yMouseDnOffset);
				//moveTo(MouseDownBackX + _data.xMouseDnOffset,MouseDownBackY + _data.yMouseDnOffset);
			}
			_phase = PhaseState.DOWN;
			viewSkin();

		}

		protected function mouseUpHandler(event : MouseEvent) : void {
			if (!_enabled) return;
			
			if ( _data.DoMouseOffset && _phase == PhaseState.DOWN && (MouseDownBackX != Button.WRONGPOS && MouseDownBackY != Button.WRONGPOS) )
			{
				
				MovePicTo( -_data.xMouseDnOffset, -_data.yMouseDnOffset);
				trace("MouseUP" + event.target);
				//moveTo(MouseDownBackX,MouseDownBackY);
			}
			
			_phase = ((event.currentTarget == this) ? PhaseState.OVER : PhaseState.UP);
			viewSkin();

		}

		protected function viewSkin() : void {
			if (!_enabled) {
				_label.textColor = _data.disabledColor;
				_current = swap(_current, _disabledSkin);
			}else if (_phase == PhaseState.UP) {
				if ( doubleClickEnabled )
				{
					MovePicTo(-_data.xMouseDnOffset,-_data.yMouseDnOffset);
					//moveTo(MouseDownBackX, MouseDownBackY);
				}
				_label.textColor = _data.labelData.textColor;
				_label.Nummber = _data.fieldInt;
				_label.filter = _data.fieldcolor;
				_current = swap(_current, _upSkin);
			}else if (_phase == PhaseState.OVER) {//鼠标一上来
				_label.textColor =  _data.rollOverColor;
				_label.Nummber = _data.upFieldInt;
				_label.filter = _data.upFieldColor;
				_current = swap(_current, _overSkin);
			}else if(_phase == PhaseState.DOWN) {
				_label.textColor = _data.labelData.textColor;
				_current = swap(_current, _downSkin);
			}
		}

		public function Button(data : ButtonData) {
			_data = data;
			super(data);
		}

		public function resetColor(textColor : uint,rollOverColor : uint,rollOverFilters:uint) : void {
			_data.labelData.textColor = textColor;
			_data.rollOverColor = rollOverColor;
			if (!_enabled) {
				_label.textColor = _data.disabledColor;
			}else if(_phase == PhaseState.UP) {
				_label.textColor = _data.labelData.textColor;
			}else if (_phase == PhaseState.OVER) {
				_label.textColor = _data.rollOverColor;
			}else if(_phase == PhaseState.DOWN) {
				_label.textColor = _data.labelData.textColor;
			}
		}

		public function set text(value : String) : void {
			_label.text = value;
			GLayout.layout(_label);
		}

		public function get label() : Label {
			return _label;
		}

		public function SetMouseOffset( boffset : Boolean ):void
		{
			_data.DoMouseOffset = boffset;
		}
		
		public function set icon(value : BitmapData) : void {
			_label.icon.bitmapdata = value;
			GLayout.layout(_label);
		}

		public function set iconGray(value : Boolean) : void {
			_label.icon.gray = value;
		}
		
		override public function initToolTip():void 
		{
			if ((_source as TextButtonInfo) != null)
			{
				(_source as TextButtonInfo).itemTipFunc((_source as TextButtonInfo).buttonStr.substr(3, (_source as TextButtonInfo).buttonStr.length - 5), toolTip);
			}
		}
		
		override public function clearToolTip():void 
		{
			if ((_source as TextButtonInfo) != null)
			{
				if (toolTip != null)
					toolTip.source = null;
			}
		}
	}
}
