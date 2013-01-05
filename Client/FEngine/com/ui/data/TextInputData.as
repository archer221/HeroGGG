package com.ui.data {
	import com.net.AssetData;
	import com.ui.core.UIComponentData;
	import com.ui.manager.ThemeSkinManager;
	import com.ui.manager.UIManager;
	import com.ui.skin.SkinEnum;
	import flash.text.TextFormat;


	/**
	 * @version 20100115
	 * @author Cafe
	 */
	public class TextInputData extends UIComponentData {

		public var borderAsset : AssetData = new AssetData("GTextInput_borderSkin");

		public var disabledAsset : AssetData = new AssetData("GTextInput_disabledSkin");

		public var textFormat : TextFormat;

		public var textColor : uint = 0xEFEFEF;

		public var textFieldFilters : Array = UIManager.getEdgeFilters(0x000000, 0.7);

		public var disabledColor : uint = 0x898989;

		public var maxChars : int = 0;

		public var displayAsPassword : Boolean = false;

		public var restrict : String = "";

		public var allowIME : Boolean = true;

		public var text : String = "";

		override protected function parse(source : *) : void {
			super.parse(source);
			var data : TextInputData = source as TextInputData;
			if(data == null)return;
			data.borderAsset = borderAsset;
			data.textFormat = textFormat;
			data.textColor = textColor;
			data.textFieldFilters = textFieldFilters.concat();
			data.maxChars = maxChars;
			data.displayAsPassword = displayAsPassword;
			data.restrict = restrict;
			data.allowIME = allowIME;
			data.text = text;
		}

		public function TextInputData() {
			width = 103;
			height = 22;
			textFormat = new TextFormat();
			textFormat.font = UIManager.defaultFont;
			textFormat.size = 12;
			textFormat.kerning = true;
		}
		
		
		/**
		 * 解析组件theme数据
		 * 
		 */
		override protected function myThemeParse(xml:XML):void
		{
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
					if ( nodeName == SkinEnum.Input_TextFormat_Font ) 		textFormat.font = xml[nodeName];
					else if ( nodeName == SkinEnum.Input_TextFormat_Size ) 	textFormat.size = xml[nodeName];
					else if ( nodeName == SkinEnum.Input_TextColor ) 		textColor = xml[nodeName];
					else if ( nodeName == SkinEnum.Input_DisabledColor ) 	disabledColor = xml[nodeName];
					else if ( nodeName == SkinEnum.Input_AsPassword ) 		displayAsPassword = ('true' == xml[nodeName]);
					else if ( nodeName == SkinEnum.Input_MaxChars ) 		maxChars = xml[nodeName];
					else if ( nodeName == SkinEnum.Input_Restrict )			restrict = xml[nodeName]; 
					else if ( nodeName == SkinEnum.Input_AllowIme ) 		allowIME = ('true' == xml[nodeName]);
					else if ( nodeName == SkinEnum.Input_Text )				text = xml[nodeName]; 
					else if ( nodeName == SkinEnum.Input_Filters_Color ) 	
					{
						filtersFlag = true;
						filtersColor = xml[nodeName];
					}
					else if ( nodeName == SkinEnum.Input_Filters_Alpha ) 	
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
					if ( nodeName == SkinEnum.Input_Assets_Border ) 		borderAsset = makeSkinAssetsData(xml[nodeName], xml[nodeName].@libkey);
					else if ( nodeName == SkinEnum.Input_Assets_Disabled ) 	disabledAsset = makeSkinAssetsData(xml[nodeName], xml[nodeName].@libkey);
				}
			}
		}
		
		
		override public function clone() : * {
			var data : TextInputData = new TextInputData();
			parse(data);
			return data;
		}
	}
}
