package com.net 
{
	import com.model.Map;
	/**
	 * ...
	 * @author ...
	 */
	public class LibsManager 
	{
		public static var libskey : String = "libs";
		public static var libsvalue : String = "conf/libs.xml";
		public static var curVersion : String = "201301011400";
		public static var Instance : LibsManager = new LibsManager();
		private var libxml : XML;
		
		public function LibsManager() 
		{
			
		}
		private var libsMap : Map = new Map();
		
		public function LoadLibs():void
		{
			libxml = RESManager.getXML(LibsManager.libskey);
			var libData : LibData;
			for each(var item:XML in libxml.*) {
				libData = new LibData(item.@url, item.@key, item.@type , item.@seria, item.@version);
				if( libData.key != libskey )
				{
					libsMap.put(libData.key, libData);
				}
			}
		}
		public function ChangeLoadIdxFromTo( ifrom : int, ito : int ):void
		{
			for each( var libdata : LibData in libsMap.values )
			{
				if ( libdata.seria == ifrom )
				{
					libdata.seria = ito;
				}
			}
		}
		public function GetLoadArryByIdx(idx : int):Array
		{
			var ret : Array = new Array();
			for each( var libdata : LibData in libsMap.values )
			{
				if (libdata.seria == idx)
				{
					ret.push(libdata);
				}
			}
			return ret;
		}
		
		public function GetLibData( key : String ):LibData
		{
			return libsMap.getBy(key);
		}
		
		public function MakeLibLoadIndex( key : String , idx : int):void
		{
			var libdata : LibData = GetLibData(key);
			libdata.seria = idx;
		}
		////////////////////////////////////////////some lib///////////////////////////////////////////////
		private var _uicommon : LibData;
		public function get uicommon():LibData
		{
			if ( _uicommon == null )
			{
				_uicommon = GetLibData("uicommon");
			}
			return _uicommon;
		}
		
		private var _themeLib : LibData;
		public function get themeLib():LibData
		{
			if ( _themeLib == null )
			{
				_themeLib = GetLibData("theme");
			}
			return _themeLib;
		}
		
		private var _skinLib : LibData;
		public function get skinLib():LibData
		{
			if ( _skinLib == null )
			{
				_skinLib = GetLibData("skin");
			}
			return _skinLib;
		}
		
		private var _taskGuardLib:LibData;
		public function get taskGuardLib():LibData
		{
			if ( _taskGuardLib == null )
			{
				_taskGuardLib = GetLibData("TaskGuardXML");
			}
			return _taskGuardLib;
		}
		
		private var _iconassets:LibData;
		public function get iconassets():LibData
		{
			if ( _iconassets == null )
			{
				_iconassets = GetLibData("iconassets");
			}
			return _iconassets;
		}
		
		private var _fightcommon:LibData;
		public function get fightcommon():LibData
		{
			if ( _fightcommon == null )
			{
				_fightcommon = GetLibData("fightcommon");
			}
			return _fightcommon;
		}
		
		private var _tutoriallib : LibData;
		public function get tutoriallib():LibData
		{
			if ( _tutoriallib == null )
			{
				_tutoriallib = GetLibData("tutorial");
			}
			return _tutoriallib;
		}
		private var _taskScenellib : LibData;
		public function get taskScenelib():LibData
		{
			if ( _taskScenellib == null )
			{
				_taskScenellib = GetLibData("taskscene");
			}
			return _taskScenellib;
		}
		private var _fightlib : LibData;
		public function get fightlib():LibData
		{
			if ( _fightlib == null )
			{
				_fightlib = GetLibData("fight");
			}
			return _fightlib;
		}
		private var _avatarlib : LibData;
		public function get avatarlib():LibData
		{
			if ( _avatarlib == null )
			{
				_avatarlib = GetLibData("avatar_luosheng");
			}
			return _avatarlib;
		}
		private var _roomlib : LibData;
		public function get roomlib():LibData
		{
			if ( _roomlib == null )
			{
				_roomlib = GetLibData("room");
			}
			return _roomlib;
		}
		private var _createrolelib:LibData;
		public function get createrolelib():LibData
		{
			if ( _createrolelib == null )
			{
				_createrolelib = GetLibData("createrole");
			}
			return _createrolelib;
		}
		private var _chatlib:LibData;
		public function get chatlib():LibData
		{
			if ( _chatlib == null )
			{
				_chatlib = GetLibData("Chat");
			}
			return _chatlib;
		}
		private var _avatarxmllib : LibData;
		public function get avatarxmllib():LibData
		{
			if ( _avatarxmllib == null )
			{
				_avatarxmllib = GetLibData("avatarXML");
			}
			return _avatarxmllib;
		}
		private var _materialxmllib : LibData;
		public function get materialxmllib():LibData
		{
			if ( _materialxmllib == null )
			{
				_materialxmllib = GetLibData("MaterialXML");
			}
			return _materialxmllib;
		}
		private var _expressionxmllib:LibData;
		public function get expressionxmllib():LibData
		{
			if ( _expressionxmllib == null )
			{
				_expressionxmllib = GetLibData("ExpressionXML");
			}
			return _expressionxmllib;
		}
		private var _weaponlxmllib : LibData;
		public function get weaponlxmllib():LibData
		{
			if ( _weaponlxmllib == null )
			{
				_weaponlxmllib = GetLibData("weaponsXML");
			}
			return _weaponlxmllib;
		}
		private var _weaponparamxmllib : LibData;
		public function get weaponparamxmllib():LibData
		{
			if ( _weaponparamxmllib == null )
			{
				_weaponparamxmllib = GetLibData("weaponParamXML");
			}
			return _weaponparamxmllib;
		}
		private var _gemxmllib : LibData;
		public function get gemxmllib():LibData
		{
			if ( _gemxmllib == null )
			{
				_gemxmllib = GetLibData("GemsXML");
			}
			return _gemxmllib;
		}		
		private var _normalitemxmllib: LibData;
		public function get normalitemxmllib():LibData
		{
			if ( _normalitemxmllib == null )
			{
				_normalitemxmllib = GetLibData("NormalItemXML");
			}
			return _normalitemxmllib;
		}	
		private var _actionFrameXML : LibData;
		public function get actionFrameXML():LibData
		{
			if ( _actionFrameXML == null )
			{
				_actionFrameXML = GetLibData("actionframeXML");
			}
			return _actionFrameXML;
		}	
		private var _roletypeXMLLib : LibData;
		public function get roletypeXMLLib():LibData
		{
			if ( _roletypeXMLLib == null )
			{
				_roletypeXMLLib = GetLibData("roletypeXML");
			}
			return _roletypeXMLLib;
		}
		private var _actionXML : LibData;
		public function get actionXML():LibData
		{
			if ( _actionXML == null )
			{
				_actionXML = GetLibData("actiontableXML");
			}
			return _actionXML;
		}
		
		private var _taskGroupsXMLLib:LibData;
		public function get taskGroupsXML():LibData
		{
			if ( null == _taskGroupsXMLLib )
			{
				_taskGroupsXMLLib = GetLibData("TaskGroupsXML");
			}
			return _taskGroupsXMLLib;
		}
		
		private var _roleparamXMLLib : LibData;
		public function get roleparamXMLLib():LibData
		{
			if ( _roleparamXMLLib == null )
			{
				_roleparamXMLLib = GetLibData("roleparamXML");
			}
			return _roleparamXMLLib;
		}		
		private var _physicLib : LibData;
		public function get physicLib():LibData
		{
			if ( _physicLib == null )
			{
				_physicLib = GetLibData("physicXML");
			}
			return _physicLib;
		}		
		private var _maskWordLib : LibData;
		public function get maskWordLib():LibData
		{
			if ( _maskWordLib == null )
			{
				_maskWordLib = GetLibData("MaskWordXML");
			}
			return _maskWordLib;
		}
		private var _roleLevelLib : LibData;
		public function get roleLevelLib():LibData
		{
			if ( _roleLevelLib == null )
			{
				_roleLevelLib = GetLibData("RoleLevelXML");
			}
			return _roleLevelLib;
		}		
		
		private var _themeMapXml : LibData;
		public function get themeMapXml():LibData
		{
			if ( _themeMapXml == null )
			{
				_themeMapXml = GetLibData("thememapXML");
			}
			return _themeMapXml;
		}
		
		private var _sceneObjXml : LibData;
		public function get sceneObjXml():LibData
		{
			if ( _sceneObjXml == null )
			{
				_sceneObjXml = GetLibData("sceneObjXML");
			}
			return _sceneObjXml;
		}
		
		private var _effectXml : LibData;
		public function get effectXml():LibData
		{
			if ( _effectXml == null )
			{
				_effectXml = GetLibData("effectConfigXML");
			}
			return _effectXml;
		}
		
		private var _fightMapXMLLib : LibData;
		public function get fightMapXMLLib():LibData
		{
			if ( _fightMapXMLLib == null )
			{
				_fightMapXMLLib = GetLibData("fightmapXML");
			}
			return _fightMapXMLLib;
		}
		
		private var _useTipsXMLLib : LibData;
		public function get useTipsXMLLib():LibData
		{
			if ( _useTipsXMLLib == null )
			{
				_useTipsXMLLib = GetLibData("usetipsXML");
			}
			return _useTipsXMLLib;
		}
		
		private var _AIActionLib : LibData;
		public function get AIActionLib():LibData
		{
			if ( _AIActionLib == null )
			{
				_AIActionLib = GetLibData("AIActionType");
			}
			return _AIActionLib;
		}
		private var _AIMonsterLib : LibData;
		public function get AIMonsterLib():LibData
		{
			if ( _AIMonsterLib == null )
			{
				_AIMonsterLib = GetLibData("AIMonster");
			}
			return _AIMonsterLib;
		}
		private var _effectConfigLib : LibData;
		public function get effectConfigLib():LibData
		{
			if ( _effectConfigLib == null )
			{
				_effectConfigLib = GetLibData("effectConfigXML");
			}
			return _effectConfigLib;
		}
		
		private var _sceneObject : LibData;
		public function get SceneObject():LibData
		{
			if ( _sceneObject == null )
			{
				_sceneObject = GetLibData("sceneobject");
			}
			return _sceneObject;
		}
		
		
		private var _addAttackLib : LibData;
		public function get AddAttackLib() : LibData
		{
			if (_addAttackLib == null)
			{
				_addAttackLib = GetLibData("IntensifyAddAttack");
			}
			return _addAttackLib;
		}
		
		private var _addCriDamageLib : LibData;
		public function get AddCriDamageLib() : LibData
		{
			if (_addCriDamageLib == null)
			{
				_addCriDamageLib = GetLibData("IntensifyAddCriDamage");
			}
			return _addCriDamageLib;
		}
		
		private var _addCriDefenceLib : LibData;
		public function get AddCriDefenceLib() : LibData
		{
			if (_addCriDefenceLib == null)
			{
				_addCriDefenceLib = GetLibData("IntensifyAddCriDefence");
			}
			return _addCriDefenceLib;
		}
		
		private var _addCriticalLib : LibData;
		public function get AddCriticalLib() : LibData
		{
			if (_addCriticalLib == null)
			{
				_addCriticalLib = GetLibData("IntensifyAddCritical");
			}
			return _addCriticalLib;
		}
		
		private var _addDefenceLib : LibData;
		public function get AddDefenceLib() : LibData
		{
			if (_addDefenceLib == null)
			{
				_addDefenceLib = GetLibData("IntensifyAddDefence");
			}
			return _addDefenceLib;
		}
		
		private var _addDropDefenceLib : LibData;
		public function get AddDropDefenceLib() : LibData
		{
			if (_addDropDefenceLib == null)
			{
				_addDropDefenceLib = GetLibData("IntensifyAddDropDefence");
			}
			return _addDropDefenceLib;
		}
		
		private var _addFightAttackLib : LibData;
		public function get AddFightAttackLib() : LibData
		{
			if (_addFightAttackLib == null)
			{
				_addFightAttackLib = GetLibData("IntensifyAddFightAttack");
			}
			return _addFightAttackLib;
		}
		
		private var _addFightFlyLib : LibData;
		public function get AddFightFlyLib() : LibData
		{
			if (_addFightFlyLib == null)
			{
				_addFightFlyLib = GetLibData("IntenifyAddFightFly");
			}
			return _addFightFlyLib;
		}
		
		private var _addFirstHandLib : LibData;
		public function get AddFirstHandLib() : LibData
		{
			if (_addFirstHandLib == null)
			{
				_addFirstHandLib = GetLibData("IntensifyAddFirstHand");
			}
			return _addFirstHandLib;
		}
		
		private var _addFlyLib : LibData;
		public function get AddFlyLib() : LibData
		{
			if (_addFlyLib == null)
			{
				_addFlyLib = GetLibData("IntensifyAddFly");
			}
			return _addFlyLib;
		}
		
		private var _addFlyDefenceLib : LibData;
		public function get AddFlyDefenceLib() : LibData
		{
			if (_addFlyDefenceLib == null)
			{
				_addFlyDefenceLib = GetLibData("IntensifyAddFlyDefence");
			}
			return _addFlyDefenceLib;
		}
		
		private var _addHpLib : LibData;
		public function get AddHpLib() : LibData
		{
			if (_addHpLib == null)
			{
				_addHpLib = GetLibData("IntensifyAddHp");
			}
			return _addHpLib;
		}
		
		private var _shoplib : LibData;
		public function get ShopLib():LibData
		{
			if (_shoplib == null)
			{
				_shoplib = GetLibData("Shop");
			}
			return _shoplib;
		}
		
		
		private var _sceneTemplateLib : LibData;
		public function get SceneTemplateLib():LibData
		{
			if (_sceneTemplateLib == null)
			{
				_sceneTemplateLib = GetLibData("SceneTemplate");
			}
			return _sceneTemplateLib;
		}
		///////////////////////////////////////////////////////////////////////////////////////////////////
	}

}
