package com.ui.data {
	import com.net.AssetData;
	import com.ui.core.ScaleMode;
	import com.ui.core.UIComponentData;

	/**
	 * @version 20091215
	 * @author Cafe
	 */
	public class SpinnerData extends UIComponentData {

		public var upArrowData : ButtonData;

		public var downArrowData : ButtonData;

		public var textInputData : TextInputData;

		override protected function parse(source : *) : void {
			super.parse(source);
			var data : SpinnerData = source as SpinnerData;
			if(data == null)return;
			data.upArrowData = (upArrowData ? upArrowData.clone() : null);
			data.downArrowData = (downArrowData ? downArrowData.clone() : null);
			data.textInputData = (textInputData ? textInputData.clone() : null);
		}

		public function SpinnerData() {
			upArrowData = new ButtonData();
			upArrowData.upAsset = new AssetData("GSpinner_upArrow_upSkin");
			upArrowData.overAsset = new AssetData("GSpinner_upArrow_overSkin");
			upArrowData.downAsset = new AssetData("GSpinner_upArrow_downSkin");
			upArrowData.disabledAsset = new AssetData("GSpinner_upArrow_disabledSkin");
			upArrowData.scaleMode = ScaleMode.SCALE_NONE;
			upArrowData.width = 18;
			upArrowData.height = 11;
			downArrowData = new ButtonData();
			downArrowData.upAsset = new AssetData("GSpinner_downArrow_upSkin");
			downArrowData.overAsset = new AssetData("GSpinner_downArrow_overSkin");
			downArrowData.downAsset = new AssetData("GSpinner_downArrow_downSkin");
			downArrowData.disabledAsset = new AssetData("GSpinner_downArrow_disabledSkin");
			downArrowData.scaleMode = ScaleMode.SCALE_NONE;
			downArrowData.width = 18;
			downArrowData.height = 11;
			textInputData = new TextInputData();
			scaleMode = ScaleMode.AUTO_WIDTH;
			width = 70;
			height = 22;
		}

		override public function clone() : * {
			var data : SpinnerData = new SpinnerData();
			parse(data);
			return data;
		}
	}
}
