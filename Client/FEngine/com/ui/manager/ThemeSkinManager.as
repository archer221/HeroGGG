package com.ui.manager 
{
	import com.net.LibsManager;
	import com.net.RESManager;
	import flash.display.Sprite;
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author 
	 */
	public class ThemeSkinManager 
	{
		private static var _dataTheme:XML = null;                           // Theme.xml缓存数据
		
		private static var _dataSkin:XML = null;                            // Skin.xml缓存数据
		
		private static var _themeId:int = 0;                                // Theme样式类型
		
		private static var _libkeyMap:Dictionary = new Dictionary();        // 存储 swfname-libkeyarray 的字典
		
		public static function Init():void
		{
			_dataTheme = RESManager.getXML(LibsManager.Instance.themeLib.key);
			_dataSkin = RESManager.getXML(LibsManager.Instance.skinLib.key);
		}
		
		//====================================================================================================================================================================
		//================================================================== Private Function ================================================================================
		//====================================================================================================================================================================
		
		//====================================================================================================================================================================
		//============================================================== Public Function =====================================================================================
		//====================================================================================================================================================================
		
		/**
		* 设置Theme样式
		* 
		**/
		public static function set themeId(value:int):void
		{
			_themeId = value;
		}
		
		/**
		* 获取组件皮肤指定元素数据（id:组件id，elmt:元素名称, prop:是否获取libkey）
		* 
		**/
		public static function getElementData(id:String, elmt:String, prop:String=''):*
		{
			if ( null != _dataTheme && null != _dataSkin )
			{
				// ------------------ 判断xml中的id是否存在 --------------------
				var themebol:Boolean = false;
				for each( var theme:XML in _dataTheme.(@id==_themeId).component )
					if ( theme.@id == id ) themebol = true;
				if ( false == themebol ) ErrorEnum.error5001(id);
				
				// ---------------- 判断xml中的skin是否存在 --------------------
				var skinid:String = _dataTheme.component.(@id == id).@skin;
				if ( '' == skinid ) ErrorEnum.error5003(id);
				
				var skinbol:Boolean = false;
				for each( var skin:XML in _dataSkin.uiskin )
				{
					if ( skin.@id == skinid ) 
					{
						skinbol = true;
						
						// ---------------- 判断xml中的elmt是否存在 --------------------
						var elmtbol:Boolean = false;
						elmtbol = skin.hasOwnProperty(elmt);
						if ( false == elmtbol ) return null;// ErrorEnum.error5004(id, elmt);
						
						if ( '' == prop )
						{
							if ( '' == skin[elmt] ) return null;
							return skin[elmt];
						}
						else
						{
							if ( undefined == skin[elmt].@[prop] ) return null;
							return skin[elmt].@[prop];
						}
					}
				}
				if ( false == skinbol ) ErrorEnum.error5002(id);
			}
			
			//elmtbol = _dataSkin.uiSkin.(@id == skinid).(hasOwnProperty(elmt));
			//_dataSkin.uiSkin.(@id == skinid)[elmt];
			//libkey = _dataSkin.uiSkin.(@id == skinid)[elmt].@[prop];
			
			return '';
		}
		
		/**
		* 获取组件皮肤相关数据（value:组件id）
		* 
		**/
		public static function getXMLData(value:String):Array
		{
			if ( null != _dataTheme && null != _dataSkin )
			{
				var xmlArr:Array = [];
				findXML(value);
				return xmlArr;
			}
			
			function findXML(id:String):void
			{
				for each( var theme:XML in _dataTheme.(@id == _themeId).component )
				{
					if ( id == theme.@id )
					{
						var arr:Array = ['', ''];
						
						arr[0] = theme;
						
						if ( undefined != theme.@skin && null != theme.@skin && '' != theme.@skin ) 
						{
							for each( var skin:XML in _dataSkin.uiskin )
							{
								if ( skin.@id == theme.@skin ) 
								{
									arr[1] = skin;
									break;
								}
							}
						}
						
						xmlArr.push(arr);
						
						if ( undefined != theme.@template && null != theme.@template && '' != theme.@template ) 
						{
							findXML(theme.@template);	
						}
						break;
					}
				}
			}
			
			return null;
		}
		
	}
}