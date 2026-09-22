package Specialists
{
    import Utils.Disposable;
    import __AS3__.vec.Vector;
    import ServerState.dResource;
    import GO.cBuilding;
    import MilitarySystem.cCombat;
    import Enums.SPECIALIST_TASK_TYPES;
    import nLib.cLog;
    import Enums.TASK_PHASES_ATTACK_BUILDING_NEW_COMBAT;
    import Interface.cGeneralInterface;
    import Communication.VO.dSpecialistTask_AttackBuildingNewCombatVO;
    import Enums.DIRTY_INDICATOR;
    import nLib.gMisc;
    import Enums.COMMAND;
    import Enums.AVATAR_MESSAGE_TYPE;
    import Enums.TASK_PHASES_RECOVER;
    import AdventureSystem.cAdventureDefinition;
    import Communication.VO.ExpeditionDifficultyDataVO;
    import BuffSystem.cBuffDefinition;
    import GO.cCombatData;
    import Tracks.TrackManager;
    import ServerState.cPlayerData;
    import Enums.COMBAT_RESULT;
    import Map.AdditionalDataTSO;
    import com.bluebyte.tso.adventure.logic.AdventureManager;
    import Utils.StringUtils;
    import BuffSystem.cBuff;
    import Enums.BUFF_APPLIANCE_MODE;
    import Model.Notifiers.SpecialistNotifier;
    import Interface.cGameInterface;
    import PathFinding.cPathObject;
    import Enums.SPECIALIST_TASK_ATTACK_BUILDING_MODE;
    import Communication.VO.dSpecialistTaskVO;
    import __AS3__.vec.*;

    public class cSpecialistTask_AttackBuildingNewCombat extends cSpecialistTask_WithSettler implements Disposable 
    {

        private static var onePopulation_vector:Vector.<dResource> = null;

        private const phaseDescriptions_list:Vector.<String> = new Vector.<String>(4);

        private var mArmyDestination:cBuilding;
        private var mTargetBuildingGridIdx:int;
        private var mTimeToReduceOneDamageLevel:int = -1;
        private var mGeneralRetreated:Boolean;
        private var mAttackBuildingMode:int;
        private var mTargetBuilding:cBuilding;
        private var mStartingArmySize:int;
        private var mCombat:cCombat;
        private var mStartingUnitType:String;
        private var mHitPointsOfOneDamageLevel:int = -1;
        private var mTimeOfNextDamageLevel:int = -1;
        private var mStartGridIdx:int;
        private var mWaitStartTime:Number;
        private var mArmyDestinationGridIdx:int;

        {
            initialize();
        }

        public function cSpecialistTask_AttackBuildingNewCombat(_arg_1:cGeneralInterface, _arg_2:cSpecialist, _arg_3:int, _arg_4:int, _arg_5:int, _arg_6:int, _arg_7:int, _arg_8:String)
        {
            super(_arg_1, SPECIALIST_TASK_TYPES.ATTACK_BUILDING_NEW_COMBAT, _arg_2, _arg_6, _arg_7);
            if (!_arg_1.UsesCombatThree())
            {
                throw (new Error("trying to create cSpecialistTask_AttackBuildingNewCombat on a combat 1.0 map"));
            };
            this.phaseDescriptions_list[1] = "Units with first strike attack:";
            this.phaseDescriptions_list[2] = "Units attack:";
            this.phaseDescriptions_list[3] = "Slow units attack:";
            if (cLog.isInfoEnabled())
            {
                cLog.info(((("cSpecialistTask_AttackBuildingNewCombat() owner:" + _arg_2) + ", targetBuildingGridIdx:") + _arg_4));
            };
            this.mStartGridIdx = _arg_3;
            var _local_9:cBuilding = _arg_1.mCurrentPlayerZone.GetBuildingFromGridPosition(_arg_4);
            this.mTargetBuildingGridIdx = _arg_4;
            this.mTargetBuilding = _local_9;
            this.mArmyDestinationGridIdx = _arg_4;
            this.mArmyDestination = _local_9;
            this.mAttackBuildingMode = _arg_5;
            this.mGeneralRetreated = false;
            this.mStartingUnitType = _arg_8;
            if (GetTaskPhase() >= TASK_PHASES_ATTACK_BUILDING_NEW_COMBAT.RETURN_TO_GARRISON)
            {
                if (mOwner.GetGarrison() != null)
                {
                    SetDestinationPath(_arg_1.mPathFinder.CalculatePath(this.mStartGridIdx, mOwner.GetGarrison().GetStreetGridEntry(), null, true));
                };
            }
            else
            {
                if (this.mStartGridIdx > -1)
                {
                    SetDestinationPath(_arg_1.mPathFinder.CalculatePath(this.mTargetBuilding.GetStreetGridEntry(), this.mStartGridIdx, null, true));
                };
            };
        }

        private static function initialize():void
        {
            onePopulation_vector = new Vector.<dResource>();
            var _local_1:dResource = new dResource();
            _local_1.name_string = defines.POPULATION_RESOURCE_NAME_string;
            _local_1.amount = 1;
            onePopulation_vector.push(_local_1);
        }

        public static function CreateTaskFromVO(_arg_1:cGeneralInterface, _arg_2:dSpecialistTask_AttackBuildingNewCombatVO, _arg_3:cSpecialist):cSpecialistTask_AttackBuildingNewCombat
        {
            if (!_arg_1.UsesCombatThree())
            {
                throw (new Error("trying to call cSpecialistTask_AttackBuildingNewCombat.CreateTaskFromVO() on a combat 1.0 map"));
            };
            var _local_4:cSpecialistTask_AttackBuildingNewCombat = new cSpecialistTask_AttackBuildingNewCombat(_arg_1, _arg_3, _arg_2.startGridPos, _arg_2.targetBuildingGridPos, _arg_2.attackBuildingMode, _arg_2.collectedTime, _arg_2.phase, _arg_2.startingUnitName);
            _local_4.SetPathPos(_arg_2.pathPos);
            _local_4.mArmyDestinationGridIdx = _arg_2.armyDestinationBuildingGridPos;
            _local_4.mArmyDestination = _arg_1.mCurrentPlayerZone.GetBuildingFromGridPosition(_local_4.mArmyDestinationGridIdx);
            _local_4.mStartingArmySize = _arg_2.startingArmySize;
            _local_4.mGeneralRetreated = false;
            _local_4.mStartingUnitType = _arg_2.startingUnitName;
            if (((!(_arg_2.combatVO == null)) && (_arg_2.phase < TASK_PHASES_ATTACK_BUILDING_NEW_COMBAT.RETURN_TO_GARRISON)))
            {
                _local_4.mCombat = new cCombat(_local_4, _arg_2.combatVO);
                _arg_1.mCurrentPlayerZone.mStreetDataMap.CreateCombatData(_arg_1, _local_4.GetOwner().getPlayerID(), _local_4.GetTargetBuildingGridIdx(), _local_4.GetCombat());
                _local_4.UpdateCombatSlots();
                _local_4.mCombat.addPropertyObserver(cCombat.SLOT_UNITS_DIED_string, globalFlash.gui.mExpeditionInfoBar);
            };
            _local_4.mWaitStartTime = _arg_2.startWaitPhase;
            _local_4.CheckSettler();
            if (_arg_2.phase == TASK_PHASES_ATTACK_BUILDING_NEW_COMBAT.ATTACK_TARGET)
            {
                _local_4.SetPathPos(_local_4.GetDestinationPath().pathLenX10000);
            };
            return (_local_4);
        }


        public function GetStartingUnitType():String
        {
            return (this.mStartingUnitType);
        }

        public function GetArmyDestination():cBuilding
        {
            return (this.mArmyDestination);
        }

        private function GoFromTowerToArmyDestination():void
        {
            if (GetDestinationPath().dest_vector.length > 0)
            {
                this.mStartGridIdx = GetDestinationPath().CalculateGridIdxForPathPos(GetPathPos());
                this.mTargetBuildingGridIdx = this.mArmyDestinationGridIdx;
                this.mTargetBuilding = this.mArmyDestination;
                SetDestinationPath(mGeneralInterface.mPathFinder.CalculatePath(this.mTargetBuilding.GetStreetGridEntry(), this.mStartGridIdx, null, true));
                mDirtyIndicator = (mDirtyIndicator | DIRTY_INDICATOR.MODIFIED_BIT);
            };
            SetPathPos(0);
        }

        public function SetStartingUnitType(_arg_1:String):void
        {
            this.mStartingUnitType = _arg_1;
        }

        override public function GetSortValue():Number
        {
            switch (GetTaskPhase())
            {
                case TASK_PHASES_ATTACK_BUILDING_NEW_COMBAT.GO_TO_TARGET:
                    if (this.GetWaitStartTime() > 0)
                    {
                        return (mGeneralInterface.GetClientTime() + this.GetWaitStartTime());
                    };
                    return (gMisc.GetMaxFloatValue());
                case TASK_PHASES_ATTACK_BUILDING_NEW_COMBAT.ATTACK_TARGET:
                    return (-1);
                case TASK_PHASES_ATTACK_BUILDING_NEW_COMBAT.WAIT_AT_TARGET:
                    return (this.GetWaitStartTime());
                default:
                    return (0);
            };
        }

        public function dispose():void
        {
            if (this.mCombat != null)
            {
                this.mCombat.dispose();
            };
        }

        public function Retreat():void
        {
            if (cLog.isInfoEnabled())
            {
                cLog.info("cSpecialistTask_AttackBuildingNewCombat.Retreat()");
            };
            if (((((GetTaskPhase() == TASK_PHASES_ATTACK_BUILDING_NEW_COMBAT.GO_TO_TARGET) || (GetTaskPhase() == TASK_PHASES_ATTACK_BUILDING_NEW_COMBAT.WAIT_FOR_ORDERS)) || (GetTaskPhase() == TASK_PHASES_ATTACK_BUILDING_NEW_COMBAT.ATTACK_TARGET)) || (GetTaskPhase() == TASK_PHASES_ATTACK_BUILDING_NEW_COMBAT.WAIT_AT_TARGET)))
            {
                mOwner.SetWaitingForServer(true);
                globalFlash.gui.mSpecialistPanel.Refresh(mOwner);
                mGeneralInterface.mClientMessages.SendMessagetoServer(COMMAND.RETREAT, mGeneralInterface.mCurrentViewedZoneID, mOwner.GetUniqueID());
            }
            else
            {
                if (cLog.isInfoEnabled())
                {
                    cLog.info(("cSpecialistTask_AttackBuildingNewCombat.Retreat() cannot retreat because general is in phase " + TASK_PHASES_ATTACK_BUILDING_NEW_COMBAT.toString(GetTaskPhase())));
                };
            };
        }

        override protected function NextPhase():void
        {
            super.NextPhase();
            globalFlash.gui.mSpecialistPanel.Refresh(mOwner);
        }

        public function GetCombatChecksum():int
        {
            var _local_1:int;
            if (this.mCombat != null)
            {
                _local_1 = this.mCombat.GetChecksum();
            };
            return (_local_1);
        }

        public function BeginAttack():void
        {
            this.SetTaskPhase(TASK_PHASES_ATTACK_BUILDING_NEW_COMBAT.BEGIN_ATTACK);
        }

        override protected function PerformTaskPhase(_arg_1:int, _arg_2:int):void
        {
            var _local_3:int;
            var _local_4:int;
            var _local_5:int;
            var _local_6:int;
            var _local_7:int;
            var _local_8:*;
            var _local_9:*;
            if (((GetTaskPhase() < TASK_PHASES_ATTACK_BUILDING_NEW_COMBAT.RETURN_TO_GARRISON) && (mGeneralInterface.mCurrentPlayerZone.GetBuildingFromGridPosition(this.mTargetBuildingGridIdx) == null)))
            {
                this.HandleInterruptedCombatResult();
                this.mCombat = null;
                if ((((this.mTargetBuilding == this.mArmyDestination) || (this.mArmyDestination == null)) || (mGeneralInterface.mCurrentPlayerZone.GetBuildingFromGridPosition(this.mArmyDestinationGridIdx) == null)))
                {
                    this.GoToGarrison();
                    this.SetTaskPhase(TASK_PHASES_ATTACK_BUILDING_NEW_COMBAT.RETURN_TO_GARRISON);
                    mGeneralInterface.channels.ZONE.notifyPropertyObserver("SUCCESSFUL_BLOCKING", null);
                }
                else
                {
                    if (cLog.isInfoEnabled())
                    {
                        cLog.info("cSpecialistTask_AttackBuildingNewCombat.PerformTaskPhase(): next phase: GO_TO_TARGET");
                    };
                    this.SetTaskPhase(TASK_PHASES_ATTACK_BUILDING_NEW_COMBAT.GO_TO_TARGET);
                    this.GoFromTowerToArmyDestination();
                    return;
                };
            };
            switch (GetTaskPhase())
            {
                case TASK_PHASES_ATTACK_BUILDING_NEW_COMBAT.GO_TO_TARGET:
                    if (this.mGeneralRetreated)
                    {
                        this.PerformRetreat(true);
                        return;
                    };
                    _local_3 = GetPathPos();
                    _local_4 = 0;
                    IncPathPos(_arg_1);
                    _local_5 = GetPathPos();
                    _local_6 = GetDestinationPath().CalculateGridIdxForPathPos(_local_5);
                    do 
                    {
                        _local_4 = GetDestinationPath().CalculateGridIdxForPathPos(_local_3);
                        _local_8 = (mGeneralInterface.mCurrentPlayerZone.mMapWidth * mGeneralInterface.mCurrentPlayerZone.mMapHeight);
                        if (((_local_4 >= 0) && (_local_4 < _local_8)))
                        {
                            if (((mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.IsWatchedByTowers(_local_4, mGeneralInterface)) && (!(mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.IsBuildingWatching(_local_4, this.GetTargetBuilding())))))
                            {
                                _local_9 = this.GoToEnemyTower(_local_4);
                                if (cLog.isInfoEnabled())
                                {
                                    cLog.info(((("cSpecialistTask_AttackBuildingNewCombat.PerformTaskPhase(): Army was disrupted by tower " + this.mTargetBuildingGridIdx) + " at gridIdx ") + _local_4));
                                };
                                if (_local_9) break;
                            };
                        };
                        _local_3 = (_local_3 + defines.INT_SCALE_FACTOR);
                    } while (_local_4 != _local_6);
                    _local_7 = int((_local_5 - (int((_local_3 / defines.INT_SCALE_FACTOR)) * defines.INT_SCALE_FACTOR)));
                    if (_local_7 > 0)
                    {
                        IncPathPos(_local_7);
                    };
                    if (((!(this.mGeneralRetreated)) && (GetPathPos() >= GetDestinationPath().pathLenX10000)))
                    {
                        SetPathPos(GetDestinationPath().pathLenX10000);
                        if (cLog.isInfoEnabled())
                        {
                            cLog.info((((((("cSpecialistTask_AttackBuildingNewCombat.PerformTaskPhase(): reached target: " + this.mTargetBuilding) + ", GetPathPos():") + GetPathPos()) + ", GetDestinationPath().pathLenX10000:") + GetDestinationPath().pathLenX10000) + ", next phase: WAIT_AT_TARGET"));
                        };
                        this.mWaitStartTime = (mGeneralInterface.GetClientTime() + _arg_2);
                        this.NextPhase();
                    };
                    return;
                case TASK_PHASES_ATTACK_BUILDING_NEW_COMBAT.WAIT_AT_TARGET:
                    if (!mOwner.GetArmy().HasUnits())
                    {
                        cLog.error(((("PLAYER " + GetOwner().getPlayerID()) + " started a fight with no army on SPECIALIST ") + GetOwner()));
                        this.PerformRetreat(false);
                        return;
                    };
                    if (this.mGeneralRetreated)
                    {
                        this.PerformRetreat(false);
                        return;
                    };
                    if (((!(this.GetTargetBuilding() == null)) && (!(this.GetTargetBuilding().IsEngagedInCombat()))))
                    {
                        if (this.mCombat == null)
                        {
                            this.mCombat = new cCombat(this, null);
                            mDirtyIndicator = (mDirtyIndicator | DIRTY_INDICATOR.DATA_ADDED_BIT);
                            mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.CreateCombatData(mGeneralInterface, mOwner.getPlayerID(), this.mTargetBuildingGridIdx, this.mCombat);
                            this.UpdateCombatSlots();
                            this.mCombat.addPropertyObserver(cCombat.SLOT_UNITS_DIED_string, globalFlash.gui.mExpeditionInfoBar);
                        };
                        this.GetTargetBuilding().SetEngagedInCombat(true, false);
                        this.NextPhase();
                    };
                    return;
                case TASK_PHASES_ATTACK_BUILDING_NEW_COMBAT.BEGIN_ATTACK:
                    if (this.mGeneralRetreated)
                    {
                        this.PerformRetreat(true);
                        return;
                    };
                    if (mGeneralInterface.mCurrentPlayer.GetPlayerId() == mOwner.getPlayerID())
                    {
                        globalFlash.gui.mAvatarMessageList.AddMessage(AVATAR_MESSAGE_TYPE.ADMIRAL_STARTET_ATTACK, mOwner);
                    }
                    else
                    {
                        globalFlash.gui.mAvatarMessageList.AddMessage(AVATAR_MESSAGE_TYPE.ADMIRAL_STARTET_ATTACK_VIEWER, mOwner);
                    };
                    SetCollectedTime(0);
                    if (cLog.isInfoEnabled())
                    {
                        cLog.info("cSpecialistTask_AttackBuildingNewCombat.PerformTaskPhase(): next phase: ATTACK_TARGET");
                    };
                    this.NextPhase();
                    globalFlash.gui.mSpecialistPanel.Refresh(mOwner);
                    return;
                case TASK_PHASES_ATTACK_BUILDING_NEW_COMBAT.ATTACK_TARGET:
                    if (((this.mGeneralRetreated) || (this.mCombat == null)))
                    {
                        this.PerformRetreat(true);
                        return;
                    };
                    this.UpdateCombatSlots();
                    if (!this.mCombat.Step(_arg_1))
                    {
                        if (mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.mCombatContainer.containsKey(this.mTargetBuildingGridIdx))
                        {
                            mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.mCombatContainer.get(this.mTargetBuildingGridIdx).dispose();
                            mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.mCombatContainer.remove(this.mTargetBuildingGridIdx);
                        };
                        this.HandleApplyBattleResult();
                        this.mCombat = null;
                    };
                    return;
                case TASK_PHASES_ATTACK_BUILDING_NEW_COMBAT.RETURN_TO_GARRISON:
                    IncPathPos(_arg_1);
                    if (((GetDestinationPath() == null) || (GetPathPos() >= GetDestinationPath().pathLenX20000)))
                    {
                        if (GetDestinationPath() != null)
                        {
                            SetPathPos(GetDestinationPath().pathLenX20000);
                        };
                        this.NextPhase();
                    };
                    return;
                case TASK_PHASES_ATTACK_BUILDING_NEW_COMBAT.WAIT_FOR_ORDERS:
                    if (this.hasLostBattle())
                    {
                        if (mGeneralInterface.mCurrentPlayer.GetPlayerId() == mOwner.getPlayerID())
                        {
                            globalFlash.gui.mAvatarMessageList.AddMessage(AVATAR_MESSAGE_TYPE.ADMIRAL_FINISHED_NEGATIVE, mOwner);
                        }
                        else
                        {
                            globalFlash.gui.mAvatarMessageList.AddMessage(AVATAR_MESSAGE_TYPE.ADMIRAL_FINISHED_NEGATIVE_VIEWER, mOwner);
                        };
                        mOwner.SetTask(new cSpecialistTask_Recover(mGeneralInterface, mOwner, 0, TASK_PHASES_RECOVER.RECOVER));
                    }
                    else
                    {
                        if (mGeneralInterface.mCurrentPlayer.GetPlayerId() == mOwner.getPlayerID())
                        {
                            globalFlash.gui.mAvatarMessageList.AddMessage(AVATAR_MESSAGE_TYPE.ADMIRAL_FINISHED_POSITIVE, mOwner);
                        }
                        else
                        {
                            globalFlash.gui.mAvatarMessageList.AddMessage(AVATAR_MESSAGE_TYPE.ADMIRAL_FINISHED_POSITIVE_VIEWER, mOwner);
                        };
                        mOwner.SetTask(null);
                    };
                    RemoveSettler();
                    globalFlash.gui.mSpecialistPanel.Refresh(mOwner);
                    return;
                default:
                    gMisc.Assert(false, (("Could not interpret task phase " + GetTaskPhase()) + "!"));
            };
        }

        public function hasLostBattle():Boolean
        {
            return (!(mOwner.GetArmy().HasUnits()));
        }

        public function GetTargetBuilding():cBuilding
        {
            return (this.mTargetBuilding);
        }

        public function GetAttackBuildingMode():int
        {
            return (this.mAttackBuildingMode);
        }

        private function HandleApplyBattleResult():void
        {
            var _local_6:int;
            var _local_7:String;
            var _local_8:cAdventureDefinition;
            var _local_9:ExpeditionDifficultyDataVO;
            var _local_10:cBuffDefinition;
            var _local_11:cBuilding;
            var _local_1:cCombatData = mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.mCombatContainer.get(this.mTargetBuildingGridIdx);
            if (_local_1 != null)
            {
                _local_1.dispose();
                mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.mCombatContainer.remove(this.mTargetBuildingGridIdx);
            };
            if (this.mGeneralRetreated)
            {
                if (cLog.isInfoEnabled())
                {
                    cLog.info("cSpecialistTask_AttackBuildingNewCombat.HandleApplyBattleResult() perform retreat!");
                };
                this.PerformRetreat(true);
                return;
            };
            if (this.mCombat == null)
            {
                if (cLog.isInfoEnabled())
                {
                    cLog.error("cSpecialistTask_AttackBuildingNewCombat.HandleApplyBattleResult(): no combat found!");
                };
                this.PerformRetreat(true);
                return;
            };
            var _local_2:int = defines.INVALID_USER_ID;
            TrackManager.getInstance().trackCombat3BattleResult(mOwner.getPlayerID(), mGeneralInterface.mCurrentViewedZoneID, this.mCombat, _local_2);
            if (cLog.isInfoEnabled())
            {
                cLog.info("cSpecialistTask_AttackBuildingNewCombat.HandleApplyBattleResult()");
            };
            var _local_3:cPlayerData = mGeneralInterface.FindPlayerFromId(mOwner.getPlayerID());
            gMisc.Assert((!(_local_3 == null)), ("Could not find player with ID " + mOwner.getPlayerID()));
            if (mGeneralInterface.mCurrentPlayer.GetPlayerId() == mOwner.getPlayerID())
            {
                globalFlash.gui.mHiredTroopsPoolPanel.SetData(mGeneralInterface.mCurrentPlayerZone.mHiredTroopsPool);
            };
            var _local_4:int;
            if ((((this.mCombat.GetCombatResult() == COMBAT_RESULT.PLAYERWON_CONTINUE) || (this.mCombat.GetCombatResult() == COMBAT_RESULT.PLAYERWON_RETURN)) || (this.mCombat.GetCombatResult() == COMBAT_RESULT.DRAW)))
            {
                _local_4 = this.mTargetBuilding.DamageBuilding(this.mTargetBuilding.GetCurrentHitPoints(), _local_3);
                if (this.mTargetBuilding.GetCurrentHitPoints() <= 0)
                {
                    mOwner.IncBuildingsDestroyed((1 + _local_4));
                    if (mGeneralInterface.IsAdventureZone())
                    {
                        _local_6 = mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.mAdditionalData.get(this.mTargetBuilding.GetGrid(), AdditionalDataTSO.Sector);
                        _local_7 = "";
                        _local_8 = cAdventureDefinition.FindAdventureDefinition(AdventureManager.getInstance().getAdventure(mGeneralInterface.mCurrentViewedZoneID).adventureName);
                        _local_9 = global.expeditionDifficultyVO.GetDifficultyData(_local_8.GetDifficulty());
                        if (_local_9 != null)
                        {
                            _local_7 = _local_9.victoryBuff;
                        };
                        _local_10 = null;
                        if (!StringUtils.isEmpty(_local_7))
                        {
                            _local_10 = cBuffDefinition.GetByName(_local_7);
                        };
                        if (_local_10 != null)
                        {
                            for each (_local_11 in mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.GetBuildings_vector())
                            {
                                if (!global.expeditionDifficultyVO.BossBuildingNameExists(this.mTargetBuilding.GetBuildingName_string()))
                                {
                                    if (_local_6 == mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.mAdditionalData.get(_local_11.GetGrid(), AdditionalDataTSO.Sector))
                                    {
                                        _local_11.AddBuff(new cBuff(_local_10, _local_3.GetNewUniqueID(), 1), BUFF_APPLIANCE_MODE.PLAYER, _local_11.GetGrid(), 0);
                                    };
                                };
                            };
                        };
                    };
                };
            };
            var _local_5:cSpecialistDescription = mOwner.GetSpecialistDescription();
            if (cCombat.bCombatLog)
            {
                cLog.info((("cSpecialistTask_AttackBuildingNewCombat.HandleApplyBattleResult: (CombatResult: " + COMBAT_RESULT.toString(this.mCombat.GetCombatResult())) + ")"));
            };
            switch (this.mCombat.GetCombatResult())
            {
                case COMBAT_RESULT.PLAYERWON_CONTINUE:
                    if (mGeneralInterface.mCurrentPlayer.GetPlayerId() == mOwner.getPlayerID())
                    {
                        globalFlash.gui.mAvatarMessageList.AddMessage(AVATAR_MESSAGE_TYPE.ADMIRAL_WON_AND_CONTINUES, mOwner);
                    }
                    else
                    {
                        globalFlash.gui.mAvatarMessageList.AddMessage(AVATAR_MESSAGE_TYPE.ADMIRAL_WON_AND_CONTINUES_VIEWER, mOwner);
                    };
                    this.GoFromTowerToArmyDestination();
                    this.SetTaskPhase(TASK_PHASES_ATTACK_BUILDING_NEW_COMBAT.GO_TO_TARGET);
                    return;
                case COMBAT_RESULT.PLAYERWON_RETURN:
                    if (mGeneralInterface.mCurrentPlayer.GetPlayerId() == mOwner.getPlayerID())
                    {
                        globalFlash.gui.mAvatarMessageList.AddMessage(AVATAR_MESSAGE_TYPE.ADMIRAL_WON_AND_RETURNS, mOwner);
                    }
                    else
                    {
                        globalFlash.gui.mAvatarMessageList.AddMessage(AVATAR_MESSAGE_TYPE.ADMIRAL_WON_AND_RETURNS_VIEWER, mOwner);
                    };
                    this.GoToGarrison();
                    this.NextPhase();
                    return;
                case COMBAT_RESULT.PLAYERLOST:
                case COMBAT_RESULT.DRAW:
                    if (mGeneralInterface.mCurrentPlayer.GetPlayerId() == mOwner.getPlayerID())
                    {
                        globalFlash.gui.mAvatarMessageList.AddMessage(AVATAR_MESSAGE_TYPE.ADMIRAL_LOST, mOwner);
                    }
                    else
                    {
                        globalFlash.gui.mAvatarMessageList.AddMessage(AVATAR_MESSAGE_TYPE.ADMIRAL_LOST_VIEWER, mOwner);
                    };
                    this.GoToGarrison();
                    this.SetTaskPhase(TASK_PHASES_ATTACK_BUILDING_NEW_COMBAT.RETURN_TO_GARRISON);
                    this.mTargetBuilding.SetEngagedInCombat(false, false);
                    mGeneralInterface.channels.SPECIALIST.notify(SpecialistNotifier.GENERAL_LOST_string, this.mOwner);
                    return;
                default:
                    if (cLog.isInfoEnabled())
                    {
                        cLog.info(("cSpecialistTask_AttackBuildingNewCombat.ApplyBattleResult(): battleResult:" + COMBAT_RESULT.toString(this.mCombat.GetCombatResult())));
                    };
                    gMisc.Assert(false, ("Could not interpret battle result " + this.mCombat.GetCombatResult()));
            };
        }

        private function HandleInterruptedCombatResult():void
        {
        }

        private function PerformRetreat(_arg_1:Boolean):void
        {
            if (cLog.isInfoEnabled())
            {
                cLog.info(("cSpecialistTask_AttackBuildingNewCombat.PerformRetreat() in phase: " + TASK_PHASES_ATTACK_BUILDING_NEW_COMBAT.toString(GetTaskPhase())));
            };
            if (_arg_1)
            {
                if (((GetTaskPhase() == TASK_PHASES_ATTACK_BUILDING_NEW_COMBAT.ATTACK_TARGET) || (GetTaskPhase() == TASK_PHASES_ATTACK_BUILDING_NEW_COMBAT.BEGIN_ATTACK)))
                {
                    this.mTargetBuilding.SetEngagedInCombat(false, false);
                    this.mTargetBuilding.SetCurrentHitPoints(this.mTargetBuilding.GetMaxHitPoints());
                };
            };
            if (cLog.isInfoEnabled())
            {
                cLog.info(("cSpecialistTask_AttackBuildingNewCombat.PerformRetreat() mTargetBuilding: " + this.mTargetBuilding));
            };
            this.GoToGarrison();
            this.SetTaskPhase(TASK_PHASES_ATTACK_BUILDING_NEW_COMBAT.RETURN_TO_GARRISON);
            if (mGeneralInterface.mCurrentPlayer.GetPlayerId() == mOwner.getPlayerID())
            {
                globalFlash.gui.mAvatarMessageList.AddMessage(AVATAR_MESSAGE_TYPE.ADMIRAL_RETREAT, mOwner);
            }
            else
            {
                globalFlash.gui.mAvatarMessageList.AddMessage(AVATAR_MESSAGE_TYPE.ADMIRAL_RETREAT_VIEWER, mOwner);
            };
            mOwner.SetWaitingForServer(false);
            var _local_2:cCombatData = mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.mCombatContainer.get(this.mTargetBuildingGridIdx);
            if (((!(_local_2 == null)) && (_local_2.GetCombat().GetSpecialistTask() == this)))
            {
                _local_2.dispose();
                mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.mCombatContainer.remove(this.mTargetBuildingGridIdx);
            };
            (mGeneralInterface as cGameInterface).requestZonePersistence(COMMAND.RETREAT);
        }

        public function GetCombat():cCombat
        {
            return (this.mCombat);
        }

        public function GetWaitStartTime():Number
        {
            return (this.mWaitStartTime);
        }

        override protected function SetTaskPhase(_arg_1:int):void
        {
            super.SetTaskPhase(_arg_1);
            globalFlash.gui.mSpecialistPanel.Refresh(mOwner);
        }

        public function GetTargetBuildingGridIdx():int
        {
            return (this.mTargetBuildingGridIdx);
        }

        public function HandleRetreat():void
        {
            if (cLog.isInfoEnabled())
            {
                cLog.info(((("cSpecialistTask_AttackBuildingNewCombat.HandleRetreat() in phase: " + TASK_PHASES_ATTACK_BUILDING_NEW_COMBAT.toString(GetTaskPhase())) + " at mCollectedTime: ") + mCollectedTime));
            };
            if (((!(GetTaskPhase() == TASK_PHASES_ATTACK_BUILDING_NEW_COMBAT.ATTACK_TARGET)) || (mCollectedTime <= defines.GAMETICK_SYSTEM_POSTPROCESS_TIME_MIN)))
            {
                this.mGeneralRetreated = true;
            };
        }

        override public function StartTask():void
        {
            super.StartTask();
            SpawnSettler(mOwner.GetGarrison().GetXInt(), mOwner.GetGarrison().GetYInt());
        }

        public function IsAtTargetBuilding():Boolean
        {
            return (this.mTargetBuildingGridIdx == this.mArmyDestinationGridIdx);
        }

        private function GoToEnemyTower(_arg_1:int):Boolean
        {
            var _local_3:cPathObject;
            var _local_4:int;
            var _local_2:Vector.<int> = mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.GetReadyTowerGridIdxs(_arg_1);
            if (_local_2.length > 0)
            {
                _local_3 = mGeneralInterface.mPathFinder.CalculatePathForDestinations(_arg_1, _local_2, null);
                if (_local_3.dest_vector.length > 0)
                {
                    if (mGeneralInterface.mCurrentPlayer.GetPlayerId() == mOwner.getPlayerID())
                    {
                        globalFlash.gui.mAvatarMessageList.AddMessage(AVATAR_MESSAGE_TYPE.ADMIRAL_DISTRACTED, mOwner);
                    }
                    else
                    {
                        globalFlash.gui.mAvatarMessageList.AddMessage(AVATAR_MESSAGE_TYPE.ADMIRAL_DISTRACTED_VIEWER, mOwner);
                    };
                    this.mStartGridIdx = _arg_1;
                    SetDestinationPath(_local_3);
                    _local_4 = gCalculations.MoveStreetGridToDir8(mGeneralInterface.mCurrentPlayerZone, _local_3.dest_vector[(_local_3.dest_vector.length - 1)].streetGridIdx, defines.DIR8_NORTH_WEST);
                    this.mTargetBuildingGridIdx = _local_4;
                    this.mTargetBuilding = mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.mBuildingContainer.get(_local_4);
                    mDirtyIndicator = (mDirtyIndicator | DIRTY_INDICATOR.MODIFIED_BIT);
                }
                else
                {
                    this.GoToGarrison();
                };
                SetPathPos(0);
                return (true);
            };
            return (false);
        }

        public function toString():String
        {
            return (((("<cSpecialistTask_AttackBuildingNewCombat target='" + this.mTargetBuilding) + "' attackBuidlingMode='") + SPECIALIST_TASK_ATTACK_BUILDING_MODE.toString(this.mAttackBuildingMode)) + "' >");
        }

        public function GetStartingArmySize():int
        {
            return (this.mStartingArmySize);
        }

        private function GoToGarrison():void
        {
            this.mCombat = null;
            var _local_1:cCombatData = mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.mCombatContainer.get(this.mTargetBuildingGridIdx);
            if (((!(_local_1 == null)) && (_local_1.GetCombat().GetSpecialistTask() == this)))
            {
                _local_1.dispose();
                mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.mCombatContainer.remove(this.mTargetBuildingGridIdx);
            };
            if (GetDestinationPath().dest_vector.length > 0)
            {
                this.mStartGridIdx = GetDestinationPath().CalculateGridIdxForPathPos(GetPathPos());
                SetDestinationPath(mGeneralInterface.mPathFinder.CalculatePath(this.mStartGridIdx, mOwner.GetGarrison().GetStreetGridEntry(), null, true));
                SetPathPos(GetDestinationPath().pathLenX10000);
            };
        }

        public function UpdateCombatSlots():void
        {
            var _local_1:cCombatData;
            if (this.GetCombat() != null)
            {
                if (mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.mCombatContainer.containsKey(this.mTargetBuildingGridIdx))
                {
                    _local_1 = mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.mCombatContainer.get(this.mTargetBuildingGridIdx);
                    _local_1.updateMenu(GetOwner(), this.GetCombat());
                };
            };
        }

        override public function CreateTaskVOFromSpecialistTask():dSpecialistTaskVO
        {
            var _local_1:dSpecialistTask_AttackBuildingNewCombatVO = new dSpecialistTask_AttackBuildingNewCombatVO();
            _local_1.type = GetType();
            _local_1.phase = GetTaskPhase();
            _local_1.collectedTime = GetCollectedTime();
            _local_1.attackBuildingMode = this.mAttackBuildingMode;
            _local_1.startGridPos = this.mStartGridIdx;
            _local_1.pathPos = GetPathPos();
            _local_1.armyDestinationBuildingGridPos = this.GetArmyDestinationGridIdx();
            _local_1.targetBuildingGridPos = this.GetTargetBuildingGridIdx();
            _local_1.startWaitPhase = this.mWaitStartTime;
            if (this.mCombat != null)
            {
                _local_1.combatVO = this.mCombat.CreateCombatVO();
            };
            return (_local_1);
        }

        public function GetArmyDestinationGridIdx():int
        {
            return (this.mArmyDestinationGridIdx);
        }

        override protected function CheckSettler():void
        {
            switch (GetTaskPhase())
            {
                case TASK_PHASES_ATTACK_BUILDING_NEW_COMBAT.WAIT_FOR_ORDERS:
                    if (GetSettler() != null)
                    {
                        RemoveSettler();
                    };
                    return;
                case TASK_PHASES_ATTACK_BUILDING_NEW_COMBAT.WAIT_AT_TARGET:
                case TASK_PHASES_ATTACK_BUILDING_NEW_COMBAT.GO_TO_TARGET:
                case TASK_PHASES_ATTACK_BUILDING_NEW_COMBAT.BEGIN_ATTACK:
                case TASK_PHASES_ATTACK_BUILDING_NEW_COMBAT.ATTACK_TARGET:
                case TASK_PHASES_ATTACK_BUILDING_NEW_COMBAT.RETURN_TO_GARRISON:
                    if (GetSettler() == null)
                    {
                        SpawnSettler(0, 0);
                    };
                    return;
                default:
                    cLog.error(("cSpecialistTask_AttackBuildingNewCombat.CheckSettler(): Could not interpret task phase " + GetTaskPhase()));
            };
        }


    }
}
