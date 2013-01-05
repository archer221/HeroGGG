package com.ui.data {
	import com.net.AssetData;
	import com.ui.core.Align;
	import com.ui.core.UIComponentData;
	import com.ui.skin.SkinEnum;

	public class PageControlData extends UIComponentData {

		public var prev_buttonData : ButtonData;

		public var next_buttonData : ButtonData;

		public var labelData : LabelData;

		override protected function parse(source : *) : void {
			super.parse(source);
			var data : PageControlData = source as PageControlData;
			if(data == null)return;
			data.prev_buttonData = (prev_buttonData == null ? null : prev_buttonData.clone());
			data.next_buttonData = (next_buttonData == null ? null : next_buttonData.clone());
			data.labelData = (labelData == null ? null : labelData.clone());
		}

		public function PageControlData() {
			width = 82;
			height = 31;
			prev_buttonData = new ButtonData();
			prev_buttonData.width = 82;
			prev_buttonData.height = 31;
			prev_buttonData.upAsset = new AssetData("PrevButUP", "Hall");
			prev_buttonData.downAsset=new AssetData("PrevButDown", "Hall");
			prev_buttonData.align = new Align(0, -1, -1, -1, -1, 0);
			prev_buttonData.labelData.text = "";
			next_buttonData = new ButtonData();
			next_buttonData.width = 50;
			next_buttonData.align = new Align(-1, 0, -1, -1, -1, 0);
			//next_buttonData.labelData.text = "下一页";
			labelData = new LabelData();
			labelData.align = new Align(-1, -1, -1, -1, 0, 0);
			//labelData.text = "1/1";
		}
		
		/**
		 * 解析组件theme数据
		 * 
		 */
		override protected function myThemeParse(xml:XML):void
		{
			if ( null == prev_buttonData ) prev_buttonData = new ButtonData();
			if ( null == next_buttonData ) next_buttonData = new ButtonData();
			if ( null == labelData ) labelData = new LabelData();
			
			var len:uint = xml.children().length()
			for ( var i:int = 0; i < len; i++ )
			{
				var nodeKind:String = xml.children()[i].nodeKind();
				var nodeName:String = xml.children()[i].name();
				
				if ( 'element' == nodeKind )
				{
					if ( nodeName == SkinEnum.Page_Component_PrevBtn )			prev_buttonData.setSkinData(xml[nodeName].@template);
					else if ( nodeName == SkinEnum.Page_Component_NextBtn ) 	next_buttonData.setSkinData(xml[nodeName].@template);
					else if ( nodeName == SkinEnum.Page_Component_Label ) 		labelData.setSkinData(xml[nodeName].@template);
				}
			}
		}
		
		override public function clone() : * {
			var data : PageControlData = new PageControlData();
			parse(data);
			return data;
		}
	}
}