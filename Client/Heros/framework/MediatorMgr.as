package framework 
{
		import flash.utils.getQualifiedClassName;
		import com.model.Map;
		import com.ui.mediator.IMediator;
		import flash.system.ApplicationDomain;
	/**
	 * ...
	 * @author ...
	 */
	public class MediatorMgr 
	{
		public static var Instance : MediatorMgr = new MediatorMgr();

		private var mediatorMap : Map = new Map();
		
		public function MediatorMgr() 
		{
		}
		
		public function Init():void
		{
			
		}
		
		public function HideAll():void
		{
			for each( var imediator : IMediator in mediatorMap.values)
			{
				if( imediator.IsShow() )
					imediator.Hide();
			}
		}
		
		public function update(elpasetime : int):void
		{
			for each( var imediator : IMediator in mediatorMap.values)
			{
				if( imediator.IsShow() )
					imediator.update(elpasetime);
			}
		}
	}

}