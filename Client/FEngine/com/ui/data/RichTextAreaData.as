package com.ui.data 
{
	/**
	 * ...
	 * @author 
	 */
	public class RichTextAreaData extends TextAreaData
	{
		public var configXML : XML;
		
		override protected function parse(source : *) : void {
			super.parse(source);
			var data : RichTextAreaData = source as RichTextAreaData;
			if (data == null) return;
			data.configXML = configXML;
		}
		
		public function RichTextAreaData() 
		{
			super();
			textFieldFilters = null;
			styleSheet = null;
		}
		
		override public function clone() : * {
			var data : RichTextAreaData = new RichTextAreaData();
			parse(data);
			return data;
		}
		
	}

}