package com.ui.manager 
{
	import BZTC.framework.CallBackFuntion;
	import com.ui.controls.Alert;
	import flash.events.Event;
	import com.net.LibData;
	import com.ui.containers.Panel;
	import com.net.RESManager;
	import com.ui.monitor.LoadMonitor;
	import flash.display.Sprite;
	import flash.events.ErrorEvent;	
	
	/**
	 * ...
	 * @author lizzardchen
	 */
	public class UIPanelRes 
	{
		protected var _PanelName : String;
		protected var _PanelType  : Class;
		protected var _panel : Panel;
		protected var _libArry : Array;
		protected var _loadMonitor : LoadMonitor;
		protected var _parent : Sprite;
		protected var _LoadCompleteCallback : Function;
		private var _args : String;
		public function UIPanelRes(libArry : Array,paneltype : Class,parent : Sprite,loadmonitor : LoadMonitor) 
		{
			_libArry = libArry;
			_PanelType = paneltype;
			_loadMonitor = loadmonitor;
			if ( parent != null )
			{
				_parent = UIManager.root;
			}
		}
		
		public function IsShow():Boolean
		{
			if ( _panel == null )
			{
				return false;
			}
			if ( _panel.parent == null )
			{
				return false;
			}
			return true;
		}
		
		public function UnLoadPanel():void
		{
			_panel = null;
		}
		
		public function get panel() : Panel
		{
			if ( _panel != null )
			{
				return _panel;
			}
			else
			{
				if (IsNeedLoad())
				{	
					//Load();
					return null;
				}
				else
				{
					_panel = new _PanelType(_parent);
				}
			}
			return _panel;
		}
		
		public function SetLoadCallBack(calback : Function,arg : String):void
		{
			_LoadCompleteCallback = calback;
			_args = arg;
		}
		public function LoadArry():Array
		{
			return _libArry;
		}
		public function IsNeedLoad() : Boolean
		{
			var bneedload : Boolean = false;
			for each( var libdata : LibData in _libArry )
			{
				if ( libdata == null ) 
				{
					bneedload = true;
					break;
				}
				if (!RESManager.IsLoaded( libdata.key ) )
				{
					return true;
				}
			}
			return bneedload;
		}
	}

}