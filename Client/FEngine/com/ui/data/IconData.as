package com.ui.data {
	import com.net.AssetData;
	import com.ui.core.ScaleMode;
	import com.ui.core.UIComponentData;
	import com.ui.manager.ThemeSkinManager;
	import com.ui.skin.SkinEnum;
	import flash.display.BitmapData;
	import flash.display.Sprite;


	/**
	 * @version 20091215
	 * @author Cafe
	 */
	public class IconData extends UIComponentData {

		public var asset : AssetData;

		public var bitmapData : BitmapData;

		override protected function parse(source : *) : void {
			super.parse(source);
			var data : IconData = source as IconData;
			if(data == null)return;
			data.asset = asset;
			data.bitmapData = bitmapData;
			data.loadingsprte = loadingsprte;
		}

		public function IconData() {
			scaleMode = ScaleMode.AUTO_SIZE;
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
					if ( nodeName == SkinEnum.Icon_Assets ) asset = makeSkinAssetsData(xml[nodeName], xml[nodeName].@libkey);
				}
			}
		}
		
		override public function clone() : * {
			var data : IconData = new IconData();
			parse(data);
			return data;
		}
	}
}
