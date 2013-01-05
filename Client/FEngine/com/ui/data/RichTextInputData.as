package com.ui.data 
{
	/**
	 * ...
	 * @author 
	 */
	public class RichTextInputData extends TextInputData
	{
		public var configXML : XML;
		
		override protected function parse(source : *) : void {
			super.parse(source);
			var data : RichTextInputData = source as RichTextInputData;
			if (data == null) return;
			data.configXML = configXML;
		}
		
		public function RichTextInputData() 
		{
			super();
		}
		
		override public function clone() : * {
			var data : RichTextInputData = new RichTextInputData();
			parse(data);
			return data;
		}
		
	}

}