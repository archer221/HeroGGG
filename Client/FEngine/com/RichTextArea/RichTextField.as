﻿/**
*
* 6dn RichTextArea 

*----------------------------------------------------------------
* @notice 6dn RichTextArea
* @author 6dn
* @as version1.1
* @date 2010-4-7
*
* AUTHOR ******************************************************************************
* 
* authorName : 黎新苑 - www.6dn.cn
* QQ :160379558(6dnの星)
* MSN :xdngo@hotmail.com
* email :6dn@6dn.cn, xdngo@163.com
* webpage : http://www.6dn.cn
* 
* LICENSE ******************************************************************************
* 
* ① RichTextArea类基于FP9,as3.0的轻量级富文本类!(聊天类型,只支持单行图文混排);
* ② 支持外部图片,可使用jpg,png静态图片,也可以使用gif动态图片,当然,也可以使用有linkage库链接的MovieClip；
* ③ 轻量级,使用简便,使用xml配置,通用的字符表情,输入后马上显示;
* ④ 可使用htmlText,可扩展加入超链接,文字粗细,下划线等textFormat(注:由于styleSheet 和 textFormat冲突,所以这里不能使用styleSheet);
* ⑤ 可自由复制，粘贴任何文本以及图像;
* ⑥ 通过richText属性set 和 get,方便易用;(richText值取到的字符串被Player自动加入了一些html标签,但不影响正常使用);
* ⑦ 此类作为开源使用，但请重视作者劳动成果，请使用此类的朋友保留作者信息。
* Please, keep this header and the list of all authors
* 
* ******************************************************************************
*   构造方法:
		RichTextArea($w:int, $h:int) //创建一个宽为$w,高为$h的RichTextArea

	公共方法:
		-appendRichText($str:Stirng):void     //追加$str到RichTextArea;
		-insertRichText($str:String, $beginIndex:int=-1, $endIndex:int = -1):void    //在$beginIndex和$endIndex之间插入字符，默认位置为文本caretIndex即，当前光标位置
		-clear():void                         //清空RichTextArea并回到初始状态
		-resizeTo($w:int, $h:int):void  	  //重新设定RichTextArea的width,height
		-autoAdjust():void  				  //当外部动态设定了textField的x,y或width,height, 可以使用该方法自动校正使RichTextArea显示正常


	公共属性:
		-textField:TextField  [read-only]   //取得RichTextArea中的文本对象
		-richText:String   [read-write]  //设置和读取富文本的值
		-configXML:XML  [read-write]   //富文本对应的XML配置,请参照示例中的格式
			//iconUrl:String 可以是外部链接，也可以是有linkage的库链接
			//iconType:String [movieClip | jpg | gif] 三种格式对应
			//iconStr:String 配置替换的字符串
			
		-defaultTextFormat:TextFormat [read-write]  //设置和读取富文本的defaultTextFormat; (当RichTextArea已经ADDED_TO_STAGE在舞台显示列表中时,如要动态改变textField的defaultTextFormat请用该属性)

	用法示例 usage：
		var _richTextArea:RichTextArea = new RichTextArea(200,300);
		_richTextArea.configXML = <root>
									<icon iconUrl='myMC' iconType ="movieClip" iconStr=":]"/>
									<icon iconUrl='img/1.jpg' iconType ="jpg" iconStr=":o"/>
									<icon iconUrl='img/2.gif' iconType ="jpg" iconStr=":)"/>
								</root>;
		_richTextArea.x = 0;
		_richTextArea.y = 0;
		_richTextArea.textField.wordWrap=true;
		_richTextArea.textField.multiline=true;
		_richTextArea.textField.border = true;
		_richTextArea.textField.type = TextFieldType.INPUT;
		
		_richTextArea.richText = "Hi!:] welcome to <b><font color='#0033FF' size='13'><a href=\"http://www.6dn.cn/blog\" >6DN Blog</a></font></b>! :) ";
		
		addChild(_richTextArea);
		
		trace(_richTextArea.richText);

* 
* 
*/

