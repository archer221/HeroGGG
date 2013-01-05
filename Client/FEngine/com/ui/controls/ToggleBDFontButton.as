package com.ui.controls 
{
	import com.bd.BDFont;
	import com.net.AssetData;
	import com.ui.data.ToggleButtonData;
	import flash.filters.GlowFilter;
	/**
	 * ...
	 * @author ...
	 */
	public class ToggleBDFontButton extends ToggleButton
	{
		
		public function setBDSkin(asset : AssetData, chars : Array, width : int, height : int, leading : int)
		{
			_upSkin = new BDFont(asset, chars, width, height, leading);
			_overSkin = new BDFont(asset, chars, width, height, leading);
			_overSkin.filters = [new GlowFilter(0xffffbe, 1, 10, 10)];
			_downSkin = new BDFont(asset, chars, width, height, leading);
			_disabledSkin = new BDFont(asset, chars, width, height, leading);
			_selectedUpSkin = new BDFont(asset, chars, width, height, leading);
			_selectedUpSkin.filters = [new GlowFilter(0xffffbe, 1, 10, 10)];
			_selectedOverSkin = new BDFont(asset, chars, width, height, leading);
			_selectedOverSkin.filters = [new GlowFilter(0xffffbe, 1, 10, 10)];
			_selectedDownSkin = new BDFont(asset, chars, width, height, leading);
			_selectedDisabledSkin = new BDFont(asset, chars, width, height, leading);
			viewSkin();
		}
		
		public function ToggleBDFontButton(data : ToggleButtonData) 
		{
			_data = data;
			super(data);
			selected = _data.selected;
		}
		
		public function set PageText(value : int) : void
		{
			(_upSkin as BDFont).text = value.toString();
			(_overSkin as BDFont).text = value.toString();
			(_downSkin as BDFont).text = value.toString();
			(_disabledSkin as BDFont).text = value.toString();
			(_selectedUpSkin as BDFont).text = value.toString();
			(_selectedOverSkin as BDFont).text = value.toString();
			(_selectedDownSkin as BDFont).text = value.toString();
			(_selectedDisabledSkin as BDFont).text = value.toString();
		}
	}

}