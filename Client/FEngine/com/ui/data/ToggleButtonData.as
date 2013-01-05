package com.ui.data {
	import com.net.AssetData;
	import com.ui.core.Align;
	import com.ui.core.UIComponentData;
	import com.ui.skin.SkinEnum;
	import com.ui.skin.SkinStyle;

	/**
	 * @verison 20091215
	 * @author Cafe
	 */
	public class ToggleButtonData extends UIComponentData {

		public var upAsset : AssetData;

		public var overAsset : AssetData;

		public var downAsset : AssetData;

		public var disabledAsset : AssetData;

		public var selectedUpAsset : AssetData;

		public var selectedOverAsset : AssetData;

		public var selectedDownAsset : AssetData;

		public var selectedDisabledAsset : AssetData;

		public var labelData : LabelData;

		public var selected : Boolean = false;

		public var disabledColor : uint = 0x787878;

		public var textRollOverColor : uint = 0xFFFFFF;

		override protected function parse(source : *) : void {
			super.parse(source);
			var data : ToggleButtonData = source as ToggleButtonData;
			if(data == null)return;
			data.upAsset = upAsset;
			data.overAsset = overAsset;
			data.downAsset = downAsset;
			data.disabledAsset = disabledAsset;
			data.selectedUpAsset = selectedUpAsset;
			data.selectedOverAsset = selectedOverAsset;
			data.selectedDownAsset = selectedDownAsset;
			data.selectedDisabledAsset = selectedDisabledAsset;
			data.labelData = (labelData ? labelData.clone() : null);
			data.disabledColor = disabledColor;
			data.textRollOverColor = textRollOverColor;
			data.selected = selected;
		}

		public function ToggleButtonData() {
			upAsset = new AssetData("RButtonOver","Login");
			overAsset = new AssetData("RButtonOver","Login");
			downAsset = new AssetData("RButtonDown","Login");
			disabledAsset = new AssetData("RButtonOver","Login");
			selectedUpAsset = new AssetData("RButtonDown","Login");
			selectedOverAsset = new AssetData("RButtonOver","Login");
			selectedDownAsset = new AssetData("RButtonDown","Login");
			//selectedDisabledAsset = new AssetData(SkinStyle.button_selectedDisabledSkin);
			width = 70;
			height = 24;
			labelData = new LabelData();
			labelData.align = new Align(-1, -1, -1, -1, 0, 0);
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
					if ( nodeName == SkinEnum.ToggleBtn_Component_Label ) 			labelData.setSkinData(xml[nodeName].@template);
					else if ( nodeName == SkinEnum.ToggleBtn_Selected ) 			selected = ('true' == xml[nodeName]);
					else if ( nodeName == SkinEnum.ToggleBtn_DisabledColor ) 		disabledColor = xml[nodeName];
					else if ( nodeName == SkinEnum.ToggleBtn_TextRollOverColor ) 	textRollOverColor = xml[nodeName];
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
					if ( nodeName == SkinEnum.ToggleBtn_UpAssets ) 						upAsset = makeSkinAssetsData(xml[nodeName], xml[nodeName].@libkey);
					else if ( nodeName == SkinEnum.ToggleBtn_OverAssets ) 				overAsset = makeSkinAssetsData(xml[nodeName], xml[nodeName].@libkey);
					else if ( nodeName == SkinEnum.ToggleBtn_DownAssets ) 				downAsset = makeSkinAssetsData(xml[nodeName], xml[nodeName].@libkey);
					else if ( nodeName == SkinEnum.ToggleBtn_DisabledAssets ) 			disabledAsset = makeSkinAssetsData(xml[nodeName], xml[nodeName].@libkey);
					else if ( nodeName == SkinEnum.ToggleBtn_SelectedUpAssets ) 		selectedUpAsset = makeSkinAssetsData(xml[nodeName], xml[nodeName].@libkey);
					else if ( nodeName == SkinEnum.ToggleBtn_SelectedOverAssets ) 		selectedOverAsset = makeSkinAssetsData(xml[nodeName], xml[nodeName].@libkey);
					else if ( nodeName == SkinEnum.ToggleBtn_SelectedDownAssets ) 		selectedDownAsset = makeSkinAssetsData(xml[nodeName], xml[nodeName].@libkey);
					else if ( nodeName == SkinEnum.ToggleBtn_SelectedDisabledAssets ) 	selectedDisabledAsset = makeSkinAssetsData(xml[nodeName], xml[nodeName].@libkey);
				}
			}
		}
		
		
		override public function clone() : * {
			var data : ToggleButtonData = new ToggleButtonData();
			parse(data);
			return data;
		}
	}
}
