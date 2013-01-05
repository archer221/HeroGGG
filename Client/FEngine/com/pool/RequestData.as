package com.pool {
	import com.log4a.Logger;

	/**
	 * @author wingox
	 * @version 20100505
	 */
	public class RequestData {

		private var _method : String;

		private var _args : Array;

		public function RequestData(method : String,args : Array) {
			_method = method;
			_args = args;
		}

		public function get method() : String {
			return _method;
		}

		public function get args() : Array {
			return _args;
		}

		public function toString() : String {
			return "method=" + _method;
		}

		public static function parse(value : Object) : RequestData {
			if(value == null) {
				Logger.warn("RequestData.parse:value=null");
				return null;
			}
			if(value.hasOwnProperty("method")) {
				if(value.method == null) {
					Logger.warn("RequestData.parse:method=null");
					return null;
				}
				var data : RequestData = new RequestData(value.method, value.args);
				return data;
			} else {
				Logger.warn("RequestData.parse:nosuch method");
				return null;
			}
		}
	}
}
