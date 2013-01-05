package com.ui.data {
	import com.ui.core.ScaleMode;
	import com.ui.core.UIComponentData;
	import com.ui.skin.SkinEnum;

	/**
	 * @version 20091215
	 * @author Cafe
	 */
	public class TabbedPanelData extends UIComponentData {

		public var tabData : TabData;

		public var viewStackData : UIComponentData;
		
		public var hvType:Boolean = false;             // false：页签按钮横排显示；true：页签按钮竖排显示

		override protected function parse(source : *) : void {
			super.parse(source);
			var data : TabbedPanelData = source as TabbedPanelData;
			if(data == null)return;
			data.tabData = (tabData ? tabData.clone() : null);
			data.viewStackData = (viewStackData ? viewStackData.clone() : null);
		}

		public function TabbedPanelData() {
			tabData = new TabData();
			viewStackData = new UIComponentData();
			scaleMode = ScaleMode.AUTO_SIZE;
			width = 200;
			height = 200;
		}
		
		/**
		 * 解析组件theme数据
		 * 
		 */
		override protected function myThemeParse(xml:XML):void
		{
			if ( null == tabData ) tabData = new TabData();
			
			var len:uint = xml.children().length()
			for ( var i:int = 0; i < len; i++ )
			{
				var nodeKind:String = xml.children()[i].nodeKind();
				var nodeName:String = xml.children()[i].name();
				
				if ( 'element' == nodeKind )
				{
					if ( nodeName == SkinEnum.Tabbed_Component_Tab ) tabData.setSkinData(xml[nodeName].@template);
				}
			}
		}
		
		override public function clone() : * {
			var data : TabbedPanelData = new TabbedPanelData();
			parse(data);
			return data;
		}
	}
}
