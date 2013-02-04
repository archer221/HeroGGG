package Fight.SceneConfig 
{
	import com.model.Map;
	import com.net.LibsManager;
	import com.net.RESManager;
	/**
	 * ...
	 * @author ZWQ
	 */
	public class SceneTemplateContainer extends Map
	{
		public static const Instance : SceneTemplateContainer = new SceneTemplateContainer();
		
		public function SceneTemplateContainer() 
		{
			
		}
		
		public function ParseXML() : void
		{
			var xm : XML = RESManager.getXML(LibsManager.Instance.SceneTemplateLib.key);
			var sceneTemplate : SceneTemplate;
			for each(var scenexml : XML in xml.*)
			{
				sceneTemplate = ParseOneScene(scenexml);
				this.put(sceneTemplate.ID, sceneTemplate);
			}
		}
		
		public function ParseOneScene(xml : XML) : SceneTemplate
		{
			var sceneTemplate : SceneTemplate = new SceneTemplate();
			sceneTemplate.ID = xml.@ID;
			sceneTemplate.Name = xml.@Name;
			sceneTemplate.Desc = xml.@Desc;
			sceneTemplate.Lib = xml.@Lib;
			sceneTemplate.BackGroundKey = xml.@BackGroundKey;
			var scenebtn : SceneMapBtn;
			for each(var scenebtnxml : XML in xml.SceneBtns.*)
			{
				scenebtn = new SceneMapBtn();
				scenebtn.X = scenebtnxml.@X;
				scenebtn.Y = scenebtnxml.@Y;
				scenebtn.BtnDownKey = scenebtnxml.@BtnDownKey;
				scenebtn.BtnUpKey = scenebtnxml.@BtnUpKey;
				scenebtn.BtnOverKey = scenebtnxml.@BtnOverKey;
				scenebtn.MapID = scenebtnxml.@MapID;
				scenebtn.SceneID = sceneTemplate.ID;
				sceneTemplate.SceneBtns.push(scenebtn);
			}
			var maptemplate : MapTemplate;
			for each(var mapxml : XML in xml.Maps.*)
			{
				maptemplate = new MapTemplate();
				maptemplate.ID = mapxml.@ID;
				maptemplate.MapLib = mapxml.@MapLib;
				maptemplate.LeftBackGroundKey = mapxml.@LeftBackGroundKey;
				maptemplate.RightBackGroundKey = mapxml.@RightBackGroundKey;
				maptemplate.Name = mapxml.@Name;
				maptemplate.Desc = mapxml.@Desc;
				maptemplate.Brick = mapxml.@Brick;
				maptemplate.Height = mapxml.@Height;
				maptemplate.Type = mapxml.@Type;
				maptemplate.VictoryKey = mapxml.@VictoryKey;
				maptemplate.VictoryY = mapxml.@VictoryY;
				maptemplate.Award.HeroPoint = mapxml.Award.@HeroPoint;
				maptemplate.Award.Gold = mapxml.Award.@Gold;
				for each(var bricklayerxml : XML in mapxml.BrickLayers.*)
				{
					var bricklayer : String = bricklayerxml.@Key;
					maptemplate.BrickLayers.push(bricklayer);
				}
				var mapmonster : MapMonster;
				for each(var monsterxml : XML in mapxml.Monsters.*)
				{
					mapmonster = new MapMonster();
					mapmonster.X = monsterxml.@X;
					mapmonster.Y = monsterxml.@Y;
					mapmonster.MonsterId = monsterxml.@MonsterId;
					maptemplate.Monsters.push(mapmonster);
				}
				sceneTemplate.SceneMaps.put(maptemplate.ID, maptemplate);
			}
			return sceneTemplate;
		}
		
	}

}