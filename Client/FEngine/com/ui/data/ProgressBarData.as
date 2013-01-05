package com.ui.data {
	import com.net.AssetData;
	import com.net.LibsManager;
	import com.ui.core.Align;
	import com.ui.core.UIComponentData;
	import com.ui.manager.ThemeSkinManager;
	import com.ui.skin.SkinEnum;
	import com.ui.skin.SkinStyle;

	/**
	 * Game Progress Bar Data
	 * 
	 * @author Cafe
	 * @version 20100719
	 */
	public class ProgressBarData extends UIComponentData {

		public static const MANUAL : int = 0;

		public static const POLLED : int = 1;

		public var trackAsset : AssetData;

		public var barAsset : AssetData;

		public var highLightAsset : AssetData;

		public var labelData : LabelData;

		public var padding : int;

		public var barMask : Boolean;

		public var mode : int ;

		public var value : int;

		public var max : int = 100;

		override protected function parse(source : *) : void {
			super.parse(source);
			var data : ProgressBarData = source as ProgressBarData;
			if(data == null)return;
			data.trackAsset = trackAsset;
			data.barAsset = barAsset;
			data.labelData = labelData.clone();
			data.padding = padding;
			data.barMask = barMask;
			data.mode = mode;
			data.value = value;
			data.max = max;
		}

		public function ProgressBarData() {
			trackAsset = new AssetData("BloodBar",LibsManager.Instance.fightlib.key);
			barAsset = new AssetData(SkinStyle.progressBar_trackSkin);
			labelData = new LabelData();
			labelData.align = Align.CENTER;
			mode =MANUAL ;
			max = 100;
			barMask = false;
			width = 100;
			height = 10;
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
					if ( nodeName == SkinEnum.Progress_Component_Label ) labelData.setSkinData(xml[nodeName].@template);
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
					if ( nodeName == SkinEnum.Progress_BarAssets ) 			barAsset = makeSkinAssetsData(xml[nodeName], xml[nodeName].@libkey);
					else if ( nodeName == SkinEnum.Progress_TrackAssets )	trackAsset = makeSkinAssetsData(xml[nodeName], xml[nodeName].@libkey);
				}
			}
		}
		
		override public function clone() : * {
			var data : ProgressBarData = new ProgressBarData();
			parse(data);
			return data;
		}
	}
}
