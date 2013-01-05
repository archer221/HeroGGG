package com.ui.data {
	import com.net.AssetData;
	import com.ui.core.Align;
	import com.ui.core.ScaleMode;
	import com.ui.core.UIComponentData;
	import com.ui.skin.SkinEnum;

	/**
	 * @version 20091215
	 * @author Cafe
	 */
	public class ComboBoxData extends UIComponentData {

		public var buttonData : ButtonData;

		public var textInputData : TextInputData;
		
		public var labelData :LabelData;

		public var arrow : ButtonData;

		public var listData : ListData;

		public var editable : Boolean = false;
		
		public var direction : Boolean = true;

		public function ComboBoxData() {
			buttonData = new ButtonData();
			buttonData.upAsset = new AssetData("GComboBox_upSkin");
			buttonData.overAsset = new AssetData("GComboBox_overSkin");
			buttonData.downAsset = new AssetData("GComboBox_downSkin");
			buttonData.disabledAsset = new AssetData("GComboBox_disabledSkin");
			buttonData.labelData.align = new Align(5, -1, -1, -1, -1, 0);
			textInputData = new TextInputData();
			labelData = new LabelData();
			labelData.y= -2;
			arrow = new ButtonData();
			arrow.upAsset = new AssetData("GComboBox_arrowUpSkin");
			arrow.overAsset = new AssetData("GComboBox_arrowOverSkin");
			arrow.downAsset = new AssetData("GComboBox_arrowDownSkin");
			arrow.disabledAsset = new AssetData("GComboBox_arrowDisabledSkin");
			arrow.width = 18;
			arrow.height = 22;
			listData = new ListData();
			listData.scaleMode = ScaleMode.AUTO_HEIGHT;
			width = 100;
			height = 22;
		}
		
		/**
		 * 解析组件theme数据
		 * 
		 */
		override protected function myThemeParse(xml:XML):void
		{
			if ( null == buttonData ) buttonData = new ButtonData();
			if ( null == arrow ) arrow = new ButtonData();
			if ( null == textInputData ) textInputData = new TextInputData();
			if ( null == labelData ) labelData = new LabelData();
			if ( null == listData ) listData = new ListData();
			
			var len:uint = xml.children().length()
			for ( var i:int = 0; i < len; i++ )
			{
				var nodeKind:String = xml.children()[i].nodeKind();
				var nodeName:String = xml.children()[i].name();
				
				if ( 'element' == nodeKind )
				{
					if ( nodeName == SkinEnum.Combo_Component_Btn )				buttonData.setSkinData(xml[nodeName].@template);
					else if ( nodeName == SkinEnum.Combo_Component_ArrowBtn ) 	arrow.setSkinData(xml[nodeName].@template);
					else if ( nodeName == SkinEnum.Combo_Component_Input ) 		textInputData.setSkinData(xml[nodeName].@template);
					else if ( nodeName == SkinEnum.Combo_Component_Label ) 		labelData.setSkinData(xml[nodeName].@template);
					else if ( nodeName == SkinEnum.Combo_Component_List )
					{
						if ( '' != xml[nodeName].@template )
							listData.setSkinData(xml[nodeName].@template + '_0_0_0_0_0');
					}
					else if ( nodeName == SkinEnum.Combo_Editable ) 			editable = ('true' == xml[nodeName]);
					else if ( nodeName == SkinEnum.Combo_Direction ) 			direction = ('true' == xml[nodeName]);
				}
			}
		}
	}
}
