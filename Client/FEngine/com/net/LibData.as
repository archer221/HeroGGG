package com.net {
	import com.utils.GStringUtil;

	/**
	 * @version 20090712
	 * @author Cafe
	 */
	public class LibData {

		protected var _url : String;

		protected var _key : String;
		
		protected var _type : String;
		
		protected var _seria : int;

		protected var _version : String;

		public function LibData(url : String,key : String = null,stype : String="swf", seria : int = 1, version : String = null) {
			_url = url.toLowerCase();
			if(key == null) {
				var separator : String = (url.indexOf("/") > -1) ? "/" : "\\";
				_key = _url.split(separator).pop().split(".").shift();
			}
			else _key = key;
			
			_type = stype;
			
			_seria = seria;
			
			_version = (version == null ? String(Math.random()) : version);
		}

		public function get url() : String {
			return _url;
		}

		public function get key() : String {
			return _key;
		}

		public function get version() : String {
			return _version;
		}
		
		public function get type():String 
		{
			return _type;
		}
		
		private var versionidx : int = 0;
		public function AddVersion()
		{
			versionidx++;
			_version += versionidx;
		}
		
		public function get seria() : int
		{
			return _seria;
		}
		public function set seria(tidx : int) :void
		{
			_seria = tidx;
		}
		public function get Loader():ALoader
		{
			if ( _type == "swf" )
			{
				return new SWFLoader(this);
			}
			else if ( _type == "xml" )
			{
				return new XMLLoader(this);
			}
			else if ( _type == "mp3" )
			{
				return new MP3Loader(this);
			}
			else if ( _type == "png" )
			{
				return new PNGLoader(this);
			}
			return null;
		}
	}
}
