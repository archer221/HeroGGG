package com.ui.data {
	import com.net.AssetData;
	import com.ui.core.UIComponentData;
	import com.ui.manager.ThemeSkinManager;
	import com.ui.skin.SkinEnum;
	import com.ui.skin.SkinStyle;

	/**
	 * @version 20091215
	 * @author Cafe
	 */
	public class ScrollBarData extends UIComponentData {

		public static const VERTICAL : int = 0;

		public static const HORIZONTAL : int = 1;

		public var trackAsset : AssetData = new AssetData(SkinStyle.scrollBar_trackSkin);

		public var thumbButtonData : ButtonData;
		
		public var upButtonData:ButtonData;
		
		public var downButtonData:ButtonData;

		public var direction : int = VERTICAL;

		public var wheelSpeed : int = 2;

		override protected function parse(source : *) : void {
			super.parse(source);
			var data : ScrollBarData = source as ScrollBarData;
			if(data == null)return;
			data.trackAsset = trackAsset;
			data.thumbButtonData = (thumbButtonData ? thumbButtonData.clone() : null);
			data.upButtonData = (upButtonData? upButtonData.clone():null);
			data.downButtonData = (downButtonData? downButtonData.clone():null);
			data.direction = direction;
			data.wheelSpeed = wheelSpeed;
		}

		public function ScrollBarData() {
			thumbButtonData = new ButtonData();
			thumbButtonData.upAsset = new AssetData(SkinStyle.scrollBar_thumbUpSkin);
			thumbButtonData.overAsset = new AssetData(SkinStyle.scrollBar_thumbOverSkin);
			thumbButtonData.downAsset = new AssetData(SkinStyle.scrollBar_thumbDownSkin);
			thumbButtonData.disabledAsset = null;
			upButtonData = new ButtonData();
			upButtonData.upAsset = new AssetData(SkinStyle.scrollBar_thumbUpSkin);
			upButtonData.overAsset = new AssetData(SkinStyle.scrollBar_thumbOverSkin);
			upButtonData.downAsset = new AssetData(SkinStyle.scrollBar_thumbDownSkin);
			upButtonData.disabledAsset = null;
			downButtonData = new ButtonData();
			downButtonData.upAsset = new AssetData(SkinStyle.scrollBar_thumbUpSkin);
			downButtonData.overAsset = new AssetData(SkinStyle.scrollBar_thumbOverSkin);
			downButtonData.downAsset = new AssetData(SkinStyle.scrollBar_thumbDownSkin);
			downButtonData.disabledAsset = null;
			width = 14;
			height = 100;
		}
		
		
		/**
		 * 解析组件theme数据
		 * 
		 */
		override protected function myThemeParse(xml:XML):void
		{
			if ( null == thumbButtonData ) thumbButtonData = new ButtonData();
			
			var len:uint = xml.children().length()
			for ( var i:int = 0; i < len; i++ )
			{
				var nodeKind:String = xml.children()[i].nodeKind();
				var nodeName:String = xml.children()[i].name();
				
				if ( 'element' == nodeKind )
				{
					if ( nodeName == SkinEnum.Scroll_Component_Btn ) 		thumbButtonData.setSkinData(xml[nodeName].@template);
					else if ( nodeName == SkinEnum.Scroll_Direction ) 		direction = xml[nodeName];
					else if ( nodeName == SkinEnum.Scroll_WheelSpeed ) 		wheelSpeed = xml[nodeName];
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
					if ( nodeName == SkinEnum.Scroll_TrackAssets ) trackAsset = makeSkinAssetsData(xml[nodeName], xml[nodeName].@libkey);
				}
			}
		}
		
		override public function clone() : * {
			var data : ScrollBarData = new ScrollBarData();
			parse(data);
			return data;
		}
	}
}
