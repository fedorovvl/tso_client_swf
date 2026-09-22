package Specialists
{
    import Utils.Disposable;
    import __AS3__.vec.Vector;
    import ServerState.dResource;
    import GO.cBuilding;
    import Communication.VO.UpdateVO.dBattleResultVO;
    import Modifier.Modifiers.Combat.CombatModifier;
    import Enums.SPECIALIST_TASK_TYPES;
    import Model.Notifiers.SpecialistNotifier;
    import nLib.cLog;
    import Enums.TASK_PHASES_ATTACK_BUILDING;
    import Interface.cGeneralInterface;
    import Communication.VO.dSpecialistTask_AttackBuildingVO;
    import nLib.gMisc;
    import Enums.DIRTY_INDICATOR;
    import Enums.COMMAND;
    import Modifier.ModifierVO;
    import ServerState.cPlayerData;
    import MilitarySystem.cSquad;
    import Enums.AVATAR_MESSAGE_TYPE;
    import Enums.TASK_PHASES_RECOVER;
    import Communication.VO.dBuffVO;
    import Communication.VO.dUniqueID;
    import BuffSystem.cBuff;
    import ServerState.cResources;
    import MilitarySystem.cArmy;
    import Enums.COMBAT_MODIFIER_ATTRIBUTE;
    import Enums.BATTLE_RESULT;
    import Communication.VO.dArmyVO;
    import Utils.TriggerUtils;
    import Enums.ModifyReason;
    import Interface.cGameInterface;
    import Tracks.TrackManager;
    import Communication.VO.Achievements.BattleStatusVO;
    import Communication.VO.dSquadVO;
    import Communication.VO.CombatCasualtyVO;
    import MilitarySystem.cMilitaryUnitDescription;
    import PathFinding.cPathObject;
    import Enums.SPECIALIST_TASK_ATTACK_BUILDING_MODE;
    import Communication.VO.dSpecialistTaskVO;
    import __AS3__.vec.*;

    public class cSpecialistTask_AttackBuilding extends cSpecialistTask_WithSettler implements Disposable 
    {

        private static var onePopulation_vector:Vector.<dResource> = null;

        private var mArmyDestination:cBuilding;
        private var mTargetBuildingGridIdx:int;
        private var mBuildingDamage:int;
        private var mCombatRoundTimeMultiplier:Number = 1;
        private var mTimeToReduceOneDamageLevel:int = -1;
        private var mGeneralRetreated:Boolean;
        private var mAttackBuildingMode:int;
        private var mTargetBuilding:cBuilding;
        private var mStartingArmySize:int;
        private var mBattleResultVO:dBattleResultVO;
        private var mHitPointsOfOneDamageLevel:int = -1;
        private var mTimeOfNextDamageLevel:int = -1;
        private var mStartGridIdx:int;
        private var mWaitStartTime:Number;
        private var mArmyDestinationGridIdx:int;

        private var combatModifiers:Vector.<CombatModifier> = new Vector.<CombatModifier>();
        private const phaseDescriptions_list:Vector.<String> = new Vector.<String>(4);

        {
            initialize();
        }

        public function cSpecialistTask_AttackBuilding(_arg_1:cGeneralInterface, _arg_2:cSpecialist, _arg_3:int, _arg_4:int, _arg_5:int, _arg_6:int, _arg_7:int)
        {
            super(_arg_1, SPECIALIST_TASK_TYPES.ATTACK_BUILDING, _arg_2, _arg_6, _arg_7);
            _arg_2.notifyPropertyObserver(SpecialistNotifier.TASK_ATTACK_BUILDING_STARTED, this);
            if (_arg_1.UsesCombatThree())
            {
                throw (new Error("trying to create cSpecialistTask_AttackBuilding on a combat 3.0 map"));
            };
            this.phaseDescriptions_list[1] = "Units with first strike attack:";
            this.phaseDescriptions_list[2] = "Units attack:";
            this.phaseDescriptions_list[3] = "Slow units attack:";
            if (cLog.isInfoEnabled())
            {
                cLog.info(((("cSpecialistTask_AttackBuilding() owner:" + _arg_2) + ", targetBuildingGridIdx:") + _arg_4));
            };
            this.mStartGridIdx = _arg_3;
            var _local_8:cBuilding = _arg_1.mCurrentPlayerZone.GetBuildingFromGridPosition(_arg_4);
            this.mTargetBuildingGridIdx = _arg_4;
            this.mTargetBuilding = _local_8;
            this.mArmyDestinationGridIdx = _arg_4;
            this.mArmyDestination = _local_8;
            this.mAttackBuildingMode = _arg_5;
            this.mGeneralRetreated = false;
            if (GetTaskPhase() >= TASK_PHASES_ATTACK_BUILDING.RETURN_TO_GARRISON)
            {
                if (mOwner.GetGarrison() != null)
                {
                    SetDestinationPath(_arg_1.mPathFinder.CalculatePath(this.mStartGridIdx, mOwner.GetGarrison().GetStreetGridEntry(), null, true));
                };
            }
            else
            {
                if (((this.mStartGridIdx > -1) && (!(this.mTargetBuilding == null))))
                {
                    if (this.mTargetBuilding != null)
                    {
                        SetDestinationPath(_arg_1.mPathFinder.CalculatePath(this.mTargetBuilding.GetStreetGridEntry(), this.mStartGridIdx, null, true));
                    }
                    else
                    {
                        SetDestinationPath(_arg_1.mPathFinder.CalculatePath(this.mTargetBuildingGridIdx, this.mStartGridIdx, null, true));
                    };
                }
                else
                {
                    this.SetTaskPhase(TASK_PHASES_ATTACK_BUILDING.WAIT_FOR_ORDERS);
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

        public static function CreateTaskFromVO(_arg_1:cGeneralInterface, _arg_2:dSpecialistTask_AttackBuildingVO, _arg_3:cSpecialist):cSpecialistTask_AttackBuilding
        {
            if (_arg_1.UsesCombatThree())
            {
                throw (new Error("trying to call cSpecialistTask_AttackBuilding.CreateTaskFromVO() on a combat 3.0 map"));
            };
            var _local_4:cSpecialistTask_AttackBuilding = new cSpecialistTask_AttackBuilding(_arg_1, _arg_3, _arg_2.startGridPos, _arg_2.targetBuildingGridPos, _arg_2.attackBuildingMode, _arg_2.collectedTime, _arg_2.phase);
            _local_4.SetPathPos(_arg_2.pathPos);
            _local_4.mArmyDestinationGridIdx = _arg_2.armyDestinationBuildingGridPos;
            _local_4.mArmyDestination = _arg_1.mCurrentPlayerZone.GetBuildingFromGridPosition(_local_4.mArmyDestinationGridIdx);
            _local_4.mStartingArmySize = _arg_2.startingArmySize;
            _local_4.mBattleResultVO = _arg_2.battleResultVO;
            _local_4.mGeneralRetreated = false;
            _local_4.mWaitStartTime = _arg_2.startWaitPhase;
            _local_4.CheckSettler();
            if (_arg_2.phase == TASK_PHASES_ATTACK_BUILDING.ATTACK_TARGET)
            {
                _local_4.SetPathPos(_local_4.GetDestinationPath().pathLenX10000);
                _local_4.StartBattleAnimationOnMap(_local_4.mTargetBuilding);
            };
            return (_local_4);
        }


        public function EndBattleAnimationOnMap(_arg_1:cBuilding):void
        {
            if (mSettler == null)
            {
                return;
            };
            mSettler.mSettlerKi.mAnimate = true;
            var _local_2:int = _arg_1.GetGrid();
            mGeneralInterface.mCurrentPlayerZone.mGoSetListAnimationManager.Remove(_local_2);
        }

        public function StartBattleAnimationOnMap(_arg_1:cBuilding):void
        {
            var _local_3:int;
            if (mSettler == null)
            {
                return;
            };
            var _local_2:String = _arg_1.GetGOContainer().mBattleAnimation_string;
            if (_local_2 != null)
            {
                _local_3 = _arg_1.GetGrid();
                if (!mGeneralInterface.mCurrentPlayerZone.mGoSetListAnimationManager.IsAnimationAtGridPos(_local_3))
                {
                    mGeneralInterface.mCurrentPlayerZone.mGoSetListAnimationManager.AddAnimation(_local_3, _local_2, 0, global.streetGridYHalf, null);
                    mSettler.mSettlerKi.mAnimate = false;
                };
            };
        }

        override public function GetSortValue():Number
        {
            switch (GetTaskPhase())
            {
                case TASK_PHASES_ATTACK_BUILDING.GO_TO_TARGET:
                    if (this.GetWaitStartTime() > 0)
                    {
                        return (mGeneralInterface.GetClientTime() + this.GetWaitStartTime());
                    };
                    return (gMisc.GetMaxFloatValue());
                case TASK_PHASES_ATTACK_BUILDING.ATTACK_TARGET:
                    return (-1);
                case TASK_PHASES_ATTACK_BUILDING.WAIT_AT_TARGET:
                    return (this.GetWaitStartTime());
                default:
                    return (0);
            };
        }

        public function GetBuildingDamage():int
        {
            return (this.mBuildingDamage);
        }

        private function GoFromTowerToArmyDestination():void
        {
            if (this.mArmyDestination == null)
            {
                this.PerformRetreat();
                return;
            };
            if (((!(GetDestinationPath() == null)) && (GetDestinationPath().dest_vector.length > 0)))
            {
                this.mStartGridIdx = GetDestinationPath().CalculateGridIdxForPathPos(GetPathPos());
                this.mTargetBuildingGridIdx = this.mArmyDestinationGridIdx;
                this.mTargetBuilding = this.mArmyDestination;
                SetDestinationPath(mGeneralInterface.mPathFinder.CalculatePath(this.mTargetBuilding.GetStreetGridEntry(), this.mStartGridIdx, null, true));
                mDirtyIndicator = (mDirtyIndicator | DIRTY_INDICATOR.MODIFIED_BIT);
            };
            SetPathPos(0);
        }

        public function GetArmyDestination():cBuilding
        {
            return (this.mArmyDestination);
        }

        public function dispose():void
        {
        }

        public function Retreat():void
        {
            if (cLog.isInfoEnabled())
            {
                cLog.info("cSpecialistTask_AttackBuilding.Retreat()");
            };
            if ((((GetTaskPhase() == TASK_PHASES_ATTACK_BUILDING.GO_TO_TARGET) || (GetTaskPhase() == TASK_PHASES_ATTACK_BUILDING.WAIT_FOR_ORDERS)) || (GetTaskPhase() == TASK_PHASES_ATTACK_BUILDING.ATTACK_TARGET)))
            {
                mOwner.SetWaitingForServer(true);
                globalFlash.gui.mSpecialistPanel.Refresh(mOwner);
                mGeneralInterface.mClientMessages.SendMessagetoServer(COMMAND.RETREAT, mGeneralInterface.mCurrentViewedZoneID, mOwner.GetUniqueID());
            }
            else
            {
                if (cLog.isInfoEnabled())
                {
                    cLog.info(("cSpecialistTask_AttackBuilding.Retreat() cannot retreat because general is in phase " + TASK_PHASES_ATTACK_BUILDING.toString(GetTaskPhase())));
                };
            };
        }

        override protected function NextPhase():void
        {
            super.NextPhase();
            globalFlash.gui.mSpecialistPanel.Refresh(mOwner);
        }

        override public function isModifierApplyable(_arg_1:ModifierVO):Boolean
        {
            return (true);
        }

        override protected function PerformTaskPhase(_arg_1:int, _arg_2:int):void
        {
            var _local_4:int;
            var _local_5:int;
            var _local_6:int;
            var _local_7:int;
            var _local_8:int;
            var _local_9:int;
            var _local_10:*;
            var _local_11:cPlayerData;
            var _local_12:cSquad;
            var _local_3:cBuilding = mGeneralInterface.mCurrentPlayerZone.GetBuildingFromGridPosition(this.mTargetBuildingGridIdx);
            if (((GetTaskPhase() < TASK_PHASES_ATTACK_BUILDING.RETURN_TO_GARRISON) && ((_local_3 == null) || (!(_local_3 == this.mTargetBuilding)))))
            {
                if (((this.mTargetBuilding == this.mArmyDestination) || (this.mArmyDestination == null)))
                {
                    this.mGeneralRetreated = true;
                    this.GoToGarrison();
                    this.SetTaskPhase(TASK_PHASES_ATTACK_BUILDING.RETURN_TO_GARRISON);
                }
                else
                {
                    if (cLog.isInfoEnabled())
                    {
                        cLog.info("cSpecialistTask_AttackBuilding.PerformTaskPhase(): next phase: GO_TO_TARGET");
                    };
                    this.EndBattleAnimationOnMap(this.mTargetBuilding);
                    this.SetTaskPhase(TASK_PHASES_ATTACK_BUILDING.GO_TO_TARGET);
                    this.GoFromTowerToArmyDestination();
                    return;
                };
            };
            switch (GetTaskPhase())
            {
                case TASK_PHASES_ATTACK_BUILDING.GO_TO_TARGET:
                    if (this.mGeneralRetreated)
                    {
                        this.PerformRetreat();
                        return;
                    };
                    _local_4 = GetPathPos();
                    _local_5 = 0;
                    IncPathPos(_arg_1);
                    _local_6 = GetPathPos();
                    if (((GetDestinationPath() == null) || (GetDestinationPath().dest_vector.length == 0)))
                    {
                        this.PerformRetreat();
                        return;
                    };
                    _local_7 = GetDestinationPath().CalculateGridIdxForPathPos(_local_6);
                    _local_8 = (mGeneralInterface.mCurrentPlayerZone.mMapWidth * mGeneralInterface.mCurrentPlayerZone.mMapHeight);
                    do 
                    {
                        _local_5 = GetDestinationPath().CalculateGridIdxForPathPos(_local_4);
                        if (((_local_5 >= 0) && (_local_5 < _local_8)))
                        {
                            if (((mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.IsWatchedByTowers(_local_5, mGeneralInterface)) && (!(mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.IsBuildingWatching(_local_5, this.GetTargetBuilding())))))
                            {
                                _local_10 = this.GoToEnemyTower(_local_5, _local_5);
                                if (cLog.isInfoEnabled())
                                {
                                    cLog.info(((("cSpecialistTask_AttackBuilding.PerformTaskPhase(): Army was disrupted by tower " + this.mTargetBuildingGridIdx) + " at gridIdx ") + _local_5));
                                };
                                if (_local_10) break;
                            };
                        };
                        _local_4 = (_local_4 + defines.INT_SCALE_FACTOR);
                        if (cLog.isInfoEnabled())
                        {
                            cLog.info(("cSpecialistTask_AttackBuilding...path position: " + GetPathPos()));
                        };
                    } while (_local_5 != _local_7);
                    _local_9 = int((_local_6 - (int((_local_4 / defines.INT_SCALE_FACTOR)) * defines.INT_SCALE_FACTOR)));
                    if (_local_9 > 0)
                    {
                        IncPathPos(_local_9);
                    };
                    if (((!(this.mGeneralRetreated)) && (GetPathPos() >= GetDestinationPath().pathLenX10000)))
                    {
                        SetPathPos(GetDestinationPath().pathLenX10000);
                        if (cLog.isInfoEnabled())
                        {
                            cLog.info((((((("cSpecialistTask_AttackBuilding.PerformTaskPhase(): reached target: " + this.mTargetBuilding) + ", GetPathPos():") + GetPathPos()) + ", GetDestinationPath().pathLenX10000:") + GetDestinationPath().pathLenX10000) + ", next phase: WAIT_AT_TARGET"));
                        };
                        this.mWaitStartTime = (mGeneralInterface.GetClientTime() + _arg_2);
                        this.NextPhase();
                    };
                    return;
                case TASK_PHASES_ATTACK_BUILDING.WAIT_AT_TARGET:
                    if (this.mGeneralRetreated)
                    {
                        this.PerformRetreat();
                        return;
                    };
                    if (((this.GetTargetBuilding() == null) || (!(this.GetTargetBuilding().IsEngagedInCombat()))))
                    {
                        if (mGeneralInterface.mCurrentPlayer.GetPlayerId() == mOwner.getPlayerID())
                        {
                            globalFlash.gui.mAvatarMessageList.AddMessage(AVATAR_MESSAGE_TYPE.GENERAL_STARTET_ATTACK, mOwner);
                        }
                        else
                        {
                            globalFlash.gui.mAvatarMessageList.AddMessage(AVATAR_MESSAGE_TYPE.GENERAL_STARTET_ATTACK_VIEWER, mOwner);
                        };
                        SetCollectedTime(0);
                        if (cLog.isInfoEnabled())
                        {
                            cLog.info("cSpecialistTask_AttackBuilding.PerformTaskPhase(): next phase: ATTACK_TARGET");
                        };
                        this.NextPhase();
                        this.StartBattleAnimationOnMap(this.mTargetBuilding);
                        globalFlash.gui.mSpecialistPanel.Refresh(mOwner);
                        this.mTargetBuilding.SetEngagedInCombat(true, true);
                    };
                    return;
                case TASK_PHASES_ATTACK_BUILDING.ATTACK_TARGET:
                    if (this.mGeneralRetreated)
                    {
                        this.PerformRetreat();
                        return;
                    };
                    if (((!(this.mBattleResultVO == null)) && (!(this.mBattleResultVO.attackedBuildingGridIdx == this.mTargetBuildingGridIdx))))
                    {
                        this.mBattleResultVO = null;
                        this.mTimeToReduceOneDamageLevel = -1;
                    };
                    if ((((!(this.mGeneralRetreated)) && (!(this.mBattleResultVO == null))) && (this.mBattleResultVO.buildingHitPoints <= 0)))
                    {
                        if (this.mTimeToReduceOneDamageLevel == -1)
                        {
                            this.mHitPointsOfOneDamageLevel = (this.mTargetBuilding.GetMaxHitPoints() / cBuilding.DAMAGE_LEVEL_AMOUNT);
                            this.mTimeToReduceOneDamageLevel = ((this.mBattleResultVO.combatDuration - this.mBattleResultVO.unitFightDuration) / cBuilding.DAMAGE_LEVEL_AMOUNT);
                            this.mTimeOfNextDamageLevel = (this.mBattleResultVO.unitFightDuration + this.mTimeToReduceOneDamageLevel);
                        };
                        _local_11 = null;
                        while (((GetCollectedTime() >= this.mTimeOfNextDamageLevel) && ((this.mTargetBuilding.GetCurrentHitPoints() - this.mHitPointsOfOneDamageLevel) > 0)))
                        {
                            if (cLog.isInfoEnabled())
                            {
                                cLog.info("cSpecialistTask_AttackBuilding.PerformTaskPhase(): calculating building battle!");
                            };
                            if (_local_11 == null)
                            {
                                _local_11 = mGeneralInterface.FindPlayerFromId(mOwner.getPlayerID());
                                gMisc.Assert((!(_local_11 == null)), ("Could not find player with ID " + mOwner.getPlayerID()));
                            };
                            this.mTargetBuilding.DamageBuilding(this.mHitPointsOfOneDamageLevel, _local_11);
                            this.mTimeOfNextDamageLevel = (this.mTimeOfNextDamageLevel + this.mTimeToReduceOneDamageLevel);
                        };
                    };
                    if ((((!(this.mGeneralRetreated)) && (!(this.mBattleResultVO == null))) && (GetCollectedTime() >= this.mBattleResultVO.combatDuration)))
                    {
                        this.HandleApplyBattleResult();
                    };
                    return;
                case TASK_PHASES_ATTACK_BUILDING.RETURN_TO_GARRISON:
                    speed = nonAttackSpeed;
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
                case TASK_PHASES_ATTACK_BUILDING.WAIT_FOR_ORDERS:
                    if (this.hasLostBattle())
                    {
                        if (mGeneralInterface.mCurrentPlayer.GetPlayerId() == mOwner.getPlayerID())
                        {
                            globalFlash.gui.mAvatarMessageList.AddMessage(AVATAR_MESSAGE_TYPE.GENERAL_FINISHED_NEGATIVE, mOwner);
                        }
                        else
                        {
                            globalFlash.gui.mAvatarMessageList.AddMessage(AVATAR_MESSAGE_TYPE.GENERAL_FINISHED_NEGATIVE_VIEWER, mOwner);
                        };
                        mOwner.SetTask(new cSpecialistTask_Recover(mGeneralInterface, mOwner, 0, TASK_PHASES_RECOVER.RECOVER));
                    }
                    else
                    {
                        if (mGeneralInterface.mCurrentPlayer.GetPlayerId() == mOwner.getPlayerID())
                        {
                            globalFlash.gui.mAvatarMessageList.AddMessage(AVATAR_MESSAGE_TYPE.GENERAL_FINISHED_POSITIVE, mOwner);
                        }
                        else
                        {
                            globalFlash.gui.mAvatarMessageList.AddMessage(AVATAR_MESSAGE_TYPE.GENERAL_FINISHED_POSITIVE_VIEWER, mOwner);
                        };
                        mOwner.SetTask(null);
                    };
                    for each (_local_12 in mOwner.GetArmy().GetSquads_vector())
                    {
                        _local_12.Heal(_local_12.GetUnitBase().GetHitPoints());
                    };
                    RemoveSettler();
                    globalFlash.gui.mSpecialistPanel.Refresh(mOwner);
                    return;
                default:
                    gMisc.Assert(false, (("Could not interpret task phase " + GetTaskPhase()) + "!"));
            };
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
            var _local_3:ModifierVO;
            var _local_8:cSquad;
            var _local_11:cPlayerData;
            var _local_12:dBuffVO;
            var _local_13:dUniqueID;
            var _local_14:cBuff;
            var _local_15:cSquad;
            var _local_16:int;
            var _local_17:int;
            var _local_18:cResources;
            if (this.mGeneralRetreated)
            {
                if (cLog.isInfoEnabled())
                {
                    cLog.info("cSpecialistTask_AttackBuilding.HandleApplyBattleResult() perform retreat!");
                };
                this.PerformRetreat();
                return;
            };
            if (this.mBattleResultVO == null)
            {
                cLog.error("cSpecialistTask_AttackBuilding.HandleApplyBattleResult(): no battle result found!");
                this.PerformRetreat();
                return;
            };
            if (cLog.isInfoEnabled())
            {
                cLog.info("cSpecialistTask_AttackBuilding.HandleApplyBattleResult()");
            };
            this.EndBattleAnimationOnMap(this.mTargetBuilding);
            var _local_1:cArmy = new cArmy(0, 0, 0, null);
            _local_1.ApplyArmyVO(mOwner.GetArmy().CreateArmyVO());
            var _local_2:Vector.<ModifierVO> = new Vector.<ModifierVO>();
            for each (_local_3 in mOwner.GetAllActiveModifiers())
            {
                if (((_local_3.modifier_string == "CombatModifier") && (_local_3.item_string == COMBAT_MODIFIER_ATTRIBUTE.toString(COMBAT_MODIFIER_ATTRIBUTE.RECOVER_LOST_TROOPS))))
                {
                    _local_2.push(_local_3);
                };
                if ((((!(this.mBattleResultVO.battleResult == BATTLE_RESULT.GENERAL_LOST)) && (_local_3.modifier_string == "CombatModifier")) && (_local_3.item_string == COMBAT_MODIFIER_ATTRIBUTE.toString(COMBAT_MODIFIER_ATTRIBUTE.HIRED_MILITARY_FOR_XP))))
                {
                    for each (_local_11 in mGeneralInterface.GetPlayerList_vector())
                    {
                        if (_local_11.getPlayerID() == mOwner.getPlayerID())
                        {
                            _local_12 = new dBuffVO();
                            _local_12.buffName_string = defines.HIRED_MILITARY_BUFF;
                            _local_12.resourceName_string = "Recruit";
                            _local_13 = _local_11.GetNewUniqueID();
                            _local_12.uniqueId1 = _local_13.uniqueID1;
                            _local_12.uniqueId2 = _local_13.uniqueID2;
                            _local_12.amount = Math.ceil(((this.mBattleResultVO.gainedXp as Number) / _local_3.multiplier));
                            _local_14 = cBuff.CreateBuffFromVO(_local_12);
                            _local_11.addBuff(_local_14);
                            globalFlash.gui.mAvatarMessageList.AddMessage(AVATAR_MESSAGE_TYPE.HIRED_MILITARY_FROM_SKILL, _local_12);
                            break;
                        };
                    };
                };
            };
            if (_local_2.length > 0)
            {
                this.CalculateFirstAidProc(_local_1, this.mBattleResultVO, _local_2);
            };
            var _local_4:dArmyVO = this.mTargetBuilding.GetArmy().CreateArmyVO();
            mOwner.GetArmy().ApplyArmyVO(this.mBattleResultVO.attackingArmyVO);
            mOwner.GetArmy().RemoveUnits(mOwner.GetSpecialistDescription().GetMilitaryUnitType_string(), 1);
            this.mTargetBuilding.GetArmy().ApplyArmyVO(this.mBattleResultVO.defendingArmyVO);
            mGeneralInterface.mCurrentPlayerZone.notifyPropertyObserver(TriggerUtils.UNITS_OWNED_NOTIFICATION_PROPERTY_NAME, mOwner.GetSpecialistDescription().GetMilitaryUnitType_string());
            var _local_5:cPlayerData = mGeneralInterface.FindPlayerFromId(mOwner.getPlayerID());
            gMisc.Assert((!(_local_5 == null)), ("Could not find player with ID " + mOwner.getPlayerID()));
            var _local_6:cArmy = mOwner.GetArmy();
            var _local_7:int;
            for each (_local_8 in _local_1.GetSquads_vector())
            {
                if ((_local_8.GetType() in mGeneralInterface.mCurrentPlayerZone.mHiredTroopsPool))
                {
                    _local_15 = _local_6.GetSquad(_local_8.GetType());
                    _local_16 = mGeneralInterface.mCurrentPlayerZone.mHiredTroopsPool[_local_8.GetType()];
                    if (_local_15 == null)
                    {
                        _local_17 = _local_8.amount;
                    }
                    else
                    {
                        _local_17 = (_local_8.amount - _local_15.amount);
                    };
                    _local_17 = Math.min(_local_17, _local_16);
                    _local_7 = (_local_7 + _local_17);
                    mGeneralInterface.mCurrentPlayerZone.mHiredTroopsPool[_local_8.GetType()] = (mGeneralInterface.mCurrentPlayerZone.mHiredTroopsPool[_local_8.GetType()] - _local_17);
                };
            };
            if (mGeneralInterface.mCurrentPlayer.GetPlayerId() == mOwner.getPlayerID())
            {
                globalFlash.gui.mHiredTroopsPoolPanel.SetData(mGeneralInterface.mCurrentPlayerZone.mHiredTroopsPool);
            };
            var _local_9:int = (this.mBattleResultVO.lostPopulationAttacker - _local_7);
            if (_local_9 > 0)
            {
                _local_18 = mGeneralInterface.mCurrentPlayerZone.GetResources(_local_5);
                if (_local_18 != null)
                {
                    _local_18.FreeMilitary(_local_9);
                    _local_18.RemovePlayerResourcesFromResourcesInList(onePopulation_vector, _local_9, ModifyReason.BATTLE_RESULT);
                }
                else
                {
                    (mGeneralInterface as cGameInterface).forceZonePersistence(COMMAND.APPLY_CASUALTIES);
                };
            };
            var _local_10:int = -1;
            mOwner.IncUnitsDefeated(this.mBattleResultVO.casualtiesDefender);
            _local_5.AddXP(this.mBattleResultVO.gainedXp);
            _local_5.AddBonusValidXP(this.mBattleResultVO.gainedBonusValidXP);
            this.mTargetBuilding.DamageBuilding((this.mTargetBuilding.GetCurrentHitPoints() - this.mBattleResultVO.buildingHitPoints), _local_5);
            if (this.mTargetBuilding.GetCurrentHitPoints() <= 0)
            {
                mOwner.IncBuildingsDestroyed(1);
            };
            TrackManager.getInstance().trackBattleResult(_local_5, mGeneralInterface.mCurrentViewedZoneID, this.mBattleResultVO, mOwner, _local_1.CreateArmyVO(), _local_4, _local_10);
            switch (this.mBattleResultVO.battleResult)
            {
                case BATTLE_RESULT.GENERAL_WON_AND_CONTINUES:
                    if (mGeneralInterface.mCurrentPlayer.GetPlayerId() == mOwner.getPlayerID())
                    {
                        globalFlash.gui.mAvatarMessageList.AddMessage(AVATAR_MESSAGE_TYPE.GENERAL_WON_AND_CONTINUES, mOwner);
                    }
                    else
                    {
                        globalFlash.gui.mAvatarMessageList.AddMessage(AVATAR_MESSAGE_TYPE.GENERAL_WON_AND_CONTINUES_VIEWER, mOwner);
                    };
                    mGeneralInterface.channels.SPECIALIST.notify(SpecialistNotifier.GENERAL_WON_string, new BattleStatusVO(mGeneralInterface.getAdventureName(), this.mTargetBuilding.GetBuildingName_string(), this.mBattleResultVO.casualtiesAttacker));
                    mGeneralInterface.channels.SPECIALIST.notify(SpecialistNotifier.GENERAL_CASUALTIES_STRING, new BattleStatusVO(mGeneralInterface.getAdventureName(), this.mTargetBuilding.GetBuildingName_string(), this.mBattleResultVO.casualtiesAttacker));
                    mGeneralInterface.channels.SPECIALIST.notify(SpecialistNotifier.GENERAL_BATTLE_FOUGHT_string, new BattleStatusVO(mGeneralInterface.getAdventureName(), this.mTargetBuilding.GetBuildingName_string(), this.mBattleResultVO.casualtiesAttacker));
                    this.SetTaskPhase(TASK_PHASES_ATTACK_BUILDING.GO_TO_TARGET);
                    this.GoFromTowerToArmyDestination();
                    break;
                case BATTLE_RESULT.GENERAL_WON_AND_RETURNS:
                    if (mGeneralInterface.mCurrentPlayer.GetPlayerId() == mOwner.getPlayerID())
                    {
                        globalFlash.gui.mAvatarMessageList.AddMessage(AVATAR_MESSAGE_TYPE.GENERAL_WON_AND_RETURNS, mOwner);
                    }
                    else
                    {
                        globalFlash.gui.mAvatarMessageList.AddMessage(AVATAR_MESSAGE_TYPE.GENERAL_WON_AND_RETURNS_VIEWER, mOwner);
                    };
                    mGeneralInterface.channels.SPECIALIST.notify(SpecialistNotifier.GENERAL_WON_string, new BattleStatusVO(mGeneralInterface.getAdventureName(), this.mTargetBuilding.GetBuildingName_string(), this.mBattleResultVO.casualtiesAttacker));
                    mGeneralInterface.channels.SPECIALIST.notify(SpecialistNotifier.GENERAL_CASUALTIES_STRING, new BattleStatusVO(mGeneralInterface.getAdventureName(), this.mTargetBuilding.GetBuildingName_string(), this.mBattleResultVO.casualtiesAttacker));
                    mGeneralInterface.channels.SPECIALIST.notify(SpecialistNotifier.GENERAL_BATTLE_FOUGHT_string, new BattleStatusVO(mGeneralInterface.getAdventureName(), this.mTargetBuilding.GetBuildingName_string(), this.mBattleResultVO.casualtiesAttacker));
                    this.GoToGarrison();
                    this.NextPhase();
                    break;
                case BATTLE_RESULT.GENERAL_LOST:
                    if (mGeneralInterface.mCurrentPlayer.GetPlayerId() == mOwner.getPlayerID())
                    {
                        globalFlash.gui.mAvatarMessageList.AddMessage(AVATAR_MESSAGE_TYPE.GENERAL_LOST, mOwner);
                    }
                    else
                    {
                        globalFlash.gui.mAvatarMessageList.AddMessage(AVATAR_MESSAGE_TYPE.GENERAL_LOST_VIEWER, mOwner);
                    };
                    mGeneralInterface.channels.SPECIALIST.notify(SpecialistNotifier.GENERAL_CASUALTIES_STRING, new BattleStatusVO(mGeneralInterface.getAdventureName(), this.mTargetBuilding.GetBuildingName_string(), this.mBattleResultVO.casualtiesAttacker));
                    mGeneralInterface.channels.SPECIALIST.notify(SpecialistNotifier.GENERAL_BATTLE_FOUGHT_string, new BattleStatusVO(mGeneralInterface.getAdventureName(), this.mTargetBuilding.GetBuildingName_string(), this.mBattleResultVO.casualtiesAttacker));
                    this.GoToGarrison();
                    this.SetTaskPhase(TASK_PHASES_ATTACK_BUILDING.RETURN_TO_GARRISON);
                    this.mTargetBuilding.SetEngagedInCombat(false, true);
                    mGeneralInterface.channels.SPECIALIST.notify(SpecialistNotifier.GENERAL_LOST_string, this.mOwner);
                    this.EndBattleAnimationOnMap(this.mTargetBuilding);
                    break;
                case BATTLE_RESULT.GENERAL_WON_AND_BLOCKED:
                    if (mGeneralInterface.mCurrentPlayer.GetPlayerId() == mOwner.getPlayerID())
                    {
                        globalFlash.gui.mAvatarMessageList.AddMessage(AVATAR_MESSAGE_TYPE.GENERAL_WON_AND_BLOCKED, mOwner);
                    }
                    else
                    {
                        globalFlash.gui.mAvatarMessageList.AddMessage(AVATAR_MESSAGE_TYPE.GENERAL_WON_AND_BLOCKED_VIEWER, mOwner);
                    };
                    mGeneralInterface.channels.SPECIALIST.notify(SpecialistNotifier.GENERAL_WON_string, new BattleStatusVO(mGeneralInterface.getAdventureName(), this.mTargetBuilding.GetBuildingName_string(), this.mBattleResultVO.casualtiesAttacker));
                    mGeneralInterface.channels.SPECIALIST.notify(SpecialistNotifier.GENERAL_CASUALTIES_STRING, new BattleStatusVO(mGeneralInterface.getAdventureName(), this.mTargetBuilding.GetBuildingName_string(), this.mBattleResultVO.casualtiesAttacker));
                    mGeneralInterface.channels.SPECIALIST.notify(SpecialistNotifier.GENERAL_BATTLE_FOUGHT_string, new BattleStatusVO(mGeneralInterface.getAdventureName(), this.mTargetBuilding.GetBuildingName_string(), this.mBattleResultVO.casualtiesAttacker));
                    this.GoToGarrison();
                    this.SetTaskPhase(TASK_PHASES_ATTACK_BUILDING.RETURN_TO_GARRISON);
                    this.mTargetBuilding.SetEngagedInCombat(false, true);
                    this.EndBattleAnimationOnMap(this.mTargetBuilding);
                    break;
                default:
                    if (cLog.isInfoEnabled())
                    {
                        cLog.info(("cSpecialistTask_AttackBuilding.ApplyBattleResult(): battleResult:" + BATTLE_RESULT.toString(this.mBattleResultVO.battleResult)));
                    };
                    gMisc.Assert(false, ("Could not interpret battle result " + this.mBattleResultVO.battleResult));
            };
            globalFlash.gui.mSpecialistPanel.Refresh(mOwner);
        }

        public function hasLostBattle():Boolean
        {
            return (((!(this.mGeneralRetreated)) && (!(this.mBattleResultVO == null))) ? (this.mBattleResultVO.battleResult == BATTLE_RESULT.GENERAL_LOST) : (!(mOwner.GetArmy().HasUnits())));
        }

        private function PerformRetreat():void
        {
            if (cLog.isInfoEnabled())
            {
                cLog.info(("cSpecialistTask_AttackBuilding.PerformRetreat() in phase: " + TASK_PHASES_ATTACK_BUILDING.toString(GetTaskPhase())));
            };
            if (GetTaskPhase() == TASK_PHASES_ATTACK_BUILDING.ATTACK_TARGET)
            {
                this.EndBattleAnimationOnMap(this.mTargetBuilding);
                this.mTargetBuilding.SetEngagedInCombat(false, true);
                this.mTargetBuilding.SetCurrentHitPoints(this.mTargetBuilding.GetMaxHitPoints());
            };
            if (cLog.isInfoEnabled())
            {
                cLog.info(("cSpecialistTask_AttackBuilding.PerformRetreat() mTargetBuilding: " + this.mTargetBuilding));
            };
            this.GoToGarrison();
            this.SetTaskPhase(TASK_PHASES_ATTACK_BUILDING.RETURN_TO_GARRISON);
            if (mGeneralInterface.mCurrentPlayer.GetPlayerId() == mOwner.getPlayerID())
            {
                globalFlash.gui.mAvatarMessageList.AddMessage(AVATAR_MESSAGE_TYPE.GENERAL_RETREAT, mOwner);
            }
            else
            {
                globalFlash.gui.mAvatarMessageList.AddMessage(AVATAR_MESSAGE_TYPE.GENERAL_RETREAT_VIEWER, mOwner);
            };
            mOwner.SetWaitingForServer(false);
            (mGeneralInterface as cGameInterface).requestZonePersistence(COMMAND.RETREAT);
        }

        private function CalculateFirstAidProc(_arg_1:cArmy, _arg_2:dBattleResultVO, _arg_3:Vector.<ModifierVO>):void
        {
            var _local_8:dSquadVO;
            var _local_9:CombatCasualtyVO;
            var _local_10:int;
            var _local_13:CombatCasualtyVO;
            var _local_14:Number;
            var _local_15:ModifierVO;
            var _local_16:Number;
            var _local_17:int;
            var _local_4:Vector.<CombatCasualtyVO> = new Vector.<CombatCasualtyVO>();
            var _local_5:Number = 0;
            var _local_6:int;
            var _local_7:dArmyVO = _arg_1.GetCasualtiesVO(this.mBattleResultVO.attackingArmyVO);
            for each (_local_8 in _local_7.squads)
            {
                _local_14 = 0;
                for each (_local_15 in _arg_3)
                {
                    if (CombatModifier.combatModifierTypeAppliesToUnit(_local_15, _local_8.GetUnitDescription()))
                    {
                        _local_14 = (_local_14 + _local_15.multiplier);
                    };
                };
                if (_local_14 > 0)
                {
                    _local_16 = gMisc.safeMultiplication(_local_8.amount, _local_14);
                    _local_5 = (_local_5 + _local_16);
                    _local_8.amount = int(Math.ceil(_local_16));
                    _local_4.push(new CombatCasualtyVO(_local_8.GetUnitDescription().GetType(), _local_8.GetUnitDescription().GetSequencePrio(), _local_16, 0));
                };
            };
            for each (_local_9 in _local_4)
            {
                _local_17 = (Math.floor(_local_9.interimRecoverValue) as int);
                if (_local_17 > 0)
                {
                    _local_9.actualRecoverValue = _local_17;
                    _local_9.interimRecoverValue = (_local_9.interimRecoverValue - _local_17);
                    _local_5 = (_local_5 - _local_17);
                };
            };
            _local_4.sort(CombatCasualtyVO.sortInterimThenSequencePrio);
            _local_6 = (Math.ceil(_local_5) as int);
            _local_10 = 0;
            while (_local_6 > 0)
            {
                if (_local_10 <= (_local_4.length - 1))
                {
                    _local_4[_local_10].actualRecoverValue++;
                    _local_6--;
                };
                if (_local_10 == (_local_4.length - 1))
                {
                    _local_10 = 0;
                }
                else
                {
                    _local_10++;
                };
            };
            var _local_11:dArmyVO = new dArmyVO();
            var _local_12:int;
            for each (_local_13 in _local_4)
            {
                if (_local_13.actualRecoverValue > 0)
                {
                    _local_11.squads.addItem(dSquadVO.Create(_local_13.unitName, _local_13.actualRecoverValue, cMilitaryUnitDescription.GetUnitDescriptionForType(_local_13.unitName).GetHitPoints()));
                    _local_12 = (_local_12 + _local_13.actualRecoverValue);
                };
            };
            this.mBattleResultVO.lostPopulationAttacker = (this.mBattleResultVO.lostPopulationAttacker - _local_12);
            this.mBattleResultVO.attackingArmyVO.AddArmyVO(_local_11);
        }

        public function GetBattleResultVO():dBattleResultVO
        {
            return (this.mBattleResultVO);
        }

        public function GetWaitStartTime():Number
        {
            return (this.mWaitStartTime);
        }

        public function SetBattleResultVO(_arg_1:dBattleResultVO):void
        {
            this.mBattleResultVO = _arg_1;
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

        public function HandleRetreat(_arg_1:Boolean):void
        {
            if (cLog.isInfoEnabled())
            {
                cLog.info(((("cSpecialistTask_AttackBuilding.HandleRetreat() in phase: " + TASK_PHASES_ATTACK_BUILDING.toString(GetTaskPhase())) + " at mCollectedTime:") + mCollectedTime));
            };
            if ((((_arg_1) || (!(GetTaskPhase() == TASK_PHASES_ATTACK_BUILDING.ATTACK_TARGET))) || (mCollectedTime <= defines.GAMETICK_SYSTEM_POSTPROCESS_TIME_MIN)))
            {
                this.mGeneralRetreated = true;
            };
        }

        override public function StartTask():void
        {
            super.StartTask();
            SpawnSettler(mOwner.GetGarrison().GetXInt(), mOwner.GetGarrison().GetYInt());
        }

        private function GoToEnemyTower(_arg_1:int, _arg_2:int):Boolean
        {
            var _local_4:cPathObject;
            var _local_5:int;
            var _local_3:Vector.<int> = mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.GetReadyTowerGridIdxs(_arg_1);
            if (_local_3.length > 0)
            {
                _local_4 = mGeneralInterface.mPathFinder.CalculatePathForDestinations(_arg_2, _local_3, null);
                if (_local_4.dest_vector.length > 0)
                {
                    if (mGeneralInterface.mCurrentPlayer.GetPlayerId() == mOwner.getPlayerID())
                    {
                        globalFlash.gui.mAvatarMessageList.AddMessage(AVATAR_MESSAGE_TYPE.GENERAL_DISTRACTED, mOwner);
                    }
                    else
                    {
                        globalFlash.gui.mAvatarMessageList.AddMessage(AVATAR_MESSAGE_TYPE.GENERAL_DISTRACTED_VIEWER, mOwner);
                    };
                    this.mStartGridIdx = _arg_2;
                    SetDestinationPath(_local_4);
                    _local_5 = gCalculations.MoveStreetGridToDir8(mGeneralInterface.mCurrentPlayerZone, _local_4.dest_vector[(_local_4.dest_vector.length - 1)].streetGridIdx, defines.DIR8_NORTH_WEST);
                    this.mTargetBuildingGridIdx = _local_5;
                    this.mTargetBuilding = mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.mBuildingContainer.get(_local_5);
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
            return (((("<cSpecialistTask_AttackBuilding target='" + this.mTargetBuilding) + "' attackBuidlingMode='") + SPECIALIST_TASK_ATTACK_BUILDING_MODE.toString(this.mAttackBuildingMode)) + "' >");
        }

        public function GetCombatRoundTimeMultiplier():Number
        {
            return (this.mCombatRoundTimeMultiplier);
        }

        public function GetStartingArmySize():int
        {
            return (this.mStartingArmySize);
        }

        private function GoToGarrison():void
        {
            this.EndBattleAnimationOnMap(this.mTargetBuilding);
            if (((!(GetDestinationPath() == null)) && (GetDestinationPath().dest_vector.length > 0)))
            {
                this.mStartGridIdx = GetDestinationPath().CalculateGridIdxForPathPos(GetPathPos());
                SetDestinationPath(mGeneralInterface.mPathFinder.CalculatePath(this.mStartGridIdx, mOwner.GetGarrison().GetStreetGridEntry(), null, true));
                SetPathPos(GetDestinationPath().pathLenX10000);
            };
        }

        override public function CreateTaskVOFromSpecialistTask():dSpecialistTaskVO
        {
            var _local_1:dSpecialistTask_AttackBuildingVO = new dSpecialistTask_AttackBuildingVO();
            _local_1.type = GetType();
            _local_1.phase = GetTaskPhase();
            _local_1.collectedTime = GetCollectedTime();
            _local_1.attackBuildingMode = this.mAttackBuildingMode;
            _local_1.startGridPos = this.mStartGridIdx;
            _local_1.pathPos = GetPathPos();
            _local_1.armyDestinationBuildingGridPos = this.GetArmyDestinationGridIdx();
            _local_1.targetBuildingGridPos = this.GetTargetBuildingGridIdx();
            _local_1.pathPos = GetPathPos();
            _local_1.battleResultVO = this.mBattleResultVO;
            _local_1.startWaitPhase = this.mWaitStartTime;
            return (_local_1);
        }

        public function GetArmyDestinationGridIdx():int
        {
            return (this.mArmyDestinationGridIdx);
        }

        public function SetCombatRoundTimeMultiplier(_arg_1:Number):void
        {
            this.mCombatRoundTimeMultiplier = _arg_1;
        }

        override protected function CheckSettler():void
        {
            switch (GetTaskPhase())
            {
                case TASK_PHASES_ATTACK_BUILDING.WAIT_FOR_ORDERS:
                    if (GetSettler() != null)
                    {
                        RemoveSettler();
                    };
                    return;
                case TASK_PHASES_ATTACK_BUILDING.WAIT_AT_TARGET:
                case TASK_PHASES_ATTACK_BUILDING.GO_TO_TARGET:
                case TASK_PHASES_ATTACK_BUILDING.ATTACK_TARGET:
                case TASK_PHASES_ATTACK_BUILDING.RETURN_TO_GARRISON:
                    if (GetSettler() == null)
                    {
                        SpawnSettler(0, 0);
                    };
                    return;
                default:
                    if (cLog.isInfoEnabled())
                    {
                        cLog.error(("cSpecialistTask_AttackBuilding.CheckSettler(): Could not interpret task phase " + GetTaskPhase()));
                    };
            };
        }


    }
}
