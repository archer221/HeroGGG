package com.ui.core {
	import com.effects.GEffect;
	import com.net.AssetData;
	import com.ui.controls.ToolTip;
	import com.ui.data.ToolTipData;
	import com.ui.manager.ThemeSkinManager;
	import com.ui.manager.UIManager;
	import com.ui.skin.SkinEnum;
	import flash.display.DisplayObjectContainer;


	/**
	 * Game Component Data
	 * 
	 * @author Cafe
	 * @version 20100724
	 */
	public class UIComponentData {

		public var parent : DisplayObjectContainer;

		public var x : int = 0;

		public var y : int = 0;

		public var width : int = 0;

		public var height : int = 0;

		public var alpha : Number = 1;

		public var enabled : Boolean = true;

		public var visible : Boolean = true;

		public var minWidth : int = 0;

		public var minHeight : int = 0;

		public var maxWidth : int = 2880;

		public var maxHeight : int = 1000;

		public var scaleMode : int = ScaleMode.SCALE9GRID;

		public var align : Align;

		public var filters : Array;

		public var showEffect : GEffect;

		public var hideEffect : GEffect;

		public var toolTip : Class = ToolTip;

		public var toolTipData : ToolTipData;
		
		public var loadingsprte : AssetData = new AssetData("loadsprite","uicommon");

		protected function parse(source : *) : void {
			var data : UIComponentData = source as UIComponentData;
			if(data == null)return;
			data.parent = parent;
			data.x = x;
			data.y = y;
			data.width = width;
			data.height = height;
			data.alpha = alpha;
			data.enabled = enabled;
			data.visible = visible;
			data.minWidth = minWidth;
			data.minHeight = minHeight;
			data.maxWidth = maxWidth;
			data.maxHeight = maxHeight;
			data.scaleMode = scaleMode;
			data.align = (align != null ? align.clone() : null);
			data.filters = (filters ? filters.concat() : null);
			data.showEffect = showEffect;
			data.hideEffect = hideEffect;
			data.toolTip = toolTip;
			data.toolTipData = (toolTipData != null ? toolTipData.clone() : null);
		}

		public function UIComponentData() {
		}
		
		/**
		 * 设置theme基础数据
		 * 
		 */
		private function _setThemeBaseData(xml:XML):void
		{
			var alignFlag:Boolean = false;
			var alignLeft:int = -1;
			var alignRight:int = -1;
			var alignTop:int = -1;
			var alignBottom:int = -1;
			var alignHorizontal:int = -1;
			var alignVertical:int = -1;
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
					if ( nodeName == SkinEnum.Base_X ) 						x = xml[nodeName];
					else if ( nodeName == SkinEnum.Base_Y ) 				y = xml[nodeName];
					else if ( nodeName == SkinEnum.Base_Width ) 			width = xml[nodeName];
					else if ( nodeName == SkinEnum.Base_Height ) 			height = xml[nodeName];
					else if ( nodeName == SkinEnum.Base_MinWidth ) 			minWidth = xml[nodeName];
					else if ( nodeName == SkinEnum.Base_MinHeight ) 		minHeight = xml[nodeName];
					else if ( nodeName == SkinEnum.Base_MaxWidth ) 			maxWidth = xml[nodeName];
					else if ( nodeName == SkinEnum.Base_MaxHeight ) 		maxHeight = xml[nodeName];
					else if ( nodeName == SkinEnum.Base_Alpha ) 			alpha = xml[nodeName];
					else if ( nodeName == SkinEnum.Base_Enabled ) 			enabled = ('true' == xml[nodeName]);
					else if ( nodeName == SkinEnum.Base_Visible ) 			visible = ('true' == xml[nodeName]);
					else if ( nodeName == SkinEnum.Base_ScaleMode ) 		scaleMode = xml[nodeName];
					
					else if ( nodeName == SkinEnum.Base_AlignLeft )
					{
						alignFlag = true;
						alignLeft = xml[nodeName];
					}
					else if ( nodeName == SkinEnum.Base_AlignRight ) 	
					{
						alignFlag = true;
						alignRight = xml[nodeName];
					}
					else if ( nodeName == SkinEnum.Base_AlignTop ) 		
					{
						alignFlag = true;
						alignTop = xml[nodeName];
					}
					else if ( nodeName == SkinEnum.Base_AlignBottom ) 		
					{
						alignFlag = true;
						alignBottom = xml[nodeName];
					}
					else if ( nodeName == SkinEnum.Base_AlignHorizontal ) 
					{
						alignFlag = true;
						alignHorizontal = xml[nodeName];
					}
					else if ( nodeName == SkinEnum.Base_AlignVertical ) 	
					{
						alignFlag = true;
						alignVertical = xml[nodeName];
					}
					else if ( nodeName == SkinEnum.Base_FiltersColor ) 		
					{
						filtersFlag = true;
						filtersColor = xml[nodeName];
					}
					else if ( nodeName == SkinEnum.Base_FiltersAlpha ) 		
					{
						filtersFlag = true;
						filtersAlpha = xml[nodeName];
					}
				}
			}
			
			if ( alignFlag ) align = new Align(alignLeft, alignRight, alignTop, alignBottom, alignHorizontal, alignVertical);
			if ( filtersFlag ) filters = UIManager.getEdgeFilters(filtersColor, filtersAlpha);
		}
		
		/**
		 * 设置皮肤数据
		 * 
		 */
		public function setSkinData(elmtId:String):void
		{
			var themeSkinArr:Array = ThemeSkinManager.getXMLData(elmtId) as Array;
			if ( null == themeSkinArr ) return;
			
			while ( themeSkinArr.length )
			{
				var arr:Array = themeSkinArr.pop();
				if ( '' != arr[0] ) 
				{
					var theme:XML = arr[0] as XML;
					_setThemeBaseData(theme);
					myThemeParse(theme);
				}
				
				if ( '' != arr[1] ) 
				{
					var skin:XML = arr[1] as XML;
					mySkinParse(skin);
				}
			}
		}
		
		public function setSkinBaseData(elmtId:String):void
		{
			
		}
		
		/**
		 * 解析组件theme数据
		 * 
		 */
		protected function myThemeParse(xml:XML):void
		{
			
		}
		
		/**
		 * 解析组件skin数据
		 * 
		 */
		protected function mySkinParse(xml:XML):void
		{
			
		}
		
		/**
		 * 生成AssetData对象
		 * 
		 */
		protected function makeSkinAssetsData(assetsName:String, libkey:String):AssetData
		{
			if ( undefined == libkey || null == libkey || '' == libkey )
				return new AssetData(assetsName);
				
			return new AssetData(assetsName, libkey);
		}
		
		public function fix() : void {
		}

		public function clone() : * {
			var data : UIComponentData = new UIComponentData();
			parse(data);
			return data;
		}
	}
}
