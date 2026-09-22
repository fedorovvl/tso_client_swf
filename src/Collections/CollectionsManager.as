package Collections
{
    import flash.utils.Dictionary;
    import __AS3__.vec.Vector;
    import Communication.VO.collectibles.CollectionVO;
    import Communication.VO.collectibles.SpawnListVO;
    import Communication.VO.collectibles.SpawnListZoneVO;
    import Communication.VO.collectibles.LootTableVO;
    import Communication.VO.collectibles.PickupVO;
    import ServerState.dResource;
    import nLib.gMisc;
    import Communication.VO.collectibles.CollectionResourceDefinitionVO;
    import Interface.cGameInterface;
    import Communication.VO.collectibles.BuffSpawnListVO;
    import __AS3__.vec.*;

    public class CollectionsManager 
    {

        public static var singletonInstance:CollectionsManager = null;
        public static const COLLECTIONS_NAME_HOME_ZONE:String = "HOME";

        private var minLevelForHomelandSpawn:int;
        private var resourceDefinitions:Dictionary;
        private var buildingToResources:Dictionary;
        private var zoneLootTablesMap:Dictionary;
        private var collectionsVector:Vector.<CollectionVO>;
        private var homelandLootTableGroupsVector:Vector.<CollectionsSpawnZone>;
        private var spawnListsVector:Vector.<SpawnListVO>;
        private var maxLootTablesRarity:int;
        private var homelandSpawnTimeMin:int;
        private var homelandSpawnTimeMax:int;
        private var ignoreGridLists_map:Object = new Dictionary();
        private var buffLootTables:Dictionary;
        private var questsToResetAtPickupGeneration:Dictionary;

        public function CollectionsManager(_arg_1:Vector.<CollectionVO>, _arg_2:Vector.<SpawnListVO>, _arg_3:Dictionary, _arg_4:Dictionary, _arg_5:Dictionary, _arg_6:int, _arg_7:int, _arg_8:int, _arg_9:Dictionary, _arg_10:Dictionary)
        {
            super();
            this.collectionsVector = _arg_1;
            this.spawnListsVector = _arg_2;
            this.homelandSpawnTimeMin = _arg_6;
            this.homelandSpawnTimeMax = _arg_7;
            this.buildingToResources = _arg_4;
            this.buffLootTables = _arg_5;
            this.resourceDefinitions = _arg_3;
            this.buildZonePickupsMap(this.spawnListsVector);
            this.minLevelForHomelandSpawn = _arg_8;
            this.questsToResetAtPickupGeneration = _arg_9;
            this.ignoreGridLists_map = _arg_10;
        }

        public static function getInstance():CollectionsManager
        {
            return (singletonInstance);
        }

        public static function setInstance(_arg_1:CollectionsManager):void
        {
            singletonInstance = _arg_1;
        }


        public function getBuildingIsNormalCollectible(_arg_1:String):Boolean
        {
            return ((!(this.buildingToResources[_arg_1] == null)) && (this.buildingToResources[_arg_1].getType() == CollectionsConsts.COLLECTIBLE_BUILDING_TYPE_NORMAL));
        }

        public function getMaxLootTablesRarity():int
        {
            return (this.maxLootTablesRarity);
        }

        public function getMinPlayerLevelForHomelandSpawn():int
        {
            return (this.minLevelForHomelandSpawn);
        }

        public function getResourceRefundAmount(_arg_1:String, _arg_2:String):Vector.<dResource>
        {
            var _local_4:SpawnListVO;
            var _local_5:SpawnListZoneVO;
            var _local_6:CollectionsLootTableGroup;
            var _local_7:LootTableVO;
            var _local_8:PickupVO;
            var _local_9:int;
            if (_arg_2 == null)
            {
                _arg_2 = COLLECTIONS_NAME_HOME_ZONE;
            };
            var _local_3:Vector.<dResource> = new Vector.<dResource>();
            for each (_local_4 in this.spawnListsVector)
            {
                for each (_local_5 in _local_4.getListZones())
                {
                    if (_local_5.getName() == _arg_2)
                    {
                        _local_6 = _local_4.getLootTableGroup();
                        for each (_local_7 in _local_6.getLootTables())
                        {
                            for each (_local_8 in _local_7.getPickups())
                            {
                                if (_local_8.hasBuildingName(_arg_1))
                                {
                                    _local_9 = ((_local_8.getMinAmount() + Math.round((gMisc.GetRandomValueMinMax(0, 1) * (_local_8.getMaxAmount() - _local_8.getMinAmount())))) as int);
                                    _local_3.push(new dResource().Init(_local_8.getResourceName(), _local_9));
                                    return (_local_3);
                                };
                            };
                        };
                    };
                };
            };
            return (_local_3);
        }

        public function getPlayerLevelMinForResource(_arg_1:String):int
        {
            return ((this.resourceDefinitions[_arg_1] as CollectionResourceDefinitionVO).getRequiredPlayerLevelMin());
        }

        public function getCollection(_arg_1:String):CollectionVO
        {
            var _local_2:CollectionVO;
            for each (_local_2 in this.collectionsVector)
            {
                if (_local_2.getName() == _arg_1)
                {
                    return (_local_2);
                };
            };
            return (null);
        }

        public function getBuildingIsEventCollectible(_arg_1:String):Boolean
        {
            return ((!(this.buildingToResources[_arg_1] == null)) && (this.buildingToResources[_arg_1].getType() == CollectionsConsts.COLLECTIBLE_BUILDING_TYPE_EVENT));
        }

        public function isCollectibleResource(_arg_1:String):Boolean
        {
            return (!(this.resourceDefinitions[_arg_1] == null));
        }

        public function getPickupsForAdventure(_arg_1:String, _arg_2:cGameInterface):Vector.<PickupVO>
        {
            var _local_3:Vector.<CollectionsSpawnZone> = (this.zoneLootTablesMap[_arg_1] as Vector.<CollectionsSpawnZone>);
            if (_local_3 != null)
            {
                return (this.getPickupsFromLootTable(this.zoneLootTablesMap[_arg_1], _arg_2));
            };
            return (new Vector.<PickupVO>());
        }

        public function getHomelandSpawnTimeMin():int
        {
            return (this.homelandSpawnTimeMin);
        }

        public function getShouldRenderResourceForBuff(_arg_1:String):Boolean
        {
            var _local_2:CollectionVO;
            for each (_local_2 in this.collectionsVector)
            {
                if (_local_2.getOutputBuffName() == _arg_1)
                {
                    return (_local_2.getShowResourceIcon());
                };
            };
            return (true);
        }

        public function getAllCollections():Vector.<CollectionVO>
        {
            return (this.collectionsVector);
        }

        public function getPickupsForHomeland(_arg_1:cGameInterface):Vector.<PickupVO>
        {
            return (this.getPickupsFromLootTable(this.homelandLootTableGroupsVector, _arg_1));
        }

        public function getPickupsForBuff(_arg_1:String, _arg_2:cGameInterface):Vector.<PickupVO>
        {
            var _local_3:BuffSpawnListVO = this.buffLootTables[_arg_1];
            if (_local_3 == null)
            {
                return (new Vector.<PickupVO>());
            };
            return (_local_3.getBuffLootTables().getPickups(_local_3.getPickupCount(), _arg_2));
        }

        public function getHomelandSpawnTimeMax():int
        {
            return (this.homelandSpawnTimeMax);
        }

        private function buildZonePickupsMap(_arg_1:Vector.<SpawnListVO>):void
        {
            var _local_2:String;
            var _local_4:SpawnListVO;
            var _local_5:SpawnListZoneVO;
            this.zoneLootTablesMap = new Dictionary();
            var _local_3:SpawnListZoneVO;
            for each (_local_4 in _arg_1)
            {
                for each (_local_5 in _local_4.getListZones())
                {
                    _local_2 = _local_5.getName();
                    if (this.zoneLootTablesMap[_local_2] == null)
                    {
                        this.zoneLootTablesMap[_local_2] = new Vector.<CollectionsSpawnZone>();
                    };
                    this.zoneLootTablesMap[_local_2].push(new CollectionsSpawnZone(_local_5, _local_4.getLootTableGroup()));
                    if (_local_2 == COLLECTIONS_NAME_HOME_ZONE)
                    {
                        _local_3 = _local_5;
                    };
                };
            };
            if (_local_3 != null)
            {
                this.homelandLootTableGroupsVector = this.zoneLootTablesMap[_local_3.getName()];
            };
        }

        private function getPickupsFromLootTable(_arg_1:Vector.<CollectionsSpawnZone>, _arg_2:cGameInterface):Vector.<PickupVO>
        {
            var _local_3:int = gMisc.GetRandomValueMinMaxInt(0, (_arg_1.length - 1));
            var _local_4:Vector.<int> = _arg_1[_local_3].getZone().getPickupCount();
            return (_arg_1[_local_3].getLootTableGroup().getPickups(_local_4, _arg_2));
        }

        public function getQuestsToResetAtPickupGeneration(_arg_1:int):Vector.<String>
        {
            return (this.questsToResetAtPickupGeneration[_arg_1]);
        }

        public function getPlayerLevelMaxForResource(_arg_1:String):int
        {
            return ((this.resourceDefinitions[_arg_1] as CollectionResourceDefinitionVO).getRequiredPlayerLevelMax());
        }

        public function getLocaExtension_string(_arg_1:String):String
        {
            return ((this.buildingToResources[_arg_1] != null) ? this.buildingToResources[_arg_1].getLocaExtension_string() : "");
        }

        public function getResourceRarity(_arg_1:String):int
        {
            return ((this.resourceDefinitions[_arg_1] as CollectionResourceDefinitionVO).getRarity());
        }

        public function getResourceRefundAmountFromEventBuff(_arg_1:String, _arg_2:String):Vector.<dResource>
        {
            var _local_5:LootTableVO;
            var _local_6:PickupVO;
            var _local_7:int;
            var _local_3:Vector.<dResource> = new Vector.<dResource>();
            var _local_4:BuffSpawnListVO = this.buffLootTables[_arg_2];
            if (_local_4 != null)
            {
                for each (_local_5 in _local_4.getBuffLootTables().getLootTables())
                {
                    for each (_local_6 in _local_5.getPickups())
                    {
                        if (_local_6.hasBuildingName(_arg_1))
                        {
                            _local_7 = ((_local_6.getMinAmount() + Math.round((gMisc.GetRandomValueMinMax(0, 1) * (_local_6.getMaxAmount() - _local_6.getMinAmount())))) as int);
                            _local_3.push(new dResource().Init(_local_6.getResourceName(), _local_7));
                            return (_local_3);
                        };
                    };
                };
            };
            return (_local_3);
        }

        public function getBuffIsCollectibleLootBuff(_arg_1:String):Boolean
        {
            return (!(this.buffLootTables[_arg_1] == null));
        }

        public function getIgnoreGridList(_arg_1:String):Vector.<int>
        {
            var _local_2:Vector.<int> = (this.ignoreGridLists_map[_arg_1] as Vector.<int>);
            if (_local_2 != null)
            {
                return (_local_2);
            };
            return (new Vector.<int>());
        }

        public function getBuildingIsCollectible(_arg_1:String):Boolean
        {
            return (!(this.buildingToResources[_arg_1] == null));
        }

        public function getCollectionsAsArray(_arg_1:cGameInterface):Array
        {
            var _local_3:CollectionVO;
            var _local_2:Array = new Array();
            for each (_local_3 in this.collectionsVector)
            {
                if (_local_3.getIsActive(_arg_1))
                {
                    _local_2.push(_local_3);
                };
            };
            return (_local_2);
        }

        public function getActiveCollections(_arg_1:cGameInterface):Vector.<CollectionVO>
        {
            var _local_3:CollectionVO;
            var _local_2:Vector.<CollectionVO> = new Vector.<CollectionVO>();
            for each (_local_3 in this.collectionsVector)
            {
                if (_local_3.getIsActive(_arg_1))
                {
                    _local_2.push(_local_3);
                };
            };
            return (_local_2);
        }


    }
}
