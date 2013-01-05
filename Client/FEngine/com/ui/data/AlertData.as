package com.ui.data
{
	import com.net.AssetData;
	import com.ui.controls.Alert;
	import com.ui.core.Align;
	import com.ui.core.ScaleMode;
	import com.ui.manager.ThemeSkinManager;
	import com.ui.manager.UIManager;
	import com.ui.skin.SkinEnum;
	import com.ui.skin.SkinStyle;
	import flash.utils.Dictionary;
	
	/**
	 * Game Alert Data
	 *
	 * @author Cafe
	 * @version 20100715
	 */
	public class AlertData extends PanelData
	{
		
		public var labelData:LabelData;
		
		public var textInputData:TextInputData;
		
		public var buttonData:ButtonData;
		
		public var okbuttonData:ButtonData;
		
		public var yesbuttonData:ButtonData;
		
		public var nobuttonData:ButtonData;
		
		public var cancelbuttonData:ButtonData;
		
		public var flag:uint = 0x4;
		
		public var okLabel:String = ""; //"<b>确定</b>";
		
		public var cancelLabel:String = ""; //"<b>取消</b>";
		
		public var yesLabel:String = ""; //"<b>是</b>";
		
		public var noLabel:String = ""; // "<b>否</b>";
		
		public var hgap:int = 10;
		
		public var vgap:int = 10;
		
		override protected function parse(source:*):void
		{
			super.parse(source);
			var data:AlertData = source as AlertData;
			if (data == null)
				return;
			data.labelData = labelData.clone();
			data.textInputData = (textInputData ? textInputData.clone() : null);
			data.buttonData = buttonData.clone();
			data.okbuttonData = okbuttonData.clone();
			data.yesbuttonData = yesbuttonData.clone();
			data.nobuttonData = nobuttonData.clone();
			data.cancelbuttonData = cancelbuttonData.clone();
			data.flag = flag;
			data.okLabel = okLabel;
			data.cancelLabel = cancelLabel;
			data.yesLabel = yesLabel;
			data.noLabel = noLabel;
			data.hgap = hgap;
			data.vgap = vgap;
		}
		
		public function AlertData()
		{
			bgAsset = new AssetData(SkinStyle.emptySkin);
			modal = true;
			scaleMode = ScaleMode.AUTO_SIZE;
			align = Align.CENTER;
			padding = 10;
			minWidth = 150;
			minHeight = 60;
			labelData = new LabelData();
			labelData.textFieldFilters = UIManager.getEdgeFilters(0x000000, 0.7);
			buttonData = new ButtonData();
			okbuttonData = new ButtonData();
			yesbuttonData = new ButtonData();
			nobuttonData = new ButtonData();
			cancelbuttonData = new ButtonData();
			buttonData.width = 60;
		}
		
		/**
		 * 解析组件theme数据
		 * 
		 */
		override protected function myThemeParse(xml:XML):void
		{
			if ( null == buttonData ) buttonData = new ButtonData();
			if ( null == okbuttonData ) okbuttonData = new ButtonData();
			if ( null == cancelbuttonData ) cancelbuttonData = new ButtonData();
			if ( null == yesbuttonData ) yesbuttonData = new ButtonData();
			if ( null == nobuttonData ) nobuttonData = new ButtonData();
			if ( null == textInputData ) textInputData = new TextInputData();
			if ( null == labelData ) labelData = new LabelData();
			
			var len:uint = xml.children().length()
			for ( var i:int = 0; i < len; i++ )
			{
				var nodeKind:String = xml.children()[i].nodeKind();
				var nodeName:String = xml.children()[i].name();
				
				if ( 'element' == nodeKind )
				{
					if ( nodeName == SkinEnum.Alert_Component_Btn )				buttonData.setSkinData(xml[nodeName].@template);
					else if ( nodeName == SkinEnum.Alert_Component_BtnOK ) 		okbuttonData.setSkinData(xml[nodeName].@template);
					else if ( nodeName == SkinEnum.Alert_Component_BtnCancel ) 	cancelbuttonData.setSkinData(xml[nodeName].@template);
					else if ( nodeName == SkinEnum.Alert_Component_BtnYes ) 	yesbuttonData.setSkinData(xml[nodeName].@template);
					else if ( nodeName == SkinEnum.Alert_Component_BtnNo ) 		nobuttonData.setSkinData(xml[nodeName].@template);
					else if ( nodeName == SkinEnum.Alert_Component_TextInput ) 	textInputData.setSkinData(xml[nodeName].@template);
					else if ( nodeName == SkinEnum.Alert_Component_Label ) 		labelData.setSkinData(xml[nodeName].@template);
					else if ( nodeName == SkinEnum.Alert_Padding ) 				padding = xml[nodeName];
					else if ( nodeName == SkinEnum.Alert_Flag ) 
					{
						var dic:Dictionary = new Dictionary(true);
						dic['ok'] = Alert.OK;
						dic['cancel'] = Alert.CANCEL;
						dic['yes'] = Alert.YES;
						dic['no'] = Alert.NO;
						dic['none'] = Alert.NONE;
						
						var string:String = String(xml[nodeName]);
						var arr:Array = string.split('|'); 
						if ( 1 == arr.length ) flag = dic[arr[0]];
						else if ( 2 == arr.length ) flag = dic[arr[0]] | dic[arr[1]];
						else trace('--- AlertData.flag Error! ---');
					}
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
					if ( nodeName == SkinEnum.Alert_BgAssets ) bgAsset = makeSkinAssetsData(xml[nodeName], xml[nodeName].@libkey);
				}
			}
		}
		
		override public function clone():*
		{
			var data:AlertData = new AlertData();
			parse(data);
			return data;
		}
	}
}
