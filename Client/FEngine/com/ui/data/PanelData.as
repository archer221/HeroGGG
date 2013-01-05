package com.ui.data {
	import com.net.AssetData;
	import com.ui.core.Align;
	import com.ui.core.UIComponentData;
	import com.ui.manager.ThemeSkinManager;
	import com.ui.skin.SkinEnum;
	import com.ui.skin.SkinStyle;

	/**
	 * Game Panel Data
	 * 
	 * @author Cafe
	 * @version 20100801
	 */
	public class PanelData extends UIComponentData {

		public var bgAsset : AssetData;

		public var modal : Boolean = false;

		public var padding : int = 0;

		public var scrollBarData : ScrollBarData = new ScrollBarData();

		override protected function parse(source : *) : void {
			super.parse(source);
			var data : PanelData = source as PanelData;
			if(data == null)return;
			data.bgAsset = bgAsset;
			data.modal = modal;
			data.padding = padding;
			data.scrollBarData = scrollBarData.clone();
		}
		
		/**
		 * 解析组件theme数据
		 * 
		 */
		override protected function myThemeParse(xml:XML):void
		{
			var len:uint = xml.children().length()
			for ( var i:int = 0; i < len; i++ )
			{
				var nodeKind:String = xml.children()[i].nodeKind();
				var nodeName:String = xml.children()[i].name();
				
				if ( 'element' == nodeKind )
				{
					if ( nodeName == SkinEnum.Bg_Modal ) 			modal = ('true' == xml[nodeName]);
					else if ( nodeName == SkinEnum.Bg_Padding ) 	padding = xml[nodeName];
				}
			}
		}
		
		/**
		 * 解析组件skin数据
		 * 
		 */
		override protected function mySkinParse(xml:XML):void
		{
			var len:uint = xml.children().length()
			for ( var i:int = 0; i < len; i++ )
			{
				var nodeKind:String = xml.children()[i].nodeKind();
				var nodeName:String = xml.children()[i].name();
				
				if ( 'element' == nodeKind )
				{
					if ( nodeName == SkinEnum.Bg_Assets ) bgAsset = makeSkinAssetsData(xml[nodeName], xml[nodeName].@libkey);
				}
			}
		}
		
		public function PanelData() {
			bgAsset = new AssetData(SkinStyle.panel_backgroundSkin);
			width = 100;
			height = 100;
		}

		override public function clone() : * {
			var data : PanelData = new PanelData();
			parse(data);
			return data;
		}
	}
}
