package Communication.VO
{
    import mx.collections.ArrayCollection;
    import Communication.VO.Achievements.UserAchievementDataVO;
    import Communication.VO.Tasks.TaskDataVO;
    import Communication.VO.Votes.dPlayerVoteVO;
    import Communication.VO.collectibles.PickupsDataVO;
    import Collections.CollectionsConsts;
    import Enums.TIMED_PRODUCTION_TYPE;

    public class dZoneVO 
    {

        public var hasAltDefaultAnimals:Boolean;
        public var contest:Object = null;
        public var activateProduction:Boolean = false;
        public var conditionCollection:ConditionCollectionVO;
        public var settings:dSettingsVO = null;
        public var questDefinitionContainer:dQuestDefinitionContainerVO;
        public var adventAssetPrefix:String = "";
        public var minimumPlayerLevel:int = -1;
        public var gameTickRefreshCounter:int;
        public var lastColonyYieldCalculationTime:Number;
        public var zoneOwnerPlayerID:int;
        public var adventureState:int;
        public var backgoundMapWidth:int = 34;
        public var alternativeWater:Boolean = false;
        public var playerResources_string:String = "";
        public var gameWorldName:String;
        public var maximumBuildingCount:int = -1;
        public var filter:int = 0;
        public var backgoundMapHeight:int = 33;
        public var requirements:dRequirementListsVO = null;
        public var clientQuestPool:dQuestPoolVO = null;
        public var streetMapMaxUsableY:int = 136;
        public var streetMapMaxUsableX:int = 63;
        public var lastGameTickRefreshTime:Number;
        public var resourcesVO:dResourcesVO;
        public var activeQuestOldQuestSystem:dQuestVO = null;
        public var mapHeight:int = 136;
        public var realmTimeOffset:Number;
        public var serverTime:Number;
        public var playerOptions:PlayerOptionsVO;
        public var colonyState:int;
        public var adventureName:String;
        public var zoneMapName:String;
        public var guildQuestTimeOffset:Number;
        public var maxAnimalsOnMap:int = 100;
        public var randomSeed:int;
        public var startGrid:int;
        public var eventToActivate:String;
        public var mapWidth:int = 64;
        public var streetMapMinUsableX:int = 2;
        public var useContinentalFog:Boolean = false;
        public var streetMapMinUsableY:int = 2;
        public var serverTimeStamp:Number;
        public var zoneVisitorPlayerID:int;

        public var itemRegistryEntries:ArrayCollection = new ArrayCollection();
        public var zoneBuffs:ArrayCollection = new ArrayCollection();
        public var specialistActivity_vector:ArrayCollection = new ArrayCollection();
        public var buildings:ArrayCollection = new ArrayCollection();
        public var sectors:ArrayCollection = new ArrayCollection();
        public var landscapes:ArrayCollection = new ArrayCollection();
        public var freeLandscapes:ArrayCollection = new ArrayCollection();
        public var overFogLandscapes:ArrayCollection = new ArrayCollection();
        public var deposits:ArrayCollection = new ArrayCollection();
        public var depositGroups:ArrayCollection = new ArrayCollection();
        public var depositQualities:ArrayCollection = new ArrayCollection();
        public var streets:ArrayCollection = new ArrayCollection();
        public var resourceCreations:ArrayCollection = new ArrayCollection();
        public var backgroundTiles:ArrayCollection = new ArrayCollection();
        public var playersOnMap:ArrayCollection = new ArrayCollection();
        public var mapValues:ArrayCollection = new ArrayCollection();
        public var landingFields:ArrayCollection = new ArrayCollection();
        public var map_PlayerID_Army:Object = new Object();
        public var timedProductions_vector:ArrayCollection = new ArrayCollection();
        public var gameTickCommands_vector:ArrayCollection = new ArrayCollection();
        public var specialists_vector:ArrayCollection = new ArrayCollection();
        public var dataTracking_vector:ArrayCollection = new ArrayCollection();
        public var buildQueue:dBuildQueueVO = new dBuildQueueVO();
        public var hiredTroopsPool:ArrayCollection = new ArrayCollection();
        public var userAchievementData:UserAchievementDataVO = new UserAchievementDataVO();
        public var comparedUsersAchievementData:ArrayCollection = new ArrayCollection();
        public var tasksData:TaskDataVO = new TaskDataVO();
        public var compareTaskData:ArrayCollection = new ArrayCollection();
        public var adventCalendarDoors:ArrayCollection = new ArrayCollection();
        public var playerGuildMarketVote:dPlayerVoteVO = new dPlayerVoteVO();
        public var historyVotedShopItems:Object = {};
        public var colonies:ArrayCollection = new ArrayCollection();
        public var combatPreviewPaths:ArrayCollection = new ArrayCollection();
        public var contentGeneratorDefinitions:ArrayCollection = new ArrayCollection();
        public var contentGeneratorCollectionParts:ArrayCollection = new ArrayCollection();
        public var genericValues:ArrayCollection = new ArrayCollection();
        public var defaultAnimals:Object = {};
        public var pickupsDataVO:PickupsDataVO = new PickupsDataVO().init(CollectionsConsts.COLLECTIBLE_BUILDING_NORMAL, -1);
        public var eventPickupsDataVO:PickupsDataVO = new PickupsDataVO().init(CollectionsConsts.COLLECTIBLE_BUILDING_EVENT, -1);
        public var pickups:ArrayCollection = new ArrayCollection();
        public var cooldowns:ArrayCollection = new ArrayCollection();
        public var eventTimes:ArrayCollection = new ArrayCollection();


        public function isPlayerOnMap(_arg_1:int):Boolean
        {
            var _local_2:dPlayerVO;
            for each (_local_2 in this.playersOnMap)
            {
                if (_local_2.userID == _arg_1)
                {
                    return (true);
                };
            };
            return (false);
        }

        public function toDebugString():String
        {
            var _local_2:dMapValueItemVO;
            var _local_1:* = (((((((((("<ZoneVO zoneVisitorPlayerID='" + this.zoneVisitorPlayerID) + "' zoneOwnerPlayerID='") + this.zoneOwnerPlayerID) + "' serverTime='") + this.serverTime) + "' lastGameTickRefreshTime='") + this.lastGameTickRefreshTime) + "' gameTickRefreshCounter='") + this.gameTickRefreshCounter) + "'>\n");
            _local_1 = (_local_1 + gCalculations.createListString("ZoneBuffs", this.zoneBuffs));
            _local_1 = (_local_1 + gCalculations.createListString("ItemRegistryEntries", this.itemRegistryEntries));
            _local_1 = (_local_1 + gCalculations.createListString("Buildings", this.buildings));
            _local_1 = (_local_1 + gCalculations.createListString("Sectors", this.sectors));
            _local_1 = (_local_1 + gCalculations.createListString("Landscapes", this.landscapes));
            _local_1 = (_local_1 + gCalculations.createListString("Deposits", this.deposits));
            _local_1 = (_local_1 + gCalculations.createListString("DepositGroups", this.depositGroups));
            _local_1 = (_local_1 + gCalculations.createListString("DepositQualities", this.depositQualities));
            _local_1 = (_local_1 + gCalculations.createListString("Streets", this.streets));
            _local_1 = (_local_1 + gCalculations.createListString("ResourceCreations", this.resourceCreations));
            _local_1 = (_local_1 + gCalculations.createListString("BackgroundTiles", this.backgroundTiles));
            _local_1 = (_local_1 + gCalculations.createListString("Players", this.playersOnMap));
            _local_1 = (_local_1 + (("<MapValues count='" + this.mapValues.length) + "' list='"));
            for each (_local_2 in this.mapValues)
            {
                _local_1 = (_local_1 + (((((_local_2.mBackgroundBlocking + ",") + 0) + ",") + _local_2.mSectorId) + ","));
            };
            _local_1 = (_local_1 + "'/>\n");
            _local_1 = (_local_1 + this.map_PlayerID_Army);
            _local_1 = (_local_1 + gCalculations.createListString("MilitaryUnitRecruitments_vector", this.timedProductions_vector[TIMED_PRODUCTION_TYPE.MILITARY_UNIT]));
            _local_1 = (_local_1 + gCalculations.createListString("BuffProduction_vector", this.timedProductions_vector[TIMED_PRODUCTION_TYPE.BUFF]));
            _local_1 = (_local_1 + gCalculations.createListString("GameTickCommands_vector", this.gameTickCommands_vector));
            _local_1 = (_local_1 + gCalculations.createListString("Specialists", this.specialists_vector));
            _local_1 = (_local_1 + gCalculations.createListString("DataTracking", this.dataTracking_vector));
            _local_1 = (_local_1 + gCalculations.createListString("Colonies", this.colonies));
            _local_1 = (_local_1 + gCalculations.createListString("EliteUnitRecruitments_vector", this.timedProductions_vector[TIMED_PRODUCTION_TYPE.ELITE_UNITS]));
            _local_1 = (_local_1 + ("\n" + this.buildQueue));
            return (_local_1 + "</ZoneVO>\n");
        }


    }
}
