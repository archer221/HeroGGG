package com.log4a {
	import com.ui.manager.UIManager;

	import flash.events.StatusEvent;
	import flash.net.LocalConnection;
	import flash.net.SharedObject;

	public final class LocalAppender extends Appender {
		private var _id : int;

		private var _name : String;

		private var _lc : LocalConnection;

		private var _shareObject : SharedObject;

		private function init() : void {
			_shareObject = SharedObject.getLocal("Logger");
			if(_shareObject.data.autoId == null) {
				_shareObject.data.autoId = 0;
			} else {
				_shareObject.data.autoId++;
			}
			_shareObject.flush();
			_id = this._shareObject.data.autoId;
			_name = UIManager.swfName;
			_lc = new LocalConnection();
			_lc.allowDomain("*");
			_lc.allowInsecureDomain("*");
			_lc.addEventListener(StatusEvent.STATUS, this.onStatus);
			_lc.send("Logger", "createLogger", this._id, this._name);
			_formatter = new SimpleLogFormatter();
		}

		private function onStatus(event : StatusEvent) : void {
			switch(event.level) {
				case "status":
					break;
				case "error":
					break;
			}
		}

		public function LocalAppender() {
			init();	
		}

		override public function append(data : LoggingData) : void {
			var message : String = _formatter.format(data);
			var color : uint = _formatter.getColor(data.level.name);
			_lc.send("Logger_" + this._id, "log", message, color);
		}
	}
}