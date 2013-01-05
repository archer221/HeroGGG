package com.utils
{
	import com.ui.controls.Label;
	import com.ui.data.LabelData;
	import flash.text.TextField;
	import flash.utils.ByteArray;
	import flash.utils.getQualifiedClassName;
	
	public class GNameUtil
	{
		private static var _counter:int=0;
		
		public static function createUniqueName(object:Object):String{
			if(!object)return null;
			var name:String=getQualifiedClassName(object);
			var index:int=name.indexOf("::");
			if (index!=-1)name=name.substr(index+2);
			var charCode:int=name.charCodeAt(name.length-1);
			if(charCode>=48&&charCode<= 57)name+="_";
			return name+_counter++;
		}
		
		public static function getUnqualifiedClassName(object:Object):String{
			var name:String;
			if(object is String)name=object as String;
			else name=getQualifiedClassName(object);
			var index:int=name.indexOf("::");
			if(index!=-1)name=name.substr(index+2);
			return name;
		}
		private static function nameIsMore (str:String):Boolean
		{
			var more:Boolean;
			var data : LabelData = new LabelData();
			data.text = str;
			data.textFormat.size = 14;
			data.textFormat.font = "微软雅黑";
			data.textFormat.leading = 2;
			data.textFormat.kerning = true;
			var _userName : Label = new Label(data);
			var whid:int = _userName.textField.width;
			if (_userName.textField.width > 90)
				more = true;
			else
				more = false;
				
			return more;
		}
		public static function IsLogicName(name : String) :Boolean
		{
			var role_name : String = GStringUtil.trim(name);
			var count:int = 0;
			var hivespent:Boolean = false;
			var testfiled : TextField = new TextField();
			var tmpbytearr : ByteArray = new ByteArray();
			var gbkrolename : String = "";
			for ( var rcnt : int = 0; rcnt < role_name.length; rcnt++ )
			{
				var rchar : String = role_name.charAt(rcnt);
				testfiled.text = rchar;
				if ( BDUtil.getTextSize(testfiled).width <= 0)//检查是否包含空格
				{
					hivespent = true;
					break;
				}
				tmpbytearr.clear();
				tmpbytearr.writeMultiByte(rchar, "GBK");
				tmpbytearr.position = 0;
				var byteary : Array = new Array();
				for (var j=0; j<tmpbytearr.length; j++)
				{
					byteary.push(tmpbytearr.readUnsignedByte());
				}
				if ( byteary.length > 1 )
				{
					for (count = 0; count < byteary.length; count+=2)//检查是否包含非GBK的
					{
						var highpos : uint = byteary[count];
						if ( highpos < 0x81 || highpos > 0xFE )
						{
							hivespent = true;
							break;
						}
						var lowpos  : uint = byteary[count+1];
						if ( lowpos < 0x40 || lowpos > 0xFE )
						{
							hivespent = true;
							break;
						}
					}
				}
			}
			for (count = 0; count < role_name.length; count++)//检查是否包含空格
			{
				var code:int = role_name.charCodeAt(count);
				if (role_name.charCodeAt(count) == 33 || role_name.charCodeAt(count) == 34 || role_name.charCodeAt(count) == 35 ||
				role_name.charCodeAt(count) == 37 || role_name.charCodeAt(count) == 38 || role_name.charCodeAt(count) == 39
				||role_name.charCodeAt(count) == 60 || role_name.charCodeAt(count) == 62 || role_name.charCodeAt(count) == 8220
				||role_name.charCodeAt(count) == 8221||role_name.charCodeAt(count) == 8216||role_name.charCodeAt(count) == 8217) {
					hivespent = true;
				}
			}
			if (role_name.length == 0) {
				return false;
			}
			if ( role_name.indexOf("'") >= 0 || role_name.indexOf("##") != -1 ||
				GStringUtil.trim(role_name).length <= 0||hivespent==true)
			{
				return false;
			}
			var length : int = GStringUtil.getDwordLength(GStringUtil.trim(role_name));	
			if (length < 4 || length > 14) {
				return false;
			}
			if ( nameIsMore( role_name ) )
			{
				return false;
			}
			
			return true;
		}
	}
}