package com.ui.data {
	import com.net.AssetData;
	import com.ui.core.ScaleMode;
	import com.ui.core.UIComponentData;

	/**
	 * Game Tool Tip Data
	 * 
	 * @author Cafe
	 * @version 20100719
	 */
	public class ToolTipData extends UIComponentData {

		public var backgroundAsset : AssetData;
		
		public var effecttimeAsset : AssetData;

		public var labelData : LabelData = new LabelData();

		public var padding : int;

		public var alginMode : int;
		
		public var busemousemove : Boolean = false;
		
		public var offsetX : int;
		
		public var offsetY : int;

		override protected function parse(source : *) : void {
			super.parse(source);
			var data : ToolTipData = source as ToolTipData;
			if(data == null)return;
			data.backgroundAsset = backgroundAsset;
			data.labelData = labelData;
			data.padding = padding;
			data.alginMode = alginMode;
			data.effecttimeAsset = effecttimeAsset;
			data.offsetX = offsetX;
			data.offsetY = offsetY;
		}

		public function ToolTipData() {
			backgroundAsset = new AssetData("ListImage","uicommon");
			padding = 5;
			alginMode = 5;
			minWidth = 295;
			scaleMode = ScaleMode.AUTO_SIZE;
		}

		override public function clone() : * {
			var data : ToolTipData = new ToolTipData();
			parse(data);
			return data;
		}
	}
}