package com.ui.controls {
	import com.net.AssetData;
	import com.ui.core.UIComponentData;
    import BZTC.UI.BztcUIManager;
	import com.ui.skin.SkinStyle;

	/**
	 * @author cafe
	 */
	public class PowerBarData extends UIComponentData {
		public var trackAsset : AssetData = new AssetData(SkinStyle.emptySkin);
		public var barAsset : AssetData = new AssetData(SkinStyle.emptySkin);
		public var lastAsset : AssetData = new AssetData(SkinStyle.emptySkin);
		public var tipAsset : AssetData = new AssetData(SkinStyle.emptySkin);

		public function PowerBarData() {
			width = 186;
			height =36;
		}
	}
}
