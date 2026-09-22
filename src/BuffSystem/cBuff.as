package BuffSystem
{
    import TimedProduction.iTimedProductionItem;
    import Communication.VO.dUniqueID;
    import com.bluebyte.tso.util.TimeUtil;
    import Communication.VO.dBuffVO;
    import Communication.VO.dQuestElementVO;
    import nLib.gMisc;
    import Interface.cGameInterface;
    import Interface.cGeneralInterface;
    import ServerState.cPlayerData;
    import nLib.cLog;
    import Communication.VO.grid.AreaGridVO;
    import GO.cBuilding;
    import __AS3__.vec.Vector;
    import GO.cGO;
    import AdventureSystem.cAdventureDefinition;
    import ServerState.cResources;
    import Communication.VO.ExpeditionMapLevelGroupDataVO;
    import Communication.VO.ExpeditionMapLevelGroupCostVO;
    import MilitarySystem.cSquad;
    import Communication.VO.dBattleBuffTarget;
    import Communication.VO.Guild.dGuildVO;
    import Communication.VO.EffectVO;
    import Skill.cSkillList;
    import Specialists.cSpecialist;
    import GO.cDeposit;
    import ServerState.dResourceCreationDefinition;
    import Enums.CURSOR_VALID;
    import Enums.BUFF_TYPE;
    import Collections.CollectionsConsts;
    import Enums.BUFF_TARGET_ZONE;
    import MilitarySystem.cMilitaryUnitBase;
    import Enums.KILL_SWITCH;
    import Utils.StringUtils;
    import Utils.RequirementsHelper;
    import Collections.CollectionsManager;
    import Trigger.TriggerList;
    import Enums.HALLOWEEN_EVENT;
    import Effects.Effects.RemoveBuff;
    import Map.AdditionalDataTSO;
    import Effects.Effects.SkillPlayer;
    import MilitarySystem.cMilitaryUtil;
    import Specialists.cSpecialistTask_Recover;
    import com.bluebyte.tso.adventure.logic.AdventureManager;
    import GO.epicWorkyard.EpicWorkyardMasterBuilding;
    import Enums.BUFF_TARGET_TYPE;
    import MilitarySystem.cArmy;
    import Map.cSector;
    import Enums.SECTOR_DISCOVERY_TYPE;
    import ServerState.dResource;
    import Enums.AVATAR_MESSAGE_TYPE;
    import Communication.VO.dBuffEfficiencyVO;
    import Enums.DEPOSIT_ACCESSIBLE_TYPES;
    import Effects.Effects.StartQuest;
    import Enums.BUFF_UI;
    import GUI.Loca.cLocaManager;
    import Enums.LOCA_GROUP;
    import MilitarySystem.KillUnitsResult;
    import Enums.BUFF_APPLIANCE_MODE;
    import Enums.ModifyReason;
    import PathFinding.cPathFinder;
    import Tracks.TrackManager;
    import Utils.TriggerUtils;
    import Map.GridPosition;
    import Effects.EffectList;
    import __AS3__.vec.*;

    public class cBuff implements iTimedProductionItem 
    {

        public static const BUFF_APPLY_ERROR:int = 0;
        public static const BUFF_APPLY_SUCCESS:int = 1;
        public static const BUFF_APPLY_ADMIRAL_CHECK_OK:int = 0;
        public static const BUFF_APPLY_ADMIRAL_CHECK_ILLEGAL:int = (1 << 0);
        public static const BUFF_APPLY_ADMIRAL_CHECK_NOT_ENOUGH_MANA:int = (1 << 1);
        public static const BUFF_APPLY_ADMIRAL_CHECK_NOT_STACKABLE:int = (1 << 2);
        public static const BUFF_APPLY_ADMIRAL_CHECK_WRONG_TASK_PHASE:int = (1 << 3);
        public static const BUFF_APPLY_ADMIRAL_CHECK_WRONG_TARGET:int = (1 << 4);
        public static const BUFF_APPLIED_string:String = "buffApplied";
        public static const BUFF_EXPIRED_string:String = "buffExpired";
        public static const BUFF_PRODUCED_string:String = "buffProduced";
        public static const COLLECTION_PRODUCED_string:String = "collectionProduced";
        public static const BUFF_TOTAL_WFSC:String = "buffTotalWaitingForServerCount";
        private static var totalWaitingForServerCount:int = 0;

        private var _sortKeyCache:String = null;
        public var enable:Boolean = true;
        private var mapLevel:int;
        private var removeUnitsAmount:int = 0;
        private var buffDefinition:cBuffDefinition;
        public var active:Boolean = true;
        private var removeUnitsSquadName_string:String = null;
        private var deleted:Boolean;
        private var nextTickTime:Number = 0;
        private var waitingForServerCount:int = 0;
        private var recurrentChance:int;
        public var loading:Boolean = false;
        private var uniqueId:dUniqueID;
        public var index:int = -1;
        private var randomSeed:int;
        private var resourceName_string:String;
        public var amount:int;
        public var insertedAt:uint;
        private var markedAsDeletable:Boolean;
        private var amountAppliedAtLastUsage:int = 0;

        public function cBuff(_arg_1:cBuffDefinition, _arg_2:dUniqueID, _arg_3:int)
        {
            super();
            this.uniqueId = _arg_2;
            this.buffDefinition = _arg_1;
            this.resourceName_string = this.buffDefinition.GetResourceName_string();
            this.amount = this.buffDefinition.GetAmount();
            this.markedAsDeletable = false;
            this.deleted = false;
            this.amount = _arg_3;
            this._sortKeyCache = null;
        }

        public static function getIsAreaBuff(_arg_1:String):Boolean
        {
            return (!(getBuffDefinitionByName(_arg_1).getAreaOffsets() == null));
        }

        public static function CreateBuffFromVO(_arg_1:dBuffVO):cBuff
        {
            var _local_2:cBuffDefinition = getBuffDefinitionByName(_arg_1.buffName_string);
            if (_local_2 == null)
            {
                throw (new Error((("Unkown buff " + _arg_1.buffName_string) + ", could not load buffDefinition!")));
            };
            var _local_3:cBuff = new cBuff(_local_2, dUniqueID.Create(_arg_1.uniqueId1, _arg_1.uniqueId2), _arg_1.amount);
            _local_3.SetResourceName(_arg_1.resourceName_string);
            _local_3.SetRecurrentChance(_arg_1.recurringChance);
            _local_3.SetRandomSeed(_arg_1.randomSeed);
            _local_3.SetMapLevel(_arg_1.mapLevel);
            if (_arg_1.insertedAt > 0)
            {
                _local_3.SetInsertedAt(_arg_1.insertedAt);
            }
            else
            {
                _local_3.SetInsertedAt(TimeUtil.getServerTime());
            };
            return (_local_3);
        }

        public static function getTotalWaitingForServerCount():int
        {
            return (totalWaitingForServerCount);
        }

        public static function getBuffDefinitionByName(_arg_1:String):cBuffDefinition
        {
            return (global.map_BuffName_BuffDefinition[_arg_1]);
        }

        public static function GetProduceableBuffDefinitions(_arg_1:cGameInterface):Array
        {
            var _local_4:cBuffDefinition;
            var _local_2:Array = [];
            var _local_3:dQuestElementVO;
            for each (_local_4 in global.map_BuffName_BuffDefinition)
            {
                if (_local_4.IsProducible())
                {
                    if (((_local_4.isEventProduceable() == _arg_1.mEventManager.isEventStarted(_local_4.RequiredEventName())) && (!(_local_4.isQuestProduceable()))))
                    {
                        _local_2.push(_local_4);
                    }
                    else
                    {
                        if (_local_4.isQuestProduceable())
                        {
                            if (_arg_1.mNewQuestManager.GetQuestPool().IsQuestActiveList(_local_4.GetRequiredQuest()))
                            {
                                _local_2.push(_local_4);
                            };
                        };
                    };
                };
            };
            _local_2.sort(gMisc.sortBuffDefinitionList);
            return (_local_2);
        }

        public static function getBuffDefinitionById(_arg_1:int):cBuffDefinition
        {
            return (global.map_BuffId_BuffDefinition[_arg_1]);
        }

        public static function decTotalWaitingForServerCount(_arg_1:cGeneralInterface):void
        {
            totalWaitingForServerCount--;
            if (_arg_1.channels.BUFF != null)
            {
                _arg_1.channels.BUFF.send(cBuff.BUFF_TOTAL_WFSC, totalWaitingForServerCount);
            };
        }


        public function SetWaitingForServer(_arg_1:cGeneralInterface):void
        {
            this.waitingForServerCount = ((this.amount > 0) ? this.amount : 1);
            totalWaitingForServerCount = (totalWaitingForServerCount + this.waitingForServerCount);
            if (_arg_1.channels.BUFF != null)
            {
                _arg_1.channels.BUFF.send(cBuff.BUFF_TOTAL_WFSC, totalWaitingForServerCount);
            };
        }

        public function GetInstantAmount():int
        {
            return (this.GetAmount() - this.GetWaitingForServerCount());
        }

        public function applyBuffResultToBuff(_arg_1:cPlayerData, _arg_2:cGeneralInterface, _arg_3:int):Boolean
        {
            if (_arg_3 == BUFF_APPLY_ERROR)
            {
                return (false);
            };
            _arg_3 = Math.abs(_arg_3);
            this.amount = (this.amount - _arg_3);
            this.amountAppliedAtLastUsage = _arg_3;
            return (true);
        }

        public function IncWaitingForServerCountBy(_arg_1:cGeneralInterface, _arg_2:int):void
        {
            this.waitingForServerCount = (this.waitingForServerCount + _arg_2);
            totalWaitingForServerCount++;
            if (_arg_1.channels.BUFF != null)
            {
                _arg_1.channels.BUFF.send(cBuff.BUFF_TOTAL_WFSC, totalWaitingForServerCount);
            };
            if (cLog.isInfoEnabled())
            {
                cLog.info(((("IncWaitingForServerCount() of " + this.uniqueId.toString()) + " to ") + this.waitingForServerCount));
            };
        }

        public function GetBuffIconData():Array
        {
            var _local_1:String = this.GetBuffDefinition().GetName_string();
            var _local_2:String = this.GetResourceName_string();
            if (_local_1.indexOf(defines.ADD_RESOURCE_BUFF) == 0)
            {
                return ([defines.RESOURCE_DICTIONARY_RESOURCES, _local_2]);
            };
            if (_local_1 == defines.BUILD_BUILDING_BUFF)
            {
                return ([defines.RESOURCE_DICTIONARY_BUILDINGS, _local_2]);
            };
            if (((_local_1 == defines.ADVENTURE_BUFF) || (_local_1 == defines.HIRED_MILITARY_BUFF)))
            {
                return ([defines.RESOURCE_DICTIONARY_BUFFS, _local_2]);
            };
            if (_local_1.indexOf(defines.CHANGE_COLOR_SCHEME_BUFF) == 0)
            {
                return ([defines.RESOURCE_DICTIONARY_BUFFS, ((defines.CHANGE_COLOR_SCHEME_BUFF + "_") + _local_2)]);
            };
            return ([defines.RESOURCE_DICTIONARY_BUFFS, _local_1]);
        }

        public function SetWaitingForServerCount(_arg_1:int, _arg_2:cGeneralInterface):void
        {
            totalWaitingForServerCount = ((totalWaitingForServerCount + _arg_1) - this.waitingForServerCount);
            this.waitingForServerCount = _arg_1;
            if (this.waitingForServerCount < 0)
            {
                totalWaitingForServerCount = (totalWaitingForServerCount + this.waitingForServerCount);
                this.waitingForServerCount = 0;
            };
            if (_arg_2.channels.BUFF != null)
            {
                _arg_2.channels.BUFF.send(cBuff.BUFF_TOTAL_WFSC, totalWaitingForServerCount);
            };
            if (cLog.isInfoEnabled())
            {
                cLog.info(((("SetWaitingForServerCount() of " + this.uniqueId.toString()) + " to ") + this.waitingForServerCount));
            };
        }

        public function isDeleted():Boolean
        {
            return (this.deleted);
        }

        public function IncWaitingForServerCount(_arg_1:cGeneralInterface):void
        {
            this.IncWaitingForServerCountBy(_arg_1, 1);
        }

        public function GetType():String
        {
            return (this.GetBuffDefinition().GetType());
        }

        public function GetWaitingForServerCount():int
        {
            return (this.waitingForServerCount);
        }

        public function SetResourceName(_arg_1:String):void
        {
            this.resourceName_string = _arg_1;
            this._sortKeyCache = null;
        }

        public function getSuitableAreaBuildingsForGrid(_arg_1:cPlayerData, _arg_2:cGeneralInterface, _arg_3:int):Vector.<cBuilding>
        {
            var _local_6:AreaGridVO;
            var _local_7:cBuilding;
            var _local_8:Object;
            var _local_4:Vector.<cBuilding> = new Vector.<cBuilding>();
            var _local_5:Vector.<AreaGridVO> = new Vector.<AreaGridVO>();
            this.getAreaGrids(_arg_3, _local_5, _arg_2.mCurrentPlayerZone.mMapWidth);
            for each (_local_6 in _local_5)
            {
                _local_7 = _arg_2.mCurrentPlayerZone.mStreetDataMap.mBuildingContainer.get(_local_6.index);
                if (_local_7 != null)
                {
                    _local_8 = this.IsApplyable(_arg_1, _arg_2, _local_6.index);
                    if ((_local_8 is cGO))
                    {
                        _local_4.push(_local_7);
                    };
                };
            };
            return (_local_4);
        }

        public function GetUniqueId():dUniqueID
        {
            return (this.uniqueId);
        }

        public function getName():String
        {
            return (this.getLocalizedBuffName());
        }

        public function IsApplyable(_arg_1:cPlayerData, _arg_2:cGeneralInterface, _arg_3:int):Object
        {
            var _local_4:cBuilding;
            var _local_8:cAdventureDefinition;
            var _local_9:cAdventureDefinition;
            var _local_10:Boolean;
            var _local_11:cResources;
            var _local_12:ExpeditionMapLevelGroupDataVO;
            var _local_13:ExpeditionMapLevelGroupCostVO;
            var _local_14:cBuilding;
            var _local_15:Boolean;
            var _local_16:Array;
            var _local_17:BuffAppliance;
            var _local_18:String;
            var _local_19:Boolean;
            var _local_20:cSquad;
            var _local_21:Vector.<cSquad>;
            var _local_22:Boolean;
            var _local_23:dBattleBuffTarget;
            var _local_24:cSquad;
            var _local_25:dGuildVO;
            var _local_26:EffectVO;
            var _local_27:BuffAppliance;
            var _local_28:String;
            var _local_29:int;
            var _local_30:int;
            var _local_31:cSkillList;
            var _local_32:EffectVO;
            var _local_33:int;
            var _local_34:int;
            var _local_35:cSpecialist;
            var _local_36:cAdventureDefinition;
            var _local_37:int;
            var _local_38:cSpecialist;
            var _local_39:cSpecialist;
            var _local_40:BuffAppliance;
            var _local_41:cDeposit;
            var _local_42:dResourceCreationDefinition;
            var _local_5:String;
            if (_arg_1 == null)
            {
                return (CURSOR_VALID.APPLY_BUFF_NO_PLAYER_SNH);
            };
            if (this.GetBuffDefinition().GetBuffType() == BUFF_TYPE.ZONE_TIMED)
            {
                if ((((!(this.GetBuffDefinition().GetName_string().indexOf(CollectionsConsts.REVEAL_COLLECTIBLES_BUFF) == -1)) && (_arg_2.mCurrentPlayerZone.mStreetDataMap.getCurrentNbOfPickups(CollectionsConsts.COLLECTIBLE_BUILDING_NORMAL) == 0)) && (_arg_2.mCurrentPlayerZone.mStreetDataMap.getCurrentNbOfPickups(CollectionsConsts.COLLECTIBLE_BUILDING_EVENT) == 0)))
                {
                    return (CURSOR_VALID.APPLY_BUFF_NO_BUILDING_AT_POSITION);
                };
                return (BUFF_TYPE.toString(BUFF_TYPE.ZONE_TIMED));
            };
            var _local_6:int = _arg_2.getZoneTypes(_arg_1.GetPlayerId());
            var _local_7:int = this.buffDefinition.GetRedeemable_vector().length;
            if ((_local_6 & this.GetBuffDefinition().getTargetZoneTypes()) == 0)
            {
                if (((_local_7 == 0) || (!((_local_6 & BUFF_TARGET_ZONE.HOME) == BUFF_TARGET_ZONE.HOME))))
                {
                    return (CURSOR_VALID.APPLY_BUFF_NO_PLAYER_SNH);
                };
            };
            if (this.buffDefinition.GetName_string() == defines.HIRED_MILITARY_BUFF)
            {
                if (_local_6 == BUFF_TARGET_ZONE.HOME)
                {
                    return (CURSOR_VALID.APPLY_BUFF_WRONG_ZONE_TYPE);
                };
                if (_local_6 == BUFF_TARGET_ZONE.ADVENTURE)
                {
                    _local_8 = cAdventureDefinition.FindAdventureDefinition(_arg_2.getAdventureName());
                    if (((!(_local_8.UseElite())) && (cMilitaryUnitBase.GetUnitBaseForType(this.resourceName_string).GetIsElite())))
                    {
                        return (CURSOR_VALID.APPLY_BUFF_WRONG_ZONE_TYPE);
                    };
                };
            }
            else
            {
                if (this.buffDefinition.IsAdventure())
                {
                    _local_9 = cAdventureDefinition.FindAdventureDefinition(this.GetResourceName_string());
                    if (_local_9.IsPvE())
                    {
                        _local_10 = true;
                        _local_11 = _arg_2.mCurrentPlayerZone.GetResources(_arg_1);
                        _local_12 = global.expeditionMapLevelGroupVO.GetExpeditionMapLevelGroupDataVO(_local_9.GetLevelRangeExpedition());
                        for each (_local_13 in _local_12.mapStartCost)
                        {
                            if (!_local_11.HasPlayerResource(_local_13.resourceType, _local_13.amount))
                            {
                                _local_10 = false;
                                break;
                            };
                        };
                        if (!_local_10)
                        {
                            return (CURSOR_VALID.APPLY_BUFF_NOT_ENOUGH_RESOURCES);
                        };
                    }
                    else
                    {
                        if (((!(_local_9.UsesCombatThree())) && (_arg_2.killswitch.isLocked(KILL_SWITCH.ADVENTURE_START))))
                        {
                            return (CURSOR_VALID.APPLY_BUFF_TEMPORARILY_BLOCKED);
                        };
                    };
                };
            };
            if (((StringUtils.startsWith(this.buffDefinition.GetName_string(), "IslandDeed")) && (_local_6 == BUFF_TARGET_ZONE.HOME)))
            {
                if (!this.isIslandDeedApplyable(_arg_2, _arg_3))
                {
                    return (CURSOR_VALID.APPLY_BUFF_WRONG_ZONE_TYPE);
                };
                _local_14 = cBuilding.CreateFromString(_arg_1, global.buildingGroup, defines.SPECIAL_WAREHOUSES_NAME_string, _arg_2);
                _local_14.SetGrid(_arg_3);
                return (_local_14);
            };
            if (((this.buffDefinition.isQuestProduceable()) && ((StringUtils.isEmpty(this.buffDefinition.GetRedeemableEventName())) || (RequirementsHelper.checkEvent(_arg_2, this.buffDefinition.GetRedeemableEventName())))))
            {
                if (!_arg_2.mNewQuestManager.GetQuestPool().IsQuestActiveList(this.buffDefinition.GetRequiredQuest()))
                {
                    return (CURSOR_VALID.APPLY_BUFF_TEMPORARILY_BLOCKED);
                };
            };
            switch (this.GetBuffDefinition().GetTargetType())
            {
                case BUFF_TARGET_TYPE.BUILDING:
                    _local_4 = _arg_2.mCurrentPlayerZone.mStreetDataMap.mBuildingContainer.get(_arg_3);
                    if (_local_4 == null)
                    {
                        _local_4 = _arg_2.mCurrentPlayerZone.mStreetDataMap.CheckIfBuildingIsSouthSouthEastAndSouthWest(_arg_3);
                    };
                    if (_local_4 != null)
                    {
                        _local_4 = _local_4.getBuildingSelection();
                    };
                    if (_local_4 == null)
                    {
                        return (CURSOR_VALID.APPLY_BUFF_NO_BUILDING_AT_POSITION);
                    };
                    if (((!(this.GetBuffDefinition().GetName_string().indexOf(CollectionsConsts.REVEAL_FRIENDS_COLLECTIBLES_BUFF) == -1)) && (!(CollectionsManager.getInstance().getBuildingIsCollectible(_local_4.GetBuildingName_string())))))
                    {
                        return (CURSOR_VALID.APPLY_BUFF_NO_BUILDING_AT_POSITION);
                    };
                    if (!TriggerList.instantCheckWithTarget(this.GetBuffDefinition().getApplyConditions(), _arg_2, _local_4.GetGrid()))
                    {
                        return (CURSOR_VALID.APPLY_BUFF_CONDITIONS_NOT_FULFILLED);
                    };
                    _local_15 = true;
                    _local_16 = this.buffDefinition.GetTargetDescription_string().split(",");
                    if ((((_local_7 > 0) && (_arg_2 is cGameInterface)) && (!((_arg_2 as cGameInterface).mEventManager.isEventStarted(this.buffDefinition.GetRedeemableEventName())))))
                    {
                        if ((_local_6 & BUFF_TARGET_ZONE.HOME) == BUFF_TARGET_ZONE.HOME)
                        {
                            _local_16 = [defines.MAYORHOUSE_NAME_string];
                        };
                    };
                    for each (_local_5 in _local_16)
                    {
                        if (this.buffDefinition.GetName_string() == HALLOWEEN_EVENT.BUFF_GHOSTBUSTER)
                        {
                            for each (_local_17 in _local_4.mBuffs_vector)
                            {
                                _local_18 = _local_17.GetBuffDefinition().GetName_string();
                                _local_19 = ((_local_18 == HALLOWEEN_EVENT.BUFF_DARKNESS) || (_local_18 == HALLOWEEN_EVENT.BUFF_HORROR));
                                if (((_local_19) && (_local_5 == "Workyard")))
                                {
                                    return (_local_4);
                                };
                            };
                            return (CURSOR_VALID.APPLY_BUFF_BUILDING_IS_INACTIVE);
                        };
                        if (this.buffDefinition.GetName_string().indexOf("BattleBuffBomb") > -1)
                        {
                            if (!_local_4.GetArmy().HasUnits())
                            {
                                return (CURSOR_VALID.APPLY_BUFF_BANDITS_EMPTY);
                            };
                            if (_local_4.IsEngagedInCombat())
                            {
                                return (CURSOR_VALID.APPLY_BUFF_TEMPORARILY_BLOCKED);
                            };
                            if (((this.buffDefinition.isLimitedPerCamp()) && (_local_4.CheckIfFlagged(defines.BATTLE_BUFF_BOMB_FLAG))))
                            {
                                return (CURSOR_VALID.APPLY_BUFF_MAXIMUM_NUMBER_OF_BUFFS_REACHED_FOR_THIS_BUILDING);
                            };
                        }
                        else
                        {
                            if (((this.buffDefinition.GetName_string().indexOf("BattleBuffKill") > -1) || (this.buffDefinition.GetName_string().indexOf(defines.BATTLE_BUFF_HURT) > -1)))
                            {
                                if (_local_4.IsEngagedInCombat())
                                {
                                    return (CURSOR_VALID.APPLY_BUFF_TEMPORARILY_BLOCKED);
                                };
                                if (((_local_5 == defines.MAYORHOUSE_NAME_string) && (_local_4.GetBuildingName_string() == defines.MAYORHOUSE_NAME_string)))
                                {
                                    return (_local_4);
                                };
                                if (_local_16.lastIndexOf(defines.MAYORHOUSE_NAME_string) != -1) continue;
                                if (!_local_4.GetArmy().HasUnits())
                                {
                                    return (CURSOR_VALID.APPLY_BUFF_BANDITS_EMPTY);
                                };
                                if (((this.buffDefinition.isLimitedPerCamp()) && (((_local_4.CheckIfFlagged(defines.BATTLE_BUFF_KILL_COMBATANT_FLAG)) && (!(this.GetBuffDefinition().HasBattleBuffTarget("RANDOM")))) || ((_local_4.CheckIfFlagged(defines.BATTLE_BUFF_KILL_RANDOM_FLAG)) && (this.GetBuffDefinition().HasBattleBuffTarget("RANDOM"))))))
                                {
                                    return (CURSOR_VALID.APPLY_BUFF_MAXIMUM_NUMBER_OF_BUFFS_REACHED_FOR_THIS_BUILDING);
                                };
                                _local_22 = false;
                                for each (_local_23 in this.buffDefinition.GetBattleBuffTargets())
                                {
                                    if (_local_23.isRandomUnit())
                                    {
                                        _local_22 = true;
                                    }
                                    else
                                    {
                                        if (_local_23.isCombatantType())
                                        {
                                            _local_21 = _local_4.GetArmy().GetSquadsByCombatantType(_local_23.combatantType);
                                            for each (_local_24 in _local_21)
                                            {
                                                if (((!(_local_24 == null)) && (!(_local_24.GetAmount() == 0))))
                                                {
                                                    _local_22 = true;
                                                };
                                            };
                                        }
                                        else
                                        {
                                            _local_20 = _local_4.GetArmy().GetSquad(_local_23.unitType);
                                            if (((!(_local_20 == null)) && (!(_local_20.GetAmount() == 0))))
                                            {
                                                _local_22 = true;
                                            };
                                        };
                                    };
                                };
                                if (!_local_22)
                                {
                                    return (CURSOR_VALID.APPLY_BUFF_UNIT_NOT_AVAILABLE);
                                };
                            };
                        };
                        if (_local_5 == defines.GUILDHOUSE_NAME_string)
                        {
                            if (_local_4.getPlayerID() == _arg_2.mCurrentPlayer.GetPlayerId())
                            {
                                _local_25 = _arg_2.GetCurrentPlayerGuild();
                                if (_local_25 == null)
                                {
                                    return (CURSOR_VALID.APPLY_BUFF_ON_GUILD_HOUSE_PLAYER_IS_NOT_IN_GUILD);
                                };
                                if ((_local_25.maxSize + this.buffDefinition.GetAmount()) > global.guildMaxSizeLimit)
                                {
                                    return (CURSOR_VALID.APPLY_BUFF_ON_GUILD_HOUSE_MAXIMUM_NUMBER_OF_GUILD_MEMBERS_REACHED);
                                };
                            };
                        };
                        if ((((_local_5 == defines.BUFFED_BUILDINGS) && (_local_4.mBuffs_vector.length > 0)) && (_local_4.IsBuildingActive())))
                        {
                            if (this.buffDefinition.GetApplyEffects() == null)
                            {
                                return (_local_4);
                            };
                            for each (_local_26 in this.buffDefinition.GetApplyEffects().list)
                            {
                                if (_local_26.effect_string == RemoveBuff.XML_string)
                                {
                                    if (((_local_26.id == 0) && (!(_local_4.productionBuff == null))))
                                    {
                                        return (_local_4);
                                    };
                                    for each (_local_27 in _local_4.mBuffs_vector)
                                    {
                                        if (_local_27.GetBuffDefinition().GetId() == _local_26.id)
                                        {
                                            return (_local_4);
                                        };
                                    };
                                }
                                else
                                {
                                    return (_local_4);
                                };
                            };
                        };
                        _local_15 = true;
                        if (_local_4.productionBuff != null)
                        {
                            switch (this.buffDefinition.GetBuffType())
                            {
                                case BUFF_TYPE.INSTANT:
                                case BUFF_TYPE.UPGRADE:
                                case BUFF_TYPE.TIMED_HIDDEN:
                                case BUFF_TYPE.PERMANENT:
                                    break;
                                default:
                                    _local_15 = false;
                            };
                        };
                        if (((this.buffDefinition.GetBuffType() == BUFF_TYPE.TIMED_HIDDEN) && (_local_4.hasHiddenTimedBuff(this.buffDefinition))))
                        {
                            _local_15 = false;
                        };
                        if ((((_local_15) && (_local_4.IsBuildingActive())) && (!(_local_4.hasBuff(this.buffDefinition.GetName_string())))))
                        {
                            _local_28 = _local_4.GetBuildingName_string();
                            if (!StringUtils.isNullOrEmpty(this.buffDefinition.GetTargetGroup_string()))
                            {
                                if (cBuffDefinition.targetGroups.groupContains(this.buffDefinition.GetTargetGroup_string(), _local_28))
                                {
                                    if (this.buffDefinition.IsCheckSectorOwner())
                                    {
                                        _local_29 = _arg_2.mCurrentPlayerZone.mStreetDataMap.mAdditionalData.get(_local_4.GetGrid(), AdditionalDataTSO.Sector);
                                        _local_30 = _local_4.mGeneralInterface.mCurrentPlayerZone.GetSectorOwnerPlayerID(_local_29);
                                        if (_local_30 == _arg_1.GetPlayerId())
                                        {
                                            return (_local_4);
                                        };
                                    }
                                    else
                                    {
                                        return (_local_4);
                                    };
                                };
                            }
                            else
                            {
                                if (_local_5.length > 0)
                                {
                                    if (_local_5 == "Brewery")
                                    {
                                        if (((_local_28 == "Brewery") || (_local_28 == "Friary")))
                                        {
                                            return (_local_4);
                                        };
                                    }
                                    else
                                    {
                                        if (_local_5 == "Farmfields")
                                        {
                                            if (((_local_28 == "Farmfield") || (!(_local_28.indexOf("Farmfield_0") == -1))))
                                            {
                                                return (_local_4);
                                            };
                                        }
                                        else
                                        {
                                            if (((_local_5.indexOf(defines.PROVISIONHOUSE_NAME_string) >= 0) && (_local_28 == _local_5)))
                                            {
                                                if (((!(this.buffDefinition.GetName_string().indexOf("AddRecipe") == -1)) && (!(_arg_2.mCurrentPlayer.getSkills() == null))))
                                                {
                                                    _local_31 = _arg_2.mCurrentPlayer.getSkills();
                                                    if (this.buffDefinition.GetApplyEffects() != null)
                                                    {
                                                        for each (_local_32 in this.buffDefinition.GetApplyEffects().list)
                                                        {
                                                            if (((_local_32.effect_string == SkillPlayer.XML_string) && (_local_31.getItemByID(_local_32.id) == null)))
                                                            {
                                                                return (_local_4);
                                                            };
                                                        };
                                                    };
                                                }
                                                else
                                                {
                                                    return (_local_4);
                                                };
                                            }
                                            else
                                            {
                                                if (StringUtils.startsWith(_local_5, defines.DESTROYABLE_MOUNTAIN_string))
                                                {
                                                    _local_33 = _arg_2.mCurrentPlayerZone.mStreetDataMap.mAdditionalData.get(_local_4.GetGrid(), AdditionalDataTSO.Sector);
                                                    _local_34 = _local_4.mGeneralInterface.mCurrentPlayerZone.GetSectorOwnerPlayerID(_local_33);
                                                    if (((_local_34 == _arg_1.GetPlayerId()) && (StringUtils.startsWith(_local_4.GetBuildingName_string(), _local_5))))
                                                    {
                                                        return (_local_4);
                                                    };
                                                }
                                                else
                                                {
                                                    if (_local_5 == "IsUpgradeAllowed")
                                                    {
                                                        if (_local_4.IsUpgradeAllowed(false))
                                                        {
                                                            return (_local_4);
                                                        };
                                                    }
                                                    else
                                                    {
                                                        if (_local_5 == "Workyard")
                                                        {
                                                            if ((((_local_4.isWorkyard()) && (_local_4.IsBuffable())) && (!(_local_4.IsProductionLevelTooLow()))))
                                                            {
                                                                return (_local_4);
                                                            };
                                                        }
                                                        else
                                                        {
                                                            if (_local_5 == "IsUpgradeAllowed")
                                                            {
                                                                if (_local_4.IsUpgradeAllowed(false))
                                                                {
                                                                    return (_local_4);
                                                                };
                                                            }
                                                            else
                                                            {
                                                                if (defines.isGarrison(_local_5))
                                                                {
                                                                    if (((this.buffDefinition.GetName_string() == "RecoverGeneral") || (StringUtils.startsWith(this.buffDefinition.GetName_string(), "LazaretRecoverGeneral"))))
                                                                    {
                                                                        _local_35 = cMilitaryUtil.GetSpecialistFromGarrison(_local_4, _arg_2);
                                                                        if ((((!(_local_35 == null)) && (_local_35.GetSpecialistDescription().isGeneral())) && (_local_35.GetTask() is cSpecialistTask_Recover)))
                                                                        {
                                                                            return (_local_4);
                                                                        };
                                                                        return (CURSOR_VALID.APPLY_BUFF_MAXIMUM_NUMBER_OF_BUFFS_REACHED_FOR_THIS_BUILDING);
                                                                    };
                                                                    if (this.buffDefinition.GetName_string() == "RecoverAdmiral")
                                                                    {
                                                                        _local_36 = cAdventureDefinition.FindAdventureDefinition(AdventureManager.getInstance().getAdventure(_arg_2.mCurrentViewedZoneID).adventureName);
                                                                        _local_37 = global.expeditionMapLevelGroupVO.GetTacticPointsLimit(_local_36.GetLevelRangeExpedition());
                                                                        _local_38 = cMilitaryUtil.GetSpecialistFromGarrison(_local_4, _arg_2);
                                                                        if (((((!(_local_38 == null)) && (_local_38.GetSpecialistDescription().isAdmiral())) && (_local_38.GetTask() is cSpecialistTask_Recover)) && (_arg_2.mCurrentPlayerZone.getResourcesFromCurrentZone().GetResourceAmount("Fish") < _local_37)))
                                                                        {
                                                                            return (_local_4);
                                                                        };
                                                                        return (CURSOR_VALID.APPLY_BUFF_MAXIMUM_NUMBER_OF_BUFFS_REACHED_FOR_THIS_BUILDING);
                                                                    };
                                                                    if (((this.GetRemainingSpaceInGarrison(_local_4, _arg_2) > 0) && (cMilitaryUtil.GetSpecialistFromGarrison(_local_4, _arg_2).GetTask() == null)))
                                                                    {
                                                                        if (this.GetBuffDefinition().GetId() == defines.HIRED_MILITARY_BUFF_ID)
                                                                        {
                                                                            _local_39 = cMilitaryUtil.GetSpecialistFromGarrison(_local_4, _arg_2);
                                                                            if (((!(_local_39 == null)) && (_local_39.GetSpecialistDescription().isGeneral())))
                                                                            {
                                                                                if (_local_39.GetArmy().HasEliteUnits() != cMilitaryUnitBase.GetUnitBaseForType(this.resourceName_string).GetIsElite())
                                                                                {
                                                                                    return (CURSOR_VALID.APPLY_BUFF_UNIT_NOT_AVAILABLE);
                                                                                };
                                                                            };
                                                                        };
                                                                        return (_local_4);
                                                                    };
                                                                    return (CURSOR_VALID.APPLY_BUFF_MAXIMUM_NUMBER_OF_BUFFS_REACHED_FOR_THIS_BUILDING);
                                                                };
                                                                if (_local_5 == defines.ENEMY_BANDIT_CAMP)
                                                                {
                                                                    if (_local_4.GetArmy() != null)
                                                                    {
                                                                        return (_local_4);
                                                                    };
                                                                }
                                                                else
                                                                {
                                                                    if (_local_5 == _local_4.GetBuildingName_string())
                                                                    {
                                                                        return (_local_4);
                                                                    };
                                                                    if ("hasPermanentBuff" == _local_5)
                                                                    {
                                                                        for each (_local_40 in _local_4.GetBuffs())
                                                                        {
                                                                            if (BUFF_TYPE.PERMANENT == _local_40.GetBuffDefinition().GetBuffType())
                                                                            {
                                                                                return (_local_4);
                                                                            };
                                                                        };
                                                                    };
                                                                };
                                                            };
                                                        };
                                                    };
                                                };
                                            };
                                        };
                                    };
                                }
                                else
                                {
                                    return (_local_4);
                                };
                                if (((_local_4.getBuildingSelection() is EpicWorkyardMasterBuilding) && (_local_5 == "EpicWorkyard")))
                                {
                                    return (_local_4);
                                };
                            };
                        };
                    };
                    if (_local_15)
                    {
                        return (CURSOR_VALID.APPLY_BUFF_BUILDING_IS_INACTIVE);
                    };
                    return (CURSOR_VALID.APPLY_BUFF_MAXIMUM_NUMBER_OF_BUFFS_REACHED_FOR_THIS_BUILDING);
                case BUFF_TARGET_TYPE.DEPOSIT:
                    _local_41 = _arg_2.mCurrentPlayerZone.mStreetDataMap.mDepositContainer.get(_arg_3);
                    if (_local_41 == null)
                    {
                        return (CURSOR_VALID.APPLY_BUFF_ON_DEPOSIT_NO_DEPOSIT_HERE);
                    };
                    if (((!(((this.GetResourceName_string().length == 0) && (global.omniSeedException.indexOf(_local_41.GetName_string()) == -1)) || (this.GetResourceName_string() == _local_41.GetName_string()))) || (!(_local_41.IsRefillable()))))
                    {
                        return (CURSOR_VALID.APPLY_BUFF_DEPOSIT_IS_OF_WRONG_TYPE);
                    };
                    _local_4 = _arg_2.mCurrentPlayerZone.mStreetDataMap.mBuildingContainer.get(_arg_3);
                    if (((!(_local_4 == null)) && (!(_local_4.GetResourceCreation() == null))))
                    {
                        _local_42 = _local_4.GetResourceCreation().GetResourceCreationDefinition();
                        if ((((!(_local_42 == null)) && (_local_42.externalResource_string == _local_41.GetName_string())) && (_local_42.amountRemoved == 0)))
                        {
                            return (CURSOR_VALID.APPLY_BUFF_DEPOSIT_IS_OF_WRONG_TYPE);
                        };
                    };
                    return (_local_41);
                case -1:
                    return (_arg_2.mCurrentPlayerZone.mStreetDataMap.GetMayorHouse());
                default:
                    gMisc.Assert(false, ("Could not interpret target type " + this.GetBuffDefinition().GetTargetType()));
                    return (CURSOR_VALID.APPLY_BUFF_COULD_NOT_INTERPRET_TYPE_SNH);
            };
        }

        private function GetRemainingSpaceInGarrison(_arg_1:cBuilding, _arg_2:cGeneralInterface):int
        {
            var _local_5:int;
            var _local_6:cArmy;
            var _local_7:int;
            var _local_3:int = -1;
            var _local_4:cSpecialist = cMilitaryUtil.GetSpecialistFromGarrison(_arg_1, _arg_2);
            if (_local_4 != null)
            {
                _local_5 = _local_4.GetMaxMilitaryUnits();
                _local_6 = _local_4.GetArmy();
                _local_7 = _local_6.GetUnitsCount();
                _local_3 = (_local_5 - _local_7);
            };
            return (_local_3);
        }

        public function SetRecurrentChance(_arg_1:int):void
        {
            this.recurrentChance = _arg_1;
        }

        public function isIslandDeedApplyable(_arg_1:cGeneralInterface, _arg_2:int):Boolean
        {
            var _local_3:int = _arg_1.mCurrentPlayerZone.mStreetDataMap.mAdditionalData.get(_arg_2, AdditionalDataTSO.Sector);
            var _local_4:cSector = _arg_1.mCurrentPlayerZone.mSectorList_vector[_local_3];
            var _local_5:String = ("IslandDeed_" + cSector.getIslandDeedTypeString(_local_4.getIslandDeedType()));
            return ((((((_arg_1.mCurrentViewedZoneID == _arg_1.mCurrentPlayer.GetPlayerId()) && (SECTOR_DISCOVERY_TYPE.isExplored(_arg_1.mCurrentPlayer.GetSectorDiscovery(_local_3)))) && (!(_arg_1.mCurrentPlayer.GetSectorDiscovery(_local_3) == SECTOR_DISCOVERY_TYPE.ACTIVATED_BY_BUFF))) && (_local_4.GetOwnerPlayerID() > -1)) && (_local_4.IsIsland())) && (this.buffDefinition.GetName_string() == _local_5));
        }

        public function GetRandomSeed():int
        {
            return (this.randomSeed);
        }

        public function GetRecurrentChance():int
        {
            return (this.recurrentChance);
        }

        private function RedeemBuff(_arg_1:cGeneralInterface, _arg_2:cGO, _arg_3:int, _arg_4:int):void
        {
            var _local_7:dResource;
            this.amount = (this.amount - _arg_3);
            globalFlash.gui.mAvatarMessageList.AddMessage(AVATAR_MESSAGE_TYPE.BUFF_REDEEMED, null, this.GetBuffDefinition().isPreventDefaultAvatarMessage());
            var _local_5:cPlayerData = _arg_1.FindPlayerFromId(_arg_2.getPlayerID());
            var _local_6:cResources = _arg_1.mCurrentPlayerZone.GetResources(_local_5);
            for each (_local_7 in this.buffDefinition.GetRedeemable_vector())
            {
                _local_6.AddResource(_local_7.name_string, (_local_7.getAmount() * _arg_3), _arg_4, null);
            };
        }

        public function getAreaGrids(_arg_1:int, _arg_2:Vector.<AreaGridVO>, _arg_3:int):void
        {
            var _local_4:Vector.<AreaGridVO>;
            var _local_5:AreaGridVO;
            var _local_6:AreaGridVO;
            if (this.buffDefinition.getAreaOffsets() != null)
            {
                gCalculations.AddGridIdxRectangle(_arg_1, this.buffDefinition.getAreaOffsets().rowOffset, this.buffDefinition.getAreaOffsets().columnOffset, _arg_2, _arg_3);
                if (this.buffDefinition.getRenderAreaRings() > 0)
                {
                    _local_4 = new Vector.<AreaGridVO>();
                    gCalculations.AddGridIdxRectangle(_arg_1, this.buffDefinition.getRenderAreaRings(), this.buffDefinition.getRenderAreaRings(), _local_4, _arg_3);
                    if (_arg_2.length != _local_4.length)
                    {
                        for each (_local_5 in _arg_2)
                        {
                            for each (_local_6 in _local_4)
                            {
                                if (_local_5.index == _local_6.index)
                                {
                                    _local_5.display = 1;
                                    break;
                                };
                            };
                        };
                    };
                };
            };
        }

        public function setDeletable(_arg_1:Boolean):void
        {
            this.markedAsDeletable = _arg_1;
        }

        public function GetAmount():int
        {
            return (this.amount);
        }

        public function SetRandomSeed(_arg_1:int):void
        {
            this.randomSeed = _arg_1;
        }

        public function IsDeletable():Boolean
        {
            return ((this.markedAsDeletable) && (this.buffDefinition.IsDeletable()));
        }

        public function getAmountAppliedOnLastUsage():int
        {
            return (this.amountAppliedAtLastUsage);
        }

        public function SetIndex(_arg_1:int):void
        {
            this.index = _arg_1;
        }

        public function toString():String
        {
            return (((((((((((((((("<cBuff" + " uniqueId='") + this.uniqueId) + "'") + " type='") + BUFF_TYPE.toString(this.buffDefinition.GetBuffType())) + "'") + " resourceName='") + this.resourceName_string) + "'") + " amount='") + this.amount) + "'") + " randomSeed='") + this.GetRandomSeed()) + "'") + "' />");
        }

        public function GetIndex():int
        {
            return (this.index);
        }

        public function markAsDeletable():void
        {
            this.markedAsDeletable = true;
        }

        public function CreateBuffVOFromBuff():dBuffVO
        {
            var _local_1:dBuffVO = new dBuffVO();
            _local_1.uniqueId1 = this.uniqueId.uniqueID1;
            _local_1.uniqueId2 = this.uniqueId.uniqueID2;
            _local_1.buffName_string = this.buffDefinition.GetType();
            _local_1.resourceName_string = this.resourceName_string;
            _local_1.amount = this.amount;
            _local_1.recurringChance = this.recurrentChance;
            _local_1.randomSeed = this.GetRandomSeed();
            _local_1.mapLevel = this.GetMapLevel();
            _local_1.insertedAt = this.GetInsertedAt();
            return (_local_1);
        }

        public function GetInsertedAt():uint
        {
            return (this.insertedAt);
        }

        public function SetAmount(_arg_1:int):void
        {
            this.amount = _arg_1;
        }

        public function SetInsertedAt(_arg_1:uint):void
        {
            this.insertedAt = _arg_1;
        }

        public function getAmount():int
        {
            return (1);
        }

        public function get IsExhausted():Boolean
        {
            return ((this.GetInstantAmount() <= 0) && (this.waitingForServerCount > 0));
        }

        public function GetResourceName_string():String
        {
            return (this.resourceName_string);
        }

        public function isNotMerged():Boolean
        {
            return ((StringUtils.startsWith(this.buffDefinition.GetName_string(), defines.PREMIUM_ACCOUNT_BUFF)) || (StringUtils.startsWith(this.buffDefinition.GetName_string(), "IncreaseMaxBuildingCount")));
        }

        public function HasDeletableFlag():Boolean
        {
            return (this.buffDefinition.IsDeletable());
        }

        public function GetBuffDefinition():cBuffDefinition
        {
            return (this.buffDefinition);
        }

        public function calculateBuffResult(_arg_1:cPlayerData, _arg_2:cGeneralInterface, _arg_3:cGO, _arg_4:int, _arg_5:Object):int
        {
            var _local_12:cDeposit;
            var _local_13:cPlayerData;
            var _local_14:cResources;
            var _local_15:dResource;
            var _local_16:int;
            var _local_17:cBuilding;
            var _local_18:int;
            var _local_19:Boolean;
            var _local_20:int;
            var _local_21:cSpecialist;
            var _local_22:cBuilding;
            var _local_23:dBuffEfficiencyVO;
            var _local_24:cBuilding;
            var _local_25:String;
            var _local_26:dBattleBuffTarget;
            var _local_27:EffectVO;
            var _local_28:cBuilding;
            var _local_29:int;
            var _local_6:String = this.buffDefinition.GetName_string();
            var _local_7:int = _arg_1.GetPlayerId();
            var _local_8:cArmy;
            var _local_9:Vector.<cSquad>;
            var _local_10:Number = 0;
            var _local_11:Number = 0;
            if (!this.GetBuffDefinition().IsAdventure())
            {
                if (StringUtils.startsWith(_local_6, defines.FILL_DEPOSIT_BUFF))
                {
                    _local_12 = (_arg_3 as cDeposit);
                    if ((((!(_local_12 == null)) && (_local_12.GetAccessibleType() == DEPOSIT_ACCESSIBLE_TYPES.ACCESSIBLE)) && (_local_12.IsRefillable())))
                    {
                        if (_arg_4 > this.amount)
                        {
                            _arg_4 = this.amount;
                        };
                        if (_arg_4 > 0)
                        {
                            return (_arg_4);
                        };
                    };
                    return (BUFF_APPLY_ERROR);
                };
                if (StringUtils.startsWith(_local_6, defines.ADD_RESOURCE_BUFF))
                {
                    _local_13 = _arg_2.FindPlayerFromId(_arg_3.getPlayerID());
                    if (_local_13 == null)
                    {
                        return (BUFF_APPLY_ERROR);
                    };
                    _local_14 = _arg_2.mCurrentPlayerZone.GetResources(_local_13);
                    _local_15 = _local_14.GetPlayerResource(this.resourceName_string);
                    if (_local_15 == null)
                    {
                        return (BUFF_APPLY_ERROR);
                    };
                    _local_16 = (_local_15.maxLimit - _local_15.amount);
                    if (_local_16 <= 0)
                    {
                        globalFlash.gui.mAvatarMessageList.AddResourceMessage(this.resourceName_string, AVATAR_MESSAGE_TYPE.USED_RESOURCE_BUFF_LIMIT_REACHED, this, this.GetBuffDefinition().isPreventDefaultAvatarMessage());
                        return (BUFF_APPLY_ERROR);
                    };
                    if (((_local_16 > _arg_4) && (this.amount > _arg_4)))
                    {
                        return (_arg_4);
                    };
                    if (this.amount > _local_16)
                    {
                        return (_local_16);
                    };
                    return (this.amount);
                };
                if (StringUtils.startsWith(_local_6, defines.HIRED_MILITARY_BUFF))
                {
                    _local_17 = (_arg_3 as cBuilding);
                    _local_18 = this.GetRemainingSpaceInGarrison(_local_17, _arg_2);
                    _local_19 = false;
                    if (_local_18 <= 0)
                    {
                        _local_19 = true;
                    }
                    else
                    {
                        if (_arg_4 > this.amount)
                        {
                            _arg_4 = this.amount;
                        };
                        _local_20 = ((_arg_4 > _local_18) ? _local_18 : _arg_4);
                        if (_local_20 == 0)
                        {
                            _local_19 = true;
                        }
                        else
                        {
                            _local_21 = cMilitaryUtil.GetSpecialistFromGarrison(_local_17, _arg_2);
                            if (_local_21 == null)
                            {
                                _local_19 = true;
                            }
                            else
                            {
                                return (_local_20);
                            };
                        };
                    };
                    if (_local_19)
                    {
                        if (cLog.isInfoEnabled())
                        {
                            cLog.info((("Appliance of " + this) + " failed! Could not add troop!"));
                        };
                        return (BUFF_APPLY_ERROR);
                    };
                }
                else
                {
                    if (StringUtils.startsWith(_local_6, "GuildIncreaseSize"))
                    {
                        if (((_arg_2.mCurrentPlayer.GetPlayerId() == _local_7) && (_arg_2.GetCurrentPlayerGuild() == null)))
                        {
                            return (BUFF_APPLY_ERROR);
                        };
                    }
                    else
                    {
                        if (StringUtils.startsWith(_local_6, HALLOWEEN_EVENT.BUFF_HIT_MONSTER))
                        {
                            this.removeUnitsAmount = 0;
                            this.removeUnitsSquadName_string = null;
                            if (_arg_4 > this.amount)
                            {
                                _arg_4 = this.amount;
                            };
                            if (_arg_4 < 1)
                            {
                                return (BUFF_APPLY_ERROR);
                            };
                            _local_22 = (_arg_3 as cBuilding);
                            if (_local_22.mIsEventMonster)
                            {
                                _local_8 = _local_22.GetArmy();
                                _local_9 = _local_8.GetSquads_vector();
                                _local_10 = 0;
                                _local_11 = 0;
                                _local_9.sort(cSquad.SortByCombatPriority);
                                if (_local_9.length > 0)
                                {
                                    this.removeUnitsSquadName_string = _local_9[0].name_string;
                                    _local_11 = _local_9[0].amount;
                                };
                                if (this.removeUnitsSquadName_string != null)
                                {
                                    for each (_local_23 in this.GetBuffDefinition().GetBuffEfficiencies_vector())
                                    {
                                        if (_local_23.buffName.indexOf(this.removeUnitsSquadName_string) != -1)
                                        {
                                            _local_10 = _local_23.efficiency;
                                        };
                                    };
                                }
                                else
                                {
                                    _local_10 = 1;
                                };
                                this.removeUnitsAmount = int((_arg_4 * _local_10));
                                if (this.removeUnitsAmount > _local_11)
                                {
                                    this.removeUnitsAmount = int(_local_11);
                                };
                                if (cLog.isInfoEnabled())
                                {
                                    cLog.info(((((((((("squadAmount: " + _local_11) + ", amountUsed: ") + _arg_4) + ", efficiency: ") + _local_10) + ", removeUnitsAmount: ") + this.removeUnitsAmount) + ", removeUnitsSquadName_string: ") + this.removeUnitsSquadName_string));
                                };
                                if (_arg_4 == 0)
                                {
                                    this.removeUnitsAmount = 0;
                                    this.removeUnitsSquadName_string = null;
                                    return (BUFF_APPLY_ERROR);
                                };
                            }
                            else
                            {
                                if (_local_22.GetBuildingName_string().indexOf(defines.MAYORHOUSE_NAME_string) != -1)
                                {
                                    if (this.CalculateRedeemBuff(_arg_2, _arg_3, _arg_4) == BUFF_APPLY_ERROR)
                                    {
                                        return (BUFF_APPLY_ERROR);
                                    };
                                };
                            };
                            return (_arg_4);
                        };
                        if (_local_6.indexOf(defines.BATTLE_BUFF_HURT) == 0)
                        {
                            this.removeUnitsSquadName_string = null;
                            if (this.amount < 1)
                            {
                                return (BUFF_APPLY_ERROR);
                            };
                            _local_24 = (_arg_3 as cBuilding);
                            if (_local_24.GetBuildingName_string().indexOf(defines.MAYORHOUSE_NAME_string) != -1)
                            {
                                _arg_4 = this.amount;
                                if (this.CalculateRedeemBuff(_arg_2, _arg_3, _arg_4) == BUFF_APPLY_ERROR)
                                {
                                    return (BUFF_APPLY_ERROR);
                                };
                            }
                            else
                            {
                                if (((_arg_5 is String) && (this.buffDefinition.HasBattleBuffTarget((_arg_5 as String)))))
                                {
                                    _local_25 = (_arg_5 as String);
                                    if (_local_24.GetArmy().GetSquad(_local_25) != null)
                                    {
                                        this.removeUnitsSquadName_string = _local_25;
                                    };
                                }
                                else
                                {
                                    _local_8 = _local_24.GetArmy();
                                    _local_9 = new Vector.<cSquad>();
                                    for each (_local_26 in this.buffDefinition.GetBattleBuffTargets())
                                    {
                                        if (_local_8.GetSquad(_local_26.unitType) != null)
                                        {
                                            _local_9.push(_local_8.GetSquad(_local_26.unitType));
                                        };
                                    };
                                    _local_9.sort(cMilitaryUnitBase.SortSquads);
                                    if (_local_9.length > 0)
                                    {
                                        this.removeUnitsSquadName_string = _local_9[0].name_string;
                                        _arg_4 = _local_9[0].amount;
                                    };
                                };
                            };
                            _arg_4 = Math.min(_arg_4, this.amount);
                            return (_arg_4);
                        };
                        if (StringUtils.startsWith(_local_6, defines.QUEST_START_BUFF))
                        {
                            if (this.buffDefinition.GetApplyEffects() != null)
                            {
                                for each (_local_27 in this.buffDefinition.GetApplyEffects().list)
                                {
                                    if (_local_27.effect_string == StartQuest.XML_string)
                                    {
                                        if (_arg_2.mNewQuestManager.getQuest(_local_27.name_string) != null)
                                        {
                                            globalFlash.gui.mAvatarMessageList.AddMessage(AVATAR_MESSAGE_TYPE.QUEST_ALREADY_ACTIVE, _local_27.name_string, this.GetBuffDefinition().isPreventDefaultAvatarMessage());
                                            return (BUFF_APPLY_ERROR);
                                        };
                                    };
                                };
                            };
                            return (1);
                        };
                        if (StringUtils.startsWith(_local_6, "IncreaseMaxBuildingCount"))
                        {
                            return (this.amount);
                        };
                    };
                };
            };
            if (((this.GetBuffDefinition().getBuffUI() == BUFF_UI.STACK_RESOURCE) || (StringUtils.startsWith(this.GetBuffDefinition().GetTargetDescription_string(), "PartyCrashers"))))
            {
                _local_28 = (_arg_3 as cBuilding);
                if (_local_28.GetBuildingName_string().indexOf(defines.MAYORHOUSE_NAME_string) != -1)
                {
                    _local_29 = this.CalculateRedeemBuff(_arg_2, _arg_3, _arg_4);
                    if (_local_29 == BUFF_APPLY_ERROR)
                    {
                        return (BUFF_APPLY_ERROR);
                    };
                    return (_local_29);
                };
                _arg_4 = Math.min(_arg_4, this.amount);
                return (_arg_4);
            };
            return (1);
        }

        public function GetMapLevel():int
        {
            return (this.mapLevel);
        }

        public function get sortKey():String
        {
            if (!this._sortKeyCache)
            {
                this._sortKeyCache = ((((this.buffDefinition.GetBuffType() + "|") + this.buffDefinition.GetName_string()) + "|") + this.GetResourceName_string()).toLowerCase();
            };
            return (this._sortKeyCache);
        }

        public function getLocalizedBuffName():String
        {
            var _local_2:String;
            var _local_1:String = this.buffDefinition.GetType();
            if (_local_1.indexOf(defines.ADVENTURE_BUFF) == 0)
            {
                return (cLocaManager.GetInstance().GetText(LOCA_GROUP.ADVENTURE_NAME, this.resourceName_string));
            };
            if (((!(_local_1.indexOf(defines.BUILD_BUILDING_BUFF) == -1)) || (!(_local_1.indexOf("BuildDefenseModeBuilding") == -1))))
            {
                return (cLocaManager.GetInstance().GetText(LOCA_GROUP.BUILDINGS, this.resourceName_string));
            };
            if ((((!(_local_1.indexOf(defines.PRODUCTIVITY_BUFF) == -1)) || (!(_local_1.indexOf(defines.SPEEDUP_POPULATION_GROWTH_BUFF) == -1))) || (!(_local_1.indexOf(defines.RECRUITING_BUFF) == -1))))
            {
                return (cLocaManager.GetInstance().GetText(LOCA_GROUP.RESOURCES, _local_1));
            };
            if ((((!(_local_1.indexOf(defines.ADD_RESOURCE_BUFF) == -1)) || (!(_local_1.indexOf(defines.FILL_DEPOSIT_BUFF) == -1))) || (!(_local_1.indexOf(defines.HIRED_MILITARY_BUFF) == -1))))
            {
                _local_2 = "";
                if (this.amount > 0)
                {
                    _local_2 = _local_1;
                    if (((_local_1 == defines.FILL_DEPOSIT_BUFF) && (this.resourceName_string == "")))
                    {
                        _local_2 = (_local_2 + "Any");
                    };
                };
                return (cLocaManager.GetInstance().GetText(LOCA_GROUP.RESOURCES, _local_2, [this.amount, this.resourceName_string]));
            };
            if (((!(_local_1.indexOf(defines.CHANGE_COLOR_SCHEME_BUFF) == -1)) && (this.GetResourceName_string())))
            {
                return (cLocaManager.GetInstance().GetText(LOCA_GROUP.RESOURCES, ((_local_1 + "_") + this.GetResourceName_string())));
            };
            return (cLocaManager.GetInstance().GetText(LOCA_GROUP.RESOURCES, _local_1));
        }

        public function getRemoveUnitsAmount():int
        {
            return (this.removeUnitsAmount);
        }

        public function applyBuffResultToZone(playerData:cPlayerData, gi:cGeneralInterface, go:cGO, buffResult:int, additionalData:int):Boolean
        {
            var building:cBuilding;
            var adventureDefinition:cAdventureDefinition;
            var playerResources:cResources;
            var expeditionMapLevelGroupDataVO:ExpeditionMapLevelGroupDataVO;
            var currentCost:ExpeditionMapLevelGroupCostVO;
            var playerResources2:cResources;
            var resourceName:String;
            var deposit:cDeposit;
            var depositGridIdx:int;
            var sectorId:int;
            var ownerPlayerID:int;
            var depositInitialAmount:int;
            var buffAppliedToFriend:Boolean;
            var playerDataOfBuffedBuilding:cPlayerData;
            var applianceModeHalloween:int;
            var days:Number;
            var duration:Number;
            var startTime:Number;
            var endTime:Number;
            var general:cSpecialist;
            var specialists:Vector.<cSpecialist>;
            var specialist:cSpecialist;
            var recoverTask:cSpecialistTask_Recover;
            var admiral:cSpecialist;
            var specialists2:Vector.<cSpecialist>;
            var specialist2:cSpecialist;
            var recoverTask2:cSpecialistTask_Recover;
            var monster:cBuilding;
            var seed:int;
            var max:int;
            var capped_amount:int;
            var result:KillUnitsResult;
            var sqd1:cSquad;
            var rmAmount:int;
            var msg_type:String;
            var squad:cSquad;
            var squads_vector:Vector.<cSquad>;
            var randidx:int;
            var numUnitsToTarget:int;
            var battleBuffTarget:dBattleBuffTarget;
            var i:int;
            var sqd2:cSquad;
            var sqd3:cSquad;
            var friendID:int;
            var areaBuildings:Vector.<cBuilding>;
            var areaBuilding:cBuilding;
            var sectId:int;
            var x:int;
            var y:int;
            var applianceMode:int = BUFF_APPLIANCE_MODE.PLAYER;
            var buffName_string:String = this.buffDefinition.GetName_string();
            building = null;
            var army:cArmy;
            var playerID:int = playerData.GetPlayerId();
            var resources:cResources;
            var isRepeatingApplied:Boolean;
            if (((((!(StringUtils.isEmpty(this.buffDefinition.GetRedeemableEventName()))) && (!(gi.mEventManager.isEventStarted(this.buffDefinition.GetRedeemableEventName())))) && (go is cBuilding)) && ((go as cBuilding).GetBuildingName_string() == defines.MAYORHOUSE_NAME_string)))
            {
                this.RedeemBuff(gi, go, buffResult, ModifyReason.ADD_RESOURCE_BUFF);
                return (true);
            };
            if (((!(this.buffDefinition.GetBuffType() == BUFF_TYPE.ZONE_TIMED)) && (((((((((((((((((StringUtils.startsWith(buffName_string, defines.ADD_RECIPE_BUFF)) || (StringUtils.startsWith(buffName_string, defines.CHANGE_AVATAR_BUFF))) || (StringUtils.startsWith(buffName_string, "ProvisionerBuffLvl"))) || (StringUtils.startsWith(buffName_string, "SpeedUpPopulationGrowth"))) || (StringUtils.startsWith(buffName_string, defines.PRODUCTIVITY_BUFF))) || (StringUtils.startsWith(buffName_string, "PayProductivityBuffLvl"))) || (StringUtils.startsWith(buffName_string, "RecruitingBuffLvl"))) || (StringUtils.startsWith(buffName_string, HALLOWEEN_EVENT.BUFF_HORROR))) || (StringUtils.startsWith(buffName_string, defines.CHANGE_COLOR_SCHEME_BUFF))) || (StringUtils.startsWith(buffName_string, "BookbinderBuffLvl"))) || (StringUtils.startsWith(buffName_string, CollectionsConsts.REVEAL_FRIENDS_COLLECTIBLES_BUFF))) || (StringUtils.startsWith(buffName_string, defines.REMOVE_BUFF_BUFF))) || (StringUtils.startsWith(buffName_string, defines.EMPTY_EFFECT_BUFF))) || (StringUtils.startsWith(buffName_string, defines.EFFECT_BUFF))) || (StringUtils.startsWith(buffName_string, defines.QUEST_START_BUFF))) || (this.buffDefinition.IsChangeDefaultSkinBuff())) || (this.buffDefinition.IsChangeSkinBuff()))))
            {
                if (go.getPlayerID() != playerID)
                {
                    applianceMode = ((additionalData == 1) ? BUFF_APPLIANCE_MODE.FRIEND_OR_GUILD_MEMBER_PREMIUM : BUFF_APPLIANCE_MODE.FRIEND);
                };
                building = (go as cBuilding);
                building.AddBuff(this, applianceMode, building.GetGrid(), 0);
                if (((this.GetBuffDefinition().getBuffUI() == BUFF_UI.STACK_RESOURCE) || (StringUtils.startsWith(this.GetBuffDefinition().GetTargetDescription_string(), "PartyCrashers"))))
                {
                    this.amount = (this.amount - buffResult);
                }
                else
                {
                    this.amount--;
                };
            }
            else
            {
                if (StringUtils.startsWith(buffName_string, "MountainDemolition"))
                {
                    building = (go as cBuilding);
                    if (gi.mCurrentPlayerZone.mStreetDataMap.isSectorOwnedAtGridPosition(building.GetGrid(), playerID))
                    {
                        building.AddBuff(this, applianceMode, building.GetGrid(), 0);
                        this.amount--;
                        return (true);
                    };
                    return (false);
                };
                if (StringUtils.startsWith(buffName_string, "IncreaseMaxBuildingCount"))
                {
                    playerData.IncMaxBuildingCount(this.amount);
                    globalFlash.gui.mAvatarMessageList.AddMessage(AVATAR_MESSAGE_TYPE.INCREASED_MAX_BUILDINGS, this, this.GetBuffDefinition().isPreventDefaultAvatarMessage());
                    globalFlash.gui.mInfoBar.SetBuildingsCount(playerData.mCurrentBuildingsCountAll, playerData.GetMaxBuildingCount());
                    this.amount = 0;
                }
                else
                {
                    if (buffName_string == "BuildingUpgrade")
                    {
                        building = (go as cBuilding);
                        building.Upgrade();
                        this.amount--;
                    }
                    else
                    {
                        if (this.buffDefinition.IsAdventure())
                        {
                            adventureDefinition = cAdventureDefinition.FindAdventureDefinition(this.resourceName_string);
                            if (adventureDefinition.IsPvE())
                            {
                                playerResources = gi.mCurrentPlayerZone.GetResources(playerData);
                                expeditionMapLevelGroupDataVO = global.expeditionMapLevelGroupVO.GetExpeditionMapLevelGroupDataVO(adventureDefinition.GetLevelRangeExpedition());
                                for each (currentCost in expeditionMapLevelGroupDataVO.mapStartCost)
                                {
                                    playerResources.AddResource(currentCost.resourceType, -(currentCost.amount), ModifyReason.ADVENTURE, null);
                                };
                            }
                            else
                            {
                                if (adventureDefinition.IsUsingAdventureSpecificBuffs())
                                {
                                    playerResources2 = gi.mCurrentPlayerZone.GetResources(playerData);
                                    for each (resourceName in adventureDefinition.GetConnectedResources())
                                    {
                                        playerResources2.SetResource(resourceName, 0);
                                    };
                                };
                            };
                            this.amount--;
                        }
                        else
                        {
                            if (StringUtils.startsWith(buffName_string, defines.FILL_DEPOSIT_BUFF))
                            {
                                if (((this.amount == 0) || (buffResult == 0)))
                                {
                                    return (true);
                                };
                                deposit = (go as cDeposit);
                                depositGridIdx = deposit.GetGrid();
                                sectorId = deposit.mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.mAdditionalData.get(depositGridIdx, AdditionalDataTSO.Sector);
                                ownerPlayerID = deposit.mGeneralInterface.mCurrentPlayerZone.GetSectorOwnerPlayerID(sectorId);
                                depositInitialAmount = deposit.GetAmount();
                                if (depositInitialAmount == 0)
                                {
                                    deposit.mGeneralInterface.mPathFinder.InvalidateDepositMatrix(ownerPlayerID, deposit.GetName_string(), cPathFinder.AMOUNT_TYPE_ABOVE_ZERO);
                                };
                                deposit.ChangeAmount(buffResult);
                                if (depositInitialAmount >= deposit.GetMaxAmount())
                                {
                                    deposit.mGeneralInterface.mPathFinder.InvalidateDepositMatrix(ownerPlayerID, deposit.GetName_string(), cPathFinder.AMOUNT_TYPE_BELOW_MAX);
                                };
                                deposit.mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.RefreshDepositGfx(depositGridIdx);
                                this.amountAppliedAtLastUsage = buffResult;
                                globalFlash.gui.mAvatarMessageList.AddMessage(AVATAR_MESSAGE_TYPE.USED_DEPOSIT_BUFF, this, this.GetBuffDefinition().isPreventDefaultAvatarMessage());
                                this.amount = (this.amount - buffResult);
                            }
                            else
                            {
                                if (this.buffDefinition.GetName_string() == defines.HIRED_MILITARY_BUFF)
                                {
                                    building = (go as cBuilding);
                                    this.amountAppliedAtLastUsage = buffResult;
                                    this.amount = (this.amount - buffResult);
                                    buffAppliedToFriend = (!(gi.mCurrentPlayer.GetPlayerId() == building.mPlayerData.GetPlayerId()));
                                    (gi as cGameInterface).hireMilitaryUnits(building.mPlayerData.GetPlayerId(), cMilitaryUtil.GetSpecialistFromGarrison(building, gi), this.resourceName_string, buffResult);
                                    globalFlash.gui.mAvatarMessageList.AddMessage(((buffAppliedToFriend) ? AVATAR_MESSAGE_TYPE.USED_HIRED_TROOP_BUFF_TO_FRIEND : AVATAR_MESSAGE_TYPE.USED_HIRED_TROOP_BUFF), this, this.GetBuffDefinition().isPreventDefaultAvatarMessage());
                                }
                                else
                                {
                                    if (((buffName_string == "GuildIncreaseSize") || (buffName_string == "GuildIncreaseSizePay")))
                                    {
                                        if (gi.GetCurrentPlayerGuild() == null)
                                        {
                                            return (false);
                                        };
                                        globalFlash.gui.mAvatarMessageList.AddMessage(AVATAR_MESSAGE_TYPE.GUILD_INCREASE_SIZE, this, this.GetBuffDefinition().isPreventDefaultAvatarMessage());
                                        this.amount--;
                                    }
                                    else
                                    {
                                        if (StringUtils.startsWith(buffName_string, defines.ADD_RESOURCE_BUFF))
                                        {
                                            if (go.getPlayerID() != playerID)
                                            {
                                                this.amountAppliedAtLastUsage = this.amount;
                                                this.amount = 0;
                                                globalFlash.gui.mAvatarMessageList.AddResourceMessage(this.resourceName_string, AVATAR_MESSAGE_TYPE.USED_RESOURCE_BUFF, this, this.GetBuffDefinition().isPreventDefaultAvatarMessage());
                                                return (true);
                                            };
                                            playerDataOfBuffedBuilding = gi.FindPlayerFromId(go.getPlayerID());
                                            if (playerDataOfBuffedBuilding != null)
                                            {
                                                resources = gi.mCurrentPlayerZone.GetResources(playerDataOfBuffedBuilding);
                                                if (resources.AddResource(this.resourceName_string, buffResult, ModifyReason.ADD_RESOURCE_BUFF, null))
                                                {
                                                    this.amountAppliedAtLastUsage = buffResult;
                                                    this.amount = (this.amount - buffResult);
                                                    if (buffResult == 0)
                                                    {
                                                        globalFlash.gui.mAvatarMessageList.AddResourceMessage(this.resourceName_string, AVATAR_MESSAGE_TYPE.USED_RESOURCE_BUFF_LIMIT_REACHED, this, this.GetBuffDefinition().isPreventDefaultAvatarMessage());
                                                    }
                                                    else
                                                    {
                                                        globalFlash.gui.mAvatarMessageList.AddResourceMessage(this.resourceName_string, AVATAR_MESSAGE_TYPE.USED_RESOURCE_BUFF, this, this.GetBuffDefinition().isPreventDefaultAvatarMessage());
                                                        if (this.resourceName_string == defines.HARD_CURRENCY_RESOURCE_NAME_string)
                                                        {
                                                            TrackManager.getInstance().trackGemAdded(playerDataOfBuffedBuilding, defines.CURRENCY_GEMS, buffResult, resources.GetPlayerResource(defines.HARD_CURRENCY_RESOURCE_NAME_string).amount, "Buff");
                                                        };
                                                    };
                                                }
                                                else
                                                {
                                                    cLog.error((("Appliance of buff " + this.uniqueId) + " failed! Could not add resource!"));
                                                    return (false);
                                                };
                                            };
                                        }
                                        else
                                        {
                                            if (buffName_string == HALLOWEEN_EVENT.BUFF_GHOSTBUSTER)
                                            {
                                                building = (go as cBuilding);
                                                applianceModeHalloween = BUFF_APPLIANCE_MODE.PLAYER;
                                                if (go.getPlayerID() != playerID)
                                                {
                                                    applianceModeHalloween = BUFF_APPLIANCE_MODE.FRIEND;
                                                };
                                                building.AddBuff(this, applianceModeHalloween, building.GetGrid(), 0);
                                                this.amount--;
                                            }
                                            else
                                            {
                                                if (buffName_string == "PermanentBuildQueueSlot")
                                                {
                                                    playerData.IncPermanentBuildSlotsAvailable(1);
                                                    this.amount--;
                                                    globalFlash.gui.mAvatarMessageList.AddMessage(AVATAR_MESSAGE_TYPE.INCREASED_PERMANENT_BUILDSLOT, this, this.GetBuffDefinition().isPreventDefaultAvatarMessage());
                                                    gi.channels.TRADE.send(TriggerUtils.TRADE_QUEUE_SLOT_PROPERTY_NAME, TriggerUtils.TRADE_QUEUE_SLOT_PERMANENT_TYPE_NAME);
                                                }
                                                else
                                                {
                                                    if (StringUtils.startsWith(buffName_string, defines.PREMIUM_ACCOUNT_BUFF))
                                                    {
                                                        this.amount = 0;
                                                        days = this.buffDefinition.getDuration(BUFF_APPLIANCE_MODE.PLAYER);
                                                        duration = ((((days * 24) * 60) * 60) * 1000);
                                                        startTime = gMisc.GetEpochMillis();
                                                        endTime = (startTime + duration);
                                                        if (playerData.GetPremiumUntil() > startTime)
                                                        {
                                                            endTime = (playerData.GetPremiumUntil() + duration);
                                                        };
                                                        playerData.ActivatePremiumAccount(startTime, endTime);
                                                        globalFlash.gui.mZoneBuffPanel.Refresh();
                                                        gi.channels.TRADE.send(TriggerUtils.TRADE_QUEUE_SLOT_PROPERTY_NAME, TriggerUtils.TRADE_QUEUE_SLOT_TEMPORARY_TYPE_NAME);
                                                        globalFlash.gui.mAvatarMessageList.AddMessage(AVATAR_MESSAGE_TYPE.PREMIUM_ACCOUNT_ACTIVATED, this, this.GetBuffDefinition().isPreventDefaultAvatarMessage());
                                                    }
                                                    else
                                                    {
                                                        if (((buffName_string == "RecoverGeneral") || (StringUtils.startsWith(buffName_string, "LazaretRecoverGeneral"))))
                                                        {
                                                            building = (go as cBuilding);
                                                            general = null;
                                                            specialists = gi.mCurrentPlayerZone.GetSpecialists_vector();
                                                            for each (specialist in specialists)
                                                            {
                                                                if (((specialist.GetSpecialistDescription().isRecoveryBuffApplicable()) && (specialist.GetGarrisonGridIdx() == building.GetGrid())))
                                                                {
                                                                    general = specialist;
                                                                    break;
                                                                };
                                                            };
                                                            if (general == null)
                                                            {
                                                                return (false);
                                                            };
                                                            if ((general.GetTask() is cSpecialistTask_Recover))
                                                            {
                                                                recoverTask = (general.GetTask() as cSpecialistTask_Recover);
                                                                recoverTask.Done();
                                                                globalFlash.gui.mAvatarMessageList.AddMessage(AVATAR_MESSAGE_TYPE.GENERAL_RECOVERED, general, this.GetBuffDefinition().isPreventDefaultAvatarMessage());
                                                                this.amount--;
                                                            };
                                                        }
                                                        else
                                                        {
                                                            if (buffName_string == "RecoverAdmiral")
                                                            {
                                                                building = (go as cBuilding);
                                                                admiral = null;
                                                                specialists2 = gi.mCurrentPlayerZone.GetSpecialists_vector();
                                                                for each (specialist2 in specialists2)
                                                                {
                                                                    if (((specialist2.GetSpecialistDescription().isRecoveryBuffApplicable()) && (specialist2.GetGarrisonGridIdx() == building.GetGrid())))
                                                                    {
                                                                        admiral = specialist2;
                                                                        break;
                                                                    };
                                                                };
                                                                if (admiral == null)
                                                                {
                                                                    return (false);
                                                                };
                                                                if ((admiral.GetTask() is cSpecialistTask_Recover))
                                                                {
                                                                    recoverTask2 = (admiral.GetTask() as cSpecialistTask_Recover);
                                                                    recoverTask2.Done();
                                                                    globalFlash.gui.mAvatarMessageList.AddMessage(AVATAR_MESSAGE_TYPE.ADMIRAL_RECOVERED, admiral, this.GetBuffDefinition().isPreventDefaultAvatarMessage());
                                                                    this.amount--;
                                                                };
                                                                gi.mCurrentPlayerZone.getResourcesFromCurrentZone().AddResource("Fish", 1, ModifyReason.RECOVER_ADMIRAL_FISH, null);
                                                            }
                                                            else
                                                            {
                                                                if (StringUtils.startsWith(buffName_string, HALLOWEEN_EVENT.BUFF_HIT_MONSTER))
                                                                {
                                                                    monster = (go as cBuilding);
                                                                    if (this.removeUnitsAmount > 0)
                                                                    {
                                                                        army = monster.GetArmy();
                                                                        army.RemoveUnits(this.removeUnitsSquadName_string, this.removeUnitsAmount);
                                                                    };
                                                                    this.amount = (this.amount - buffResult);
                                                                    globalFlash.gui.mEventMonster.Refresh();
                                                                }
                                                                else
                                                                {
                                                                    if (StringUtils.startsWith(buffName_string, "BattleBuff"))
                                                                    {
                                                                        building = (go as cBuilding);
                                                                        army = building.GetArmy();
                                                                        seed = gi.getSeed();
                                                                        max = army.GetUnitsCount();
                                                                        capped_amount = gMisc.getPseudoRandomMinMax(seed, Math.min(max, Math.max(this.buffDefinition.GetMin(), 1)), Math.min(this.buffDefinition.GetMax(), max));
                                                                        result = new KillUnitsResult();
                                                                        if (StringUtils.startsWith(buffName_string, "BattleBuffBomb"))
                                                                        {
                                                                            for each (sqd1 in army.GetSquads_vector())
                                                                            {
                                                                                rmAmount = int(int(Math.round(((capped_amount * sqd1.GetAmount()) / Number(max)))));
                                                                                army.KillUnits(sqd1.GetType(), rmAmount, result);
                                                                            };
                                                                            globalFlash.gui.mAvatarMessageList.AddMessage(AVATAR_MESSAGE_TYPE.REMOVED_RANDOM_BANDITS, this, this.GetBuffDefinition().isPreventDefaultAvatarMessage());
                                                                            if (this.buffDefinition.isLimitedPerCamp())
                                                                            {
                                                                                building.FlagBandit(defines.BATTLE_BUFF_BOMB_FLAG);
                                                                            };
                                                                            this.amount = (this.amount - buffResult);
                                                                        }
                                                                        else
                                                                        {
                                                                            if (StringUtils.startsWith(buffName_string, "BattleBuffKill"))
                                                                            {
                                                                                msg_type = AVATAR_MESSAGE_TYPE.REMOVED_BANDIT_UNIT;
                                                                                for each (battleBuffTarget in this.buffDefinition.GetBattleBuffTargets())
                                                                                {
                                                                                    if (battleBuffTarget.isRandomUnit())
                                                                                    {
                                                                                        squads_vector = army.GetSquads_vector();
                                                                                        numUnitsToTarget = battleBuffTarget.getNumUnitsToTarget(squads_vector.length, seed);
                                                                                        msg_type = AVATAR_MESSAGE_TYPE.REMOVED_RANDOM_BANDIT_UNIT;
                                                                                        if (this.buffDefinition.isLimitedPerCamp())
                                                                                        {
                                                                                            building.FlagBandit(defines.BATTLE_BUFF_KILL_RANDOM_FLAG);
                                                                                        };
                                                                                    }
                                                                                    else
                                                                                    {
                                                                                        if (battleBuffTarget.isCombatantType())
                                                                                        {
                                                                                            squads_vector = building.GetArmy().GetSquadsByCombatantType(battleBuffTarget.combatantType);
                                                                                            msg_type = AVATAR_MESSAGE_TYPE.REMOVED_BANDIT_UNIT;
                                                                                            numUnitsToTarget = battleBuffTarget.getNumUnitsToTarget(squads_vector.length, seed);
                                                                                            if (this.buffDefinition.isLimitedPerCamp())
                                                                                            {
                                                                                                building.FlagBandit(defines.BATTLE_BUFF_KILL_COMBATANT_FLAG);
                                                                                            };
                                                                                        }
                                                                                        else
                                                                                        {
                                                                                            squad = building.GetArmy().GetSquad(battleBuffTarget.unitType);
                                                                                            squads_vector = new Vector.<cSquad>();
                                                                                            msg_type = AVATAR_MESSAGE_TYPE.REMOVED_BANDIT_UNIT;
                                                                                            squads_vector.push(squad);
                                                                                            numUnitsToTarget = 1;
                                                                                        };
                                                                                    };
                                                                                    squads_vector.sort(cSquad.SortByCombatPriority);
                                                                                    i = 0;
                                                                                    while (i < numUnitsToTarget)
                                                                                    {
                                                                                        randidx = gMisc.getPseudoRandomMinMax(seed, 0, (squads_vector.length - 1));
                                                                                        squad = squads_vector[randidx];
                                                                                        squads_vector.splice(randidx, 1);
                                                                                        if (((!(squad == null)) && (!(squad.GetAmount() == 0))))
                                                                                        {
                                                                                            army.KillUnits(squad.GetType(), squad.GetAmount(), result);
                                                                                            globalFlash.gui.mAvatarMessageList.AddMessage(msg_type, this, this.GetBuffDefinition().isPreventDefaultAvatarMessage());
                                                                                        };
                                                                                        i = (i + 1);
                                                                                    };
                                                                                };
                                                                                if (result.amount > 0)
                                                                                {
                                                                                    this.amount = (this.amount - buffResult);
                                                                                };
                                                                            }
                                                                            else
                                                                            {
                                                                                if (StringUtils.startsWith(buffName_string, "BattleBuffDestroy"))
                                                                                {
                                                                                    if (army.GetSquads_vector().length == 0)
                                                                                    {
                                                                                        result.amount = 1;
                                                                                    }
                                                                                    else
                                                                                    {
                                                                                        for each (sqd2 in army.GetSquads_vector())
                                                                                        {
                                                                                            army.KillUnits(sqd2.GetType(), sqd2.GetAmount(), result);
                                                                                        };
                                                                                    };
                                                                                    this.amount = (this.amount - buffResult);
                                                                                    if (this.buffDefinition.GetAvatarMessageOverride_string() != "default")
                                                                                    {
                                                                                        globalFlash.gui.mAvatarMessageList.AddMessage(this.buffDefinition.GetAvatarMessageOverride_string(), this, this.GetBuffDefinition().isPreventDefaultAvatarMessage());
                                                                                    }
                                                                                    else
                                                                                    {
                                                                                        globalFlash.gui.mAvatarMessageList.AddMessage(AVATAR_MESSAGE_TYPE.REMOVED_BANDIT_CAMP, this, this.GetBuffDefinition().isPreventDefaultAvatarMessage());
                                                                                    };
                                                                                }
                                                                                else
                                                                                {
                                                                                    if (StringUtils.startsWith(buffName_string, defines.BATTLE_BUFF_HURT))
                                                                                    {
                                                                                        this.amount = (this.amount - buffResult);
                                                                                        sqd3 = army.GetSquad(this.removeUnitsSquadName_string);
                                                                                        if (sqd3 != null)
                                                                                        {
                                                                                            army.KillUnits(sqd3.GetType(), buffResult, result);
                                                                                        };
                                                                                        globalFlash.gui.mAvatarMessageList.AddMessage(AVATAR_MESSAGE_TYPE.BUFF_ADVENTURE_APPLIED, this.buffDefinition, this.GetBuffDefinition().isPreventDefaultAvatarMessage());
                                                                                    };
                                                                                };
                                                                            };
                                                                        };
                                                                        if (result.amount == 0)
                                                                        {
                                                                            return (false);
                                                                        };
                                                                        playerData.AddXP(result.xp);
                                                                        playerData.AddPvPXp(result.pvpXp);
                                                                        if (army.GetUnitsCount() == 0)
                                                                        {
                                                                            building.DamageBuilding(building.GetCurrentHitPoints(), playerData);
                                                                        }
                                                                        else
                                                                        {
                                                                            building.flagDirtyModified();
                                                                            army.ApplyArmyVO(army.CreateArmyVO());
                                                                        };
                                                                    }
                                                                    else
                                                                    {
                                                                        if (((!(this.buffDefinition.GetBuffType() == BUFF_TYPE.ZONE_TIMED)) && (StringUtils.startsWith(this.buffDefinition.GetTargetDescription_string(), "EpicWorkyard"))))
                                                                        {
                                                                            if (go.getPlayerID() != playerID)
                                                                            {
                                                                                applianceMode = ((playerData.hasActivePremiumAccount()) ? BUFF_APPLIANCE_MODE.FRIEND_OR_GUILD_MEMBER_PREMIUM : BUFF_APPLIANCE_MODE.FRIEND);
                                                                            };
                                                                            building = (go as cBuilding);
                                                                            building = building.getBuildingSelection();
                                                                            building.AddBuff(this, applianceMode, building.GetGrid(), 0);
                                                                            this.amount--;
                                                                        }
                                                                        else
                                                                        {
                                                                            if ("EasterEggHunt" == buffName_string)
                                                                            {
                                                                                friendID = go.getPlayerID();
                                                                                this.amount--;
                                                                            }
                                                                            else
                                                                            {
                                                                                if (CollectionsManager.getInstance().getBuffIsCollectibleLootBuff(buffName_string))
                                                                                {
                                                                                    if (go.getPlayerID() != playerID)
                                                                                    {
                                                                                        applianceMode = BUFF_APPLIANCE_MODE.FRIEND;
                                                                                    };
                                                                                    building = (go as cBuilding);
                                                                                    building.AddBuff(this, applianceMode, building.GetGrid(), 0);
                                                                                    this.amount--;
                                                                                }
                                                                                else
                                                                                {
                                                                                    if (getIsAreaBuff(buffName_string))
                                                                                    {
                                                                                        if (go.getPlayerID() != playerID)
                                                                                        {
                                                                                            applianceMode = ((playerData.hasActivePremiumAccount()) ? BUFF_APPLIANCE_MODE.FRIEND_OR_GUILD_MEMBER_PREMIUM : BUFF_APPLIANCE_MODE.FRIEND);
                                                                                        };
                                                                                        building = (go as cBuilding);
                                                                                        if (!this.buffDefinition.isIgnoreAreaOrigin())
                                                                                        {
                                                                                            building.AddBuff(this, applianceMode, building.GetGrid(), 0);
                                                                                        };
                                                                                        areaBuildings = this.getSuitableAreaBuildingsForGrid(playerData, gi, building.GetGrid());
                                                                                        for each (areaBuilding in areaBuildings)
                                                                                        {
                                                                                            areaBuilding.AddBuff(this, applianceMode, areaBuilding.GetGrid(), 0);
                                                                                        };
                                                                                        this.amount--;
                                                                                    }
                                                                                    else
                                                                                    {
                                                                                        if (StringUtils.startsWith(buffName_string, "IslandDeed_"))
                                                                                        {
                                                                                            this.amount--;
                                                                                            building = (go as cBuilding);
                                                                                            sectId = gi.mCurrentPlayerZone.mStreetDataMap.mAdditionalData.get(building.GetGrid(), AdditionalDataTSO.Sector);
                                                                                            if (sectId >= defines.MAIN_ISLAND_SECTORS)
                                                                                            {
                                                                                                playerData.SetSectorDiscovery(sectId, SECTOR_DISCOVERY_TYPE.ACTIVATED_BY_BUFF);
                                                                                                globalFlash.gui.mAvatarMessageList.AddMessage(AVATAR_MESSAGE_TYPE.UNLOCKED_ISLAND_BY_BUFF, this, this.GetBuffDefinition().isPreventDefaultAvatarMessage());
                                                                                            };
                                                                                        }
                                                                                        else
                                                                                        {
                                                                                            this.amount = (this.amount - buffResult);
                                                                                        };
                                                                                    };
                                                                                };
                                                                            };
                                                                        };
                                                                    };
                                                                };
                                                            };
                                                        };
                                                    };
                                                };
                                            };
                                        };
                                    };
                                };
                            };
                        };
                    };
                };
            };
            if (this.buffDefinition.GetBuffType() == BUFF_TYPE.ZONE_TIMED)
            {
                if (((gi.mCurrentViewedZoneID <= defines.ADVENTUREZONEID) && (!(playerData.getPlayerID() == gi.mCurrentPlayer.getPlayerID()))))
                {
                    globalFlash.gui.mAvatarMessageList.AddMessage(AVATAR_MESSAGE_TYPE.FRIEND_USED_ZONE_BUFF, this, this.GetBuffDefinition().isPreventDefaultAvatarMessage());
                }
                else
                {
                    if (((gi.mHomePlayer.getPlayerID() == playerData.getPlayerID()) && (playerData.getPlayerID() == gi.mCurrentPlayer.getPlayerID())))
                    {
                        globalFlash.gui.mAvatarMessageList.AddMessage(AVATAR_MESSAGE_TYPE.USED_ZONE_BUFF, this, this.GetBuffDefinition().isPreventDefaultAvatarMessage());
                    }
                    else
                    {
                        if (gi.mCurrentPlayer.getPlayerID() == gi.mHomePlayer.getPlayerID())
                        {
                            globalFlash.gui.mAvatarMessageList.AddMessage(AVATAR_MESSAGE_TYPE.FRIEND_USED_ZONE_BUFF, this, this.GetBuffDefinition().isPreventDefaultAvatarMessage());
                        }
                        else
                        {
                            if (playerData.getPlayerID() == gi.mCurrentPlayer.getPlayerID())
                            {
                                if (gi.mCurrentViewedZoneID <= defines.ADVENTUREZONEID)
                                {
                                    globalFlash.gui.mAvatarMessageList.AddMessage(AVATAR_MESSAGE_TYPE.USED_ZONE_BUFF, this, this.GetBuffDefinition().isPreventDefaultAvatarMessage());
                                }
                                else
                                {
                                    globalFlash.gui.mAvatarMessageList.AddMessage(AVATAR_MESSAGE_TYPE.USED_ZONE_BUFF_ON_FRIEND, this, this.GetBuffDefinition().isPreventDefaultAvatarMessage());
                                };
                            };
                        };
                    };
                };
                if (((!(playerData.getPlayerID() == gi.mHomePlayer.getPlayerID())) && (gi.mCurrentViewedZoneID > defines.ADVENTUREZONEID)))
                {
                    if (additionalData == 1)
                    {
                        applianceMode = BUFF_APPLIANCE_MODE.FRIEND_OR_GUILD_MEMBER_PREMIUM;
                    }
                    else
                    {
                        applianceMode = BUFF_APPLIANCE_MODE.FRIEND;
                    };
                }
                else
                {
                    applianceMode = BUFF_APPLIANCE_MODE.PLAYER;
                };
                gi.mZoneBuffManager.addBuff(this, applianceMode);
                isRepeatingApplied = true;
            };
            if (((!(go == null)) && (go is cBuilding)))
            {
                building = (go as cBuilding);
            };
            if (building != null)
            {
                x = GridPosition.getX(building.GetGrid(), gi.mCurrentPlayerZone.mMapWidth);
                y = GridPosition.getY(building.GetGrid(), gi.mCurrentPlayerZone.mMapWidth);
                EffectList.applyWith(this.buffDefinition.GetApplyEffects(), (gi as cGameInterface), function (_arg_1:EffectVO):void
                {
                    _arg_1.playerId = playerData.getPlayerID();
                    _arg_1.otherPlayerId = building.getPlayerID();
                    _arg_1.targetX = x;
                    _arg_1.targetY = y;
                });
            }
            else
            {
                if (((!(isRepeatingApplied)) || (this.buffDefinition.GetRepeatingEffects() == null)))
                {
                    EffectList.apply(this.buffDefinition.GetApplyEffects(), (gi as cGameInterface));
                };
            };
            return (true);
        }

        public function SetMapLevel(_arg_1:int):void
        {
            this.mapLevel = _arg_1;
        }

        public function DecWaitingForServerCount(_arg_1:cGeneralInterface):void
        {
            this.waitingForServerCount--;
            totalWaitingForServerCount--;
            if (_arg_1.channels.BUFF != null)
            {
                _arg_1.channels.BUFF.send(cBuff.BUFF_TOTAL_WFSC, totalWaitingForServerCount);
            };
            if (this.waitingForServerCount < 0)
            {
                totalWaitingForServerCount = (totalWaitingForServerCount + this.waitingForServerCount);
                this.waitingForServerCount = 0;
            };
            if (cLog.isInfoEnabled())
            {
                cLog.info(((("DecWaitingForServerCount() of " + this.uniqueId.toString()) + " to ") + this.waitingForServerCount));
            };
        }

        public function setDeleted():void
        {
            this.deleted = true;
        }

        public function GetId():int
        {
            return (this.GetBuffDefinition().GetId());
        }

        public function GetNextTickTime():Number
        {
            return (this.nextTickTime);
        }

        public function GetWaitingForServer():Boolean
        {
            return ((this.waitingForServerCount > 0) && (this.waitingForServerCount >= this.amount));
        }

        public function getMergeUniqueKey():String
        {
            return (((this.GetBuffDefinition().GetName_string() + this.GetType()) + this.GetResourceName_string()) + this.GetRecurrentChance());
        }

        private function CalculateRedeemBuff(_arg_1:cGeneralInterface, _arg_2:cGO, _arg_3:int):int
        {
            var _local_5:int;
            var _local_6:dResource;
            var _local_7:cResources;
            var _local_8:dResource;
            var _local_9:int;
            var _local_4:cPlayerData = _arg_1.FindPlayerFromId(_arg_2.getPlayerID());
            for each (_local_6 in this.buffDefinition.GetRedeemable_vector())
            {
                _local_7 = _arg_1.mCurrentPlayerZone.GetResources(_local_4);
                _local_8 = _local_7.GetPlayerResource(_local_6.name_string);
                _local_5 = (_local_8.maxLimit - _local_8.amount);
                _local_9 = int((_local_5 / _local_6.amount));
                _arg_3 = ((_arg_3 > _local_9) ? _local_9 : _arg_3);
                if (_arg_3 < 1)
                {
                    globalFlash.gui.mAvatarMessageList.AddMessage(AVATAR_MESSAGE_TYPE.REDEEM_LIMIT_REACHED, _local_6, this.GetBuffDefinition().isPreventDefaultAvatarMessage());
                    return (BUFF_APPLY_ERROR);
                };
            };
            return (_arg_3);
        }

        public function GetAmountForTrigger():int
        {
            return (this.GetAmount());
        }

        public function SetNextTickTime(_arg_1:Number):void
        {
            this.nextTickTime = _arg_1;
        }


    }
}
