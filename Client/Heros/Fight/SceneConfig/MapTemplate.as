package Fight.SceneConfig 
{
	/**
	 * ...
	 * @author ZWQ
	 */
	public class MapTemplate 
	{
		public var ID : int;
		public var Name : String;
		public var Desc : String;
		public var MapLib : String;
		public var LeftBackGroundKey : String;
		public var RightBackGroundKey : String;
		public var Brick : String;
		public var Height : int;
		public var Type : int;
		public var VictoryY : int;
		public var VictoryKey : String;
		public var Award : MapAward = new MapAward();
		public var BrickLayers : Vector.<String> = new Vector.<String>();				//砖块的花纹层
		public var Monsters : Vector.<MapMonster> = new Vector.<MapMonster>();		//地图上的怪物
		public function MapTemplate() 
		{
			
		}
		
	}

}