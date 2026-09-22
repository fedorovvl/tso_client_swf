package ServerOnly
{
    import Communication.VO.dDepositVO;
    import converted.bluebyte.tso.contentgenerator.logic.CollectionPart;
    import Communication.VO.dQuestPoolVO;
    import Communication.VO.dQuestElementVO;
    import Communication.VO.dDepositQualityVO;
    import Communication.VO.dDepositGroupVO;
    import converted.bluebyte.tso.contentgenerator.logic.ContentGeneratorDefinitions;
    import Communication.VO.CollectionPartVO;
    import Communication.VO.ContentGenerator.ContentGeneratorCategoryVO;
    import Interface.cGeneralInterface;
    import __AS3__.vec.Vector;
    import GO.cDepositGroup;
    import GO.cDepositQuality;
    import ServerState.dResourceCreationDefinition;
    import ServerState.cResourceCreation;
    import ServerState.gEconomics;
    import Enums.RESOURCE_TYPE;
    import Enums.DIRTY_INDICATOR;
    import Communication.VO.dZoneVO;
    import GO.cDeposit;
    import nLib.cLog;
    import Enums.DEPOSIT_ACCESSIBLE_TYPES;
    import GO.cBuilding;
    import Map.cSector;
    import ServerState.cResources;
    import Specialists.cSpecialist;
    import ServerState.cDataTrackingItem;
    import GO.cGO;
    import GO.cFreeLandscape;
    import GO.cLandingField;
    import GO.cCombatPreviewPath;
    import Achievements.UserAchievementManager;
    import GO.cStreet;
    import Communication.VO.dGameTickCommandVO;
    import Communication.VO.ColonyVO;
    import ServerState.cPlayerData;
    import Communication.VO.dPlayerVO;
    import GO.cLandscape;
    import TimedProduction.cTimedProductionQueue;
    import mx.collections.ArrayCollection;
    import TimedProduction.cTimedProduction;
    import Communication.VO.dTimedProductionVO;
    import Communication.VO.dMapValueItemVO;
    import Communication.VO.dBackgroundTileVO;
    import Communication.VO.dHiredUnitsVO;
    import AdventureSystem.cAdventure;
    import Communication.VO.dBuildQueueVO;
    import Enums.OBJECTTYPE;
    import nLib.gMisc;
    import TimedProduction.cAbstractTimedProductionOrder;
    import Map.AdditionalDataTSO;
    import Enums.COMMAND;
    import Collections.CollectionsConsts;
    import Enums.SECTOR_DISCOVERY_TYPE;
    import Communication.VO.UpdateVO.dFoundDepositVO;
    import Enums.EXPLORED_DEPOSIT_RESULT;
    import ServerState.*;
    import GO.*;
    import __AS3__.vec.*;
    import Communication.VO.*;
    import nLib.*;
    import Communication.VO.UpdateVO.*;
    import Map.*;
    import Communication.VO.ContentGenerator.*;
    import Enums.*;

    public class cServerOnly 
    {

        private static const dummy1:dDepositVO = null;
        private static const dummy2:CollectionPart = null;
        private static const dummy3:dQuestPoolVO = null;
        private static const dummy4:dQuestElementVO = null;
        private static const dummy5:dDepositQualityVO = null;
        private static const dummy6:dDepositGroupVO = null;
        private static const dummy7:ContentGeneratorDefinitions = null;
        private static const dummy8:CollectionPartVO = null;
        private static const dummy9:ContentGeneratorCategoryVO = null;

        private var mGeneralInterface:cGeneralInterface = null;

        public const mDepositGroups_vector:Vector.<cDepositGroup> = new Vector.<cDepositGroup>();
        public const mDepositQualities_vector:Vector.<cDepositQuality> = new Vector.<cDepositQuality>();

        public function cServerOnly(_arg_1:cGeneralInterface)
        {
            super();
            this.mGeneralInterface = _arg_1;
        }

        public function InitCreatedAlwaysProduction(_arg_1:int, _arg_2:int):void
        {
            var _local_3:dResourceCreationDefinition;
            var _local_4:cResourceCreation;
            for each (_local_3 in gEconomics.mResourceCreationDefinition_vector)
            {
                if (_local_3.typeEnumResourceType == RESOURCE_TYPE.CREATED_ALWAYS)
                {
                    _local_4 = new cResourceCreation(_arg_1, _local_3, null);
                    _local_4.mDirtyIndicator = (_local_4.mDirtyIndicator | DIRTY_INDICATOR.CREATED_BIT);
                    this.mGeneralInterface.mComputeResourceCreation.mResourceCreation_vector.push(_local_4);
                };
            };
        }

        public function CreateZoneVO(_arg_1:int):dZoneVO
        {
            return (this.createZoneVOLocal(_arg_1, false));
        }

        private function ChooseNextAccessibleDeposit(_arg_1:cDepositGroup, _arg_2:int, _arg_3:Boolean):cDeposit
        {
            var _local_4:int;
            var _local_5:cDeposit;
            var _local_6:cDeposit;
            cLog.info((("ChooseNextAccessibleDeposit( " + _arg_1) + " )"));
            var _local_7:Vector.<int> = _arg_1.GetDepositGridIdxs_vector();
            if (_local_7.length == 0)
            {
                return (null);
            };
            var _local_8:int;
            for each (_local_4 in _local_7)
            {
                if (this.mGeneralInterface.mCurrentPlayerZone.isPlayerOwnerOfGridIdx(_local_4, _arg_2))
                {
                    _local_5 = this.mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.mDepositContainer.get(_local_4);
                    if (_local_5 != null)
                    {
                        if (_local_5.GetAccessibleType() == DEPOSIT_ACCESSIBLE_TYPES.NOT_ACCESSIBLE)
                        {
                            if (((_local_6 == null) || (_local_5.GetEmptied() < _local_6.GetEmptied())))
                            {
                                _local_6 = _local_5;
                            };
                        }
                        else
                        {
                            _local_8++;
                        };
                    };
                };
            };
            if (((!(_arg_3)) && (_local_8 >= _arg_1.GetMaxAccessible())))
            {
                return (null);
            };
            return (_local_6);
        }

        public function CreateGenericZoneVO(_arg_1:int):dZoneVO
        {
            return (this.createZoneVOLocal(_arg_1, true));
        }

        private function createZoneVOLocal(_arg_1:int, _arg_2:Boolean):dZoneVO
        {
            var _local_6:cBuilding;
            var _local_7:cSector;
            var _local_8:cResources;
            var _local_9:cSpecialist;
            var _local_10:cDataTrackingItem;
            var _local_11:cBuilding;
            var _local_12:cGO;
            var _local_13:cFreeLandscape;
            var _local_14:cFreeLandscape;
            var _local_15:cLandingField;
            var _local_16:cCombatPreviewPath;
            var _local_17:UserAchievementManager;
            var _local_18:cResourceCreation;
            var _local_19:cDeposit;
            var _local_20:cStreet;
            var _local_21:String;
            var _local_22:int;
            var _local_23:int;
            var _local_25:dGameTickCommandVO;
            var _local_26:String;
            var _local_27:ColonyVO;
            var _local_28:cPlayerData;
            var _local_29:dPlayerVO;
            var _local_30:cPlayerData;
            var _local_31:dPlayerVO;
            var _local_32:cLandscape;
            var _local_33:cBuilding;
            var _local_34:int;
            var _local_35:cTimedProductionQueue;
            var _local_36:ArrayCollection;
            var _local_37:cTimedProduction;
            var _local_38:dTimedProductionVO;
            var _local_39:dMapValueItemVO;
            var _local_40:String;
            var _local_41:dBackgroundTileVO;
            var _local_42:dHiredUnitsVO;
            var _local_3:dZoneVO = new dZoneVO();
            _local_3.zoneMapName = this.mGeneralInterface.mZoneMapName;
            _local_3.filter = this.mGeneralInterface.mCurrentPlayerZone.filter;
            var _local_4:cAdventure = this.mGeneralInterface.mCurrentPlayerZone.GetAdventure();
            if (_local_4 != null)
            {
                _local_3.adventureName = _local_4.GetName_string();
                _local_3.adventureState = _local_4.GetStatus();
            }
            else
            {
                _local_3.adventureName = null;
            };
            _local_3.serverTime = this.mGeneralInterface.GetClientTime();
            _local_3.lastGameTickRefreshTime = this.mGeneralInterface.mLastGameTickRefreshClientTime;
            var _local_5:cPlayerData = this.mGeneralInterface.FindPlayerFromId(_arg_1);
            _local_3.zoneVisitorPlayerID = _arg_1;
            _local_3.zoneOwnerPlayerID = this.mGeneralInterface.mHomePlayer.GetPlayerId();
            this.UpdateDiscoveredSectorsForPlayer(_local_5, _arg_1);
            _local_3.buildQueue = new dBuildQueueVO();
            _local_3.buildQueue.maxCount = _local_5.mBuildQueue.GetMaxCount();
            _local_3.buildQueue.permanentSlotsCount = _local_5.GetPermanentBuildQueueSlotsCount();
            for each (_local_6 in _local_5.mBuildQueue.GetQueue_vector())
            {
                _local_3.buildQueue.buildings.addItem(_local_6.CreateBuildingVOFromBuilding());
            };
            for each (_local_7 in this.mGeneralInterface.mCurrentPlayerZone.mSectorList_vector)
            {
                _local_3.sectors.addItem(_local_7.CreateSectorVOFromSector());
            };
            if (_local_3.zoneVisitorPlayerID == _local_3.zoneOwnerPlayerID)
            {
                for each (_local_28 in this.mGeneralInterface.GetPlayerList_vector())
                {
                    _local_29 = _local_28.CreatePlayerVOFromPlayer(false);
                    _local_3.playersOnMap.addItem(_local_29);
                };
            }
            else
            {
                for each (_local_30 in this.mGeneralInterface.GetPlayerList_vector())
                {
                    if (_local_3.zoneVisitorPlayerID == _local_30.GetPlayerId())
                    {
                        _local_31 = _local_30.CreatePlayerVOFromPlayer(false);
                    }
                    else
                    {
                        _local_31 = _local_30.CreatePlayerVOFromPlayer(true);
                    };
                    _local_3.playersOnMap.addItem(_local_31);
                };
            };
            _local_8 = null;
            if (((this.mGeneralInterface.IsAdventureZone()) && (this.mGeneralInterface.mCurrentPlayerZone.GetAdventure().GetAdventureDefinition().UsesCombatThree())))
            {
                _local_8 = this.mGeneralInterface.mCurrentPlayerZone.GetResources(this.mGeneralInterface.mHomePlayer);
            }
            else
            {
                _local_8 = this.mGeneralInterface.mCurrentPlayerZone.GetResources(_local_5);
            };
            if (_local_8 != null)
            {
                _local_3.resourcesVO = _local_8.CreateResourcesVO();
            };
            for each (_local_9 in this.mGeneralInterface.mCurrentPlayerZone.GetSpecialists_vector())
            {
                _local_3.specialists_vector.addItem(_local_9.CreateSpecialistVOFromSpecialist());
            };
            for each (_local_10 in this.mGeneralInterface.mDataTracking.GetTrackingValues())
            {
                _local_3.dataTracking_vector.addItem(_local_10.CreateVO());
            };
            for each (_local_11 in this.mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.GetBuildings_vector())
            {
                if (null != _local_11)
                {
                    _local_3.buildings.addItem(_local_11.CreateBuildingVOFromBuilding());
                };
            };
            for each (_local_12 in this.mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.GetLandscapes_vector())
            {
                if (null != _local_12)
                {
                    if (_local_12.GetLevelEnumObjectType() == OBJECTTYPE.LANDSCAPE)
                    {
                        _local_32 = (_local_12 as cLandscape);
                        _local_3.landscapes.addItem(_local_32.CreateLandscapeVOFromLandscape());
                    }
                    else
                    {
                        _local_33 = (_local_12 as cBuilding);
                        _local_3.buildings.addItem(_local_33.CreateBuildingVOFromBuilding());
                    };
                };
            };
            for each (_local_13 in this.mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.mFreeLandscape_vector)
            {
                _local_3.freeLandscapes.addItem(_local_13.CreateVO());
            };
            for each (_local_14 in this.mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.mOverFogLandscape_vector)
            {
                _local_3.overFogLandscapes.addItem(_local_14.CreateVO());
            };
            for each (_local_15 in this.mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.mLandingFields_vector)
            {
                _local_3.landingFields.addItem(_local_15.CreateVO());
            };
            for each (_local_16 in this.mGeneralInterface.mCombatPersitedPreview.mCombatPreviewPaths)
            {
                _local_3.combatPreviewPaths.addItem(_local_16.CreateVO());
            };
            _local_17 = this.mGeneralInterface.getCurrentUserAchievementManager();
            if (_local_17 != null)
            {
                _local_3.userAchievementData.userID = this.mGeneralInterface.mCurrentPlayer.GetPlayerId();
                _local_17.getAchievementTriggerUpdates(_local_3.userAchievementData.finishedAchievementTriggers, _local_3.userAchievementData.achievementTriggerValueUpdates);
                _local_3.comparedUsersAchievementData = this.mGeneralInterface.getComparedUsersAchievementsData();
            };
            if (this.mGeneralInterface.pickupManager != null)
            {
                _local_3.pickups = this.mGeneralInterface.pickupManager.getPickups();
            };
            if (this.mGeneralInterface.cooldownManager != null)
            {
                _local_3.cooldowns = this.mGeneralInterface.cooldownManager.getList();
            };
            if (this.mGeneralInterface.getCurrentTaskManager() != null)
            {
                _local_3.tasksData = this.mGeneralInterface.getCurrentTaskManager().getTaskTriggerUpdates();
            };
            for each (_local_18 in this.mGeneralInterface.mComputeResourceCreation.mResourceCreation_vector)
            {
                _local_3.resourceCreations.addItem(_local_18.CreateResourceCreationVOFromResourceCreation());
            };
            for each (_local_19 in this.mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.GetDeposits_vector())
            {
                if (((_local_19.GetAccessibleType() == DEPOSIT_ACCESSIBLE_TYPES.ACCESSIBLE) || (_arg_2)))
                {
                    _local_3.deposits.addItem(_local_19.CreateDepositVOFromDeposit());
                };
            };
            for each (_local_20 in this.mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.GetStreets_vector())
            {
                if (null != _local_20)
                {
                    _local_3.streets.addItem(_local_20.CreateStreetVOFromStreet());
                };
            };
            for (_local_21 in this.mGeneralInterface.mCurrentPlayerZone.map_PlayerID_Army)
            {
                _local_34 = gMisc.ParseInt(_local_21);
                _local_3.map_PlayerID_Army[_local_34] = this.mGeneralInterface.mCurrentPlayerZone.GetArmy(_local_34).CreateArmyVO();
            };
            if (_local_3.zoneVisitorPlayerID == _local_3.zoneOwnerPlayerID)
            {
                for each (_local_35 in this.mGeneralInterface.mCurrentPlayerZone.GetProductionQueue_vector())
                {
                    _local_36 = new ArrayCollection();
                    for each (_local_37 in _local_35.mTimedProductions_vector)
                    {
                        _local_38 = _local_37.CreateTimedProductionVO();
                        _local_38.ResetModifiers();
                        this.mGeneralInterface.mCurrentPlayer.notifyPropertyObserver(cAbstractTimedProductionOrder.PRODUCTION_START, _local_37.GetProductionOrder());
                        _local_36.addItem(_local_38);
                    };
                    _local_3.timedProductions_vector.addItem(_local_36);
                };
            };
            var _local_24:int;
            _local_23 = this.mGeneralInterface.mCurrentPlayerZone.mStreetMapMinUsableY;
            while (_local_23 <= this.mGeneralInterface.mCurrentPlayerZone.mStreetMapMaxUsableY)
            {
                _local_24 = ((_local_23 * this.mGeneralInterface.mCurrentPlayerZone.mMapWidth) + this.mGeneralInterface.mCurrentPlayerZone.mStreetMapMinUsableX);
                _local_22 = this.mGeneralInterface.mCurrentPlayerZone.mStreetMapMinUsableX;
                while (_local_22 <= this.mGeneralInterface.mCurrentPlayerZone.mStreetMapMaxUsableX)
                {
                    _local_39 = new dMapValueItemVO();
                    _local_39.mBackgroundBlocking = this.mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.GetBackgroundBlocking(_local_24);
                    _local_39.mSectorId = this.mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.mAdditionalData.get(_local_24, AdditionalDataTSO.Sector);
                    _local_3.mapValues.addItem(_local_39);
                    _local_24++;
                    _local_22++;
                };
                _local_23++;
            };
            _local_24 = 0;
            _local_23 = 0;
            while (_local_23 < this.mGeneralInterface.mCurrentPlayerZone.mBackgoundMapHeight)
            {
                _local_22 = 0;
                while (_local_22 < this.mGeneralInterface.mCurrentPlayerZone.mBackgoundMapWidth)
                {
                    _local_40 = this.mGeneralInterface.mCurrentPlayerZone.mBackgroundDataMap.GetNameFromGrid_string(_local_24);
                    _local_41 = new dBackgroundTileVO();
                    if (_local_40 != null)
                    {
                        _local_41.name_string = _local_40;
                    };
                    _local_3.backgroundTiles.addItem(_local_41);
                    _local_24++;
                    _local_22++;
                };
                _local_23++;
            };
            for each (_local_25 in this.mGeneralInterface.mGameTickCommand_vector)
            {
                if (((_local_25.mode == COMMAND.GAMETICK_REFRESH_COMMAND) || (_local_25.playerID == _local_3.zoneVisitorPlayerID)))
                {
                    _local_3.gameTickCommands_vector.addItem(_local_25);
                };
            };
            _local_3.gameTickRefreshCounter = this.mGeneralInterface.mGameTickRefreshCounter;
            for (_local_26 in this.mGeneralInterface.mCurrentPlayerZone.mHiredTroopsPool)
            {
                _local_42 = new dHiredUnitsVO();
                _local_42.unitType_string = _local_26;
                _local_42.amount = this.mGeneralInterface.mCurrentPlayerZone.mHiredTroopsPool[_local_26];
                _local_3.hiredTroopsPool.addItem(_local_42);
            };
            _local_3.pickupsDataVO.numberOfGeneratedPickups = this.mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.getInitialNbOfPickups(CollectionsConsts.COLLECTIBLE_BUILDING_NORMAL);
            _local_3.eventPickupsDataVO.numberOfGeneratedPickups = this.mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.getInitialNbOfPickups(CollectionsConsts.COLLECTIBLE_BUILDING_EVENT);
            for each (_local_27 in this.mGeneralInterface.mCurrentPlayerZone.ColonyGetAll())
            {
                _local_3.colonies.addItem(_local_27);
            };
            _local_3.zoneBuffs.addAll(this.mGeneralInterface.mZoneBuffManager.getZoneBuffsForPersistence());
            return (_local_3);
        }

        public function UpdateDiscoveredSectorsForPlayer(_arg_1:cPlayerData, _arg_2:int):void
        {
            var _local_3:cPlayerData;
            var _local_4:int;
            var _local_5:cSector;
            if (_arg_2 != this.mGeneralInterface.mHomePlayer.GetPlayerId())
            {
                if (!this.mGeneralInterface.IsAdventureZoneID(this.mGeneralInterface.mCurrentViewedZoneID))
                {
                    _local_4 = 0;
                    while (_local_4 < _arg_1.GetSectorsAmount())
                    {
                        _arg_1.SetSectorDiscovery(_local_4, this.mGeneralInterface.mHomePlayer.GetSectorDiscovery(_local_4));
                        _local_4++;
                    };
                }
                else
                {
                    for each (_local_5 in this.mGeneralInterface.mCurrentPlayerZone.mSectorList_vector)
                    {
                        if (_local_5.mIsExplored)
                        {
                            _arg_1.SetSectorDiscovery(_local_5.GetSectorID(), SECTOR_DISCOVERY_TYPE.EXPLORED);
                        };
                    };
                };
                _local_3 = this.mGeneralInterface.FindPlayerFromId(_arg_2);
                if (_local_3 != null)
                {
                    _local_3.mIsPlayerZone = false;
                };
            }
            else
            {
                _local_3 = this.mGeneralInterface.FindPlayerFromId(_arg_2);
                if (_local_3 != null)
                {
                    _local_3.mIsPlayerZone = true;
                };
            };
        }

        public function FindNewDeposit(_arg_1:String, _arg_2:int, _arg_3:int, _arg_4:int):dFoundDepositVO
        {
            var _local_7:cDepositGroup;
            var _local_10:cDepositGroup;
            var _local_11:int;
            var _local_12:int;
            var _local_13:int;
            var _local_14:int;
            var _local_15:cDepositQuality;
            var _local_5:dFoundDepositVO = new dFoundDepositVO();
            var _local_6:cDeposit = new cDeposit(this.mGeneralInterface);
            var _local_8:Vector.<cDeposit> = new Vector.<cDeposit>();
            var _local_9:Vector.<cDepositGroup> = new Vector.<cDepositGroup>();
            cLog.info((((((((("FindNewDeposit( search:" + _arg_1) + ", playerID:") + _arg_2) + " Failover:") + _arg_3) + " seed:") + _arg_4) + " )"));
            for each (_local_7 in this.mDepositGroups_vector)
            {
                if (_local_7.GetDepositType_string() == _arg_1)
                {
                    _local_6 = this.ChooseNextAccessibleDeposit(_local_7, _arg_2, false);
                    if (_local_6 != null)
                    {
                        _local_8.push(_local_6);
                        _local_9.push(_local_7);
                    };
                };
            };
            cLog.info(((("Found " + _local_8.length) + " possible deposits: ") + _local_8));
            _local_10 = null;
            if (_local_8.length > 0)
            {
                _local_11 = gMisc.GetRandomMinMaxInt(0, (_local_8.length - 1));
                if (_arg_4 > 0)
                {
                    _local_11 = gMisc.getPseudoRandomMinMax(_arg_4, 0, (_local_8.length - 1));
                };
                _local_6 = _local_8[_local_11];
                _local_10 = _local_9[_local_11];
                if (_local_5.exploredDepositResult == EXPLORED_DEPOSIT_RESULT.PENDING)
                {
                    _local_5.exploredDepositResult = EXPLORED_DEPOSIT_RESULT.FOUND;
                };
            }
            else
            {
                _local_6 = null;
                if (_arg_3 > 0)
                {
                    _local_10 = this.mDepositGroups_vector[_arg_3];
                    _local_6 = this.ChooseNextAccessibleDeposit(_local_10, _arg_2, true);
                    if (((!(_local_6 == null)) && (_local_5.exploredDepositResult == EXPLORED_DEPOSIT_RESULT.PENDING)))
                    {
                        _local_5.exploredDepositResult = EXPLORED_DEPOSIT_RESULT.FAIL_OVERRIDE_DEPOSIT_FOUND;
                    };
                    cLog.info(((("Deposit Search Override with groupID: " + _arg_3) + " result=") + _local_6));
                };
                if (_local_6 == null)
                {
                    if (_local_5.exploredDepositResult == EXPLORED_DEPOSIT_RESULT.PENDING)
                    {
                        _local_5.exploredDepositResult = EXPLORED_DEPOSIT_RESULT.ALL_DEPOSITS_ACCESSIBLE;
                    };
                    return (_local_5);
                };
            };
            if (_local_6 != null)
            {
                _local_12 = _local_10.GetAverageAmount();
                _local_13 = gMisc.GetRandomMinMaxInt(1, 100);
                if (_arg_4 > 0)
                {
                    _local_13 = gMisc.getPseudoRandomMinMax(_arg_4, 1, 100);
                };
                _local_14 = 0;
                for each (_local_15 in this.mDepositQualities_vector)
                {
                    if (_local_13 >= _local_15.GetDiceThrow())
                    {
                        _local_14 = _local_15.GetDepositBonus();
                        break;
                    };
                };
                _local_12 = int((_local_12 + ((_local_12 * _local_14) / 100)));
                _local_6.SetAmount(_local_12);
                _local_6.SetMaxAmount(_local_12);
                _local_6.SetAccessibleType(DEPOSIT_ACCESSIBLE_TYPES.ACCESSIBLE);
                _local_5.depositVO = _local_6.CreateDepositVOFromDeposit();
                cLog.info(("Deposit Found! Deposit=" + _local_6));
            };
            return (_local_5);
        }


    }
}
