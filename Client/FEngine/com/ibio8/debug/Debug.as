/**
 * Debug
 * @version 1.1
 * @author www.hexagonstar.com
 * 2009-4-14 17:17
 */
package com.ibio8.debug {
	import com.ibio8.debug.StopWatch;
	
	import flash.display.Stage;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.StatusEvent;
	import flash.net.LocalConnection;
	import flash.net.SharedObject;
	import flash.net.SharedObjectFlushStatus;
	import flash.system.Capabilities;
	import flash.system.Security;
	import flash.system.SecurityPanel;
	import flash.utils.ByteArray;
	import flash.utils.describeType;
	/**
	 * 爱博吧远程调试工具-- IDebuger。
	 * 
	 * <p>
	 * 此类是用来远程调试。将此类编译到 swf 中，然后启动远程调试面板，即可观察
	 * 到在 swf 中的输出。
	 * </p>
	 * <p>调试 demo 以及 exe 调试面板地址：http://code.google.com/p/ibio/downloads/list</p>
	 * <p>在线调试面板地址：http://www.ibio8.com/labs/debug/</p>
	 * <p>详细帮助文档：http://hi.baidu.com/ibio/blog/item/3688bda1bcd3028346106437.html</p>
	 * <b>此调试工具类由 www.hexagonstar.com 启发而来。</b>
	 */
	public final class Debug {
		/** 输出内容的等级：Debug **/
		public static const LEVEL_DEBUG:uint = 0;
		/** 输出内容的等级：Info **/
		public static const LEVEL_INFO:uint	= 1;
		/** 输出内容的等级：Warning **/
		public static const LEVEL_WARNING:uint = 2;
		/** 输出内容的等级：Error **/
		public static const LEVEL_ERROR:uint = 3;
		/** 输出内容的等级：Fatal **/
		public static const LEVEL_FATAL:uint = 4;
		/** @private **/
		protected static const SEND_DATA:String = "onData";
		/** @private **/
		protected static const SEND_CAP:String = "onCap";
		/** @private **/
		protected static const SEND_PROP:String = "onProp";
		/** @private **/
		protected static const SEND_LARGE_DATA:String = "onLargeData";
		/** @private **/
		protected static const LAST_DEPTH:uint = 128;
		/** @private **/
		protected static var m_isConnected:Boolean = false;
		/** @private **/
		protected static var m_enabled:Boolean = true;
		/** @private **/
		protected static var m_connection:LocalConnection;
		/** @private **/
		protected static var m_stopWatch:StopWatch;
		/** @private **/
		protected static var m_isInit:Boolean = false;
		
		/**
		 * 输出数据
		 * @example
		 * Debug.dump("这里是要输出的字符串!");
		 * Debug.dump(new Object(a:1, b:2), 1, 10);
		 * @param data	当前需要显示的信息
		 * @param level	此信息的层级
		 * @param depth	若此信息为object，则为此信息的遍历层级
		 */
		public static function dump(data:*, level:uint = 1, depth:uint = 64):void {
			if (level > LEVEL_FATAL) {
				level = LEVEL_FATAL;
			}
			if (depth > LAST_DEPTH) {
				level = LAST_DEPTH;
			}
			//如果是显示对象
			if (data is DisplayObject) {
				data = getFullPath(data);
			}
			send(SEND_DATA, data, level, depth);
		}
		
		/**
		 * 初始化远程调试工具
		 * <p>此操作是可选的，如果初始化，则可获得舞台相关属性。</p>
		 * @param	stage	此 swf 的舞台实例。
		 */
		public static function initialize(stage:Stage):void {
			//确保只 call 一次
			if (!m_isInit) {
				send(SEND_PROP, {frameRate:stage.frameRate, flashvars:stage.loaderInfo.parameters,
								 stageWidth:stage.stageWidth, stageHeight:stage.stageHeight});
				m_isInit = true;
			}
		}
		
		/**
		 * 清除所有数据
		 */
		public static function clear():void {
			dump("$DEBUG_CLEAR$", LEVEL_FATAL + 1);
		}
		
		/**
		 * 是否禁用
		 */
		public static function set enabled(value:Boolean):void {
			m_enabled = value;
		}
		
		public static function get enabled():Boolean {
			return m_enabled;
		}
		
		/**
		 * 开始计时器
		 * 
		 * @param title 此计时的标题
		 * @example 下面的例子简要说明了怎样使用此方法。
		 * Debug.timerStart("Loop Execution Time");
		 * for each(var i:Object in list) {
		 *     ...
		 * }
		 * Debug.timerStop();
		 * Debug.timerToString();
		 */
		public static function timerStart(title:String = ""):void {
			if (m_enabled) {
				if (!m_stopWatch) {
					m_stopWatch = new StopWatch();
				}
				m_stopWatch.start(title);
			}
		}
		
		/**
		 * 停止计时器
		 */
		public static function timerStop():void {
			if (m_stopWatch) {
				m_stopWatch.stop();
			}
		}
		
		/**
		 * 计时器重启
		 */
		public static function timerReset():void {
			if (m_stopWatch) {
				m_stopWatch.reset();
			}
		}
		
		/**
		 * 将时间转化为毫秒显示
		 */
		public static function timerInMilliSeconds():void {
			if (m_stopWatch) {
				dump(m_stopWatch.timeInMilliSeconds + "ms");
			}
		}
		
		/**
		 * 将时间转化为秒显示
		 */
		public static function timerInSeconds():void {
			if (m_stopWatch) {
				dump(m_stopWatch.timeInSeconds + "s");
			}
		}
		
		/**
		 * 将时间转化为字符串
		 */
		public static function timerToString():void {
			if (m_stopWatch) {
				dump(m_stopWatch.toString());
			}
		}
		
		/**
		 * 停止当前计时器，且将时间转化为字符串
		 * @param	reset	是否自动重置数据
		 */
		public static function timerStopToString(reset:Boolean = false):void {
			if (m_stopWatch) {
				m_stopWatch.stop();
				dump(m_stopWatch.toString());
				if (reset) {
					m_stopWatch.reset();
				}
			}
		}
		
		/** @private **/
		protected static function onStatusHandler(e:StatusEvent):void {
			//
		}
		
		/** @private **/
		//当前 SWF 文件的系统和播放器的一些属性
		protected static function sendCapabilities():void {
			var xml:XML = describeType(Capabilities);
			var tempArr:Array = [];
			for each (var node:XML in xml.*) {
				var n:String = node.@name.toString();
				if ((n.length > 0) && (n != "_internal") && (n != "prototype")) {
					tempArr.push({name:n, value:Capabilities[n].toString()});
				}
			}
			//
			tempArr.sortOn(["key"], Array.CASEINSENSITIVE);
			send(SEND_CAP, tempArr);
		}
		
		/**
		 * 发送数据到IDebuger
		 * @param method	当前的方式
		 * @param data		需要显示的数据
		 * @param level		层级
		 * @param depth		循环深度
		 * @private
		 */
		protected static function send(method:String, data:*, level:uint = 1, depth:uint = 0):void {
			if (m_enabled) {
				//确保每次只连接一次
				if (!m_isConnected) {
					m_isConnected = true;
					m_connection = new LocalConnection();
					m_connection.addEventListener(StatusEvent.STATUS, onStatusHandler);
					//发送相关的属性
					sendCapabilities();
				}
				//获取当前数据大小
				var size:uint = 0;
				if (typeof(data) == "string") {
					size = String(data).length;
				}else if (typeof(data) == "object") {
					var byteArray:ByteArray = new ByteArray();
					byteArray.writeObject(data);
					size = byteArray.length;
					byteArray = null;
				}
				//因为 connection 每次只能传递 40 千字节
				/* If the data size exceeds 39Kb, use a LSO instead */
				if (size > 39000) {
					storeDataLSO(method, data);
					method = SEND_LARGE_DATA;
					data = null;
				}
				m_connection.send("_idebuger_lc", method, data, level, depth);
			}
		}
		
		/**
		 * 如果数据 > 40KB，则在本地存储
		 * @param	method	方法名
		 * @param	data	数据
		 * @private
		 */
		protected static function storeDataLSO(method:String, data:*):void {
			var sharedObject:SharedObject = SharedObject.getLocal("idebuger", "/");
			sharedObject.data["idebugerMethod"] = method;
			sharedObject.data["idebugerData"] = data;
			try {
				var flushResult:String = sharedObject.flush();
				if (flushResult == SharedObjectFlushStatus.FLUSHED) {
					return;
				}
			}catch (e:Error) {
				Security.showSettings(SecurityPanel.LOCAL_STORAGE);
			}
		}
		
		/** @private **/
		protected static function getFullPath(data:DisplayObject):String {
			var path:String = data.name;
			while (data.stage && (data.parent != data.stage)) {
				data = data.parent;
				path = data.name + "." + path;
			}
			return path;
		}
	}
}
