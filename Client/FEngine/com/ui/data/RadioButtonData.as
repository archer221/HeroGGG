package com.ui.data {
	import com.net.AssetData;
	import com.ui.core.UIComponentData;
	import com.ui.skin.SkinEnum;
	import com.ui.skin.SkinStyle;

	/**
	 * @version 20091215
	 * @author Cafe
	 */
	public class RadioButtonData extends UIComponentData {

		public var upAsset : AssetData;

		public var upIcon : AssetData;

		public var selectedUpIcon : AssetData;

		public var labelData : LabelData;

		public var selected : Boolean = false;

		public var padding : int = 2;

		public var hGap : int = 2;

		override protected function parse(source : *) : void {
			super.parse(source);
			var data : RadioButtonData = source as RadioButtonData;
			if(data == null)return;
			data.upAsset = upAsset;
			data.upIcon = upIcon;
			data.selectedUpIcon = selectedUpIcon;
			data.labelData = labelData.clone();
			data.selected = selected;
			data.padding = padding;
			data.hGap = hGap;
		}

		public function RadioButtonData() {
			upAsset = new AssetData(SkinStyle.emptySkin, AssetData.AS_LIB);
			upIcon = new AssetData(SkinStyle.radioButton_upIcon);
			selectedUpIcon = new AssetData(SkinStyle.radioButton_selectedUpIcon);
			labelData = new LabelData();
			width = 70;
			height = 18;
		}
		
		/**
		 * 解析组件theme数据
		 * 
		 */
		override protected function myThemeParse(xml:XML):void
		{
			if ( null == labelData ) labelData = new LabelData();
			
			var len:uint = xml.children().length()
			for ( var i:int = 0; i < len; i++ )
			{
				var nodeKind:String = xml.children()[i].nodeKind();
				var nodeName:String = xml.children()[i].name();
				
				if ( 'element' == nodeKind )
				{
					if ( nodeName == SkinEnum.Radio_Component_Label ) 	labelData.setSkinData(xml[nodeName].@template);
					else if ( nodeName == SkinEnum.Radio_Selected ) 	selected = ('true' == xml[nodeName]);
					else if ( nodeName == SkinEnum.Radio_Padding ) 		padding = xml[nodeName];
					else if ( nodeName == SkinEnum.Radio_HGap ) 		hGap = xml[nodeName];
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
					if ( nodeName == SkinEnum.Radio_UpAssets ) 				upAsset = makeSkinAssetsData(xml[nodeName], xml[nodeName].@libkey);
					else if ( nodeName == SkinEnum.Radio_UpIcon ) 			upIcon = makeSkinAssetsData(xml[nodeName], xml[nodeName].@libkey);
					else if ( nodeName == SkinEnum.Radio_SelectedUpIcon ) 	selectedUpIcon = makeSkinAssetsData(xml[nodeName], xml[nodeName].@libkey);
				}
			}
		}
		
		override public function clone() : * {
			var data : RadioButtonData = new RadioButtonData();
			parse(data);
			return data;
		}
	}
}
