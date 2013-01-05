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
	public class CheckBoxData extends UIComponentData {

		public var upAsset : AssetData;

		public var upIcon : AssetData;

		public var selectedUpIcon : AssetData;

		public var labelData : LabelData = new LabelData();

		public var selected : Boolean = false;

		public var padding : int = 2;

		public var hGap : int = 3;

		override protected function parse(source : *) : void {
			super.parse(source);
			var data : CheckBoxData = source as CheckBoxData;
			if(data == null)return;
			data.upAsset = upAsset;
			data.upIcon = upIcon;
			data.selectedUpIcon = selectedUpIcon;
			data.labelData = labelData.clone();
			data.selected = selected;
			data.hGap = hGap;
			data.padding = padding;
		}

		public function CheckBoxData() {
			upAsset = new AssetData(SkinStyle.emptySkin, AssetData.AS_LIB);
			upIcon = new AssetData(SkinStyle.checkBox_upIcon);
			selectedUpIcon = new AssetData(SkinStyle.checkBox_selectedUpIcon);
			width = 70;
			height = 18;
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
					if ( nodeName == SkinEnum.Checkbox_HGap ) 			hGap = xml[nodeName];
					else if ( nodeName == SkinEnum.Checkbox_Padding ) 	padding = xml[nodeName];
					else if ( nodeName == SkinEnum.Checkbox_Selected ) 	selected = ('true' == xml[nodeName]);
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
					if ( nodeName == SkinEnum.Checkbox_Skin_Up ) 			upAsset = makeSkinAssetsData(xml[nodeName], xml[nodeName].@libkey);
					else if ( nodeName == SkinEnum.Checkbox_UpIcon ) 		upIcon = makeSkinAssetsData(xml[nodeName], xml[nodeName].@libkey);
					else if ( nodeName == SkinEnum.Checkbox_SelectIcon ) 	selectedUpIcon = makeSkinAssetsData(xml[nodeName], xml[nodeName].@libkey);
				}
			}
		}
		
		override public function clone() : * {
			var data : CheckBoxData = new CheckBoxData();
			parse(data);
			return data;
		}
	}
}
