package Collections
{
    import __AS3__.vec.Vector;
    import Communication.VO.collectibles.CollectionVO;
    import Communication.VO.collectibles.SpawnListVO;
    import flash.utils.Dictionary;
    import Communication.VO.collectibles.LootTableVO;
    import nLib.cXML;
    import Communication.VO.collectibles.BuffSpawnListVO;
    import Utils.StringUtils;
    import nLib.gMisc;
    import Communication.VO.collectibles.CollectionResourceDefinitionBuildingVO;
    import Communication.VO.collectibles.PickupVO;
    import Communication.VO.collectibles.CollectionResourceDefinitionVO;
    import Communication.VO.collectibles.CollectionResourceVO;
    import Communication.VO.collectibles.SpawnListZoneVO;
    import __AS3__.vec.*;

    public class CollectionsParser 
    {

        private static var NAME_ELEMENT_COLLECTIONS:String = "collections";
        private static var NAME_ELEMENT_LOOT_TABLES:String = "lootTables";
        private static var NAME_ELEMENT_SPAWN_LISTS:String = "spawnLists";
        private static var NAME_ELEMENT_IGNORE_GRID_LISTS:String = "ignoreGridLists";
        private static var NAME_ELEMENT_BUFF_LOOT_TABLES:String = "buffSpawnLists";
        private static var NAME_ELEMENT_RESOURCE_DEFINITIONS:String = "resourceDefinitions";
        private static var NAME_ELEMENT_SETTINGS:String = "settings";
        private static var NAME_COLLECTIONS_NAME:String = "name";
        private static var NAME_COLLECTIONS_PLAYER_LEVEL:String = "pLvl";
        private static var NAME_COLLECTIONS_OUTPUT_BUFF_NAME:String = "outBuffName";
        private static var NAME_COLLECTIONS_BLUEPRINT:String = "blueprint";
        private static var NAME_COLLECTIONS_PRODUCTION_TIME:String = "productionTime";
        private static var NAME_COLLECTIONS_OUTPUT_BUFF_RESOURCE_NAME:String = "outBuffResourceName";
        private static var NAME_COLLECTIONS_OUTPUT_BUFF_RESOURCE_AMOUNT:String = "outBuffResourceAmount";
        private static var NAME_COLLECTIONS_INSTANT_BUILD_COSTS:String = "InstantBuildCosts";
        private static var NAME_COLLECTIONS_SHOW_RESOURCE_ICON:String = "showResourceIcon";
        private static var NAME_COLLECTIONS_REQUIRES_EVENT:String = "requiresEvent";
        private static var NAME_COLLECTIONS_RESOURCE_NAME:String = "name";
        private static var NAME_COLLECTIONS_RESOURCE_AMOUNT:String = "amount";
        private static var NAME_LOOT_TABLE_NAME:String = "name";
        private static var NAME_LOOT_TABLE_RARITY:String = "rarity";
        private static var NAME_LOOT_TABLE_REQUIRES_EVENT:String = "requiresEvent";
        private static var NAME_PICKUPS_BUILDINGNAME:String = "buildingName";
        private static var NAME_PICKUPS_RESOURCENAME:String = "resourceName";
        private static var NAME_PICKUPS_MIN:String = "min";
        private static var NAME_PICKUPS_MAX:String = "max";
        private static var NAME_PICKUPS_CHANCE:String = "chance";
        private static var NAME_SPAWN_LISTS_ZONES:String = "zones";
        private static var NAME_SPAWN_LISTS_LOOT_TABLES:String = "lootTables";
        private static var NAME_SPAWN_LISTS_SPAWN_LIST_NAME:String = "name";
        private static var NAME_SPAWN_LISTS_ZONES_ZONE_NAME:String = "name";
        private static var NAME_SPAWN_LISTS_ZONES_ZONE_RARITY:String = "rarity";
        private static var NAME_SPAWN_LISTS__LOOT_TABLES__LOOT_TABLE__NAME:String = "name";
        private static var NAME_IGNORE_GRIDS_LISTS_ZONE_NAME:String = "name";
        private static var NAME_IGNORE_GRIDS_LISTS_IDS:String = "gridIds";
        private static var NAME__SETTINGS__HOMELAND:String = "homeland";
        private static var NAME__SETTINGS__HOMELAND__MIN_MINUTES:String = "minMinutes";
        private static var NAME__SETTINGS__HOMELAND__MAX_MINUTES:String = "maxMinutes";
        private static var NAME__SETTINGS__QUESTS_TO_RESET_AT_PICKUP_GENERATION:String = "questsToResetAtPickupGeneration";
        private static var NAME__SETTINGS__QUESTS_TO_RESET_AT_PICKUP_GENERATION__QUEST:String = "quest";
        private static var NAME__SETTINGS__QUESTS_TO_RESET_AT_PICKUP_GENERATION__QUEST__NAME:String = "name";
        private static var NAME__SETTINGS__QUESTS_TO_RESET_AT_PICKUP_GENERATION__QUEST__TYPE:String = "type";
        private static var NAME__RESOURCE_DEFINITIONS__RES_DEF__NAME:String = "name";
        private static var NAME__RESOURCE_DEFINITIONS__RES_DEF__BUILDING_NAME:String = "buildingName";
        private static var NAME__RESOURCE_DEFINITIONS__RES_DEF__RARITY:String = "rarity";
        private static var NAME__RESOURCE_DEFINITIONS__RES_DEF__LEVEL:String = "pLvl";
        private static var NAME__RESOURCE_DEFINITIONS__RES_DEF__LEVEL_MIN:String = "minLevel";
        private static var NAME__RESOURCE_DEFINITIONS__RES_DEF__LEVEL_MAX:String = "maxLevel";
        private static var NAME_RESOURCE_DEFINITION_BUILDING_NAME:String = "name";
        private static var NAME_RESOURCE_DEFINITION_BUILDING_TYPE:String = "type";
        private static var NAME_RESOURCE_DEFINITION_BUILDING_ASSOCIATED_LOOT_TABLES:String = "lootTables";
        private static var NAME_RESOURCE_DEFINITION_BUILDING_LOCA_EXTENSION:String = "locaExtension";
        private static var NAME_BUFF_LOOT_TABLE_BUFF_NAME:String = "buffName";
        private static var NAME_BUFF_LOOT_TABLE_LOOT_TABLE_NAMES:String = "lootTableNames";
        private static const MILLISECONDS_TO_SECONDS:int = 1000;

        private var homelandSpawnTimeMax:int;
        private var homelandSpawnTimeMin:int;
        private var minLevelForHomelandSpawn:int = 2147483647;
        private var maxLootTablesRarity:int;

        private var collectionsVector:Vector.<CollectionVO> = new Vector.<CollectionVO>();
        private var spawnListVector:Vector.<SpawnListVO> = new Vector.<SpawnListVO>();
        private var ignoreGridLists_map:Dictionary = new Dictionary();
        private var lootTablesVector:Vector.<LootTableVO> = new Vector.<LootTableVO>();
        private var resourceDefinitionsMap:Dictionary = new Dictionary();
        private var buildingToResources:Dictionary = new Dictionary();
        private var buffLootTables:Dictionary = new Dictionary();
        private var questsToResetAtPickupGeneration:Dictionary = new Dictionary();

        public function CollectionsParser(_arg_1:cXML)
        {
            super();
            this.parseXML(_arg_1);
        }

        private function parseBuffLootTables(_arg_1:cXML):void
        {
            var _local_3:cXML;
            var _local_4:String;
            var _local_5:CollectionsLootTableGroup;
            var _local_6:String;
            var _local_7:Vector.<int>;
            var _local_8:int;
            var _local_2:Vector.<cXML> = _arg_1.CreateChildrenArray();
            for each (_local_3 in _local_2)
            {
                _local_4 = _local_3.GetAttributeString_string(NAME_BUFF_LOOT_TABLE_BUFF_NAME);
                _local_5 = new CollectionsLootTableGroup();
                for each (_local_6 in _local_3.GetAttributeString_string(NAME_BUFF_LOOT_TABLE_LOOT_TABLE_NAMES).split(","))
                {
                    _local_5.addCollectionsLootTable(this.getLootTableByName(_local_6));
                };
                _local_7 = new Vector.<int>(this.maxLootTablesRarity);
                _local_8 = 0;
                while (_local_8 <= this.maxLootTablesRarity)
                {
                    _local_7[_local_8] = _local_3.GetAttributeInt((NAME_SPAWN_LISTS_ZONES_ZONE_RARITY + _local_8));
                    _local_8++;
                };
                this.buffLootTables[_local_4] = new BuffSpawnListVO(_local_5, _local_7);
            };
        }

        private function parseIgnoreGridLists(_arg_1:cXML):void
        {
            var _local_3:Array;
            var _local_4:cXML;
            var _local_5:String;
            var _local_6:String;
            var _local_7:Vector.<int>;
            var _local_8:String;
            var _local_2:Vector.<cXML> = _arg_1.CreateChildrenArray();
            for each (_local_4 in _local_2)
            {
                _local_5 = _local_4.GetAttributeString_string(NAME_IGNORE_GRIDS_LISTS_ZONE_NAME);
                _local_6 = _local_4.GetAttributeString_string(NAME_IGNORE_GRIDS_LISTS_IDS);
                _local_3 = StringUtils.split(_local_6, StringUtils.COMMA);
                _local_7 = new Vector.<int>();
                for each (_local_8 in _local_3)
                {
                    _local_7.push(gMisc.ParseInt(_local_8));
                };
                this.ignoreGridLists_map[_local_5] = _local_7;
            };
        }

        private function parseResourceDefinitionBuildings(_arg_1:cXML):Vector.<CollectionResourceDefinitionBuildingVO>
        {
            var _local_4:cXML;
            var _local_5:String;
            var _local_6:String;
            var _local_7:String;
            var _local_8:String;
            var _local_9:Array;
            var _local_10:CollectionResourceDefinitionBuildingVO;
            var _local_2:Vector.<CollectionResourceDefinitionBuildingVO> = new Vector.<CollectionResourceDefinitionBuildingVO>();
            var _local_3:Vector.<cXML> = _arg_1.CreateChildrenArray();
            for each (_local_4 in _local_3)
            {
                _local_5 = _local_4.GetAttributeString_string(NAME_RESOURCE_DEFINITION_BUILDING_NAME);
                _local_6 = _local_4.GetAttributeString_string(NAME_RESOURCE_DEFINITION_BUILDING_LOCA_EXTENSION, "");
                _local_7 = _local_4.GetAttributeString_string(NAME_RESOURCE_DEFINITION_BUILDING_TYPE);
                _local_8 = _local_4.GetAttributeString_string(NAME_RESOURCE_DEFINITION_BUILDING_ASSOCIATED_LOOT_TABLES);
                if (_local_7 == "")
                {
                    _local_7 = CollectionsConsts.COLLECTIBLE_BUILDING_TYPE_NORMAL;
                };
                if (_local_8 == "")
                {
                    _local_9 = [CollectionsConsts.COLLECTIBLE_LOOT_TABLE_ALL];
                }
                else
                {
                    _local_9 = _local_8.split(",");
                };
                _local_10 = new CollectionResourceDefinitionBuildingVO(_local_5, _local_7, _local_9, _local_6);
                this.buildingToResources[_local_10.getName()] = _local_10;
                _local_2.push(_local_10);
            };
            return (_local_2);
        }

        private function parseLootTables(_arg_1:cXML):void
        {
            var _local_3:String;
            var _local_4:Vector.<CollectionResourceDefinitionBuildingVO>;
            var _local_5:cXML;
            var _local_6:LootTableVO;
            var _local_7:Vector.<PickupVO>;
            var _local_8:String;
            var _local_9:cXML;
            var _local_10:PickupVO;
            var _local_2:Vector.<cXML> = _arg_1.CreateChildrenArray();
            for each (_local_5 in _local_2)
            {
                _local_7 = new Vector.<PickupVO>();
                _local_8 = _local_5.GetAttributeString_string(NAME_LOOT_TABLE_NAME);
                for each (_local_9 in _local_5.CreateChildrenArray())
                {
                    _local_3 = _local_9.GetAttributeString_string(NAME_PICKUPS_RESOURCENAME);
                    _local_4 = (this.resourceDefinitionsMap[_local_3] as CollectionResourceDefinitionVO).getBuildingsForLootTableGroup(_local_8);
                    _local_10 = new PickupVO(_local_4, _local_3, _local_9.GetAttributeInt(NAME_PICKUPS_MIN), _local_9.GetAttributeInt(NAME_PICKUPS_MAX), _local_9.GetAttributeInt(NAME_PICKUPS_CHANCE));
                    _local_7.push(_local_10);
                };
                this.lootTablesVector.push(new LootTableVO(_local_8, _local_5.GetAttributeInt(NAME_LOOT_TABLE_RARITY), _local_5.GetAttributeString_string(NAME_LOOT_TABLE_REQUIRES_EVENT), _local_7));
            };
            this.maxLootTablesRarity = 0;
            for each (_local_6 in this.lootTablesVector)
            {
                if (this.maxLootTablesRarity < _local_6.getRarity())
                {
                    this.maxLootTablesRarity = _local_6.getRarity();
                };
            };
        }

        private function parseResourceDefinitions(_arg_1:cXML):void
        {
            var _local_3:String;
            var _local_4:cXML;
            var _local_5:Vector.<CollectionResourceDefinitionBuildingVO>;
            var _local_6:int;
            var _local_7:int;
            var _local_8:Vector.<CollectionResourceDefinitionBuildingVO>;
            var _local_2:Vector.<cXML> = _arg_1.CreateChildrenArray();
            for each (_local_4 in _local_2)
            {
                _local_3 = _local_4.GetAttributeString_string(NAME__RESOURCE_DEFINITIONS__RES_DEF__NAME);
                _local_6 = _local_4.GetAttributeInt(NAME__RESOURCE_DEFINITIONS__RES_DEF__LEVEL_MIN, -1);
                if (_local_6 == -1)
                {
                    _local_6 = _local_4.GetAttributeInt(NAME__RESOURCE_DEFINITIONS__RES_DEF__LEVEL);
                };
                _local_7 = _local_4.GetAttributeInt(NAME__RESOURCE_DEFINITIONS__RES_DEF__LEVEL_MAX, global.playerLevels_vector.length);
                if (_local_6 < this.minLevelForHomelandSpawn)
                {
                    this.minLevelForHomelandSpawn = _local_6;
                };
                _local_8 = this.parseResourceDefinitionBuildings(_local_4);
                this.resourceDefinitionsMap[_local_3] = new CollectionResourceDefinitionVO(_local_3, _local_8, _local_4.GetAttributeInt(NAME__RESOURCE_DEFINITIONS__RES_DEF__RARITY), _local_6, _local_7);
            };
            _local_5 = new Vector.<CollectionResourceDefinitionBuildingVO>();
            _local_5.push(new CollectionResourceDefinitionBuildingVO(CollectionsConsts.NAME_RESOURCE_NOTHING, CollectionsConsts.COLLECTIBLE_BUILDING_TYPE_NORMAL, [CollectionsConsts.COLLECTIBLE_LOOT_TABLE_ALL], ""));
            this.resourceDefinitionsMap[CollectionsConsts.NAME_RESOURCE_NOTHING] = new CollectionResourceDefinitionVO(CollectionsConsts.NAME_RESOURCE_NOTHING, _local_5, 0, 0, 0);
        }

        private function parseCollections(_arg_1:cXML):void
        {
            var _local_3:cXML;
            var _local_4:String;
            var _local_5:int;
            var _local_6:String;
            var _local_7:String;
            var _local_8:String;
            var _local_9:int;
            var _local_10:int;
            var _local_11:int;
            var _local_12:Boolean;
            var _local_13:String;
            var _local_14:CollectionVO;
            var _local_15:cXML;
            var _local_16:CollectionResourceVO;
            var _local_2:Vector.<cXML> = _arg_1.CreateChildrenArray();
            for each (_local_3 in _local_2)
            {
                _local_4 = _local_3.GetAttributeString_string(NAME_COLLECTIONS_NAME);
                _local_5 = _local_3.GetAttributeInt(NAME_COLLECTIONS_PLAYER_LEVEL);
                _local_6 = _local_3.GetAttributeString_string(NAME_COLLECTIONS_BLUEPRINT);
                _local_7 = _local_3.GetAttributeString_string(NAME_COLLECTIONS_OUTPUT_BUFF_NAME);
                _local_8 = _local_3.GetAttributeString_string(NAME_COLLECTIONS_OUTPUT_BUFF_RESOURCE_NAME);
                _local_9 = _local_3.GetAttributeInt(NAME_COLLECTIONS_OUTPUT_BUFF_RESOURCE_AMOUNT);
                _local_10 = (_local_3.GetAttributeInt(NAME_COLLECTIONS_PRODUCTION_TIME) * MILLISECONDS_TO_SECONDS);
                _local_11 = _local_3.GetAttributeInt(NAME_COLLECTIONS_INSTANT_BUILD_COSTS);
                _local_12 = _local_3.GetAttributeBool(NAME_COLLECTIONS_SHOW_RESOURCE_ICON, true);
                _local_13 = _local_3.GetAttributeString_string(NAME_COLLECTIONS_REQUIRES_EVENT, "");
                _local_14 = new CollectionVO(_local_4, _local_5, _local_6, _local_7, _local_8, _local_9, _local_10, _local_11, _local_12, _local_13);
                for each (_local_15 in _local_3.CreateChildrenArray())
                {
                    _local_16 = new CollectionResourceVO(_local_15.GetAttributeString_string(NAME_COLLECTIONS_RESOURCE_NAME), _local_15.GetAttributeInt(NAME_COLLECTIONS_RESOURCE_AMOUNT));
                    _local_14.addCollectionResource(_local_16);
                };
                this.collectionsVector.push(_local_14);
            };
        }

        private function parseXML(_arg_1:cXML):CollectionsParser
        {
            this.parseResourceDefinitions(_arg_1.MoveToSubNode(NAME_ELEMENT_RESOURCE_DEFINITIONS));
            this.parseCollections(_arg_1.MoveToSubNode(NAME_ELEMENT_COLLECTIONS));
            this.parseLootTables(_arg_1.MoveToSubNode(NAME_ELEMENT_LOOT_TABLES));
            this.parseSpawnLists(_arg_1.MoveToSubNode(NAME_ELEMENT_SPAWN_LISTS));
            this.parseIgnoreGridLists(_arg_1.MoveToSubNode(NAME_ELEMENT_IGNORE_GRID_LISTS));
            this.parseBuffLootTables(_arg_1.MoveToSubNode(NAME_ELEMENT_BUFF_LOOT_TABLES));
            this.parseCollectionsSettings(_arg_1.MoveToSubNode(NAME_ELEMENT_SETTINGS));
            return (this);
        }

        private function parseCollectionsSettings(_arg_1:cXML):void
        {
            var _local_3:cXML;
            var _local_4:cXML;
            var _local_5:String;
            var _local_6:int;
            var _local_2:Vector.<cXML> = _arg_1.CreateChildrenArray();
            for each (_local_3 in _local_2)
            {
                if (_local_3.GetName_string() == NAME__SETTINGS__HOMELAND)
                {
                    this.homelandSpawnTimeMin = _local_3.GetAttributeInt(NAME__SETTINGS__HOMELAND__MIN_MINUTES);
                    this.homelandSpawnTimeMax = _local_3.GetAttributeInt(NAME__SETTINGS__HOMELAND__MAX_MINUTES);
                }
                else
                {
                    if (_local_3.GetName_string() == NAME__SETTINGS__QUESTS_TO_RESET_AT_PICKUP_GENERATION)
                    {
                        for each (_local_4 in _local_3.CreateChildrenArray())
                        {
                            if (_local_4.GetName_string() == NAME__SETTINGS__QUESTS_TO_RESET_AT_PICKUP_GENERATION__QUEST)
                            {
                                _local_5 = _local_4.GetAttributeString_string(NAME__SETTINGS__QUESTS_TO_RESET_AT_PICKUP_GENERATION__QUEST__NAME);
                                _local_6 = _local_4.GetAttributeInt(NAME__SETTINGS__QUESTS_TO_RESET_AT_PICKUP_GENERATION__QUEST__TYPE);
                                if (this.questsToResetAtPickupGeneration[_local_6] == null)
                                {
                                    this.questsToResetAtPickupGeneration[_local_6] = new Vector.<String>();
                                };
                                Vector.<String>(this.questsToResetAtPickupGeneration[_local_6]).push(_local_5);
                            };
                        };
                    };
                };
            };
        }

        public function buildCollectionsManager():CollectionsManager
        {
            return (new CollectionsManager(this.collectionsVector, this.spawnListVector, this.resourceDefinitionsMap, this.buildingToResources, this.buffLootTables, this.homelandSpawnTimeMin, this.homelandSpawnTimeMax, this.minLevelForHomelandSpawn, this.questsToResetAtPickupGeneration, this.ignoreGridLists_map));
        }

        private function parseSpawnLists(_arg_1:cXML):void
        {
            var _local_3:cXML;
            var _local_4:Vector.<SpawnListZoneVO>;
            var _local_5:Vector.<int>;
            var _local_6:cXML;
            var _local_7:CollectionsLootTableGroup;
            var _local_8:cXML;
            var _local_9:SpawnListVO;
            var _local_10:int;
            var _local_11:SpawnListZoneVO;
            var _local_12:String;
            var _local_13:LootTableVO;
            var _local_2:Vector.<cXML> = _arg_1.CreateChildrenArray();
            for each (_local_3 in _local_2)
            {
                _local_4 = new Vector.<SpawnListZoneVO>();
                _local_5 = new Vector.<int>(this.maxLootTablesRarity);
                for each (_local_6 in _local_3.MoveToSubNode(NAME_SPAWN_LISTS_ZONES).CreateChildrenArray())
                {
                    _local_10 = 0;
                    while (_local_10 <= this.maxLootTablesRarity)
                    {
                        _local_5[_local_10] = _local_6.GetAttributeInt((NAME_SPAWN_LISTS_ZONES_ZONE_RARITY + _local_10));
                        _local_10++;
                    };
                    _local_11 = new SpawnListZoneVO(_local_6.GetAttributeString_string(NAME_SPAWN_LISTS_ZONES_ZONE_NAME), _local_5);
                    _local_4.push(_local_11);
                };
                _local_7 = new CollectionsLootTableGroup();
                for each (_local_8 in _local_3.MoveToSubNode(NAME_SPAWN_LISTS_LOOT_TABLES).CreateChildrenArray())
                {
                    _local_12 = _local_8.GetAttributeString_string(NAME_SPAWN_LISTS__LOOT_TABLES__LOOT_TABLE__NAME);
                    _local_13 = this.getLootTableByName(_local_12);
                    if (_local_13 != null)
                    {
                        _local_7.addCollectionsLootTable(_local_13);
                    };
                };
                _local_9 = new SpawnListVO(_local_3.GetAttributeString_string(NAME_SPAWN_LISTS_SPAWN_LIST_NAME), _local_4, _local_7);
                this.spawnListVector.push(_local_9);
            };
        }

        private function getLootTableByName(_arg_1:String):LootTableVO
        {
            var _local_2:LootTableVO;
            for each (_local_2 in this.lootTablesVector)
            {
                if (_arg_1 == _local_2.getName())
                {
                    return (_local_2);
                };
            };
            return (null);
        }


    }
}
