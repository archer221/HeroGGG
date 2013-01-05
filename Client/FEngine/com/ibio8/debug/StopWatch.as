/**
 * 计时
 * @version 1
 * @author www.hexagonstar.com
 * 2009-4-14 17:53
 */
package com.ibio8.debug {
	import flash.utils.getTimer;
	/**
	 * 计时器相关扩展。
	 * @private
	 */
	public class StopWatch {
		//以 ms 计时默认有多少位
		protected const DIGIT_NUML:uint = 5;
		protected var m_started:Boolean = false;
		protected var m_startTimeKeys:Array;
		protected var m_stopTimeKeys:Array;
		protected var m_title:String;
		
		public function StopWatch() {
			reset();
		}
		
		/**
		 * 开始计时
		 * @param title 此计时的标题
		 */
		public function start(title:String = ""):void {
			if (!m_started) {
				m_title = title;
				m_started = true;
				m_startTimeKeys.push(getTimer());
			}
		}
		
		public function stop():void {
			if (m_started) {
				m_stopTimeKeys[m_startTimeKeys.length - 1] = getTimer();
				m_started = false;
			}
		}
		
		public function reset():void {
			m_startTimeKeys = [];
			m_stopTimeKeys = [];
			m_started = false;
		}
		
		/**
		 * @return	返回某个时间段的计时结果
		 */
		public function toString():String {
			var s:String = "\n *********************** [计时] ************************";
			if (m_title != "") {
				s += "\n * " + m_title;
			}
			for (var i:int = 0; i < m_startTimeKeys.length; i++) {
				var s1:int = m_startTimeKeys[i];
				var s2:int = m_stopTimeKeys[i];
				s += "\n * 开始 ["
				  + format(s1) + "ms]  结束 ["
				  + format(s2) + "ms]  时长 ["
				  + format(s2 - s1) + "ms]";
			}
			if (i == 0) {
				s += "\n * 还没有开始。";
			}else {
				s += "\n * 总的时长: " + timeInSeconds + "s";
			}
			s += "\n *******************************************************";
			return s;
		}
		
		public function get isStart():Boolean {
			return m_started;
		}
		
		/**
		 * 返回当前所经过的时间(ms)
		 * 注意：这里仍然不会停止计时
		 */
		public function get timeInMilliSeconds():int {
			if (m_started) {
				m_stopTimeKeys[m_startTimeKeys.length - 1] = getTimer();
			}
			var r:int = 0;
			for (var i:int = 0; i < m_startTimeKeys.length; i++) {
				r += (m_stopTimeKeys[i] - m_startTimeKeys[i]);
			}
			return r;
		}
		
		/**
		 * 返回当前所经过的时间(s)
		 * 注意：这里仍然不会停止计时
		 */
		public function get timeInSeconds():Number {
			return timeInMilliSeconds / 1000;
		}
		
		//补全 0
		protected function format(v:int):String {
			var s:String = "";
			var l:int = v.toString().length;
			for (var i:int = 0; i < (DIGIT_NUML - l); i++) {
				s += "0";
			}
			return s + v;
		}
	}
}
