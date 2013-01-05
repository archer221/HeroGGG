package com.ui.data {
	import BZTC.debug.ErrorEnum;
	import com.net.AssetData;
	import com.ui.cell.CellData;
	import com.ui.cell.ListCell;
	import com.ui.manager.ThemeSkinManager;
	import com.ui.skin.SkinEnum;

	/**
	 * Game List Data
	 * 
	 * @author Cafe
	 * @version 20100730
	 */
	public class ListData extends PanelData {

		public var allowDrag : Boolean ;

		public var hGap : int;

		public var rows : int;
		
		public var columns : int = 3;

		public var cell : Class;

		public var cellData : CellData;
		
		public var scrollbarData:ScrollBarData;
		
		public var treeType : Boolean = false;

		override protected function parse(source : *) : void {
			super.parse(source);
			var data : ListData = source as ListData;
			if(data == null)return;
			data.allowDrag = allowDrag;
			data.hGap = hGap;
			data.columns = columns;
			data.rows = rows;
			data.cell = cell;
			data.cellData = cellData.clone();
		}

		public function ListData() {
			allowDrag = true;
			padding = 2;
			hGap = 1;
			rows = 1;
			cell = ListCell;
			cellData = new CellData();
		}
		
		
		/**
		 * 解析组件theme数据
		 * 
		 */
		override protected function myThemeParse(xml:XML):void
		{
			if ( null == scrollbarData ) scrollbarData = new ScrollBarData();
			if ( null == cellData ) cellData = new CellData();
			
			var len:uint = xml.children().length()
			for ( var i:int = 0; i < len; i++ )
			{
				var nodeKind:String = xml.children()[i].nodeKind();
				var nodeName:String = xml.children()[i].name();
				
				if ( 'element' == nodeKind )
				{
					if ( nodeName == SkinEnum.List_Component_Scroll )		scrollbarData.setSkinData(xml[nodeName].@template);
					else if ( nodeName == SkinEnum.List_Component_Cell ) 	cellData.setSkinData(xml[nodeName].@template);
					else if ( nodeName == SkinEnum.List_AllowDrag ) 		allowDrag = ('true' == xml[nodeName]);
					else if ( nodeName == SkinEnum.List_TreeType ) 			treeType = ('true' == xml[nodeName]);
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
					if ( nodeName == SkinEnum.List_BgAssets ) bgAsset = makeSkinAssetsData(xml[nodeName], xml[nodeName].@libkey);
				}
			}
		}
		
		/**
		 * 设置皮肤数据
		 * 
		 */
		override public function setSkinData(value:String):void
		{
			var array = value.split('_');
			if ( 8 == array.length ) 
			{
				var elmtId:String = array[0] + '_' + array[1] + '_' + array[2];
				rows = array[4];
				columns = array[5];
				padding = array[6];
				hGap = array[7];
			}
			else ErrorEnum.error5009(value);
			
			super.setSkinData(elmtId);
		}
		
		
		override public function clone() : * {
			var data : ListData = new ListData();
			parse(data);
			return data;
		}
	}
}
