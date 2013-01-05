package com.ui.data {
	import com.net.AssetData;
	import com.ui.core.UIComponentData;
	import com.ui.manager.UIManager;
	import com.ui.skin.SkinEnum;
	import flash.text.StyleSheet;
	import flash.text.TextFormat;
    import com.ui.skin.SkinStyle;

	/**
	 * @version 20100325
	 * @author Cafe
	 */
	public class TextAreaData extends UIComponentData {

		public var backgroundAsset : AssetData = new AssetData("GTextArea_backgroundSkin");

		public var textFormat : TextFormat;

		public var styleSheet : StyleSheet;

		public var textColor : uint = 0xFFFFFF;

		public var textFieldFilters : Array = UIManager.getEdgeFilters(0x000000, 0.7);

		public var padding : int = 2;

		public var editable : Boolean = true;

		public var selectable : Boolean = true;

		public var maxLines : int = 0;

		public var edlim : String;

		public var maxChars : int = 0;
		
		public var lockScroll:Boolean = false;
		
		public var scrooldata:ScrollBarData=new ScrollBarData();

		override protected function parse(source : *) : void {
			super.parse(source);
			var data : TextAreaData = source as TextAreaData;
			if(data == null)return;
			data.backgroundAsset = backgroundAsset;
			data.textFormat = textFormat;
			data.styleSheet = styleSheet;
			data.textColor = textColor;
			//data.textFieldFilters = textFieldFilters.concat();
			data.padding = padding;
			data.editable = editable;
			data.selectable = selectable;
			data.maxLines = maxLines;
			data.edlim = edlim;
			data.scrooldata= scrooldata.clone();
		}

		public function TextAreaData() {
			textFormat = new TextFormat();
			textFormat.font = UIManager.defaultFont;
			textFormat.size = 12;
			textFormat.leading = 2;
			textFormat.kerning = true;
			styleSheet = UIManager.defaultCSS;
			width = 104;
			height = 104;
			
		}
		
		
		/**
		 * 解析组件theme数据
		 * 
		 */
		override protected function myThemeParse(xml:XML):void
		{
			if ( null == scrooldata ) scrooldata = new ScrollBarData();
			
			var filtersFlag:Boolean = false;
			var filtersColor:uint;
			var filtersAlpha:Number = 1;
			
			var len:uint = xml.children().length()
			for ( var i:int = 0; i < len; i++ )
			{
				var nodeKind:String = xml.children()[i].nodeKind();
				var nodeName:String = xml.children()[i].name();
				
				if ( 'element' == nodeKind )
				{
					if ( nodeName == SkinEnum.Area_Component_Scroll )	scrooldata.setSkinData(xml[nodeName].@template);
					else if ( nodeName == SkinEnum.Area_TextColor ) 	textColor = xml[nodeName];
					else if ( nodeName == SkinEnum.Area_Padding ) 		padding = xml[nodeName];
					else if ( nodeName == SkinEnum.Area_Editable ) 		editable = ('true' == xml[nodeName]);
					else if ( nodeName == SkinEnum.Area_Selectable ) 	selectable = ('true' == xml[nodeName]);
					else if ( nodeName == SkinEnum.Area_MaxLines ) 		maxLines = xml[nodeName];
					else if ( nodeName == SkinEnum.Area_Edlim ) 		edlim = xml[nodeName];
					else if ( nodeName == SkinEnum.Area_MaxChars )		maxChars = xml[nodeName]; 
					else if ( nodeName == SkinEnum.Area_LockScroll ) 	lockScroll = ('true' == xml[nodeName]);
					else if ( nodeName == SkinEnum.Area_Font )			textFormat.font = xml[nodeName]; 
					else if ( nodeName == SkinEnum.Area_Size )			textFormat.size = xml[nodeName]; 
					else if ( nodeName == SkinEnum.Area_Bold )			textFormat.bold = xml[nodeName]; 
					else if ( nodeName == SkinEnum.Area_Align )			textFormat.align = xml[nodeName]; 
					else if ( nodeName == SkinEnum.Area_Leading )		textFormat.leading = xml[nodeName]; 
					else if ( nodeName == SkinEnum.Area_FiltersColor ) 	
					{
						filtersFlag = true;
						filtersColor = xml[nodeName];
					}
					else if ( nodeName == SkinEnum.Area_FiltersAlpha ) 	
					{
						filtersFlag = true;
						filtersAlpha = xml[nodeName];
					}
				}
			}
			if ( filtersFlag ) textFieldFilters = UIManager.getEdgeFilters(filtersColor, filtersAlpha);
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
					if ( nodeName == SkinEnum.Area_BackGroundAssets ) 	backgroundAsset = makeSkinAssetsData(xml[nodeName], xml[nodeName].@libkey);
				}
			}
		}
		
		
		override public function clone() : * {
			var data : TextAreaData = new TextAreaData();
			parse(data);
			return data;
		}
	}
}
