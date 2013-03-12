package Fight.Model 
{
	import Fight.Character.MapHero;
	import Fight.Character.MapMonsterBase;
	/**
	 * ...
	 * @author ZWQ
	 * 战斗地图数据
	 */
	public class MapModel 
	{
		//地图上的英雄角色
		public var m_mapHeros : Vector.<MapHero> = new Vector.<MapHero>();
		//地图上的怪物角色
		public var m_mapMonster : Vector.<MapMonsterBase> = new Vector.<MapMonsterBase>();
		//地图id
		private var mapid : int = 0;
		
		public function MapModel() 
		{
			
		}
		
	}

}