package com.ui.manager 
{
	/**
	 * ...
	 * @author 
	 */
	public class ErrorEnum 
	{
		//============================================================ ThemeSkin ===============================================================
		public static function error5001(id:String):void
		{
			var str:String = 'Theme.xml中没有找到 id=' + id + ' 的子项xml!' ;
			_throwError(str);
		}
		
		public static function error5002(id:String):void
		{
			var str:String = 'Skin.xml中没有找到 id=' + id + ' 的子项xml.';
			_throwError(str);
		}
		
		public static function error5003(id:String):void
		{
			var str:String = 'Theme.xml中 id=' + id + ' 的子项xml中没有配置属性skin.';
			_throwError(str);
		}
		
		public static function error5004(id:String, elmt:String):void
		{
			var str:String = 'Skin.xml中没有找到指定 id=' + id +' 的子项xml中的指定元素' + elmt + '.';
			_throwError(str);
		}
		
		public static function error5005(id:String, prop:String):void
		{
			var str:String = 'Skin.xml中没有找到指定 id=' + id +' 的子项xml中的指定属性' + prop + '.';
			_throwError(str);
		}
		
		public static function error5006():void
		{
			var str:String = '制作 Panel.fla 时没有创建 Panelbg 的 mc.';
			_throwError(str);
		}
		
		public static function error5008(id:String):void
		{
			var str:String = 'id=' + id + ' 的Grid类型组件命名不符合规则.';
			_throwError(str);
		}
		
		public static function error5009(id:String):void
		{
			var str:String = 'id=' + id + ' 的List类型组件命名不符合规则.';
			_throwError(str);
		}
		
		//============================================================ Guard ===============================================================
		public static function error6001(taskid:int, phase:int):void
		{
			var str:String = 'TaskGuard.xml 里没有找到 taskid=' + taskid + ' phase=' + phase + ' 的匹配项.';
			_throwError(str);
		}
		
		private static function _throwError(str:String):void
		{
			//try { throw new Error(str); }
			//catch ( error:Error ) { trace(error) }
			
			//throw new Error(str);
			
			var string:String = '************************';
			string += str;
			string += '************************';
			trace(string);
		}
	}

}