package com.RichTextArea
{
	import com.model.Map;
	import com.net.AssetData;
	import com.net.RESManager;
	import com.ui.controls.Button;
	import com.ui.data.ButtonData;
	import com.ui.data.LabelData;
	import com.ui.data.ToolTipData;
	import com.ui.skin.SkinStyle;
	import com.utils.BDUtil;
	import com.utils.GStringUtil;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.IOErrorEvent;
	import flash.events.KeyboardEvent;
	
	import flash.text.TextLineMetrics;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import flash.utils.getDefinitionByName;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;	
	import BZTC.framework.BztcModel;
	
	public class RichTextField extends Sprite
	{
		private var _textField:TextField;
		private var _cacheTextField:TextField;
		private var _txtInfo:Object;
		private var _configXML:XML;
		private var _richTxt:String;	
		private var _defaultFormat:TextFormat;
		
		private var _spriteMap:Array;
		private var _spriteButtons : Array;
		private var _spriteContainer:Sprite;
		private var _this:Sprite;
		private var _gifPlayer:GifPlayer;
		
		public var iconHeight : int = 0;
		
		public var itemNameGetFuc : Function;
		public var itemTipFunc : Function;
		public var buttonClickHandle : Function;
		public var buttonQuality:Function;
		
		private var _butUnderColor:int = 0;
		
		public static const ICONASSERTSPLIT : String = "#@$";
		
		private const PLACEHOLDER:String = "　";
		private const SEPARATOR:String = "[@6dn@]";
		private const BUTTONSEPARATOR:String = "[#6dn#]";
		private const ButtonFlag:String="##"
		private const TYPE_MOVIECLIP:String = "movieClip";
		private const TYPE_JPG:String = "jpg";
		private const TYPE_GIF:String = "gif";
		private const STATUS_INIT:String = "init";
		private const STATUS_LOADED:String = "loaded";
		private const STATUS_NORMAL:String = "normal";
		private const STATUS_CHANGE:String = "change";
		private const STATUS_CONVERT:String = "convert";
		private const STATUS_SCROLL:String = "scroll";
		private const STATUS_INPUT:String = "input";
		private var firformat:Boolean = true;
		private var backtextformat:TextFormat;
		public var inpanel:int;
		
		public function get IconCount() : int
		{
			return _spriteMap.length;
		}
		public function dispose():void
		{
			if( stage != null )
				stage.focus = null;
			unloadHandler(null);
		}
		public function RichTextField($w:int, $h:int) 
		{
			_this = this;
			
			_spriteMap = new Array();
			_spriteButtons = new Array();
			_configXML = new XML();
			
			_txtInfo = {
				cursorIndex:null,
				firstPartLength:null,
				lastPartLength:null
			}
			
			//
			_gifPlayer = new GifPlayer();
			
			_cacheTextField = new TextField();
			_cacheTextField.multiline = true;
			
			_textField = new TextField();
			_textField.width = $w;
			_textField.height = $h;
			_textField.useRichTextClipboard = true;
			_textField.wordWrap = true;
			
			backtextformat = new TextFormat();
			_defaultFormat = new TextFormat();
			_defaultFormat.size = 12;
			_defaultFormat.font = "微软雅黑";
			_defaultFormat.letterSpacing = 0;
			_defaultFormat.leading = 2;
			_defaultFormat.underline = false;
			if (firformat) {
				backtextformat = _defaultFormat;
				firformat = false;
			}
			
			_spriteContainer = new Sprite();
			_spriteContainer.mouseChildren = true;
			_spriteContainer.mouseEnabled = true;
			
			_this.addChild(_textField);
			_this.addChild(_spriteContainer);
			
			//
			_this.addEventListener(Event.ADDED_TO_STAGE, initHandler);
			_this.addEventListener(Event.UNLOAD, unloadHandler);
			
			_textField.addEventListener(MouseEvent.CLICK, clickHandler);
			_textField.addEventListener(KeyboardEvent.KEY_DOWN, keyHandler);
			
			_textField.addEventListener(Event.CHANGE , changeHandler);
			_textField.addEventListener(Event.SCROLL , scrollHandler);
			
		}
		
		public function appendRichText($str:String):void
		{
			_textField.defaultTextFormat = _defaultFormat;
			$str = changeKeyworldColor($str);
			//屏蔽某人说话
			var textbuttoninfo:TextButtonInfo = getTextButtonInfo($str);
			//var buttondata : ButtonData = GetButtonData(textbuttoninfo.buttonType);
			var labelstr : String = "";
			if (textbuttoninfo.buttonType.localeCompare(TextButtonInfo.SpeakerButton) == 0)
			{
				labelstr = textbuttoninfo.buttonStr.substr(3, textbuttoninfo.buttonStr.length - 5);
				for (var i:int = 0; i < BztcModel.shutuparr.length; i++) {
					if (BztcModel.shutuparr[i] == labelstr)
						return;
				}
			}
			
			var $_htmlText:String = _textField.htmlText;
			$_htmlText += $str;
			_textField.htmlText = $_htmlText;
			if (_textField.numLines >= 50)
			{
				var ary : Array = _textField.htmlText.split("</TEXTFORMAT>");
				if (ary != null && ary.length > 2)
					RemoveMultiyLine(ary.length * 0.6);
			}
			convert();
			refresh();
		}
		
		private function changeKeyworldColor($str:String):String
		{
			if ($str.indexOf("【系统消息】") != -1 && $str.match("等级排名第") != null) {
				var bindex:int = $str.indexOf("等级排名第");
				if ($str.substr(bindex + 6, 1) == ("0"||"1"||"2"||"3"||"4"||"5"||"6"||"7"||"8"||"9")) {
					var colorstr:String = $str.substr(bindex, 7);
					var temptxt:TextField = new TextField();
					temptxt.textColor = 0xffff00;
					temptxt.htmlText = $str.substring(0, bindex) + '<FONT COLOR="#ff2400">' + colorstr + '</FONT>'  +" "+ $str.substr(bindex + 7);
				}else {
					var colorstr:String = $str.substr(bindex, 6);
					var temptxt:TextField = new TextField();
					temptxt.textColor = 0xffff00;
					temptxt.htmlText = $str.substring(0, bindex) + '<FONT COLOR="#ff2400">' + colorstr + '</FONT>'  +" "+ $str.substr(bindex + 6);
				}
				$str = temptxt.htmlText;
			}
			if ($str.indexOf("【系统消息】") != -1 && $str.match("战斗力排名第") != null) {
				var bindex:int = $str.indexOf("战斗力排名第");
				if ($str.substr(bindex + 7, 1) == ("0"||"1"||"2"||"3"||"4"||"5"||"6"||"7"||"8"||"9")) {
					var colorstr:String = $str.substr(bindex, 8);
					var temptxt:TextField = new TextField();
					temptxt.textColor = 0xffff00;
					temptxt.htmlText = $str.substring(0, bindex) + '<FONT COLOR="#ff2400">' + colorstr + '</FONT>' +" "+ $str.substr(bindex + 8);
				}else {
					var colorstr:String = $str.substr(bindex, 7);
					var temptxt:TextField = new TextField();
					temptxt.textColor = 0xffff00;
					temptxt.htmlText = $str.substring(0, bindex) + '<FONT COLOR="#ff2400">' + colorstr + '</FONT>' +" "+ $str.substr(bindex + 7);
				}
				$str = temptxt.htmlText;
			}
			if ($str.indexOf("【系统消息】") != -1 && $str.match("战队升到") != null) {
				var bindex:int = $str.indexOf("恭喜");
				var colorstr:String = $str.substring(bindex + 2, $str.length - 6);
				var temptxt:TextField = new TextField();
				temptxt.textColor = 0xffff00;
				temptxt.htmlText = $str.substring(0, bindex+2) + '<FONT COLOR="#00ff00">' + colorstr + '</FONT>'  +" "+ $str.substr(bindex + 2+colorstr.length);
				$str = temptxt.htmlText;
			}
			return $str;
		}
	
		protected function RemoveMultiyLine(toberemovenum : int):void
		{
			if ( _textField.numLines <= toberemovenum )  return;
			var str : String = _textField.htmlText;
			//var formatstr : String = GStringUtil.format("(<TEXTFORMAT.*?<\\/TEXTFORMAT>){{0}}?", toberemovenum);
			//var regexp : RegExp = new RegExp(formatstr,"gi");
			//var retStr : String = str.replace(/(<TEXTFORMAT.*?<\/TEXTFORMAT>){100}?/gi, "");
			var maxcharszie = str.length;
			var idx :int = str.indexOf("<TEXTFORMAT", maxcharszie * 0.5);
			
			var retStr:String = str.substr(idx);
			var tempstr:String = str.substr(0, idx);
			_cacheTextField.htmlText = tempstr;
			//_cacheTextField.defaultTextFormat = _defaultFormat;
			var $_arr:Array = _spriteMap;
			var $_len:int = $_arr.length;
			var $_info:Object;
			var i : int = 0;
			//for ( var ridx : int = 0; ridx < charindx; ridx++ )
			//{
				$_len = $_arr.length;
				for (i = 0; i < $_len; ) {
					$_info = $_arr[i];
					if ($_info) {
						if ( $_info.index < _cacheTextField.text.length)
						{
							if ($_info.item != null && $_info.item.parent != null)
								$_info.item.parent.removeChild($_info.item);
							$_arr.splice(i, 1);
							continue;
						}
					}
					i++;
				}
				for (var i : int = 0; i < _spriteButtons.length;)
				{
					var textbuttoninfo : TextButtonInfo = _spriteButtons[i];
					if (textbuttoninfo != null)
					{
						if (textbuttoninfo.index < _cacheTextField.text.length)
						{
							if (textbuttoninfo.item != null && textbuttoninfo.item.parent != null)
							{
								if ( buttonClickHandle )
								{
									textbuttoninfo.item.removeEventListener(MouseEvent.CLICK, buttonClickHandle);
								}
								textbuttoninfo.item.parent.removeChild(textbuttoninfo.item);
							}
							_spriteButtons.splice(i, 1);
							continue;
						}
						
					}
					i++;
				}
			//}
			
			$_len = $_arr.length;
			for (i = 0; i < $_len; i++) 
			{
				$_info = $_arr[i];
				if ($_info)
				{
					$_info.index -= _cacheTextField.text.length;
				}
			}
			for (var i : int = 0; i < _spriteButtons.length; i++)
			{
				var textbuttoninfo : TextButtonInfo = _spriteButtons[i];
				if (textbuttoninfo != null)
				{
					textbuttoninfo.index -= _cacheTextField.text.length;
				}
			}
			
			_textField.htmlText = "";
			_textField.htmlText = retStr;
			_textField.defaultTextFormat = _defaultFormat;
		}
		
		
		public function insertRichText($str:String, $beginIndex:int=-1, $endIndex:int = -1):void
		{
			$beginIndex = $beginIndex != -1 ? $beginIndex : _textField.selectionBeginIndex;
			$endIndex = $endIndex != -1 ? $endIndex : _textField.selectionEndIndex;
			
			_textField.replaceText($beginIndex, $endIndex, $str);
			_textField.setTextFormat(_defaultFormat, $beginIndex, $beginIndex+$str.length);
			refreshArr($beginIndex, $str.length- ($endIndex - $beginIndex), false);
			
			//setTextInfo();
			
			controlManager(STATUS_CHANGE);
			stage.focus = _textField;
		}
		public function resizeTo($w:int, $h:int):void
		{
			_textField.width = $w;
			_textField.height = $h;
			_spriteContainer.x = _textField.x;
			_spriteContainer.y = _textField.y;
			refresh();
		}
		
		public function autoAdjust():void
		{
			_spriteContainer.x = _textField.x;
			_spriteContainer.y = _textField.y;
			refresh();
		}
		
		public function clear():void
		{
			_spriteMap = [];
			if (buttonClickHandle != null)
			{
				for each(var textbuttoninfo : TextButtonInfo in _spriteButtons)
				{
					if (textbuttoninfo != null && textbuttoninfo.item != null)
					{
						textbuttoninfo.item.removeEventListener(MouseEvent.CLICK, buttonClickHandle);
					}
				}
			}
			_spriteButtons.splice(0);
			
			_txtInfo = {
				cursorIndex:null,
				firstPartLength:null,
				lastPartLength:null
			}
			
			while (_spriteContainer.numChildren) {
				_spriteContainer.removeChildAt(0);
			}
			_textField.htmlText = "";
		}
		//============================================================================
		// Event Handler
		//============================================================================	
		private function initHandler(evt:Event):void
		{
			_defaultFormat = backtextformat;
			_textField.defaultTextFormat = backtextformat;
		}
		private function unloadHandler(evt:Event):void
		{
			if ( _textField != null )
			{
				_textField.removeEventListener(MouseEvent.CLICK, clickHandler);
				_textField.removeEventListener(KeyboardEvent.KEY_DOWN, keyHandler);
				_textField.removeEventListener(Event.CHANGE, changeHandler);
				_textField.removeEventListener(Event.SCROLL , scrollHandler);
				_this.removeChild(_textField);
			}
			_this.removeChild(_spriteContainer);
		}
		
		private function clickHandler(evt:Event):void
		{
			setTextInfo();
		}
		
		private function keyHandler(evt:KeyboardEvent):void
		{
			setDefaultFormat();
			setTextInfo();
		}	
		
		private function scrollHandler(evt:Event):void
		{
			if(_textField.htmlText ==null || _textField.htmlText =="") return;
			controlManager(STATUS_SCROLL);
		}
		private function changeHandler(evt:Event):void
		{
			controlManager(STATUS_CHANGE);	
		}
		//============================================================================
		// control function
		//============================================================================		
		private function controlManager($eventStr:String):void
		{
			if ($eventStr == STATUS_CONVERT) {
				convert();
				refresh();
			}else if ($eventStr == STATUS_CHANGE) {	
				setDefaultFormat();
				change();
				convert();
				setTextInfo();
				refresh();
			}else if ($eventStr == STATUS_SCROLL) {
				refresh();
			}
			
		}
			
		//============================================================================
		// convert & revert
		//============================================================================	
		
		public function convert():void
		{
			var $_replaceStr:String = PLACEHOLDER;
			var $_strLen:int;
			var $_id:int;
			var $_index:int;
			var $_iconStr:String ;
			var $_iconInfo:Object;
			
			while ($_index != -1) {	
				
				$_iconInfo = getInfoFormXML(_textField.text);
				if ($_iconInfo == null) break;
				$_index = $_iconInfo.index;
				
				if ($_index != -1) {
					refreshArr($_index, $_replaceStr.length - $_iconInfo.iconStr.length);
					
					$_strLen = $_iconInfo.iconStr.length;
					_textField.replaceText($_iconInfo.index, $_iconInfo.index + $_strLen, $_replaceStr);
					addIcon($_iconInfo);
				}
			}
			
			var textbuttoninfo : TextButtonInfo;
			$_index = 0;
			while ($_index != -1)
			{
				textbuttoninfo = getTextButtonInfo(_textField.text);
				$_index = textbuttoninfo.index;
				if ($_index != -1) {
					refreshArr($_index, $_replaceStr.length - textbuttoninfo.buttonStr.length);
					
					$_strLen = textbuttoninfo.buttonStr.length;
					_textField.replaceText(textbuttoninfo.index, textbuttoninfo.index + $_strLen, $_replaceStr);
					addButton(textbuttoninfo);
				}
			}
		}
		
		private function change():void
		{
			var $_textInfo:Object = getTextInfo();
			var $_cursorIndex:int = $_textInfo.cursorIndex < _txtInfo.cursorIndex ? $_textInfo.cursorIndex : _txtInfo.cursorIndex;
			var $_gap:int = $_textInfo.firstPartLength - _txtInfo.firstPartLength + $_textInfo.lastPartLength - _txtInfo.lastPartLength;
			if ($_textInfo.cursorIndex > _txtInfo.cursorIndex)  checkTxtFormat(_txtInfo.cursorIndex, $_textInfo.cursorIndex);
			refreshButton($_cursorIndex, $_gap);
			refreshIcon($_cursorIndex, $_gap);
		}
		
		private function revertCachedField() : void
		{
			var $_replaceStr :String= PLACEHOLDER;
			var $_placeHolderLen:int = $_replaceStr.length;
			
			var $_arr:Array = _spriteMap;
			var $_len:int = _spriteMap.length;
			
			var $_index:int;
			
			var $_info:Object;			
			
			_cacheTextField.htmlText = _textField.htmlText;
			
			$_arr.sortOn(["index"], 16);
			
			while ($_len--) {
				$_info  = $_arr[$_len];
				if($_info){
					$_index = $_info.index;
					_cacheTextField.replaceText($_index, $_index + $_placeHolderLen, $_info.iconStr);
				}
			}
			
			$_len = _spriteButtons.length;
			var textButtoninfo : TextButtonInfo;
			_spriteButtons.sortOn(["index"], 16);
			while ($_len--)
			{
				textButtoninfo = _spriteButtons[$_len];
				if (textButtoninfo != null)
				{
					$_index = textButtoninfo.index;
					_cacheTextField.replaceText($_index, $_index + $_placeHolderLen, textButtoninfo.buttonStr);
				}
			}
		}
		
		private function revertText() : String
		{
			revertCachedField();
			var $_returnStr:String = _cacheTextField.text;
			return $_returnStr;
		}
		
		private function revert():String
		{
			revertCachedField();
			var $_returnStr:String = _cacheTextField.htmlText;
			return $_returnStr;
		}
		
		//-------------------------------------------------------------------------
		// refresh
		//-------------------------------------------------------------------------
		
		private function refreshArr($index:int,$num:int, $isSetSelection:Boolean = true):void
		{
			var $_arr:Array = _spriteMap;
			var $_len:int = $_arr.length;
			var $_info:Object;
			var i : int = 0;
			for (i = 0; i < $_len; i++) {
				$_info = $_arr[i];
				if ($_info) {
					if ($_info.index >= $index) {
						$_info.index += $num;
					}
				}
			}
			for (var i : int = 0; i < _spriteButtons.length; i++)
			{
				var textbuttoninfo : TextButtonInfo = _spriteButtons[i];
				if (textbuttoninfo != null)
				{
					if (textbuttoninfo.index >= $index)
					{
						textbuttoninfo.index += $num;
					}
				}
			}
			if ($num != 0) {
				if($isSetSelection) _textField.setSelection(_textField.caretIndex + $num, _textField.caretIndex + $num);
				setTextInfo();
			}
		}
		
		private function refresh():void
		{
			var $_arr:Array = _spriteMap;
			var $_len:int = $_arr.length;
			
			var $_info:Object;
			var $_item:Sprite;
			var $_rect:Rectangle;
			
			var $_txtLineMetrics :TextLineMetrics ;
			var $_lineHeight:int;
			
			while ($_len--) 
			{
				$_info = $_arr[$_len];
				if($_info){
					$_item = $_info.item;
					if($_item){
						$_rect = _textField.getCharBoundaries($_info.index);
						if ($_rect) {
							$_txtLineMetrics = _textField.getLineMetrics(_textField.getLineIndexOfChar($_info.index));
							$_lineHeight = $_rect.height *0.5 > $_item.height? $_txtLineMetrics.ascent- $_item.height  : ($_rect.height - $_item.height)*0.5;// $_txtLineMetrics.ascent ;// + $_txtLineMetrics.descent * 0.5;
							$_item.visible = true;
							$_item.x =  $_rect.x + ($_rect.width - $_item.width)*0.5;
							$_item.y =  $_rect.y + $_lineHeight;
							if (_textField.getLineIndexOfChar($_info.index) + 1 > _textField.bottomScrollV ||
								_textField.getLineIndexOfChar($_info.index) + 1 < _textField.scrollV)
								$_item.visible = false;
						}else {
							$_item.visible = false;
						}
					}
				}
			}
			
			$_len = _spriteButtons.length;
			while ($_len--) 
			{
				var textbuttoninfo : TextButtonInfo = _spriteButtons[$_len];
				if (textbuttoninfo != null)
				{
					$_item = textbuttoninfo.item;
					if ($_item != null)
					{
						$_rect = _textField.getCharBoundaries(textbuttoninfo.index);
						if ($_rect != null) 
						{
							$_txtLineMetrics = _textField.getLineMetrics(_textField.getLineIndexOfChar(textbuttoninfo.index));
							$_lineHeight = $_rect.height * 0.5 > $_item.height ? $_txtLineMetrics.ascent - $_item.height  : ($_rect.height - $_item.height) * 0.5;
							$_item.visible = true;
							$_item.x =  $_rect.x + ($_rect.width - $_item.width)*0.5;
							$_item.y =  $_rect.y + $_lineHeight;
							if (_textField.getLineIndexOfChar(textbuttoninfo.index) + 1 > _textField.bottomScrollV ||
								_textField.getLineIndexOfChar(textbuttoninfo.index) + 1 < _textField.scrollV)
								$_item.visible = false;
						}
						else 
						{
							$_item.visible = false;
						}
					}
				}
			}
			setContainerPos();
		}
		
		//-------------------------------------------------------------------------
		// TextFormat
		//-------------------------------------------------------------------------
		private function setButtonFormat(id:int):void
		{
			var _format:TextFormat;
			var _item:Sprite;
			var _rec:Rectangle;
			var textButtonInfo : TextButtonInfo = _spriteButtons[id];
			
			_item = textButtonInfo.item;
			_format = new TextFormat();
			
			_format.size = _item.height;
			_format.font = textButtonInfo.buttonStr + BUTTONSEPARATOR + textButtonInfo.buttonType;
			_format.letterSpacing = _item.width - getTxtWidth(_item.height);
			if (textButtonInfo.buttonType.localeCompare(TextButtonInfo.ItemButton) == 0 && itemNameGetFuc != null)
			{
				_format.underline= false;
			}
			else
			{
				_format.underline = true;
			}
			
			if (textButtonInfo.buttonType.localeCompare(TextButtonInfo.VipMundeButton) == 0)
			{
				_format.underline = false;
			}
			
			_format.color = _butUnderColor;
			
			if (!bSetHeight) 
			{
				_format.size = _defaultFormat.size;
				_format.letterSpacing = _item.width - getTxtWidth(int(_format.size));
			}
			
			_textField.setTextFormat(_format, textButtonInfo.index, textButtonInfo.index + 1);
			//_textField.setTextFormat(_defaultFormat, textButtonInfo.index + 1, _textField.text.length);
			
			textButtonInfo.textFormat = _format;
			textButtonInfo.status = STATUS_NORMAL;
		}
		
		public var bSetHeight : Boolean = true;		
		private function setFormat($id:int):void
		{
			var $_format:TextFormat;
			var $_item:Sprite;
			var $_rec:Rectangle;
			var $_info:Object = _spriteMap[$id];
			
			$_item = $_info.item;
			$_format = new TextFormat();
			
			$_format.size = $_item.height;
			$_format.font = $_info.iconStr + SEPARATOR + $_info.iconType + SEPARATOR + $_item.name;
			$_format.letterSpacing = $_item.width - getTxtWidth($_item.height);
			
			if (!bSetHeight) 
			{
				$_format.size = _defaultFormat.size;
				$_format.letterSpacing = $_item.width - getTxtWidth(int($_format.size));
			}
			
			_textField.setTextFormat($_format, $_info.index);
			
			$_info.textFormat = $_format;
			$_info.status = STATUS_NORMAL;
		}
		
		private function getButtonTxtWidth($size:int, txt : String):int
		{
			var $_txt:TextField = new TextField();
			var $_format:TextFormat = new TextFormat();
			$_txt.text = txt;
			$_format.size = $size;
			$_txt.setTextFormat($_format);
			return $_txt.textWidth-2;
		}
		
		private function getTxtWidth($size:int):int
		{
			var $_txt:TextField = new TextField();
			var $_format:TextFormat = new TextFormat();
			$_txt.text = PLACEHOLDER;
			$_format.size = $size;
			$_txt.setTextFormat($_format);
			return $_txt.textWidth-2;
		}
		
		private function checkTxtFormat($beginIndex:int, $endIndex:int):void
		{
			var $_gap :int = $endIndex - $beginIndex;
			var $_textFormat:TextFormat;
			var $_str:String;
			var $_index:int;
			var $_arr:Array;
			var $_txtInfo:Object;
			var $_iconUrl:String;
			
			while ($_gap--) 
			{
				$_index = $endIndex - $_gap - 1;
				$_textFormat = _textField.getTextFormat($_index);
				$_str = $_textFormat.font;
				
				if ($_str.indexOf(SEPARATOR) != -1) 
				{
					$_arr = $_str.split(SEPARATOR);
					$_iconUrl =  findIconUrl($_arr[0]);
					$_txtInfo = {
						iconStr : $_arr[0],
						iconType : $_arr[1],
						iconUrl : $_iconUrl,
						index: $_index
					}
					if ($_iconUrl == null) {
						_textField.replaceText($_index, $_index+1, $_arr[0]);
						refreshArr($_index, $_arr[0].length- PLACEHOLDER.length);
					}else {
						addIcon($_txtInfo);
					}
				}
				else if ($_str.indexOf(BUTTONSEPARATOR) != -1)
				{
					$_arr = $_str.split(BUTTONSEPARATOR);
					var textbuttoninfo : TextButtonInfo = new TextButtonInfo();
					textbuttoninfo.index = $_index;
					textbuttoninfo.buttonStr = $_arr[0];
					textbuttoninfo.buttonType = $_arr[1];
					
					addButton(textbuttoninfo);
					//addIcon($_txtInfo);
				}
			}
		}
		private function setDefaultFormat():void
		{
			_textField.defaultTextFormat = _defaultFormat;
		}
		//-------------------------------------------------------------------------
		// textInfo
		//-------------------------------------------------------------------------
		private function setTextInfo():void
		{
			_txtInfo = {
				cursorIndex : _textField.caretIndex,
				firstPartLength : _textField.caretIndex,
				lastPartLength : _textField.length - _textField.caretIndex
			}
		}
		private function getTextInfo():Object
		{
			var $_obj:Object = {
				cursorIndex : _textField.caretIndex,
				firstPartLength : _textField.caretIndex,
				lastPartLength : _textField.length - _textField.caretIndex
			};
			return  $_obj;
		}
		//-------------------------------------------------------------------------
		// position
		//-------------------------------------------------------------------------

		private function getTextFieldPos():Object
		{
			var $_xpos:Number = _textField.scrollH;
			var $_ypos:Number = 0;
			if (_textField.numLines < _textField.scrollV) {
				var max:int = _textField.numLines - _textField.bottomScrollV + _textField.scrollV - 1;
				_textField.scrollV = Math.min(_textField.maxScrollV - 1, max) + 1;
			}
			var $_n:int = _textField.scrollV - 1;
			while ($_n--) {
				$_ypos += _textField.getLineMetrics($_n).height;
			}
			return { x:-$_xpos, y:-$_ypos };
		}
		
		private function setContainerPos():void
		{
			var $_txtPos:Object = getTextFieldPos();
			
			_spriteContainer.x = _textField.x + $_txtPos.x;
			_spriteContainer.y = _textField.y + $_txtPos.y;
		}
		//-------------------------------------------------------------------------
		// configXML
		//-------------------------------------------------------------------------
		private function getTextButtonInfo(str : String) : TextButtonInfo
		{
			var _beginindex:int = -1;
			var _endindex:int = -1;
			var _id:int = -1;
			
			var textbuttoninfo : TextButtonInfo = new TextButtonInfo();
				
			_beginindex = str.indexOf(TextButtonInfo.ButtonFlag);
			if (_beginindex != -1)
			{
				_endindex = str.indexOf(TextButtonInfo.ButtonFlag, _beginindex + 2);
				if (_endindex != -1)
				{
					textbuttoninfo.buttonStr = str.substring(_beginindex, _endindex + 2);
					textbuttoninfo.buttonType = textbuttoninfo.buttonStr.substring(2, 3);
					textbuttoninfo.index = _beginindex;
				}
			}
			return textbuttoninfo; 
		}
		
		private function getInfoFormXML($str:String):Object
		{
			var $_xml:XML = _configXML;
			var $_len:int = $_xml.icon.length();
			var $_index:int = -1;
			var $_id:int = -1;
			if ($_len <= 0) return null;
			
			var $_info:Object = {
				index: -1,
				iconStr:"",
				iconUrl:"",
				iconType:""
			}
			
			for (var i:int = 0; i < $_len; i++ ) {
				
				$_index = $str.indexOf(getIconStr(i));
				
				if ($_id == -1 || ($_index != -1 && $_id > $_index)) {
					$_id = $_index;
					$_info.index = $_index;
					$_info.iconStr = getIconStr(i);
					$_info.iconUrl = getIconUrl(i);
					$_info.iconType = getIconType(i);
				}
			}
			return $_info; 
		}
		
		private function findIconUrl($iconStr:String):String
		{
			var $_xml:XML = _configXML;
			var $_len:int = $_xml.icon.length();
			
			for (var i:int = 0; i < $_len; i++) {
				if (getIconStr(i) == $iconStr) {
					return getIconUrl(i);
				}
			}
			return null;
		}
		
		private function getIconStr($index:int):String
		{
			var $_xml:XML = _configXML;
			return $_xml.icon[$index].@iconStr;
		}
		
		private function getIconUrl($index:int):String
		{
			var $_xml:XML = _configXML;
			return $_xml.icon[$index].@iconUrl;
		}
		
		private function getIconType($index:int):String
		{
			var $_xml:XML = _configXML;
			return $_xml.icon[$index].@iconType;
		}
		
		//-------------------------------------------------------------------------
		// addIcon & removeIcon
		//-------------------------------------------------------------------------
		
		private function addButton(textbuttoninfo : TextButtonInfo) : void
		{
			var _id:int;
			
			//var _sprite:Sprite = new Sprite();
			var buttondata : ButtonData = GetButtonData(textbuttoninfo.buttonType);
			var labelstr : String = "";
			if (textbuttoninfo.buttonType.localeCompare(TextButtonInfo.SpeakerButton) == 0)
			{
				//labelstr = textbuttoninfo.buttonStr.substr(3, textbuttoninfo.buttonStr.length - 5);
				labelstr = "[" + textbuttoninfo.buttonStr.substr(3, textbuttoninfo.buttonStr.length - 5) + "]";
				buttondata.labelData.textColor = 0x99ccff;
				buttondata.rollOverColor = 0x99ccff;
				_butUnderColor = 0x99ccff;
			}
			else if (textbuttoninfo.buttonType.localeCompare(TextButtonInfo.SystemButton) == 0)
			{
				//labelstr = "【系统消息】: ";
			}
			else if (textbuttoninfo.buttonType.localeCompare(TextButtonInfo.NameButton) == 0 ||
					textbuttoninfo.buttonType.localeCompare(TextButtonInfo.RegionNameButton) == 0)
			{
				labelstr = "[" + textbuttoninfo.buttonStr.substr(3, textbuttoninfo.buttonStr.length - 5) + "]";
				if (inpanel == 1)
				{
					buttondata.labelData.textColor = 0x000000;
					buttondata.rollOverColor = 0x000000;
					_butUnderColor = 0x000000;
				}
				else
				{
					buttondata.labelData.textColor = 0x99ccff;
					buttondata.rollOverColor = 0x99ccff;
					_butUnderColor = 0x99ccff;
				}
			}
			else if (textbuttoninfo.buttonType.localeCompare(TextButtonInfo.ItemButton) == 0 && itemNameGetFuc != null)
			{
				var quality:int = 0;
				labelstr = "[" + itemNameGetFuc(textbuttoninfo.buttonStr.substr(3, textbuttoninfo.buttonStr.length - 5)) + "]";
				if(buttonQuality != null)
					quality = buttonQuality(textbuttoninfo.buttonStr.substr(3, textbuttoninfo.buttonStr.length - 5));
				if (inpanel == 1)
				{
					buttondata.rollOverColor = 0x000000;
					buttondata.labelData.textColor = 0x000000;
					_butUnderColor = 0x000000;
				}
				else
				{
					switch(quality) {
						case 1:
							buttondata.rollOverColor = 0xFFFFFF;
							buttondata.labelData.textColor = 0xFFFFFF;
							_butUnderColor = 0xFFFFFF;
							break;
						case 2:
							buttondata.rollOverColor = 0x00FF00;
							buttondata.labelData.textColor = 0x00FF00;
							_butUnderColor = 0x00FF00;
							break;
						case 3:
							buttondata.rollOverColor = 0x0070DD;
							buttondata.labelData.textColor = 0x0070DD;
							_butUnderColor = 0x0070DD;
							break;
						case 4:
							buttondata.rollOverColor = 0xFF0084;
							buttondata.labelData.textColor = 0xFF0084;
							_butUnderColor = 0xFF0084;
							break;
						case 5:
							buttondata.rollOverColor = 0xA335EE;
							buttondata.labelData.textColor = 0xA335EE;
							_butUnderColor = 0xA335EE;
							break;
						case 6:
							buttondata.rollOverColor = 0xff6600;
							buttondata.labelData.textColor = 0xff6600;
							_butUnderColor = 0xff6600;
							break;
						case 7:
							buttondata.rollOverColor = 0xF8F64A;
							buttondata.labelData.textColor = 0xF8F64A;
							_butUnderColor = 0xF8F64A;
							break;
						case 8:
							buttondata.rollOverColor = 0xcfb53b;
							buttondata.labelData.textColor = 0xcfb53b;
							_butUnderColor = 0xcfb53b;
							break;
						default:
							buttondata.rollOverColor = 0xffffff;
							buttondata.labelData.textColor = 0xffffff;
							_butUnderColor = 0xffffff;
							break;
					}
				}
				
				if (itemTipFunc != null)
				{
					buttondata.toolTip = itemTipFunc(null, null);
					buttondata.toolTipData = new ToolTipData();
				}
			}
			else if(textbuttoninfo.buttonType.localeCompare(TextButtonInfo.PayButton) == 0)
			{
				labelstr = "[" + textbuttoninfo.buttonStr.substr(3, textbuttoninfo.buttonStr.length - 5) + "]";
				buttondata.labelData.textColor = 0xffffff;
				buttondata.rollOverColor = 0xffffff;
				_butUnderColor = 0xffffff;
			}
			else if(textbuttoninfo.buttonType.localeCompare(TextButtonInfo.VipButton) == 0)
			{
				labelstr = "[" + textbuttoninfo.buttonStr.substr(3, textbuttoninfo.buttonStr.length - 5) + "]";
				buttondata.labelData.textColor = 0xffffff;
				buttondata.rollOverColor = 0xffffff;
				_butUnderColor = 0xffffff;
			}
			else if(textbuttoninfo.buttonType.localeCompare(TextButtonInfo.VipMundeButton) == 0)
			{
				labelstr = "[" + textbuttoninfo.buttonStr.substr(3, textbuttoninfo.buttonStr.length - 5) + "]";
				buttondata.labelData.textColor = 65535;
				buttondata.rollOverColor =65535;
			}
			buttondata.height = _defaultFormat.size == null ? 12 : int(_defaultFormat.size);
			buttondata.width = getButtonTxtWidth(buttondata.height, labelstr) + 2;
			buttondata.labelData.text = labelstr;
			buttondata.labelData.hGap = 0;
			var _item : Button = new Button(buttondata);
			_item.width = _item.label.width;
			_item.label.x = (_item.width - _item.label.width) * 0.5;
			_item.label.y = (_item.height - _item.label.height) * 0.5;
			if (buttonClickHandle != null)
				_item.addEventListener(MouseEvent.CLICK, buttonClickHandle);
			_item.source = textbuttoninfo;
			//_sprite.addChild(_item);
			if (textbuttoninfo.buttonType.localeCompare(TextButtonInfo.ItemButton) == 0 && itemTipFunc != null)
			{
				textbuttoninfo.itemTipFunc = itemTipFunc;
				//itemTipFunc(textbuttoninfo.buttonStr.substr(3, textbuttoninfo.buttonStr.length - 5), _item.toolTip);
			}
			
			textbuttoninfo.item = _item;
			textbuttoninfo.status = STATUS_INIT;
			_spriteButtons.push( textbuttoninfo );
			_id = _spriteButtons.length-1;
				
			_spriteContainer.addChild(_item);
			setButtonFormat(_id);
			//refresh();
		}
		
		private function addIcon($iconInfo:Object):void
		{
			var $_id:int ;
			
			var $_onItemLoaded:Function = function($item:Sprite):void 
			{
				_spriteMap.push( { 
					item: $item,
					iconStr : $iconInfo.iconStr,
					iconType : $iconInfo.iconType,
					iconUrl : $iconInfo.iconUrl, 
					index : $iconInfo.index,
					textFormat : null,
					status: STATUS_INIT
				});
				//trace($item.width);
				$_id = _spriteMap.length-1;
				
				_spriteContainer.addChild($item);
				setFormat($_id);
				//refresh();
			}
			
			if ($iconInfo.iconType == TYPE_MOVIECLIP) {
				addMovieClip($iconInfo, $_onItemLoaded); 
			}else if ($iconInfo.iconType == TYPE_JPG) { 
				addJpg($iconInfo, $_onItemLoaded);
			}else if ($iconInfo.iconType == TYPE_GIF) { 
				addGif($iconInfo, $_onItemLoaded);
			}
		}
		
		private function refreshButton($index:int, $gap:int):void
		{
			var _len : int = _spriteButtons.length;
			var textButtoninfo : TextButtonInfo;
			var _item : Sprite;
			
			var _textFormat:TextFormat;
			
			while (_len--) 
			{
				textButtoninfo = _spriteButtons[_len];
				if (textButtoninfo != null)
				{
					_item = textButtoninfo.item;
					if (_item != null)
					{
						if (textButtoninfo.index >= $index) textButtoninfo.index += $gap;
						if ( textButtoninfo.index < 0 || textButtoninfo.index >= _textField.length)
						{
							if (buttonClickHandle != null)
								_item.removeEventListener(MouseEvent.CLICK, buttonClickHandle);
							_spriteContainer.removeChild(_item);
							_spriteButtons[_len] = null;
							textButtoninfo = null;
						}
						else
						{
							_textFormat = _textField.getTextFormat(textButtoninfo.index);
							if (textButtoninfo.status == STATUS_NORMAL && _textFormat.font != textButtoninfo.textFormat.font) 
							{
								if (buttonClickHandle != null)
									_item.removeEventListener(MouseEvent.CLICK, buttonClickHandle);
								_spriteContainer.removeChild(_item);
								_spriteButtons[_len] = null;
								textButtoninfo = null;
							}
						}
					}
				}
			}
		}
		
		private function refreshIcon($index:int, $gap:int):void
		{
			var $_arr:Array = _spriteMap;
			var $_len:int = $_arr.length;
			
			var $_info:Object;
			var $_item:Sprite;
			
			var $_textFormat:TextFormat;
			
			while ($_len--) 
			{
				$_info = $_arr[$_len];
				if($_info){
					$_item = $_info.item;
					if($_item){
						
						if ($_info.index >= $index) $_info.index += $gap;
						if ( $_info.index < 0 || $_info.index >= _textField.length) {
							_spriteContainer.removeChild($_item);
							$_arr[$_len] = null;
							$_info = null;
							//trace("remove1");
						}else{
							$_textFormat = _textField.getTextFormat($_info.index);
							if ($_info.status == STATUS_NORMAL && $_textFormat.font != $_info.textFormat.font) {	
								_spriteContainer.removeChild($_item);
								$_arr[$_len] = null;
								$_info = null;
								//trace("remove2");
							}
						}
					}
				}
			}
		}
		
		private function addMovieClip($info:Object, $onComplete:Function = null):void
		{
			var $_sprite:Sprite = new Sprite();
			var $_class:Class ;
			var $_item:MovieClip ;
			
			if ($info.iconUrl == null  || $info.iconUrl == "" ) {
				drawErrGraphics($_sprite); 
			}else {
				try {
					var ary : Array = $info.iconUrl.split(ICONASSERTSPLIT);
					if (ary != null && ary.length == 2)
					{
						$_item = RESManager.getMC(new AssetData(ary[0], ary[1]));
						if (iconHeight != 0)
						{
							$_item.height = iconHeight;
							$_item.width = iconHeight;
						}
						if ($_item != null)
							$_sprite.addChild($_item);
						else
							drawErrGraphics($_sprite);
					}
					else
					{
						drawErrGraphics($_sprite); 
					}
				}catch($e:Error){
					drawErrGraphics($_sprite); 
					//trace($e);
				}
			}
			if($onComplete !=null ) $onComplete($_sprite);
		}
		
		private function addJpg($info:Object, $onComplete:Function = null):void
		{
			var $_sprite:Sprite = new Sprite();
			var $_imgLoader:Loader = new Loader();
			var $_onComplete:Function = function(evt:Event):void
			{
				if ($onComplete != null ) $onComplete($_sprite); 
			}
			var $_onError:Function = function(evt:Event):void
			{
				drawErrGraphics($_sprite); 
				if($onComplete !=null ) $onComplete($_sprite);
			}
			if ($info.iconUrl == null || $info.iconUrl == "" ) {
				drawErrGraphics($_sprite); 
				if($onComplete !=null ) $onComplete($_sprite);
			}else {
				$_sprite.addChild($_imgLoader);
				$_imgLoader.load(new URLRequest($info.iconUrl));
				$_imgLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, $_onComplete);
				$_imgLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, $_onError );
			}
		}
		private function addGif($info:Object, $onComplete:Function = null):void
		{
			var $_sprite:Sprite = new Sprite();
			var $_onComplete:Function = function(evt:Object):void
			{
				var $_frameRect:Rectangle = evt.rect;
				drawRectGraphics($_sprite, $_frameRect.width, $_frameRect.height, false, 0);
				if ($onComplete != null ) $onComplete($_sprite); 
			}
			var $_onError:Function = function(evt:Event):void
			{
				drawErrGraphics($_sprite); 
				if($onComplete !=null ) $onComplete($_sprite);
			}
			if ($info.iconUrl == null  || $info.iconUrl == "") {
				drawErrGraphics($_sprite); 
				if($onComplete !=null ) $onComplete($_sprite);
			}else{
				_gifPlayer.createGif($_sprite, $info.iconUrl, $_onComplete, $_onError);
			}
		}
		
		//-------------------------------------------------------------------------
		// draw graphics
		//-------------------------------------------------------------------------
		
		private function drawErrGraphics($container:Sprite):void 
		{
			$container.graphics.clear();
			$container.graphics.lineStyle(1,0xff0000);
			$container.graphics.beginFill(0xffffff);
			$container.graphics.drawRect(0, 0, 10, 10);
			
			$container.graphics.moveTo(0, 0);
			$container.graphics.lineTo(10, 10);
			$container.graphics.moveTo(0, 10);
			$container.graphics.lineTo(10, 0);
			
			$container.graphics.endFill();
		}
		
		private function drawRectGraphics($container:Sprite, $w:int = 10, $h:int = 10, $isClear:Boolean = false,  $alpha:int = 1):void 
		{
			if($isClear) $container.graphics.clear();
			$container.graphics.beginFill(0x0,$alpha);
			$container.graphics.drawRect(0, 0, $w, $h);
			$container.graphics.endFill();
		}
		
		//============================================================================
		//setter & getter
		//============================================================================
		public function set textField(field : TextField) : void
		{
			if (_textField != null)
			{
				_textField.removeEventListener(MouseEvent.CLICK, clickHandler);
				_textField.removeEventListener(KeyboardEvent.KEY_DOWN, keyHandler);
				
				_textField.removeEventListener(Event.CHANGE , changeHandler);
				_textField.removeEventListener(Event.SCROLL , scrollHandler);
				this.removeChildAt(0);
			}
			
			_textField = field;
			
			_textField.addEventListener(MouseEvent.CLICK, clickHandler);
			_textField.addEventListener(KeyboardEvent.KEY_DOWN, keyHandler);
			
			_textField.addEventListener(Event.CHANGE , changeHandler);
			_textField.addEventListener(Event.SCROLL , scrollHandler);
			this.addChildAt(field, 0);
		}
		
		public function set textFieldtext(str:String):void
		{
			clear();
			_textField.text = str;
			convert();
			refresh();
		}
		
		public function get textField():TextField
		{
			return _textField;
		}
		public function set richText($str:String):void
		{
			clear();
			_richTxt = $str;
			_textField.htmlText = $str;	
			
			if ($str == null || $str == "" || _configXML == null ) return;
			
			controlManager(STATUS_CONVERT);
		}
		public function get richText():String
		{
			return revert();
		}
		
		public function get Text() : String
		{
			return revertText();
		}
		
		public function set configXML($xml:XML):void
		{
			_configXML = $xml;
		}
		public function get configXML():XML
		{
			return _configXML;
		}
		public function set defaultTextFormat($textFormat:TextFormat):void
		{
			_defaultFormat = $textFormat;
			_textField.defaultTextFormat = _defaultFormat;
		}
		
		public function get defaultTextFormat() : TextFormat
		{
			return _defaultFormat;
		}
		
		
		private const buttonDataMap : Map = new Map();
		
		public function RegisterButtonData(buttontype : String, buttondata : ButtonData) : void
		{
			if (buttonDataMap.containsKey(buttontype))
				buttonDataMap.removeBy(buttontype);
			buttonDataMap.put(buttontype, buttondata);
		}
		
		public function GetButtonData(buttontype : String) : ButtonData
		{
			if (buttonDataMap.containsKey(buttontype))
				return buttonDataMap.getBy(buttontype);
			var buttondata : ButtonData = new ButtonData();
			buttondata.upAsset = new AssetData(SkinStyle.emptySkin);
			buttondata.downAsset = new AssetData(SkinStyle.emptySkin);
			buttondata.overAsset = new AssetData(SkinStyle.emptySkin);
			buttondata.labelData = new LabelData();
			buttondata.labelData.styleSheet = null;
			buttondata.labelData.textFormat = _defaultFormat;
			buttondata.labelData.textColor = 0xFFFFFF00;
			buttondata.labelData.textFieldFilters = null;
			buttondata.labelData.hGap = 0;
			buttondata.enabled = true;
			return buttondata;
		}
	}
	
}

