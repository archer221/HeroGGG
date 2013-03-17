package framework 
{
	import com.EngFrameWork.EngObserver.Notification;
	import com.frame.ExactTimer;
	import com.frame.FrameTimer;
	import com.frame.IFrame;
	import com.model.Map;
	import com.project.Game;
	import com.ui.core.EventDispatcherEx;
	
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.utils.getTimer;

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
		public function SendNotification(note :Notification) :void
		{
			logicCmdList.push(note);
		}
		public function RegisterExceptCmd(scmd : String, cmdhandler : BSimpleCmd):void
		{
			ExceptMap.put(scmd, cmdhandler);
		}
		
		public function RegisterCommad(scmd : String,cmd :ICommand):void
		{
			var ary :Array = ListenerMap.getBy(scmd) as Array;
			if ( ary != null )
			{
				var needdelary : Array = new Array();
				for each( var cmdhand : ICommand in ary )
				{
					if ( cmdhand._owner == cmd._owner )
					{
						needdelary.push(cmdhand);
					}
				}
				for each(var cmdhand : ICommand in needdelary)
				{
					var idx : int = ary.indexOf(cmdhand);
					if ( idx != -1 )
					{
						ary.splice(idx, 1);
					}
				}
				ary.push(cmd);
			}
			else {
				ary = new Array();
				ary.push(cmd);
				ListenerMap.put(scmd, ary);
			}
			
		}
		public function UnReigisterCmd(scmd : String,obj : Object):void
		{
			var ary :Array = ListenerMap.getBy(scmd) as Array;
			if ( ary != null )
			{
				var needdelary : Array = new Array();
				for each( var cmdhand : BSimpleCmd in ary )
				{
					if ( cmdhand.Obj == obj )
					{
						needdelary.push(cmdhand);
					}
				}
				for each(var cmdhand : BSimpleCmd in needdelary)
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
			BztcViewer.instance.Update();
			var elapsetime : int = 0;
			var note :Notification = null;
			while ( elapsetime < delayTime && logicCmdList.length > 0 )
			{
				var inow : int = getTimer();
				note = logicCmdList.shift();
				//if ( note != null )
				//{
					//trace(note.scmd);
					//if ( note.scmd == EventEnum.load_startLoading && bNeedSuspend)
					//{
						//_bsuspend = true;
					//}
					//if ( note.scmd == EventEnum.load_Completed && bNeedSuspend)
					//{
						//_bsuspend = false;
					//}
				//}
				if ( ExceptMap.containsKey(note.getName()) )
				{
					var handler : BSimpleCmd = ExceptMap.getBy(note.getName());
					var bresult : int = handler.Exec(note);
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
							SendNotification(new Notification(EventEnum.SystemStopSuspend));
							elapsetime += (getTimer() - inow);
							break;
						}
					case FKPPInfoCode.SystemWaitSuspend:
						{
							SendNotification(note);
							return;
						}
					case FKPPInfoCode.SystemIgnoreSuspend:
					default:
						{
							break;
						}
					}
				}

				var ary :Array = ListenerMap.getBy(note.getName()) as Array;
				if ( ary != null && ary.length > 0 )
				{
					for each( var cmdhandler : ICommand in ary )
					{
						cmdhandler.Exec(note);
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
			//village
			//BztcFacade.Instance.AddExceptCmdListener(EventEnum.server_EnterVillage, new BCmdHandler(this, OnExceptionCmdHandlerWait));
			//load
			BztcFacade.Instance.RegisterExceptCmd(EventEnum.load_Wait, new BSimpleCmd(this, OnExceptionCmdHandlerWait));
		}
		///////////////////////////////////Exception Handler////////////////////////////////////////
		public function OnExceptionCmdHandlerWait(note :Notification):int
		{
			if ( BztcFacade.Instance.Suspended )
			{
				return FKPPInfoCode.SystemWaitSuspend;
			}
			return FKPPInfoCode.SystemIgnoreSuspend;
		}
		public function OnExceptionCmdHandlerSkip(cmd : ICommand):int
		{
			if ( BztcFacade.Instance.Suspended )
			{
				return FKPPInfoCode.SystemSkipEvent;
			}
			return FKPPInfoCode.SystemIgnoreSuspend;	
		}
		public function OnExceptionCmdHandlerStop(cmd : ICommand):int
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