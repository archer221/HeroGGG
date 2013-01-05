package com.ui.cell {
	//import BZTC.task.TaskGuard.Config.ComposeGuardConfig;
	import com.net.AssetData;
	import com.ui.core.Align;
	import com.ui.core.UIComponentData;
	import com.ui.data.IconData;
	import com.ui.data.LabelData;
	import com.ui.data.ToolTipData;
	import com.ui.manager.ThemeSkinManager;
	import com.ui.skin.SkinEnum;
	import com.utils.BDUtil;

	/**
	 * Game Cell Data
	 * 
	 * @author Cafe
	 * @version 20100730
	 */
	public class CellData extends UIComponentData {

		public var upAsset : AssetData;

		public var overAsset : AssetData;

		public var selected_upAsset : AssetData;

		public var selected_overAsset : AssetData;

		public var disabledAsset : AssetData;

		public var lockIconData : IconData;

		public var labelData : LabelData;

		public var allowSelect : Boolean ;

		public var clickSelect : Boolean;

		public var allowDoubleClick : Boolean;

		public var lock : Boolean;

		public var index : int;

		public var hotKey : String;
		
		public var bShowDeleteButon : Boolean;

		override protected function parse(source : *) : void {
			super.parse(source);
			var data : CellData = source as CellData;
			if(data == null)return;
			data.upAsset = upAsset;
			data.overAsset = overAsset;
			data.selected_upAsset = selected_upAsset;
			data.selected_overAsset = selected_overAsset;
			data.disabledAsset = disabledAsset;
			data.lockIconData = lockIconData.clone();
			data.labelData = labelData.clone();
			data.allowSelect = allowSelect;
			data.clickSelect = clickSelect;
			data.allowDoubleClick = allowDoubleClick;
			data.lock = lock;
			data.bShowDeleteButon = bShowDeleteButon;
		}

		public function CellData() {
			upAsset = new AssetData("GCell_upSkin");
			overAsset = new AssetData("GCell_overSkin");
			selected_upAsset = new AssetData("GCell_selected_upSkin");
			selected_overAsset == new AssetData("GCell_selected_overSkin");
			disabledAsset = new AssetData("GCell_disabledSkin");
			lockIconData = new IconData();
			labelData = new LabelData();
			allowSelect = true;
			clickSelect = true;
			allowDoubleClick = false;
			bShowDeleteButon = false;
			lock = false;
			index = -1;
			width = 100;
			height = 22;
			labelData.align = new Align(8, -1, -1, -1, -1, 0);
			lockIconData.bitmapData = BDUtil.getBD(new AssetData("lock_icon"));
			lockIconData.align = Align.CENTER;
			toolTipData = new ToolTipData();
		}
		
		/**
		 * 解析组件theme数据
		 * 
		 */
		override protected function myThemeParse(xml:XML):void
		{
			if ( null == lockIconData ) lockIconData = new IconData();
			if ( null == labelData ) labelData = new LabelData();
			
			var len:uint = xml.children().length()
			for ( var i:int = 0; i < len; i++ )
			{
				var nodeKind:String = xml.children()[i].nodeKind();
				var nodeName:String = xml.children()[i].name();
				
				if ( 'element' == nodeKind )
				{
					if ( nodeName == SkinEnum.Cell_Component_Icon ) 		lockIconData.setSkinData(xml[nodeName].@template);
					else if ( nodeName == SkinEnum.Cell_Component_Label ) 	labelData.setSkinData(xml[nodeName].@template);
					else if ( nodeName == SkinEnum.Cell_AllowSelect ) 		allowSelect = ('true' == xml[nodeName]);
					else if ( nodeName == SkinEnum.Cell_ClickSelect ) 		clickSelect = ('true' == xml[nodeName]);
					else if ( nodeName == SkinEnum.Cell_AllowDoubleClick ) 	allowDoubleClick = ('true' == xml[nodeName]);
					else if ( nodeName == SkinEnum.Cell_Lock ) 				lock = ('true' == xml[nodeName]);
					else if ( nodeName == SkinEnum.Cell_Index ) 			index = xml[nodeName];
					else if ( nodeName == SkinEnum.Cell_IsShowDeleteBtn ) 	bShowDeleteButon = ('true' == xml[nodeName]);
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
					if ( nodeName == SkinEnum.Cell_UpAssets ) 					upAsset = makeSkinAssetsData(xml[nodeName], xml[nodeName].@libkey);
					else if ( nodeName == SkinEnum.Cell_OverAssets ) 			overAsset = makeSkinAssetsData(xml[nodeName], xml[nodeName].@libkey);
					else if ( nodeName == SkinEnum.Cell_Selected_UpAssets ) 	selected_upAsset = makeSkinAssetsData(xml[nodeName], xml[nodeName].@libkey);
					else if ( nodeName == SkinEnum.Cell_Selected_OverAssets ) 	selected_overAsset = makeSkinAssetsData(xml[nodeName], xml[nodeName].@libkey);
					else if ( nodeName == SkinEnum.Cell_DisabledAssets ) 		disabledAsset = makeSkinAssetsData(xml[nodeName], xml[nodeName].@libkey);
				}
			}
		}
		
		override public function clone() : * {
			var data : CellData = new CellData();
			parse(data);
			return data;
		}
	}
}
