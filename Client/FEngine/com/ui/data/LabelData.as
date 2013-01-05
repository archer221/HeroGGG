package com.ui.data {
	import com.ui.core.UIComponentData;
	import com.ui.manager.ThemeSkinManager;
	import com.ui.manager.UIManager;
	import com.ui.skin.SkinEnum;
	import flash.text.StyleSheet;
	import flash.text.TextFormat;


	/**
	 * Game Label Data
	 * 
	 * @author Cafe
	 * @version 20100719
	 */
	public class LabelData extends UIComponentData {

		public var iconData : IconData = new IconData();

		public var iconY : int = 0;

		public var textColor : uint;

		public var textFieldFilters : Array;

		public var textFieldAlpha : Number;

		public var textFormat : TextFormat;

		public var styleSheet : StyleSheet;

		public var hGap : int;

		public var text : String;

		public var maxLength : int;
		
		public var multiLine : Boolean = false;

		override protected function parse(source : *) : void {
			super.parse(source);
			var data : LabelData = source as LabelData;
			if(data == null)return;
			data.iconData = iconData.clone();
			data.iconY = iconY;
			data.textColor = textColor;
			data.textFieldFilters = (textFieldFilters ? textFieldFilters.concat() : null);
			data.textFormat = textFormat;
			data.styleSheet = styleSheet;
			data.hGap = hGap;
			data.text = text;
			data.multiLine = multiLine;
		}

		public function LabelData() {
			textColor = 0xEFEFEF;
			textFieldFilters = UIManager.getEdgeFilters(0x000000, 0.7);
			textFieldAlpha = 1;
			textFormat = new TextFormat();
			textFormat.font = UIManager.defaultFont;
			textFormat.size = 12;
			textFormat.leading = 3;
			textFormat.kerning = true;
			styleSheet = UIManager.defaultCSS;
			hGap = 1;
			text = "";
			maxLength = 0;
		}
		
		
		/**
		 * 解析组件theme数据
		 * 
		 */
		override protected function myThemeParse(xml:XML):void
		{
			if ( null == iconData ) iconData = new IconData();
			
			var filtersFlag:Boolean = false;
			var filtersColor:uint;
			var filtersAlpha:Number = 1;
			
			var len:uint = xml.children().length();
			for ( var i:int = 0; i < len; i++ )
			{
				var nodeKind:String = xml.children()[i].nodeKind();
				var nodeName:String = xml.children()[i].name();
				
				if ( 'element' == nodeKind )
				{
					if ( nodeName == SkinEnum.Label_Component_Icon ) 		iconData.setSkinData(xml[nodeName].@template);
					else if ( nodeName == SkinEnum.Label_IconY ) 			iconY = xml[nodeName];
					else if ( nodeName == SkinEnum.Label_Color ) 			textColor = xml[nodeName];
					else if ( nodeName == SkinEnum.Label_Font ) 			textFormat.font = xml[nodeName];
					else if ( nodeName == SkinEnum.Label_Size ) 			textFormat.size = xml[nodeName];
					else if ( nodeName == SkinEnum.Label_Bold ) 			textFormat.bold = ('true' == xml[nodeName]);
					else if ( nodeName == SkinEnum.Label_Algin ) 			textFormat.align = xml[nodeName];
					else if ( nodeName == SkinEnum.Label_HGap ) 			hGap = xml[nodeName];
					else if ( nodeName == SkinEnum.Label_MaxLength ) 		maxLength = xml[nodeName];
					else if ( nodeName == SkinEnum.Label_MultiLine ) 		multiLine = ('true' == xml[nodeName]);
					else if ( nodeName == SkinEnum.Label_Text )				text = xml[nodeName];
					else if ( nodeName == SkinEnum.Label_Filters_Color )
					{
						filtersFlag = true;
						filtersColor = xml[nodeName];
					}
					else if ( nodeName == SkinEnum.Label_Filters_Alpha )
					{
						filtersFlag = true;
						filtersAlpha = xml[nodeName];
					}
				}
			}
			if ( filtersFlag ) textFieldFilters = UIManager.getEdgeFilters(filtersColor, filtersAlpha);
		}
		
		override public function clone() : * {
			var data : LabelData = new LabelData();
			parse(data);
			return data;
		}
	}
}