//*****************************************************
// 以下为包外类-----------
//*****************************************************

//==============================================================================================
// gifPlayer
// 注:gifPlayer作者是bytearray.org ,此处为引用,如需源码,请查看http://code.google.com/p/as3gif/;
//==============================================================================================

import flash.display.Loader;
import flash.display.Sprite;

import flash.events.Event;
import flash.events.IOErrorEvent;

import flash.net.URLRequest;
import flash.utils.ByteArray;

internal class GifPlayer {
	private var _gifPlayerClass:Class;
	private var _gifPlayerEvent:Class;
	private var _byteArray:ByteArray;
	private var _loader:Loader;
	
	private	const GIFPLAYERSTR ="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"
	
	public function GifPlayer()
	{
		_byteArray = new Base64(GIFPLAYERSTR);
		_loader = new Loader();
		createClass();
	}
	public function createGif($container:Sprite, $url:String, $onComplete:Function = null, $onError:Function = null):void
	{
		var $_gifPlayer;
		var $_fun:Function = function():void
		{
			$_gifPlayer = new _gifPlayerClass();
			$container.addChild($_gifPlayer);
			$_gifPlayer.load( new URLRequest ($url) );	
			$_gifPlayer.addEventListener( _gifPlayerEvent.COMPLETE, $onComplete);
			$_gifPlayer.addEventListener(IOErrorEvent.IO_ERROR, $onError );
		}
		createClass($_fun);
	}
	
