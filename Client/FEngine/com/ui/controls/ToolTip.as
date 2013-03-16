package com.ui.controls {
	import com.net.AssetData;
	import com.net.LibsManager;
	import com.ui.core.UIComponent;
	import com.ui.data.ToolTipData;
	import com.ui.manager.UIManager;
	import flash.display.Sprite;


	/**
	 * Game ToolTip
	 * 
	 * @author Cafe
	 * @version 20100719
	 */
	public class ToolTip extends UIComponent {

		protected var _data : ToolTipData;
		protected var effectTimeIcon : Sprite;

		protected var _backgroundSkin : Sprite;

		protected var _label : Label;
		protected var ItemName:Label;

		override protected function create() : void {
			_backgroundSkin = UIManager.getUI(_data.backgroundAsset);
			addChild(_backgroundSkin);
			_label = new Label(_data.labelData);
			_label.x = _label.y = _data.padding;
			addChild(_label);
			effectTimeIcon = UIManager.getUI(data.effecttimeAsset);
			if (effectTimeIcon != null)
				addChild(effectTimeIcon);
			effectTimeIcon.visible = false;
			ItemName = new Label(_data.labelData);
			ItemName.x = ItemName.y = _data.padding;
			addChild(ItemName);
		}

		override protected function layout() : void {
			//_width = _label.width + _data.padding * 2;
			//_height = _label.height + _data.padding * 2;
			//_backgroundSkin.width = _width;
			//_backgroundSkin.height = _height;
			if (ItemName.text.length > 0)
			{
				if (effectTimeIcon != null)
				{
					effectTimeIcon.width = ItemName.width + 65;
					effectTimeIcon.x = _width / 8;
					effectTimeIcon.y = 0;
				}
				_width = _label.width + _data.padding * 2;
				_height = _label.height + _data.padding * 2;
				if(_width<=effectTimeIcon.width + effectTimeIcon.width / 4){
					_width = effectTimeIcon.width + effectTimeIcon.width / 4;
					_height = _label.height + _data.padding * 2;
					_backgroundSkin.width = _width;
					_backgroundSkin.height = _height - 5;
					ItemName.x = effectTimeIcon.x + 30;
				}else {
					effectTimeIcon.x = (_width - effectTimeIcon.width) * 0.5;
					_backgroundSkin.width = _width;
					_backgroundSkin.height = _height - 5;
					ItemName.x = effectTimeIcon.x + 30;
				}
			}else {
				//var maxWidth:int=0;
				//super.layout();
				//_width = _label.width + _data.padding * 2;
				//_height = _label.height + _data.padding * 2;
				//_backgroundSkin.height = _height - 5;
				//if (_label.text.length>=10){
				//var y:int = 0;
				//if (bindIcon != null) {
					//y = bindIcon.width;
				//}
				//maxWidth = y;
				//}
				//if (effectTimeIcon != null)
				//{
					//effectTimeIcon.width = _width - _width / 4;
					//effectTimeIcon.x = _width / 8;
					//effectTimeIcon.y = 0;
				//}
			
				_width = _label.width + _data.padding * 2;
				_height = _label.height + _data.padding * 2;
				_backgroundSkin.width = _width;
				_backgroundSkin.height = _height;
			}
		}

		public function ToolTip(data : ToolTipData) {
			_data = data;
			_data.effecttimeAsset = new AssetData("TipsHeadbg", LibsManager.Instance.uicommon.key);
			super(data);
			mouseEnabled = mouseChildren = false;
		}

		public function get data() : ToolTipData {
			return _data;
		}

		public function get text() : String {
			return _label.text;
		}
		
		public function set HeadName(str:String):void
		{
			if (str.length < 1) 
			{
				effectTimeIcon.visible = false;
			}else{
				effectTimeIcon.visible = true;
			}
			ItemName.text = str;
			layout();
		}

		override public function set source(value : *) : void {
			if(value == null) {
				_label.clear();
			} else {
				_label.text = String(value);
				layout();
			}
			_source = value;
		}
	}
}