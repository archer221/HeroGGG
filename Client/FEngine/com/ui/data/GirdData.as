package com.ui.data {
	import BZTC.debug.ErrorEnum;
	import com.net.AssetData;
	import com.ui.cell.Cell;
	import com.ui.cell.CellData;
	import com.ui.controls.Alert;
	import com.ui.core.ScaleMode;
	import com.ui.manager.ThemeSkinManager;
	import com.ui.manager.UIManager;
	import com.ui.skin.SkinEnum;
	import com.utils.BDUtil;

	/**
	 * @version 20100330
	 * @author Cafe
	 */
	public class GirdData extends PanelData {

		public var allowDrag : Boolean = false;

		public var hgap : int = 2;

		public var vgap : int = 2;

		public var columns : int = 3;

		public var rows : int = 3;

		public var cell : Class = Cell;

		public var cellData : CellData = new CellData();

		public var alertData : AlertData;

		public var hotKeys : Array;

		override protected function parse(source : *) : void {
			super.parse(source);
			var data : GirdData = source as GirdData;
			if(data == null)return;
			data.allowDrag = allowDrag;
			data.hgap = hgap;
			data.vgap = vgap;
			data.columns = columns;
			data.rows = rows;
			data.cell = cell;
			data.cellData = cellData.clone();
			data.alertData = alertData.clone();
		}

		public function GirdData() {
			alertData = new AlertData();
			alertData.parent = UIManager.root;
			alertData.labelData.iconData.bitmapData = BDUtil.getBD(new AssetData("light_22"));
			alertData.flag = Alert.YES | Alert.NO;
			scaleMode = ScaleMode.AUTO_SIZE;
		}
		
		/**
		 * 解析组件theme数据
		 * 
		 */
		override protected function myThemeParse(xml:XML):void
		{
			if ( null == alertData ) alertData = new AlertData();
			if ( null == cellData ) cellData = new CellData();
			
			var len:uint = xml.children().length()
			for ( var i:int = 0; i < len; i++ )
			{
				var nodeKind:String = xml.children()[i].nodeKind();
				var nodeName:String = xml.children()[i].name();
				
				if ( 'element' == nodeKind )
				{
					if ( nodeName == SkinEnum.Grid_Component_Alert ) 		alertData.setSkinData(xml[nodeName].@template);
					else if ( nodeName == SkinEnum.Grid_Component_Cell ) 	cellData.setSkinData(xml[nodeName].@template);
					else if ( nodeName == SkinEnum.Grid_AllowDrag ) 		allowDrag = ('true' == xml[nodeName]);
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
					if ( nodeName == SkinEnum.Grid_BgAssets ) bgAsset = makeSkinAssetsData(xml[nodeName], xml[nodeName].@libkey);
				}
			}
		}
		
		/**
		 * 设置皮肤数据
		 * 
		 */
		override public function setSkinData(value:String):void
		{
			var array:Array = value.split('_');
			if ( 9 == array.length ) 
			{
				var elmtId:String = array[0] + '_' + array[1] + '_' + array[2];
				rows = array[4];
				columns = array[5];
				padding = array[6];
				hgap = array[7];
				vgap = array[8];
			}
			else ErrorEnum.error5008(value);
			
			super.setSkinData(elmtId);
		}
		
		override public function clone() : * {
			var data : GirdData = new GirdData();
			parse(data);
			return data;
		}
	}
}
