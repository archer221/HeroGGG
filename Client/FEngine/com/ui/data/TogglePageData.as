package com.ui.data 
{
	import com.net.AssetData;
	import com.ui.core.Align;
	import com.ui.core.UIComponentData;
	import com.ui.layout.GGirdLayout;
	import flash.geom.Point;
	/**
	 * ...
	 * @author ...
	 */
	public class TogglePageData extends UIComponentData
	{
		public var prev_buttonData : ButtonData;

		public var next_buttonData : ButtonData;
		
		public var bdFontAsset : AssetData;
		
		public var bdFontWidth : int;
		
		public var bdFontHeight : int;
		
		public var bdFontLeading : int;
		
		public var chars : Array;
		
		public var toggleButtonData : ToggleButtonData;
		
		public var ggridLayOut : GGirdLayout;
		
		public var maxPageShow : int;
		
		override protected function parse(source:*):void 
		{
			super.parse(source);
			var data : TogglePageData = source as TogglePageData;
			if(data == null)return;
			data.prev_buttonData = (prev_buttonData == null ? null : prev_buttonData.clone());
			data.next_buttonData = (next_buttonData == null ? null : next_buttonData.clone());
			data.toggleButtonData = (toggleButtonData == null ? null : toggleButtonData.clone());
			data.ggridLayOut = ggridLayOut;
			data.bdFontAsset = bdFontAsset;
			data.bdFontWidth = bdFontWidth;
			data.bdFontHeight = bdFontHeight;
			data.bdFontLeading = bdFontLeading;
			data.maxPageShow = maxPageShow;
			data.chars = chars;
		}
		
		public function TogglePageData() 
		{
			width = 82;
			height = 31;
			prev_buttonData = new ButtonData();
			prev_buttonData.width = 82;
			prev_buttonData.height = 31;
			prev_buttonData.align = new Align(0, -1, -1, -1, -1, 0);
			prev_buttonData.labelData.text = "";
			next_buttonData = new ButtonData();
			next_buttonData.width = 50;
			next_buttonData.align = new Align( -1, 0, -1, -1, -1, 0);
			toggleButtonData = new ToggleButtonData();
			ggridLayOut = new GGirdLayout(new Point(0, 0), 1, 1, 20, 20, 0);
			maxPageShow = 1;
		}
		
		override public function clone() : * {
			var data : TogglePageData = new TogglePageData();
			parse(data);
			return data;
		}
		
	}

}