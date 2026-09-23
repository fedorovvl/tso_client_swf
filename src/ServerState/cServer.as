package ServerState
{
    import converted.bluebyte.tso.quests.logic.QuestManagerStatic;
    import nLib.cLog;
    import Interface.cGeneralInterface;
    import Communication.VO.dFreeLandscapeVO;
    import GO.cLandingField;
    import Communication.VO.dLandingFieldVO;
    import Specialists.cSpecialist;
    import Communication.VO.dSectorVO;
    import MilitarySystem.cArmy;
    import TimedProduction.cTimedProductionUtl;
    import mx.collections.ArrayCollection;
    import Communication.VO.dLandscapeVO;
    import Communication.VO.dDepositVO;
    import Communication.VO.dStreetVO;
    import Communication.VO.dResourceCreationVO;
    import Communication.VO.dSpecialistVO;
    import Communication.VO.dDataTrackingVO;
    import Communication.VO.dGameTickCommandVO;
    import Communication.VO.ColonyVO;
    import Communication.VO.CombatPreviewPathVO;
    import TimedProduction.cTimedProductionQueue;
    import Communication.VO.dPlayerVO;
    import Skill.cSkill;
    import Model.Observers.LevelUpObserver;
    import Model.Observers.PvPLevelObserver;
    import Communication.VO.dArmyVO;
    import Communication.VO.dSquadVO;
    import Communication.VO.dBuildingVO;
    import Communication.VO.dTimedProductionVO;
    import Communication.VO.dMapValueItemVO;
    import Communication.VO.dBackgroundTileVO;
    import GO.cBackground;
    import AdventureSystem.cAdventureDefinition;
    import Communication.VO.dBuffVO;
    import __AS3__.vec.Vector;
    import converted.bluebyte.tso.contentgenerator.logic.ContentGeneratorCategory;
    import Communication.VO.ContentGenerator.ContentGeneratorCategoryVO;
    import TimedProduction.cTimedProduction;
    import Communication.VO.UpdateVO.dAdventureClientInfoVO;
    import com.bluebyte.tso.util.TimeUtil;
    import Interface.cGameInterface;
    import Colony.cColony;
    import Enums.ADVENTURE_MODE;
    import Map.cSector;
    import Enums.DIRTY_INDICATOR;
    import nLib.gMisc;
    import Map.AdditionalDataTSO;
    import Sound.cSoundManager;
    import Enums.FILTER;
    import GameEvent.GameEventManager;
    import Enums.COMMAND;
    import Communication.VO.dUniqueID;
    import flash.utils.Dictionary;
    import Collections.CollectionsConsts;
    import converted.bluebyte.tso.contentgenerator.logic.ContentGeneratorDefinitions;
    import TimedProduction.cAbstractTimedProductionOrder;
    import GUI.ApplicationFacade;
    import GUI.GAME.avatarSelection.AvatarSelectionPanel;
    import com.bluebyte.tso.adventure.logic.AdventureManager;
    import Model.Notifiers.ZoneChannel;
    import Communication.VO.dZoneVO;
    import Communication.VO.dQuestDefinitionContainerVO;
    import GO.cBuilding;
    import Enums.OBJECTTYPE;
    import Communication.VO.dPurchasedShopItemVO;
    import Communication.VO.dTempBuildSlotVO;
    import BuffSystem.cBuff;
    import GO.cStreet;
    import GO.cDepositGroup;
    import Communication.VO.dDepositGroupVO;
    import GO.cLandscape;
    import GO.cDepositQuality;
    import Communication.VO.dDepositQualityVO;
    import GO.cDeposit;
    import __AS3__.vec.*;

    public class cServer 
    {

        private static const dummy1:QuestManagerStatic = null;
        private static const dummy2:cLog = null;

        private var mServerInitialized:Boolean = false;
        private var mGeneralInterface:cGeneralInterface = null;

        public function cServer(_arg_1:cGeneralInterface)
        {
            super();
            this.mGeneralInterface = _arg_1;
        }

        public function CreateOverFogLandscapeFromOverFogLandscapeVO(_arg_1:dFreeLandscapeVO):void
        {
            this.mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.SetLandscapeAtFogPosition(_arg_1.name_string, _arg_1.x, _arg_1.y);
        }

        public function CreateLandingFieldFromLandingFieldVO(_arg_1:dLandingFieldVO):void
        {
            var _local_2:cLandingField = new cLandingField();
            _local_2.SetGrid(_arg_1.grid);
            _local_2.mId = _arg_1.id;
            this.mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.mLandingFields_vector.push(_local_2);
        }

        private function RefreshZoneLocal(_arg_1:dZoneVO, _arg_2:ArrayCollection, _arg_3:dQuestDefinitionContainerVO, _arg_4:Boolean, _arg_5:Boolean, _arg_6:Boolean, _arg_7:Boolean, _arg_8:int, _arg_9:int, _arg_10:Boolean):void
        {
            var _local_11:int;
            var _local_12:int;
            var _local_13:int;
            var _local_16:cSpecialist;
            var _local_18:cPlayerData;
            var _local_19:dSectorVO;
            var _local_20:cResources;
            var _local_21:cArmy;
            var _local_22:String;
            var _local_23:cTimedProductionUtl;
            var _local_24:ArrayCollection;
            var _local_25:dLandscapeVO;
            var _local_26:dDepositVO;
            var _local_27:dStreetVO;
            var _local_28:dFreeLandscapeVO;
            var _local_29:dFreeLandscapeVO;
            var _local_30:dLandingFieldVO;
            var _local_32:dResourceCreationVO;
            var _local_33:cSpecialist;
            var _local_34:dSpecialistVO;
            var _local_35:dSpecialistVO;
            var _local_37:dDataTrackingVO;
            var _local_38:dGameTickCommandVO;
            var _local_39:dGameTickCommandVO;
            var _local_40:Object;
            var _local_41:ColonyVO;
            var _local_42:CombatPreviewPathVO;
            var _local_43:cResourceCreation;
            var _local_44:cTimedProductionQueue;
            var _local_45:dPlayerVO;
            var _local_46:cPlayerData;
            var _local_47:cPlayerData;
            var _local_48:cPlayerData;
            var _local_49:cPlayerData;
            var _local_50:cSkill;
            var _local_51:LevelUpObserver;
            var _local_52:PvPLevelObserver;
            var _local_53:int;
            var _local_54:int;
            var _local_55:dArmyVO;
            var _local_56:cArmy;
            var _local_57:dSquadVO;
            var _local_58:dBuildingVO;
            var _local_59:dTimedProductionVO;
            var _local_60:dMapValueItemVO;
            var _local_61:dBackgroundTileVO;
            var _local_62:cBackground;
            var _local_63:cAdventureDefinition;
            var _local_64:cSpecialist;
            var _local_65:cSpecialist;
            var _local_66:dBuffVO;
            var _local_67:Vector.<ContentGeneratorCategory>;
            var _local_68:ContentGeneratorCategoryVO;
            var _local_69:String;
            var _local_70:Array;
            var _local_71:cTimedProduction;
            var _local_72:dAdventureClientInfoVO;
            var _local_14:* = (!(this.mGeneralInterface.mCurrentPlayerZone.mMapHeight == _arg_1.mapHeight));
            var _local_15:* = (!(this.mGeneralInterface.mCurrentPlayerZone.mMapWidth == _arg_1.mapWidth));
            for each (_local_16 in this.mGeneralInterface.mCurrentPlayerZone.GetSpecialists_vector())
            {
                _local_16.dispose();
            };
            this.mGeneralInterface.mCurrentPlayerZone.GetSpecialists_vector().length = 0;
            // Detach before Init replaces the old map, or Clear empties its containers.
            var oldMap:Object = this.mGeneralInterface.mCurrentPlayerZone.mStreetDataMap;
            if (oldMap != null)
            {
                var oldContainers:Array = [oldMap.mBuildingContainer, oldMap.mDepositContainer,
                    oldMap.mStreetContainer, oldMap.mLandscapeContainer];
                for each (var oldContainer:Object in oldContainers)
                {
                    if (oldContainer == null) continue;
                    for each (var oldObject:Object in oldContainer.mContainer)
                    {
                        var oldIso:GO.cIsoGO = oldObject as GO.cIsoGO;
                        if (oldIso != null)
                        {
                            this.mGeneralInterface.channels.ZONE.removePropertyObserver("FOG_RECALCULATED", oldIso);
                        }
                    }
                }
            }
            if ((((!(_arg_4)) || (_local_14)) || (_local_15)))
            {
                this.mGeneralInterface.mCurrentPlayerZone.Init(_arg_1);
            };
            var _local_17:Vector.<cPlayerData> = new Vector.<cPlayerData>();
            for each (_local_18 in this.mGeneralInterface.GetPlayerList_vector())
            {
                _local_17.push(_local_18);
            };
            TimeUtil._setServerTime(_arg_1.serverTimeStamp);
            TimeUtil._setRealmTimeOffset(_arg_1.realmTimeOffset);
            TimeUtil._setGuildQuestTimeOffset(_arg_1.guildQuestTimeOffset);
            this.mGeneralInterface.lastColonyYieldCalculationTime = _arg_1.lastColonyYieldCalculationTime;
            this.mGeneralInterface.mRefreshZoneIsActive = true;
            this.mGeneralInterface.UsesCombatThreeSet(_arg_10);
            if (_arg_4)
            {
                this.mGeneralInterface.ClearLevelOnTheFly();
            }
            else
            {
                this.mGeneralInterface.ClearLevel();
            };
            this.mGeneralInterface.mCurrentViewedZoneID = _arg_8;
            if (!_arg_7)
            {
                this.mGeneralInterface.ResetPlayerList();
                for each (_local_45 in _arg_1.playersOnMap)
                {
                    _local_48 = new cPlayerData(this.mGeneralInterface);
                    this.CreatePlayerFromPlayerVO(_local_48, _local_45, false);
                    this.mGeneralInterface.AddNewPlayer(_local_48);
                };
                for each (_local_46 in _local_17)
                {
                    _local_49 = this.mGeneralInterface.FindPlayerFromId(_local_46.GetPlayerId());
                    if (_local_49 != null)
                    {
                        _local_46.copyBuffWaitingForServerCount(_local_49);
                        if (_local_46.getSkills() != null)
                        {
                            for each (_local_50 in _local_46.getSkills().getItems_vector())
                            {
                                if (_local_50.isTemporary())
                                {
                                    _local_49.addSkill(_local_50.getVO(), _local_49, this.mGeneralInterface, _local_50.isTemporary());
                                };
                            };
                        };
                    };
                };
                this.mGeneralInterface.mCurrentPlayer = this.mGeneralInterface.FindPlayerFromId(_arg_9);
                _local_47 = this.mGeneralInterface.mHomePlayer;
                this.mGeneralInterface.mHomePlayer = this.mGeneralInterface.FindPlayerFromId(_arg_8);
                if (_arg_9 == _arg_8)
                {
                    _local_51 = new LevelUpObserver((this.mGeneralInterface as cGameInterface));
                    if ((((_local_47.GetPlayerId() == _arg_8) && (!(_local_47.GetPlayerName_string() == ""))) && (_local_47.GetPlayerLevel() < this.mGeneralInterface.mHomePlayer.GetPlayerLevel())))
                    {
                        _local_51.update(this.mGeneralInterface.mHomePlayer, cPlayerData.PLAYER_LEVEL_CHANGED, this.mGeneralInterface.mHomePlayer.GetPlayerLevel());
                    };
                    this.mGeneralInterface.mHomePlayer.addPropertyObserver(cPlayerData.PLAYER_LEVEL_CHANGED, _local_51);
                    _local_52 = new PvPLevelObserver((this.mGeneralInterface as cGameInterface));
                    this.mGeneralInterface.mHomePlayer.addPropertyObserver(cPlayerData.PLAYER_PVP_LEVEL_CHANGED, _local_52);
                };
                if (this.mGeneralInterface.mCurrentPlayer.GetPlayerName_string() == null)
                {
                    this.mGeneralInterface.mCurrentPlayer.SetPlayerName(globalFlash.gui.mAvatar.GetDisplayedPlayerVO().username);
                };
                globalFlash.gui.mFriendsList.AddCurrentPlayer();
            };
            this.mGeneralInterface.mIsDefenseMode = cColony.IsAssignableState(_arg_1.colonyState);
            if (this.mGeneralInterface.mIsDefenseMode)
            {
                globalFlash.gui.mAvatarMessageList.clearAllMessages();
            };
            if (_arg_9 == _arg_8)
            {
                this.mGeneralInterface.mCurrentPlayer.mIsPlayerZone = true;
                this.mGeneralInterface.mCurrentPlayer.mIsAdventureZone = false;
                this.mGeneralInterface.mCurrentPlayer.mIsDefenseMode = false;
                this.mGeneralInterface.mCalculateEconomy = true;
            }
            else
            {
                if (this.mGeneralInterface.IsAdventureZoneID(this.mGeneralInterface.mHomePlayer.GetPlayerId()))
                {
                    this.mGeneralInterface.mCurrentPlayer.mIsPlayerZone = true;
                    this.mGeneralInterface.mCurrentPlayer.mIsAdventureZone = true;
                    this.mGeneralInterface.mCurrentPlayer.mIsDefenseMode = this.mGeneralInterface.mIsDefenseMode;
                    this.mGeneralInterface.mCalculateEconomy = true;
                    this.mGeneralInterface.mCurrentPlayer.mIsColony = cAdventureDefinition.FindAdventureDefinition(_arg_1.adventureName).IsColony();
                    this.mGeneralInterface.mCurrentPlayer.mIsColony = ((this.mGeneralInterface.mCurrentPlayer.mIsColony) || (cAdventureDefinition.FindAdventureDefinition(_arg_1.adventureName).GetMode() == ADVENTURE_MODE.MODE_EXPEDITION));
                }
                else
                {
                    this.mGeneralInterface.mCurrentPlayer.mIsPlayerZone = false;
                    this.mGeneralInterface.mCurrentPlayer.mIsAdventureZone = false;
                    this.mGeneralInterface.mCurrentPlayer.mIsDefenseMode = false;
                    this.mGeneralInterface.mCalculateEconomy = false;
                    this.mGeneralInterface.mCurrentPlayer.mIsColony = false;
                };
            };
            this.mGeneralInterface.mCurrentPlayerZone.mSectorList_vector.length = 0;
            for each (_local_19 in _arg_1.sectors)
            {
                _local_53 = _local_19.playerID;
                if (_arg_7)
                {
                    if (((!(_local_53 == 0)) && (!(_local_53 == -1))))
                    {
                        _local_53 = _arg_8;
                    };
                };
                this.mGeneralInterface.mCurrentPlayerZone.mSectorList_vector.push(new cSector(_local_19.sectorID, _local_53, _local_19.explorePriority, _local_19.cityLevelAtWhichSectorIsActivated, _local_19.isIsland, _local_19.islandDeedType, _local_19.isExplored));
            };
            if (_arg_1.resourcesVO != null)
            {
                _local_20 = _arg_1.resourcesVO.CreateResourcesFromVO(this.mGeneralInterface, this.mGeneralInterface.mCurrentViewedZoneID, this.mGeneralInterface.mCurrentPlayer.GetPlayerId());
            }
            else
            {
                _local_20 = new cResources(this.mGeneralInterface, this.mGeneralInterface.mCurrentViewedZoneID, this.mGeneralInterface.mCurrentPlayer.GetPlayerId());
                _local_20.CreateResourceEntries();
                _local_20.CalculateMaxLimitsForResources(this.mGeneralInterface.mCurrentPlayer.GetPlayerId());
                _local_20.mDirtyIndicator = DIRTY_INDICATOR.CLEAN;
            };
            this.mGeneralInterface.mCurrentPlayerZone.AddResources(_local_20);
            for each (_local_21 in this.mGeneralInterface.mCurrentPlayerZone.map_PlayerID_Army)
            {
                _local_21.DisbandArmy(null);
            };
            for (_local_22 in _arg_1.map_PlayerID_Army)
            {
                _local_54 = gMisc.ParseInt(_local_22);
                _local_55 = (_arg_1.map_PlayerID_Army[_local_54] as dArmyVO);
                _local_56 = this.mGeneralInterface.mCurrentPlayerZone.GetArmy(_local_54);
                for each (_local_57 in _local_55.squads)
                {
                    _local_56.AddSquadVO(_local_57, false);
                };
            };
            _local_23 = new cTimedProductionUtl(this.mGeneralInterface);
            this.mGeneralInterface.mCurrentPlayerZone.clearProductionQueue();
            this.mGeneralInterface.mZoneBuffManager.resetExtraBuildingBuff();
            global.buildingLayerManager.clear();
            if (_arg_2 != null)
            {
                for each (_local_58 in _arg_2)
                {
                    if (_arg_7)
                    {
                        this.CreateBuildingFromBuildingVO(_arg_8, _local_58);
                    }
                    else
                    {
                        this.CreateBuildingFromBuildingVO(_local_58.playerID, _local_58);
                    };
                };
            };
            this.mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.bindEpicWorkyardSubBuildings();
            for each (_local_24 in _arg_1.timedProductions_vector)
            {
                for each (_local_59 in _local_24)
                {
                    _local_59.ResetModifiers();
                    _local_23.continueTimedProduction(_local_59);
                };
            };
            if (globalFlash.gui.mTimedProductionInfoPanel.IsVisible())
            {
                globalFlash.gui.mTimedProductionInfoPanel.Refresh();
            }
            else
            {
                if (globalFlash.gui.mSkillProductionPanel.IsVisible())
                {
                    globalFlash.gui.mSkillProductionPanel.refresh();
                }
                else
                {
                    if (globalFlash.gui.mBarracksInfoPanel.IsVisible())
                    {
                        globalFlash.gui.mBarracksInfoPanel.Refresh();
                    }
                    else
                    {
                        if (globalFlash.gui.mBarracks3InfoPanel.IsVisible())
                        {
                            globalFlash.gui.mBarracks3InfoPanel.Refresh();
                        };
                    };
                };
            };
            globalFlash.gui.mSpecialistTravelPanel.SetBusyOff();
            for each (_local_25 in _arg_1.landscapes)
            {
                this.CreateLandscapeFromLandscapeVO(_local_25);
            };
            for each (_local_26 in _arg_1.deposits)
            {
                this.CreateDepositFromDepositVO(_local_26, _arg_7, false);
            };
            for each (_local_27 in _arg_1.streets)
            {
                this.CreateStreetFromStreetVO(_local_27);
            };
            for each (_local_28 in _arg_1.freeLandscapes)
            {
                this.CreateFreeLandscapeFromFreeLandscapeVO(_local_28);
            };
            for each (_local_29 in _arg_1.overFogLandscapes)
            {
                this.CreateOverFogLandscapeFromOverFogLandscapeVO(_local_29);
            };
            for each (_local_30 in _arg_1.landingFields)
            {
                this.CreateLandingFieldFromLandingFieldVO(_local_30);
            };
            if (_arg_1.userAchievementData.isInitialized())
            {
                this.mGeneralInterface.buildCurrentUserAchievementManager(_arg_1.userAchievementData);
                this.mGeneralInterface.setComparedUsersAchievementManager(_arg_1.comparedUsersAchievementData);
            };
            if (_arg_1.tasksData.isInitialized())
            {
                this.mGeneralInterface.buildTaskManager(_arg_1);
            };
            this.mGeneralInterface.pickupManager.updatePickups(_arg_1.pickups);
            this.mGeneralInterface.cooldownManager.updateFromList(_arg_1.cooldowns);
            this.mGeneralInterface.mEventManager.updateTimes(_arg_1.eventTimes);
            this.mGeneralInterface.mContentGeneratorManager.SetPartsFromVO(_arg_1.contentGeneratorCollectionParts);
            this.mGeneralInterface.genericValueManager.updateFrom(_arg_1.genericValues);
            if (this.mGeneralInterface.mCurrentPlayer.GetHomeZoneId() == _arg_8)
            {
                this.mGeneralInterface.mCurrentPlayer.mBuildQueue.Init(_arg_1.buildQueue);
            };
            var _local_31:int;
            _local_13 = this.mGeneralInterface.mCurrentPlayerZone.mStreetMapMinUsableY;
            while (_local_13 <= this.mGeneralInterface.mCurrentPlayerZone.mStreetMapMaxUsableY)
            {
                _local_11 = ((_local_13 * this.mGeneralInterface.mCurrentPlayerZone.mMapWidth) + this.mGeneralInterface.mCurrentPlayerZone.mStreetMapMinUsableX);
                _local_12 = this.mGeneralInterface.mCurrentPlayerZone.mStreetMapMinUsableX;
                while (_local_12 <= this.mGeneralInterface.mCurrentPlayerZone.mStreetMapMaxUsableX)
                {
                    _local_60 = _arg_1.mapValues[_local_31];
                    this.mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.SetBackgroundBlocking(_local_11, _local_60.mBackgroundBlocking);
                    this.mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.mAdditionalData.set(_local_11, AdditionalDataTSO.Sector, _local_60.mSectorId);
                    _local_11++;
                    _local_31++;
                    _local_12++;
                };
                _local_13++;
            };
            if (!_arg_4)
            {
                _local_11 = 0;
                _local_13 = 0;
                while (_local_13 < this.mGeneralInterface.mCurrentPlayerZone.mBackgoundMapHeight)
                {
                    _local_12 = 0;
                    while (_local_12 < this.mGeneralInterface.mCurrentPlayerZone.mBackgoundMapWidth)
                    {
                        _local_61 = (_arg_1.backgroundTiles[_local_11] as dBackgroundTileVO);
                        _local_62 = null;
                        if (_local_61 != null)
                        {
                            _local_62 = cBackground.CreateFromString(_local_61.name_string, this.mGeneralInterface);
                        };
                        this.mGeneralInterface.mCurrentPlayerZone.mBackgroundDataMap.mMap_list[_local_11] = _local_62;
                        _local_11++;
                        _local_12++;
                    };
                    _local_13++;
                };
            };
            this.mGeneralInterface.mCurrentPlayerZone.mBackgroundDataMap.UpdatePositions();
            this.mGeneralInterface.ZoneUpdateAfterMapRefreshed();
            for each (_local_32 in _arg_1.resourceCreations)
            {
                this.mGeneralInterface.mComputeResourceCreation.CreateResourceCreationFromResourceCreationVO(_local_32);
            };
            if (!_arg_4)
            {
                (this.mGeneralInterface as cGameInterface).UpdateGuiOnZoneLoad();
            };
            this.mGeneralInterface.mCurrentPlayerZone.mZoneColorSchema = null;
            if (_arg_1.adventureName != null)
            {
                this.mGeneralInterface.channels.ZONE.notifyPropertyObserver("VISIT_ADVENTURE", _arg_1);
                _local_63 = cAdventureDefinition.FindAdventureDefinition(_arg_1.adventureName);
                cSoundManager.getInstance().playLoop(_local_63.GetMusic_string());
                this.mGeneralInterface.mCurrentPlayerZone.mZoneColorSchema = _local_63.GetColorSchema();
                if (_local_63.GetColorSchema() != null)
                {
                    gGfxResource.applyFilter(_local_63.GetColorSchema(), this.mGeneralInterface);
                };
            }
            else
            {
                gGfxResource.applyFilter(FILTER.toString(_arg_1.filter), this.mGeneralInterface);
                cSoundManager.getInstance().playLoop();
            };
            this.mGeneralInterface.mZoneBuffManager.loadZoneBuffs(_arg_1.zoneBuffs);
            this.mGeneralInterface.mZoneSpecialistActivityTracker.loadActivity(_arg_1.specialistActivity_vector);
            this.mGeneralInterface.mItemRegistry.RegisterAllItems(_arg_1.itemRegistryEntries);
            this.mGeneralInterface.mReactionManager.activate();
            this.mGeneralInterface.mQuestClientCallbacks.ZoneRefreshed(_arg_8, _arg_4, _arg_5, _arg_1);
            this.mGeneralInterface.mPathFinder.InvalidateAll(this.mGeneralInterface.mCurrentPlayer.GetPlayerId());
            this.mGeneralInterface.mComputeResourceCreation.CalculateProductionPaths(null, true);
            for each (_local_33 in this.mGeneralInterface.mCurrentPlayerZone.GetSpecialists_vector())
            {
                _local_33.dispose();
            };
            this.mGeneralInterface.mCurrentPlayerZone.GetSpecialists_vector().length = 0;
            for each (_local_34 in _arg_1.specialists_vector)
            {
                _local_64 = cSpecialist.CreateSpecialistWithOutTasksFromVO(this.mGeneralInterface, _local_34, false);
                this.mGeneralInterface.mCurrentPlayerZone.addSpecialist(_local_64);
            };
            this.mGeneralInterface.mZoneBuffManager.applyRepeatingEffect();
            for each (_local_35 in _arg_1.specialists_vector)
            {
                _local_65 = this.mGeneralInterface.mCurrentPlayerZone.getSpecialist(_local_35.playerID, _local_35.uniqueID);
                cSpecialist.LoadSpecialistTasks(this.mGeneralInterface, _local_35, false, _local_65);
            };
            if (globalFlash.gui.mSkillTreeWindow.IsVisible())
            {
                globalFlash.gui.mSkillTreeWindow.refresh();
            };
            var _local_36:int;
            for each (_local_37 in _arg_1.dataTracking_vector)
            {
                this.mGeneralInterface.mDataTracking.mDataTrackingItem_vector[_local_36].CreateFromVO(_local_37);
                _local_36++;
            };
            this.mGeneralInterface.mCurrentPlayerZone.SetBackgroundHasChanged(true);
            this.mGeneralInterface.mRefreshZoneIsActive = false;
            if (!this.mServerInitialized)
            {
                this.mServerInitialized = true;
                this.mGeneralInterface.ZoneFinished();
            };
            this.mGeneralInterface.SetClientTime(_arg_1.serverTime);
            this.mGeneralInterface.mLastGameTickRefreshClientTime = _arg_1.lastGameTickRefreshTime;
            if (this.mGeneralInterface.gameEventManager != null)
            {
                this.mGeneralInterface.gameEventManager.dispose();
                this.mGeneralInterface.gameEventManager.createTriggers();
            }
            else
            {
                this.mGeneralInterface.gameEventManager = new GameEventManager();
            };
            for each (_local_38 in this.mGeneralInterface.mGameTickCommand_vector)
            {
                if (_local_38.mode == COMMAND.APPLY_BUFF)
                {
                    this.subtractFromWaitingForServerCount(_local_38.playerID, (_local_38.data.data as dUniqueID), _local_38.data.endGrid);
                }
                else
                {
                    if (_local_38.mode == COMMAND.APPLY_BUFF_LIST)
                    {
                        for each (_local_66 in (_local_38.data.data.buffList as ArrayCollection))
                        {
                            this.subtractFromWaitingForServerCount(_local_38.playerID, new dUniqueID().Init(_local_66.uniqueId1, _local_66.uniqueId2), _local_66.amount);
                        };
                    };
                };
            };
            this.mGeneralInterface.mGameTickCommand_vector.length = 0;
            for each (_local_39 in _arg_1.gameTickCommands_vector)
            {
                this.mGeneralInterface.AddGameTickCommand(_local_39);
            };
            this.mGeneralInterface.mGameTickRefreshCounter = _arg_1.gameTickRefreshCounter;
            this.mGeneralInterface.mCurrentPlayerZone.mHiredTroopsPool = new Dictionary();
            for each (_local_40 in _arg_1.hiredTroopsPool)
            {
                this.mGeneralInterface.mCurrentPlayerZone.mHiredTroopsPool[_local_40.unitType_string] = _local_40.amount;
            };
            if (this.mGeneralInterface.mCurrentPlayer.mIsAdventureZone)
            {
                globalFlash.gui.mHiredTroopsPoolPanel.SetData(this.mGeneralInterface.mCurrentPlayerZone.mHiredTroopsPool);
            }
            else
            {
                globalFlash.gui.mHiredTroopsPoolPanel.Hide();
            };
            global.gameworld = _arg_1.gameWorldName;
            this.mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.setInitialNumberOfPickups(CollectionsConsts.COLLECTIBLE_BUILDING_NORMAL, _arg_1.pickupsDataVO.numberOfGeneratedPickups);
            this.mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.setInitialNumberOfPickups(CollectionsConsts.COLLECTIBLE_BUILDING_EVENT, _arg_1.eventPickupsDataVO.numberOfGeneratedPickups);
            this.mGeneralInterface.mCurrentPlayerZone.ColonyClear();
            for each (_local_41 in _arg_1.colonies)
            {
                this.mGeneralInterface.mCurrentPlayerZone.ColonyAdd(_local_41);
            };
            this.mGeneralInterface.mCombatPersitedPreview = new cCombatPersistedPreview(this.mGeneralInterface);
            for each (_local_42 in _arg_1.combatPreviewPaths)
            {
                this.mGeneralInterface.mCombatPersitedPreview.AddPreviewPath(_local_42);
            };
            if (_arg_1.adventCalendarDoors.length > 0)
            {
                this.mGeneralInterface.mAdventCalendarManager.Init(_arg_1.adventCalendarDoors);
            };
            this.mGeneralInterface.mVotesManager.Init(_arg_1.playerGuildMarketVote);
            this.mGeneralInterface.mVotesManager.SetHistoryVotedShopItems(_arg_1.historyVotedShopItems);
            globalFlash.gui.mGuildWindow.RefreshGuildMarket();
            if (_arg_1.contentGeneratorDefinitions.length > 0)
            {
                _local_67 = new Vector.<ContentGeneratorCategory>();
                for each (_local_68 in _arg_1.contentGeneratorDefinitions)
                {
                    _local_67.push(ContentGeneratorCategory.createCategoryFromVO(_local_68));
                };
                ContentGeneratorDefinitions.setInstance(new ContentGeneratorDefinitions(_local_67));
                globalFlash.gui.mContentGeneratorPanel.updateContentDefinitions();
            };
            if (((!(_arg_7)) && (!(_arg_1.eventToActivate == null))))
            {
                for each (_local_69 in _arg_1.eventToActivate.split(","))
                {
                    if (_local_69.indexOf(":") > 0)
                    {
                        _local_70 = _local_69.split(":");
                        this.mGeneralInterface.mEventManager.StartEvent((this.mGeneralInterface as cGameInterface), _local_70[0], new Number(_local_70[1]), new Number(_local_70[2]), new Number(_local_70[3]), new Number(_local_70[4]), new Number(_local_70[5]));
                    };
                };
            };
            for each (_local_43 in this.mGeneralInterface.mComputeResourceCreation.mResourceCreation_vector)
            {
                this.mGeneralInterface.mCurrentPlayer.notifyPropertyObserver(cResourceCreation.RESOURCE_CREATION_APPLY_MODIFIERS, _local_43);
            };
            for each (_local_44 in this.mGeneralInterface.mCurrentPlayerZone.GetProductionQueue_vector())
            {
                for each (_local_71 in _local_44.mTimedProductions_vector)
                {
                    if (!(_local_71.GetProductionOrder() as cAbstractTimedProductionOrder).isModified())
                    {
                        this.mGeneralInterface.mCurrentPlayer.notifyPropertyObserver(cAbstractTimedProductionOrder.PRODUCTION_START, _local_71.GetProductionOrder());
                    };
                };
            };
            ApplicationFacade.getInstance().sendNotification(AvatarSelectionPanel.ZONE_RECEIVED);
            if (_arg_1.conditionCollection)
            {
                this.mGeneralInterface.mConditionManager.Init(_arg_1.conditionCollection);
            };
            if (((this.mGeneralInterface.IsAdventureZone()) && (cAdventureDefinition.FindAdventureDefinition(this.mGeneralInterface.getAdventureName()).mMaxPlayers > 1)))
            {
                _local_72 = AdventureManager.getInstance().getAdventure(this.mGeneralInterface.mCurrentViewedZoneID);
                if (((!(_local_72 == null)) && (_local_72.ownerPlayerID == this.mGeneralInterface.mCurrentPlayer.getPlayerID())))
                {
                    globalFlash.gui.mChatPanel.joinMyCoopAdventureChatroom(this.mGeneralInterface.mCurrentViewedZoneID);
                }
                else
                {
                    globalFlash.gui.mChatPanel.joinFriendsCoopAdventureChatrom(this.mGeneralInterface.mCurrentViewedZoneID);
                };
            };
            this.mGeneralInterface.channels.ZONE.send(ZoneChannel.ZONE_REFRESHED, this.mGeneralInterface);
        }

        public function CreateBuildingFromBuildingVO(_arg_1:int, _arg_2:dBuildingVO):cBuilding
        {
            var _local_3:int;
            var _local_4:cPlayerData;
            var _local_7:cBuilding;
            var _local_5:int = _arg_2.buildingGrid;
            if (((_arg_2.playerID == -1) || (_arg_2.playerID == 0)))
            {
                _local_3 = _arg_2.playerID;
                _local_4 = null;
            }
            else
            {
                _local_3 = _arg_1;
                _local_4 = this.mGeneralInterface.FindPlayerFromId(_local_3);
            };
            var _local_6:cBuilding = (this.mGeneralInterface.mCurrentPlayerZone.SetAtGridPosition(_local_4, OBJECTTYPE.BUILDING, _arg_2.buildingName_string, _local_5) as cBuilding);
            if ((((_local_6 == null) && (!(this.mGeneralInterface.mCurrentPlayerZone.GetBuildingFromGridPosition(_local_5) == null))) && (this.mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.IsADepletedDeposit(this.mGeneralInterface.mCurrentPlayerZone.GetBuildingFromGridPosition(_local_5)))))
            {
                _local_7 = new cBuilding(this.mGeneralInterface, this.mGeneralInterface.mCurrentViewedZoneID);
                _local_7.SetUniqueId(_arg_2.uniqueId);
                _local_7._setGridRaw(_local_5);
                _local_7.dispose();
                return (null);
            };
            _local_6.setPlayerID(_local_3);
            if (_arg_2.hitPoints == -1)
            {
                _arg_2.hitPoints = _local_6.GetMaxHitPoints();
            };
            _local_6.InitFromVO(_arg_2);
            _local_6.mDirtyIndicator.clean();
            return (_local_6);
        }

        public function CreatePlayerFromPlayerVO(_arg_1:cPlayerData, _arg_2:dPlayerVO, _arg_3:Boolean):void
        {
            var _local_4:String;
            var _local_5:dBuffVO;
            var _local_6:dPurchasedShopItemVO;
            var _local_7:dTempBuildSlotVO;
            _arg_1.InitBaseData(_arg_2.userID, _arg_2.username_string, _arg_2.xp, _arg_2.bonusValipXp, _arg_2.playerLevel, _arg_2.cityLevel, _arg_2.pvpXp, _arg_2.pvpLevel, _arg_2.claimedPvpLevel, _arg_2.pvpModifier, _arg_2.avatarId, _arg_2.uniqueID, _arg_2.canCheat, _arg_2.admiralAmount, _arg_2.generalsAmount, _arg_2.explorersAmount, _arg_2.geologistsAmount, _arg_2.currentMaximumBuildingsCountAll, _arg_2.permanentBuildQueueSlotsCount, _arg_2.colonySlotCountPermanent, _arg_2.colonySlotCountTemp, _arg_2.skills, _arg_2.blackMarketUnlocked);
            _arg_1.SetPremiumUntil(_arg_2.premiumUntil);
            _arg_1.SetPremiumExpireNotified(_arg_2.premiumExpiredNotified);
            _arg_1.mHideHelp = _arg_2.hideHelp;
            for each (_local_4 in _arg_2.knownHelp_vector)
            {
                _arg_1.addKnownHelp(_local_4);
            };
            _arg_1.InitSectorDiscovery(_arg_2.discoveredSectors);
            for each (_local_5 in _arg_2.availableBuffs_vector)
            {
                _arg_1.addBuffNoMergeChecks(cBuff.CreateBuffFromVO(_local_5));
            };
            for each (_local_6 in _arg_2.purchasedShopItems_vector)
            {
                _arg_1.mPurchasedShopItems_vector.push(_local_6);
            };
            for each (_local_7 in _arg_2.availableTempSlots_vector)
            {
                _arg_1.mAvailableTempSlots_vector.push(_local_7);
            };
            if (((_arg_1.mAvailableTempSlots_vector.length > 0) && (_arg_3)))
            {
                _arg_1.mBuildQueue.updateTempSlots();
            };
            _arg_1.setGuildID(_arg_2.guildId);
            _arg_1.setGuildMaxSize(_arg_2.guildMaxSize);
            _arg_1.mLandingZoneID = _arg_2.landingZoneID;
        }

        private function subtractFromWaitingForServerCount(_arg_1:int, _arg_2:dUniqueID, _arg_3:int):void
        {
            var _local_5:cBuff;
            var _local_4:cPlayerData = this.mGeneralInterface.FindPlayerFromId(_arg_1);
            if (_local_4 != null)
            {
                _local_5 = _local_4.getBuffByUniqueID(_arg_2);
                if (_local_5 != null)
                {
                    _arg_3 = ((_arg_3 > 1) ? _arg_3 : 1);
                    _local_5.SetWaitingForServerCount((_local_5.GetWaitingForServerCount() - _arg_3), this.mGeneralInterface);
                };
            };
        }

        public function CreateFreeLandscapeFromFreeLandscapeVO(_arg_1:dFreeLandscapeVO):void
        {
            this.mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.SetLandscapeAtFreePosition(_arg_1.name_string, _arg_1.x, _arg_1.y);
        }

        public function CreateStreetFromStreetVO(_arg_1:dStreetVO):void
        {
            var _local_2:int = _arg_1.grid;
            var _local_3:String = cStreet.CreateStringFromStreetBitField_string(_arg_1.bits);
            var _local_4:cStreet = (this.mGeneralInterface.mCurrentPlayerZone.SetAtGridPosition(this.mGeneralInterface.mCurrentPlayer, OBJECTTYPE.STREET, (defines.STREET_ELEMENT_NAME_string + _local_3), _local_2) as cStreet);
            _local_4.Init(_arg_1.skin, _arg_1.variation, _local_2);
        }

        public function RefreshZone(_arg_1:dZoneVO, _arg_2:Boolean, _arg_3:Boolean, _arg_4:Boolean):void
        {
            this.RefreshZoneLocal(_arg_1, _arg_1.buildings, _arg_1.questDefinitionContainer, _arg_2, _arg_3, _arg_4, false, _arg_1.zoneOwnerPlayerID, _arg_1.zoneVisitorPlayerID, (_arg_1.zoneMapName.indexOf("Expedition") >= 0));
        }

        public function CreateDepositGroupFromDepositGroupVO(_arg_1:dDepositGroupVO):void
        {
            var _local_3:int;
            var _local_2:cDepositGroup = new cDepositGroup(this.mGeneralInterface, _arg_1.mId, _arg_1.mMaxAccessible, _arg_1.mAccessibleFromStart, _arg_1.mAverageAmount, _arg_1.mDepositType_string);
            for each (_local_3 in _arg_1.mDepositsVector)
            {
                _local_2.AddDepositGridIdx(_local_3);
            };
            this.mGeneralInterface.mServerOnly.mDepositGroups_vector.push(_local_2);
        }

        public function CreateLandscapeFromLandscapeVO(_arg_1:dLandscapeVO):void
        {
            var _local_2:int = _arg_1.grid;
            var _local_3:cLandscape = (this.mGeneralInterface.mCurrentPlayerZone.SetAtGridPosition(null, OBJECTTYPE.LANDSCAPE, _arg_1.name_string, _local_2) as cLandscape);
            _local_3.SetName_string(_arg_1.name_string);
            _local_3.SetGrid(_arg_1.grid);
        }

        public function CreateDepositQualityFromDepositQualityVO(_arg_1:dDepositQualityVO):void
        {
            var _local_2:cDepositQuality = new cDepositQuality(_arg_1.depositBonus, _arg_1.diceThrow);
            this.mGeneralInterface.mServerOnly.mDepositQualities_vector.push(_local_2);
        }

        public function CreateDepositFromDepositVO(_arg_1:dDepositVO, _arg_2:Boolean, _arg_3:Boolean):void
        {
            var _local_4:int = _arg_1.gridIdx;
            var _local_5:cDeposit = (this.mGeneralInterface.mCurrentPlayerZone.SetAtGridPosition(this.mGeneralInterface.mCurrentPlayer, OBJECTTYPE.DEPOSIT, ("Deposit" + _arg_1.name_string), _local_4) as cDeposit);
            _local_5.Init(_arg_1.name_string, _local_4, _arg_1.amount, _arg_1.maxAmount, _arg_1.depositGroupdId, _arg_1.accessible, _arg_1.emptied, _arg_1.goSetListName_string, _arg_1.refillable, _arg_1.skills);
            if (_arg_3)
            {
                _local_5.SetAmount(0);
            };
            this.mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.RefreshDepositGfx(_local_4);
        }


    }
}
