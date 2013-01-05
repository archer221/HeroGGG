package com.ui.mediator 
{
	import com.net.RESManager;
	import com.ui.containers.Panel;
	import com.ui.core.Align;
	import com.ui.layout.GLayout;
	import com.ui.manager.CallBackFuntion;
	import flash.display.Sprite;
	import framework.BztcModel;
	import framework.LoadTypeEnum;
	/**
	 * ...
	 * @author ...
	 */
	public class IMediator 
	{
		protected var _parent : Sprite;
		protected var _bloadOK : Boolean = false;
		public function IMediator()
		{
			
		}
		public function IsShow():Boolean
		{
			if ( mypanel != null )
			{
				return (mypanel.parent != null);
			}
			return false;
		}
		public function parent():Sprite
		{
			return _parent;
		}
		protected function get mypanel():Panel
		{
			return null;
		}
		protected function set mypanel(value : Panel):void
		{
			
		}
		public function get MyPanelType():Class
		{
			return Panel;
		}
		public function Show(parent : Sprite):void
		{
			_bloadOK = false;
			if ( MyPanelType == Panel ) return;
			_parent = parent;
			var parmary : Array = new Array();
			parmary.push(parent);
			var notloadAry : Array = RESManager.instance.CheckLoad( MyPanelType.libkeys );
			if ( notloadAry.length > 0 )
			{
				BztcModel.Instance.StartLoading(notloadAry, LoadTypeEnum.WindScreenSuspendLoad, new CallBackFuntion(OnWindowLoadOK, this,parmary ));	
			}
			else
			{
				OnWindowLoadOK(parmary);
			}
			
		}
		protected function OnWindowLoadOK(ary : Array):void
		{
			_bloadOK = true;
			if ( mypanel == null )
			{
				mypanel = new MyPanelType(ary[0]);
			}
			mypanel._base.parent = ary[0];
			mypanel.hide();
			mypanel.align = Align.CENTER;
			mypanel.show();
			GLayout.layout(mypanel);
		}
		public function Hide():void
		{
			if ( mypanel != null )
			{
				mypanel.hide();
			}
		}
		
		public function update(elapsetime : int):void
		{
			
		}
	}

}