package com.utils 
{
	import flash.filters.ColorMatrixFilter;
	/**
	 * ...
	 * @author lizzardchen
	 */
	public class GFilterUtil 
	{
		public function GFilterUtil() 
		{
			
		}
		
		public static function GrayFilter(): Object
		{
			return new ColorMatrixFilter(ColorMatrixUtil.GRAY);
		}
		
	}

}