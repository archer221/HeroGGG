package com.ui.data {
	import com.net.AssetData;
	import com.ui.core.Align;
	import com.ui.core.UIComponentData;
	import com.ui.manager.ThemeSkinManager;
	import com.ui.skin.SkinEnum;
	import com.ui.skin.SkinStyle;

	/**
	 * Game Button Data
	 * 
	 * @author Cafe
	 * @version 20100727
	 */
	public class ButtonData extends UIComponentData {

		public var upAsset : AssetData;

		public var overAsset : AssetData;

		public var downAsset : AssetData;

		public var disabledAsset : AssetData;

		public var labelData : LabelData;
		
		public var OverFiltersColor:uint;
		
		public var fieldInt:Number;
		
		public var fieldcolor:uint;
		
		public var Upcolor:uint;
		
		public var upFieldColor:uint;
		
		public var upFieldInt:Number;
		
		public var rollOverColor:uint;

		public var disabledColor : uint = 0x898989;
		
		public var DoMouseOffset : Boolean = true;
		
		public var xMouseDnOffset : int = 2;
		public var yMouseDnOffset : int = 2;

		override protected function parse(source : *) : void {
			super.parse(source);
			var data : ButtonData = source as ButtonData;
			if(data == null)return;
			data.upAsset = upAsset;
			data.overAsset = overAsset;
			data.downAsset = downAsset;
			data.disabledAsset = disabledAsset;
			data.labelData = (labelData ? labelData.clone() : null);
			data.disabledColor = disabledColor;
			data.rollOverColor = rollOverColor;
			data.OverFiltersColor = OverFiltersColor;
			data.DoMouseOffset = DoMouseOffset;
			data.xMouseDnOffset = xMouseDnOffset;
			data.yMouseDnOffset = yMouseDnOffset;
			data.fieldcolor = fieldcolor;
			data.fieldInt = fieldInt;
			data.Upcolor = Upcolor;
			data.upFieldColor = upFieldColor;
			data.upFieldInt = upFieldInt;
		}

		public function ButtonData() {
			upAsset = new AssetData(SkinStyle.button_upSkin);
			overAsset = new AssetData(SkinStyle.button_overSkin);
			downAsset = new AssetData(SkinStyle.button_downSkin);
			disabledAsset = new AssetData(SkinStyle.button_disabledSkin);
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
					if ( nodeName == SkinEnum.Btn_Component_Label ) 	labelData.setSkinData(xml[nodeName].@template);
					else if ( nodeName == SkinEnum.Btn_UpColor ) 		Upcolor = xml[nodeName];
					else if ( nodeName == SkinEnum.Btn_RollOverColor ) 	rollOverColor = xml[nodeName];
					else if ( nodeName == SkinEnum.Btn_DisabledColor ) 	disabledColor = xml[nodeName];
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
					if ( nodeName == SkinEnum.Btn_Skin_Up ) 			upAsset = makeSkinAssetsData(xml[nodeName], xml[nodeName].@libkey);
					else if ( nodeName == SkinEnum.Btn_Skin_Over ) 		overAsset = makeSkinAssetsData(xml[nodeName], xml[nodeName].@libkey);
					else if ( nodeName == SkinEnum.Btn_Skin_Down ) 		downAsset = makeSkinAssetsData(xml[nodeName], xml[nodeName].@libkey);
					else if ( nodeName == SkinEnum.Btn_Skin_Disabled ) 	disabledAsset = makeSkinAssetsData(xml[nodeName], xml[nodeName].@libkey);
				}
			}
		}
		
		override public function clone() : * {
			var data : ButtonData = new ButtonData();
			parse(data);
			return data;
		}
	}
}
