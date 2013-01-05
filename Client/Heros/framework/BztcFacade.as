package framework 
{
	import com.frame.ExactTimer;
	import com.frame.FrameTimer;
	import com.frame.IFrame;
	import com.model.Map;
	import com.project.Game;
	import com.ui.core.EventDispatcherEx;
	import flash.utils.getTimer;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	/**
	 * ...
	 * @author ...
	 */
	public class BztcFacade implements IFrame
	{
		public static var Instance : BztcFacade = new BztcFacade();
		public static var delayTime : int = 60;
		private var _bsuspend : Boolean = false;
		public var bztcgame : HerosGame;
		public function BztcFacade() 
		{
			FrameTimer.add(this);
		}
		public function Init(tgame : Game):void
		{
			bztcgame = tgame as HerosGame;
			FKPPInfoCode.Init();
			InitEventListener();
			BztcViewer.instance.Init();
			BztcModel.Instance.Init();
		}
		private var logicCmdList : Array = new Array();
		private var ExceptMap : Map = new Map();
		private var ListenerMap : Map = new Map();
		public function AddCommand(cmd : BCommand) :void
		{
			logicCmdList.push(cmd);
		}
		public function AddExceptCmdListener(scmd : String, cmdhandler : BCmdHandler):void
		{
			ExceptMap.put(scmd, cmdhandler);
		}
		
		public function AddCmdListener(scmd : String,cmdHandler : BCmdHandler):void
		{
			var ary :Array = ListenerMap.getBy(scmd) as Array;
			if ( ary != null )
			{
				var needdelary : Array = new Array();
				for each( var cmdhand : BCmdHandler in ary )
				{
					if ( cmdhand.Obj == cmdHandler.Obj )
					{
						needdelary.push(cmdhand);
					}
				}
				for each(var cmdhand : BCmdHandler in needdelary)
				{
					var idx : int = ary.indexOf(cmdhand);
					if ( idx != -1 )
					{
						ary.splice(idx, 1);
					}
				}
				ary.push(cmdHandler);
			}
			else {
				ary = new Array();
				ary.push(cmdHandler);
				ListenerMap.put(scmd, ary);
			}
			
		}
		public function RemoveCmdListener(scmd : String,obj : Object):void
		{
			var ary :Array = ListenerMap.getBy(scmd) as Array;
			if ( ary != null )
			{
				var needdelary : Array = new Array();
				for each( var cmdhand : BCmdHandler in ary )
				{
					if ( cmdhand.Obj == obj )
					{
						needdelary.push(cmdhand);
					}
				}
				for each(var cmdhand : BCmdHandler in needdelary)
				{
					var idx : int = ary.indexOf(cmdhand);
					if ( idx != -1 )
					{
						ary.splice(idx, 1);
					}
				}
			}
		}
		
		private var lastupdatetime : int = 0;
		public function action() : void {
			var curtime = getTimer();
			if ( lastupdatetime == 0 )
			{
				lastupdatetime = curtime;
			}
			BztcModel.Instance.Update();
			var elapsetime : int = 0;
			var cmd : BCommand = null;
			while ( elapsetime < delayTime && logicCmdList.length > 0 )
			{
				var inow : int = getTimer();
				cmd = logicCmdList.shift();
				//if ( cmd != null )
				//{
					//trace(cmd.scmd);
					//if ( cmd.scmd == EventEnum.load_startLoading && bNeedSuspend)
					//{
						//_bsuspend = true;
					//}
					//if ( cmd.scmd == EventEnum.load_Completed && bNeedSuspend)
					//{
						//_bsuspend = false;
					//}
				//}
				if ( ExceptMap.containsKey(cmd.scmd) )
				{
					var handler : BCmdHandler = ExceptMap.getBy(cmd.scmd);
					var bresult : int = handler.Exec(cmd);
					switch( bresult )
					{
					case FKPPInfoCode.SystemSkipEvent:
						{
							elapsetime += (getTimer() - inow);
							return;
						}
					case FKPPInfoCode.SystemStopSuspend:
						{
							_bsuspend = false;
							AddCommand(new BCommand(EventEnum.SystemStopSuspend));
							elapsetime += (getTimer() - inow);
							break;
						}
					case FKPPInfoCode.SystemWaitSuspend:
						{
							AddCommand(cmd);
							return;
						}
					case FKPPInfoCode.SystemIgnoreSuspend:
					default:
						{
							break;
						}
					}
				}

				var ary :Array = ListenerMap.getBy(cmd.scmd) as Array;
				if ( ary != null && ary.length > 0 )
				{
					for each( var cmdhandler : BCmdHandler in ary )
					{
						cmdhandler.Exec(cmd);
					}
				}
				elapsetime += (getTimer() - inow);
			}
		}
		
		//Loading process
		public function get Suspended():Boolean
		{
			return _bsuspend;
		}
		public function set Suspended(value : Boolean):void
		{
			_bsuspend = value;
		}
		private var _bNeedSuspend : Boolean;
		public function get bNeedSuspend():Boolean
		{
			return _bNeedSuspend;
		}
		public function set bNeedSuspend(bneed : Boolean):void
		{
			_bNeedSuspend = bneed;
		}
		///////////////////////////////////Init Event Listener//////////////////////////////////////
		public function InitEventListener():void
		{
			//load
			BztcFacade.Instance.AddExceptCmdListener(EventEnum.load_Wait, new BCmdHandler(this, OnExceptionCmdHandlerWait));
		}
		///////////////////////////////////Exception Handler////////////////////////////////////////
		public function OnExceptionCmdHandlerWait(cmd :BCommand):int
		{
			if ( BztcFacade.Instance.Suspended )
			{
				return FKPPInfoCode.SystemWaitSuspend;
			}
			return FKPPInfoCode.SystemIgnoreSuspend;
		}
		public function OnExceptionCmdHandlerSkip(cmd : BCommand):int
		{
			if ( BztcFacade.Instance.Suspended )
			{
				return FKPPInfoCode.SystemSkipEvent;
			}
			return FKPPInfoCode.SystemIgnoreSuspend;	
		}
		public function OnExceptionCmdHandlerStop(cmd : BCommand):int
		{
			if ( BztcFacade.Instance.Suspended )
			{
				return FKPPInfoCode.SystemStopSuspend;
			}
			return FKPPInfoCode.SystemIgnoreSuspend;	
		}
		////////////////////////////////////////////////////////////////////////////////////////////
	}

}