package Fight.SceneConfig 
{
	import com.model.Map;
	/**
	 * ...
	 * @author ZWQ
	 */
	public class SceneTemplate 
	{
		public var ID : int;
		public var Name : String;
		public var Desc : String;
		public var Lib : String;
		public var BackGroundKey : String;
		public var SceneBtns : Vector.<SceneMapBtn> = new Vector.<SceneMapBtn>();
		public var SceneMaps : Map = new Map();
		public function SceneTemplate() 
		{
			
		}
		
	}

}