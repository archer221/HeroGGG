package com.RichTextArea 
{
	import com.model.Map;
	import com.net.AssetData;
	import com.ui.controls.Button;
	import com.ui.data.ButtonData;
	import com.ui.data.LabelData;
	import com.ui.skin.SkinStyle;
	import flash.text.TextFormat;
	/**
	 * ...
	 * @author 
	 */
	public class TextButtonInfo 
	{
		public static const ButtonFlag : String = "##";
		public static const SpeakerButton : String = "~";
		public static const SystemButton : String = "&";
		public static const NameButton : String = "@";
		public static const ItemButton : String = "%";
		public static const PayButton : String = "^";
		public static const VipButton:String = "!";
		public static const VipMundeButton:String = "/";
		public static const RegionNameButton : String = "*";
		
		public var itemTipFunc : Function;
		public var item : Button = null;
		public var index : int = -1;
		public var buttonStr : String = "";
		public var buttonType : String = "";
		public var textFormat : TextFormat = null;
		public var status : String = "";
		
		public function TextButtonInfo() 
		{
			
		}
	}

}