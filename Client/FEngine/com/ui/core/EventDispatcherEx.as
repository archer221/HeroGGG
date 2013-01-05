package com.ui.core 
{
	import com.model.Map;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.getQualifiedClassName;
	
	/**
	 * ...
	 * @author lizzardchen
	 */
	public class EventDispatcherEx extends EventDispatcher 
	{
		
		public function EventDispatcherEx(target:IEventDispatcher = null) 
		{
			super(target);
		}
		
		protected var _parent : Object;
		
		protected var AlistenMap : Map = new Map(); //自身作为事件发起者的一个Map，比如A.addeventlistener(b.f),A.addeventlistener(c.f),A.addevetlistener(d.f);
		protected var BTargetMap :Vector.<EventTargetCollect> = new Vector.<EventTargetCollect>(); //自身作为事件监听者的一个Map，比如A.addeventlistener(b.f1),C.addeventlistener(b.f2),D.addeventlistener(b.f3);,
		
		public function SetParent( obj : Object ):void
		{
			_parent = obj;
		}
		
		public function AddEventListenerEx( e : String, b : Object, fun : Function )
		{
			if ( AlistenMap.containsKey( b ) )
			{
				var eventvector : Vector.<EventTargetCollect> = AlistenMap.getBy(b);
				var havethis : Boolean = false;
				for each( var etarget : EventTargetCollect in eventvector )
				{
					if ( etarget.etype == e && etarget.alistener == b && etarget.func == fun )
					{
						havethis = true;
						break;
					}
				}
				if ( !havethis )
				{
					eventvector.push( new EventTargetCollect(e, b, fun) );	
				}
			}
			else
			{
				var eventvector : Vector.<EventTargetCollect> = new Vector.<EventTargetCollect>();
				eventvector.push(new EventTargetCollect(e, b, fun));
				AlistenMap.put(b, eventvector);
			}
			
			if ( _parent != null )
			{
				var uilistener : UIComponent = _parent as UIComponent;
				if ( uilistener != null )
				{
					uilistener.addEventListener(e, fun);
				}
			}
			else
			{
				this.addEventListener(e, fun);	
			}
			
			var btarget : EventDispatcherEx = b as EventDispatcherEx;
			if ( btarget != null )
			{
				if ( _parent != null )
				{
					btarget.AddTargetListener(e, _parent, fun);
				}
				else
				{
					btarget.AddTargetListener(e, this, fun);
				}
			}
			else if ( (b as UIComponent) != null)
			{
				var buitarget : UIComponent = b as UIComponent;
				if ( _parent != null )
				{
					buitarget.AddTargetListener(e, _parent, fun);	
				}
				else
				{
					buitarget.AddTargetListener(e, this, fun);	
				}
				
			}
		}
		public function AddTargetListener( e : String, alistener : Object, fun : Function)
		{
			var fndtarget : Boolean = false;
			for each( var etart : EventTargetCollect in BTargetMap )
			{
				if ( etart.etype == e && etart.alistener == alistener && etart.func == fun )
				{
					fndtarget = true;
					break;
				}
			}
			if ( !fndtarget && BTargetMap != null)
			{
				BTargetMap.push(new EventTargetCollect(e,alistener, fun));	
			}
			
		}
		
		public function RemoveEventListenerEx(e : String , b : Object,func : Function)
		{
			if ( _parent != null )
			{
				var uitarget : UIComponent = _parent as UIComponent;
				if ( uitarget != null )
				{
					uitarget.removeEventListener(e, func);
				}
			}
			else
			{
				removeEventListener(e, func);
			}
			if ( AlistenMap.containsKey(b) )
			{
				var eventvector : Vector.<EventTargetCollect> = AlistenMap.getBy(b);
				var havethis : Boolean = false;
				var fndidx : int = -1;
				for each( var etarget : EventTargetCollect in eventvector )
				{
					fndidx++;
					if ( etarget.etype == e && etarget.alistener == b && etarget.func == func )
					{
						havethis = true;
						break;
					}
				}
				if( havethis )
				{
					eventvector.splice(fndidx, 1);
				}
			}
		}
		
		public function ClearEvent( obj : Object )
		{

			if ( AlistenMap.containsKey(obj) )
			{
				AlistenMap.removeBy(obj);
			}
			
			for each( var eventtarget : EventTargetCollect in BTargetMap )
			{
				if ( eventtarget.alistener != null && eventtarget.alistener == obj)
				{
					var thistarget : EventDispatcherEx = eventtarget.alistener as EventDispatcherEx;
					if ( thistarget != null )
					{
						if ( _parent == null )
						{
							thistarget.RemoveEventListenerEx(eventtarget.etype,this,eventtarget.func);
						}
						else
						{
							thistarget.RemoveEventListenerEx(eventtarget.etype,_parent,eventtarget.func);
						}
						
					}
					else
					{
						var uitarget : UIComponent = eventtarget.alistener as UIComponent;
						if ( uitarget != null )
						{
							if ( _parent == null )
							{
								uitarget.RemoveEventListenerEx(eventtarget.etype,this,eventtarget.func);
							}
							else
							{
								uitarget.RemoveEventListenerEx(eventtarget.etype,_parent,eventtarget.func);
							}
							
						}
					}
				}
			}
		}
		public function ClearEvents()
		{
			for each( var eventtarget : EventTargetCollect in BTargetMap )
			{
				var alistendispatcher : EventDispatcherEx = eventtarget.alistener as EventDispatcherEx;
				if (alistendispatcher != null)
				{
					if ( _parent == null )
					{
						alistendispatcher.RemoveEventListenerEx(eventtarget.etype,this,eventtarget.func);
						alistendispatcher.ClearEvent(this);
					}
					else
					{
						alistendispatcher.RemoveEventListenerEx(eventtarget.etype,_parent,eventtarget.func);
						alistendispatcher.ClearEvent(_parent);
					}
					
				}
				else
				{
					var uitarget : UIComponent = eventtarget.alistener as UIComponent;
					if ( uitarget != null )
					{
						if ( _parent == null )
						{
							uitarget.RemoveEventListenerEx(eventtarget.etype,this,eventtarget.func);
							uitarget.ClearEvent(this);
						}
						else
						{
							uitarget.RemoveEventListenerEx(eventtarget.etype,_parent,eventtarget.func);
							uitarget.ClearEvent(_parent);
						}
						
					}
				}
			}
			for each( var eventtargetList : Vector.<EventTargetCollect> in AlistenMap.values )
			{
				for each( var eventtarget : EventTargetCollect in eventtargetList )
				{
					var btarget : EventDispatcherEx = eventtarget.alistener as EventDispatcherEx;
					if ( btarget != null )
					{
						if ( _parent == null )
						{
							removeEventListener(eventtarget.etype, eventtarget.func);
							btarget.ClearEvent(this);
						}
						else
						{
							var uitarget : UIComponent = _parent as UIComponent;
							if ( uitarget != null )
							{
								uitarget.removeEventListener(eventtarget.etype, eventtarget.func);
							}
							btarget.ClearEvent(_parent);
						}
					}
					else
					{
						var buitarget : UIComponent = eventtarget.alistener as UIComponent;
						if (buitarget != null)
						{
							//buitarget.RemoveEventListenerEx(eventtarget.etype,eventtarget.alistener,eventtarget.func);
							if ( _parent == null )
							{
								removeEventListener(eventtarget.etype, eventtarget.func);
								buitarget.ClearEvent(this);
							}
							else
							{
								var uitarget : UIComponent = _parent as UIComponent;
								if ( uitarget != null )
								{
									uitarget.removeEventListener(eventtarget.etype, eventtarget.func);
								}
								buitarget.ClearEvent(_parent);
							}
						}
					}
				}
				
			}
			var btalenth : int = BTargetMap.length;
			if ( btalenth > 0 )
			{
				BTargetMap.splice(0,btalenth);	
			}
			
			AlistenMap.clear();
		}
	}

}