	private function createClass($onComplete:Function = null):void
	{
		if (_gifPlayerClass != null ) {
			if ($onComplete != null) $onComplete();
			return;
		}
		//trace("create");
		var $_completeHandler:Function = function(evt:Event):void {
			_gifPlayerClass = _loader.contentLoaderInfo.applicationDomain.getDefinition("org.bytearray.gif.player.GIFPlayer") as Class;
			_gifPlayerEvent = _loader.contentLoaderInfo.applicationDomain.getDefinition("org.bytearray.gif.events.GIFPlayerEvent") as Class;
			if ($onComplete != null) $onComplete();
		}
		_loader.loadBytes(_byteArray);
		_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, $_completeHandler);
	}
	public function get gifPlayerClass ():Class
	{
		return _gifPlayerClass;
	}
	public function get gifPlayerEvent ():Class
	{
		return _gifPlayerEvent;
	}
}

//============================================================================
// Base64 
// 通用的base64转byteArray;
//============================================================================

internal class Base64 extends ByteArray {
	private static  const BASE64:Array = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,62,0,0,0,63,52,53,54,55,56,57,58,59,60,61,0,0,0,0,0,0,0,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,0,0,0,0,0,0,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,0,0,0,0,0];
	public function Base64(str:String):void {
		var n:int, j:int;
		for (var i:int = 0; i < str.length && str.charAt(i) != "="; i++) {
			j = (j << 6) | BASE64[str.charCodeAt(i)];
			n += 6;
			while (n >= 8) {
				writeByte((j >> (n -= 8)) & 0xFF);
			}
		}
		position = 0;
	}
}