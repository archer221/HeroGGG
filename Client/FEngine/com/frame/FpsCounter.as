package com.frame 
{
	import flash.utils.getTimer;
	/**
	 * ...
	 * @author 
	 */
	public class FpsCounter 
	{
		public function FpsCounter(){
			oldT = getTimer();
		}

		public function update():void{
			var newT:uint = getTimer();
			var f1:uint = newT-oldT;
			mfpsCount += f1;
			if (avgCount < 1){
				avgCount = 30;
				mfpsCount = 0;
			}
			avgCount--;
			oldT = getTimer();
		}
		
		private var mfpsCount:int = 0;
		private var avgCount:int = 30;
		private var oldT:uint;
		
	}

}