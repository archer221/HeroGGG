package Fight.View
{
	import com.ui.containers.Panel;
	import com.ui.IMediator;

	public class InstFightMediator extends IMediator
	{
		private var sceneview : SceneView;
		public function InstFightMediator()
		{
		}
		
		
		override public function get MyPanelType():Class
		{
			// TODO Auto Generated method stub
			return SceneView;
		}
		
		override protected function get mypanel():Panel
		{
			// TODO Auto Generated method stub
			return sceneview;
		}
		
		override protected function set mypanel(value:Panel):void
		{
			// TODO Auto Generated method stub
			super.mypanel = value;
		}
		
	}
}