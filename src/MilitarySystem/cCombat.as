package MilitarySystem
{
    import Model.Notifier;
    import Utils.Disposable;
    import __AS3__.vec.Vector;
    import ServerState.dResource;
    import Utils.Random;
    import Specialists.cSpecialistTask_AttackBuildingNewCombat;
    import mx.collections.ArrayCollection;
    import Communication.VO.CombatVO;
    import Communication.VO.CombatKillStatsVO;
    import nLib.cLog;
    import Communication.VO.CombatSlotVO;
    import Enums.COMBAT_RESULT;
    import GO.cCombatData;
    import Specialists.cSpecialist;
    import ServerState.cPlayerData;
    import ServerState.cResources;
    import Enums.ModifyReason;
    import Enums.MILITARY_UNIT_ABILITY;
    import BuffSystem.BuffAppliance;
    import BuffSystem.cBuffDefinition;
    import Enums.BUFF_PARAMETER_NAME;
    import GO.cBuilding;
    import Communication.VO.CombatUnitSwitchVO;
    import Enums.DIRTY_INDICATOR;
    import __AS3__.vec.*;

    public class cCombat extends Notifier implements Disposable 
    {

        public static const bCombatLog:Boolean = false;
        public static const SLOT_PLAYER_DAMAGE_TAKEN_string:String = "playerDamageTaken";
        public static const SLOT_NPC_DAMAGE_TAKEN_string:String = "npcDamageTaken";
        public static const SLOT_BATCH_DIED_string:String = "batchDied";
        public static const SLOT_BATCH_DEPLOYED_string:String = "batchDeployed";
        public static const SLOT_UNITS_DIED_string:String = "unitsDied";
        public static const PLAYER_UNIT_SWITCH_FAILED_string:String = "unitChangeFailed";
        private static var onePopulation_vector:Vector.<dResource> = null;
        public static const CombatSlotTypePlayer:int = 1;
        public static const CombatSlotTypeNPC:int = 2;
        public static const COMBAT_STATE_NONE:int = 0;
        public static const COMBAT_STATE_ROUND_FINISHED:int = 1;
        public static const COMBAT_STATE_WAIT_FOR_REFILL:int = 2;
        public static const COMBAT_STATE_COMPLETED:int = 3;

        private var mCombatSlotNPC:cCombatSlot;
        private var mDoUnitSwitchPause:Boolean = false;
        private var mCombatTimeBuffer:int = 0;
        private var mRandom:Random;
        private var mUpcomingUnitPlayer:cSquad = null;
        private var mSpecialistTask:cSpecialistTask_AttackBuildingNewCombat = null;
        private var mCombatSlotPlayer:cCombatSlot;
        private var mCombatResult:int = 1;
        private var mFightingUnitPlayer:cSquad = null;
        private var mCombatRound:int = 1;
        private var mCombatState:int = 0;
        private var mUpcomingUnitNPC:cSquad = null;
        private var dKillStats:Object = new Object();
        private var mFightingUnitNPC:cSquad = null;
        private var mCombatUnitSwitch:ArrayCollection = new ArrayCollection();

        {
            InitStatic();
        }

        public function cCombat(_arg_1:cSpecialistTask_AttackBuildingNewCombat, _arg_2:CombatVO)
        {
            super();
            this.mSpecialistTask = _arg_1;
            if (_arg_2 != null)
            {
                this.InitFromVO(_arg_2);
            }
            else
            {
                this.InitNewInstance();
            };
        }

        private static function InitStatic():void
        {
            onePopulation_vector = new Vector.<dResource>();
            var _local_1:dResource = new dResource();
            _local_1.name_string = defines.POPULATION_RESOURCE_NAME_string;
            _local_1.amount = 1;
            onePopulation_vector.push(_local_1);
        }


        private function SetFightingUnitNPC(_arg_1:cSquad):void
        {
            this.mFightingUnitNPC = _arg_1;
            this.LogCombat((("cCombat.SetFightingUnitNPC: (Type: " + ((this.mFightingUnitNPC != null) ? this.mFightingUnitNPC.GetUnitBase().GetType() : "null")) + ")"));
        }

        private function InitNewInstance():void
        {
            var _local_1:cSquad;
            var _local_2:cSquad;
            var _local_3:int;
            var _local_4:int;
            this.LogCombat("cCombat.InitNewInstance:");
            this.mRandom = new Random(int(((this.mSpecialistTask.GetTargetBuildingGridIdx() + this.mSpecialistTask.GetTargetBuilding().GetArmy().GetUnitsCount()) + this.mSpecialistTask.GetTargetBuilding().getPlayerID())));
            this.mCombatSlotPlayer = new cCombatSlot(null);
            this.mCombatSlotNPC = new cCombatSlot(null);
            for each (_local_1 in this.mSpecialistTask.GetOwner().GetArmy().GetSquads_vector())
            {
                this.dKillStats[_local_1.GetType()] = CombatKillStatsVO.Create(_local_1.GetType(), _local_1.GetAmount(), 0, 0);
                this.LogCombat((((("cCombat.InitNewInstance: Attacker units (UnitType: " + _local_1.GetType()) + " / Amount: ") + _local_1.GetAmount()) + ")"));
            };
            for each (_local_2 in this.mSpecialistTask.GetTargetBuilding().GetArmy().GetSquads_vector())
            {
                this.dKillStats[_local_2.GetType()] = CombatKillStatsVO.Create(_local_2.GetType(), _local_2.GetAmount(), 0, 0);
                this.LogCombat((((("cCombat.InitNewInstance: Defender units (UnitType: " + _local_2.GetType()) + " / Amount: ") + _local_2.GetAmount()) + ")"));
            };
            if (this.GetFirstUnitPlayer() != null)
            {
                this.SetFightingUnitPlayer(this.GetFirstUnitPlayer());
            }
            else
            {
                this.SetFightingUnitPlayer(this.GetDefaultNextPlayerUnit());
            };
            this.SetFightingUnitNPC(this.mSpecialistTask.GetTargetBuilding().GetArmy().GetFirstDefenseNPCUnit());
            if ((((bCombatLog) && (cLog.isInfoEnabled())) && (!(this.GetFightingUnitNPC() == null))))
            {
                cLog.info((("cCombat.SelectFirstNPCUnit: setting first NPC unit (Type: " + this.GetFightingUnitNPC().GetUnitBase().GetType()) + ")"));
            };
            if (this.GetFightingUnitPlayer() != null)
            {
                this.GetCombatSlotPlayer().Reset(this.GetFightingUnitPlayer(), Math.min(this.GetFightingUnitPlayer().GetAmount(), this.GetFightingUnitPlayer().GetUnitData().GetCombatBatchSize()));
                notifyPropertyObserver(SLOT_BATCH_DEPLOYED_string, this.GetCombatSlotPlayer());
            }
            else
            {
                cLog.error(((((("PLAYER " + this.mSpecialistTask.GetOwner().getPlayerID()) + " No fighting unit for SPECIALIST ") + this.mSpecialistTask.GetOwner()) + " ARMY ") + this.mSpecialistTask.GetOwner().GetArmy()));
            };
            if (this.GetFightingUnitNPC() != null)
            {
                _local_3 = 0;
                _local_4 = this.GetFightingUnitNPC().GetUnitData().GetCombatBatchSize();
                if (_local_4 > 0)
                {
                    _local_3 = this.GetCombatSlotNPC().GetUnitData().GetCombatBatchSize();
                }
                else
                {
                    _local_3 = this.GetCombatSlotPlayer().GetUnitData().GetCombatBatchSize();
                };
                this.GetCombatSlotNPC().Reset(this.GetFightingUnitNPC(), Math.min(this.GetFightingUnitNPC().GetAmount(), _local_3));
                notifyPropertyObserver(SLOT_BATCH_DEPLOYED_string, this.GetCombatSlotNPC());
            };
            this.SetUpcomingUnitPlayer(this.GetDefaultNextPlayerUnit());
            this.SetUpcomingUnitNPC(this.getNextNPCUnit());
        }

        public function CreateCombatSlotVO(_arg_1:int, _arg_2:cCombatSlot):CombatSlotVO
        {
            var _local_3:CombatSlotVO;
            if (_arg_2 != null)
            {
                _local_3 = new CombatSlotVO();
                _local_3.slotType = _arg_1;
                _local_3.unitType = ((_arg_2.GetSquad() != null) ? _arg_2.GetUnitData().GetType() : null);
                _local_3.hitPointsLeft = _arg_2.GetHitPointsLeft();
            };
            return (_local_3);
        }

        public function GetCombatResult():int
        {
            return (this.mCombatResult);
        }

        public function GetUpcomingUnitPlayer():cSquad
        {
            return (this.mUpcomingUnitPlayer);
        }

        public function GetChecksum():int
        {
            var _local_1:int;
            _local_1 = (_local_1 ^ (this.mCombatRound << 16));
            _local_1 = (_local_1 ^ (this.mCombatState << 8));
            var _local_2:Number = this.GetCombatSlotPlayer().GetHitPointsLeft();
            _local_2 = (_local_2 + this.GetCombatSlotNPC().GetHitPointsLeft());
            _local_1 = (_local_1 + int(_local_2));
            this.LogCombat((((("cCombat.GetCheckSum: (Round: " + this.GetCombatRound()) + " / Checksum: ") + _local_1) + ")"));
            return (_local_1);
        }

        private function DoCombatEvaluation():Boolean
        {
            var _local_1:Boolean;
            var _local_2:Boolean = this.mSpecialistTask.GetTargetBuilding().GetArmy().HasUnits();
            var _local_3:Boolean = this.mSpecialistTask.GetOwner().GetArmy().HasUnits();
            if (((this.GetFightingUnitNPC() == null) || (!(_local_2))))
            {
                if (((!(this.GetFightingUnitPlayer() == null)) || (_local_3)))
                {
                    this.mCombatResult = COMBAT_RESULT.PLAYERWON_RETURN;
                }
                else
                {
                    this.mCombatResult = COMBAT_RESULT.DRAW;
                };
                _local_1 = true;
            }
            else
            {
                if (((this.GetFightingUnitPlayer() == null) || (!(_local_3))))
                {
                    this.mCombatResult = COMBAT_RESULT.PLAYERLOST;
                    _local_1 = true;
                };
            };
            if (((this.GetCombatResult() == COMBAT_RESULT.PLAYERWON_RETURN) && (!(this.mSpecialistTask.IsAtTargetBuilding()))))
            {
                this.mCombatResult = COMBAT_RESULT.PLAYERWON_CONTINUE;
            };
            this.mSpecialistTask.UpdateCombatSlots();
            if (((bCombatLog) && (cLog.isInfoEnabled())))
            {
                if (_local_1)
                {
                    cLog.info("Evaluating previous combat round for end conditions, result : Combat completed");
                }
                else
                {
                    cLog.info("Evaluating previous combat round for end conditions, result : Combat continues");
                };
            };
            return (_local_1);
        }

        private function updateUI():void
        {
            var _local_1:cCombatData = this.getCombatData();
            if (_local_1 != null)
            {
                _local_1.updateMenu(this.mSpecialistTask.GetOwner(), this);
            };
        }

        override public function dispose():void
        {
            if (this.mSpecialistTask.GetGeneralInterface().mCurrentPlayerZone.mStreetDataMap.mCombatContainer.containsKey(this.mSpecialistTask.GetTargetBuildingGridIdx()))
            {
                this.mSpecialistTask.GetGeneralInterface().mCurrentPlayerZone.mStreetDataMap.mCombatContainer.get(this.mSpecialistTask.GetTargetBuildingGridIdx()).dispose();
                this.mSpecialistTask.GetGeneralInterface().mCurrentPlayerZone.mStreetDataMap.mCombatContainer.remove(this.mSpecialistTask.GetTargetBuildingGridIdx());
            };
            super.dispose();
        }

        private function PlayerUnitDied(_arg_1:int):Boolean
        {
            var _local_2:cSquad = this.GetCombatSlotPlayer().GetSquad();
            var _local_3:Boolean;
            this.LogCombat((((((((((("cCombat.PlayerUnitDied: (Round: " + this.GetCombatRound()) + " / Type: ") + this.GetCombatSlotPlayer().GetSquad().GetType()) + " / Lost: ") + _arg_1) + " / LeftSlot: ") + this.GetCombatSlotPlayer().GetAmount()) + " / Left: ") + Math.max(0, (_local_2.GetAmount() - _arg_1))) + ")"));
            if (this.GetCombatSlotPlayer().GetAmount() <= 0)
            {
                this.LogCombat("No player units left in squad, triggering a switch!");
                _local_3 = true;
            };
            _local_2.DecAmount(_arg_1);
            var _local_4:cSpecialist = this.mSpecialistTask.GetOwner();
            if (_local_2.GetAmount() <= 0)
            {
                _local_4.GetArmy().RemoveUnits(_local_2.GetType(), 999999);
            };
            notifyPropertyObserver(SLOT_UNITS_DIED_string, [this.GetCombatSlotPlayer(), _arg_1]);
            var _local_5:cPlayerData = this.mSpecialistTask.GetGeneralInterface().FindPlayerFromId(_local_4.getPlayerID());
            var _local_6:cResources = this.mSpecialistTask.GetGeneralInterface().mCurrentPlayerZone.GetResources(_local_5);
            if (_local_6 != null)
            {
                _local_6.FreeMilitary(_arg_1);
                _local_6.RemovePlayerResourcesFromResourcesInList(onePopulation_vector, _arg_1, ModifyReason.MILITARY);
            };
            this.dKillStats[_local_2.GetType()].lost = (this.dKillStats[_local_2.GetType()].lost + _arg_1);
            return (_local_3);
        }

        private function SetUpcomingUnitPlayer(_arg_1:cSquad):void
        {
            this.mUpcomingUnitPlayer = _arg_1;
            this.LogCombat((("cCombat.SetUpcomingUnitPlayer: (Type: " + ((this.mUpcomingUnitPlayer != null) ? this.mUpcomingUnitPlayer.GetUnitBase().GetType() : "null")) + ")"));
        }

        public function GetSpecialistTask():cSpecialistTask_AttackBuildingNewCombat
        {
            return (this.mSpecialistTask);
        }

        public function CalcDamageFactor(_arg_1:cMilitaryUnitData, _arg_2:cMilitaryUnitData):Number
        {
            var _local_4:cMilitaryUnitAbility;
            var _local_3:Number = 1;
            for each (_local_4 in _arg_1.GetAbilities())
            {
                switch (_local_4.GetType())
                {
                    case MILITARY_UNIT_ABILITY.DAMAGE_BONUS_PERCENT_HEAVY_ARMOR:
                        if (_arg_2.IsArmorTypeHeavy())
                        {
                            _local_3 = (_local_3 + (_local_4.GetValue() / 100));
                        };
                        break;
                    case MILITARY_UNIT_ABILITY.DAMAGE_BONUS_PERCENT_LIGHT_ARMOR:
                        if (_arg_2.IsArmorTypeLight())
                        {
                            _local_3 = (_local_3 + (_local_4.GetValue() / 100));
                        };
                        break;
                    case MILITARY_UNIT_ABILITY.DAMAGE_BONUS_PERCENT_MEDIUM_ARMOR:
                        if (_arg_2.IsArmorTypeMedium())
                        {
                            _local_3 = (_local_3 + (_local_4.GetValue() / 100));
                        };
                        break;
                    case MILITARY_UNIT_ABILITY.DAMAGE_BONUS_PERCENT_TANK_ARMOR:
                        if (_arg_2.IsArmorTypeTank())
                        {
                            _local_3 = (_local_3 + (_local_4.GetValue() / 100));
                        };
                        break;
                };
            };
            return (_local_3);
        }

        private function getCombatData():cCombatData
        {
            return (this.mSpecialistTask.GetGeneralInterface().mCurrentPlayerZone.mStreetDataMap.mCombatContainer.get(this.mSpecialistTask.GetTargetBuildingGridIdx()));
        }

        private function DoFightAndReturnIfStacksDepleted():Boolean
        {
            var _local_5:BuffAppliance;
            var _local_6:cCombatSlot;
            var _local_7:cCombatSlot;
            var _local_8:cBuffDefinition;
            var _local_9:int;
            var _local_10:int;
            var _local_11:Number;
            var _local_12:Number;
            this.LogCombat("Entering DoFight method");
            this.mDoUnitSwitchPause = false;
            var _local_1:cCombatData = this.getCombatData();
            var _local_2:Boolean;
            var _local_3:Number = 1;
            var _local_4:Number = 1;
            for each (_local_5 in this.mSpecialistTask.GetTargetBuilding().mBuffs_vector)
            {
                _local_8 = _local_5.GetBuffDefinition();
                if (_local_8.IsTypeCombatTimed())
                {
                    _local_3 = (_local_3 + (_local_8.GetParameter(BUFF_PARAMETER_NAME.BASE_DAMAGE_MODIFIER_ATTACKER) / 100));
                    _local_4 = (_local_4 + (_local_8.GetParameter(BUFF_PARAMETER_NAME.BASE_DAMAGE_MODIFIER_DEFENDER) / 100));
                };
            };
            _local_6 = this.GetCombatSlotNPC();
            _local_7 = this.GetCombatSlotPlayer();
            if (((((!(_local_6 == null)) && (_local_6.IsOccupied())) && (!(_local_7 == null))) && (_local_7.IsOccupied())))
            {
                _local_9 = _local_6.GetAmount();
                _local_10 = _local_7.GetAmount();
                _local_11 = (((_local_6.GetUnitData().GetBaseDamage() * _local_6.GetAmount()) * _local_4) * this.CalcDamageFactor(_local_6.GetUnitData(), _local_7.GetUnitData()));
                _local_12 = (((_local_7.GetUnitData().GetBaseDamage() * _local_7.GetAmount()) * _local_3) * this.CalcDamageFactor(_local_7.GetUnitData(), _local_6.GetUnitData()));
                _local_11 = _local_7.DecHitPointsLeft(_local_11);
                _local_12 = _local_6.DecHitPointsLeft(_local_12);
                notifyPropertyObserver(SLOT_NPC_DAMAGE_TAKEN_string, _local_12);
                notifyPropertyObserver(SLOT_PLAYER_DAMAGE_TAKEN_string, _local_11);
                if (_local_7.GetAmount() < _local_10)
                {
                    _local_2 = this.PlayerUnitDied((_local_10 - _local_7.GetAmount()));
                };
                if (_local_6.GetAmount() < _local_9)
                {
                    _local_2 = ((this.NPCUnitDied((_local_9 - _local_6.GetAmount()))) || (_local_2));
                };
            };
            if (_local_1 != null)
            {
                if (((_local_6 == null) || (!(_local_6.IsOccupied()))))
                {
                    notifyPropertyObserver(SLOT_BATCH_DIED_string, _local_6);
                };
                if (((_local_7 == null) || (!(_local_7.IsOccupied()))))
                {
                    notifyPropertyObserver(SLOT_BATCH_DIED_string, _local_7);
                };
            };
            this.IncCombatRound();
            return (_local_2);
        }

        private function LogCombat(_arg_1:String):void
        {
            if (((bCombatLog) && (cLog.isInfoEnabled())))
            {
                cLog.info(_arg_1);
            };
        }

        private function InitFromVO(_arg_1:CombatVO):void
        {
            var _local_2:CombatKillStatsVO;
            this.LogCombat("cCombat.InitFromVO:");
            this.mRandom = new Random(0);
            this.mRandom.Init(_arg_1.randomSeed, _arg_1.random1, _arg_1.random2, _arg_1.random3);
            this.mCombatRound = _arg_1.combatRound;
            this.mCombatState = _arg_1.combatState;
            this.mCombatResult = _arg_1.combatResult;
            if (this.mSpecialistTask.GetTargetBuilding() != null)
            {
                if (_arg_1.currentFightingUnitNPC != null)
                {
                    this.SetFightingUnitNPC(this.mSpecialistTask.GetTargetBuilding().GetArmy().GetSquad(_arg_1.currentFightingUnitNPC));
                };
                if (_arg_1.currentFightingUnitPlayer != null)
                {
                    this.SetFightingUnitPlayer(this.mSpecialistTask.GetOwner().GetArmy().GetSquad(_arg_1.currentFightingUnitPlayer));
                };
                if (_arg_1.upcomingUnitNPC != null)
                {
                    this.SetUpcomingUnitNPC(this.mSpecialistTask.GetTargetBuilding().GetArmy().GetSquad(_arg_1.upcomingUnitNPC));
                };
                if (_arg_1.upcomingUnitPlayer != null)
                {
                    this.SetUpcomingUnitPlayer(this.mSpecialistTask.GetOwner().GetArmy().GetSquad(_arg_1.upcomingUnitPlayer));
                };
                this.mCombatSlotNPC = cCombatSlot.CreateFromVO(_arg_1.combatSlotNPC, this.mSpecialistTask.GetTargetBuilding().GetArmy().GetSquad(_arg_1.combatSlotNPC.unitType));
                this.mCombatSlotPlayer = cCombatSlot.CreateFromVO(_arg_1.combatSlotPlayer, this.mSpecialistTask.GetOwner().GetArmy().GetSquad(_arg_1.combatSlotPlayer.unitType));
            };
            for each (_local_2 in _arg_1.combatKillStats)
            {
                this.dKillStats[_local_2.unitType] = _local_2;
            };
            this.mCombatUnitSwitch.addAll(_arg_1.combatUnitSwitch);
            if (this.GetUpcomingUnitNPC() == null)
            {
                this.SetUpcomingUnitNPC(this.getNextNPCUnit());
            };
            this.updateUI();
        }

        public function GetTargetBuilding():cBuilding
        {
            return (this.mSpecialistTask.GetTargetBuilding());
        }

        public function GetFirstUnitPlayer():cSquad
        {
            var _local_1:cSquad;
            if (this.mSpecialistTask.GetStartingUnitType() != null)
            {
                _local_1 = this.mSpecialistTask.GetOwner().GetArmy().GetSquad(this.mSpecialistTask.GetStartingUnitType());
                if (((!(_local_1 == null)) && (_local_1.GetAmount() > 0)))
                {
                    return (_local_1);
                };
            };
            return (null);
        }

        public function HandleSwitchPlayerUnit(_arg_1:String):Boolean
        {
            this.SetUpcomingUnitPlayer(this.mSpecialistTask.GetOwner().GetArmy().GetSquad(_arg_1));
            this.mCombatUnitSwitch.addItem(CombatUnitSwitchVO.Create(_arg_1, this.GetCombatRound()));
            this.LogCombat((((("cCombat.SetNextPlayerUnit: unist switched (Unit: " + ((this.mUpcomingUnitPlayer != null) ? this.mUpcomingUnitPlayer.GetType() : "null")) + " / CombatRound: ") + this.GetCombatRound()) + ")"));
            this.mSpecialistTask.mDirtyIndicator = (this.mSpecialistTask.mDirtyIndicator | DIRTY_INDICATOR.MODIFIED_BIT);
            return (!(this.GetUpcomingUnitPlayer() == null));
        }

        private function CheckUpcomingPlayerUnit():void
        {
            if (((!(this.GetUpcomingUnitPlayer() == null)) && (this.GetUpcomingUnitPlayer().GetAmount() <= 0)))
            {
                this.LogCombat("Player upcoming unit selection depleted, switching automatically");
                this.SetUpcomingUnitPlayer(this.GetDefaultNextPlayerUnit());
            };
        }

        public function GetKillStats(_arg_1:String):CombatKillStatsVO
        {
            return (this.dKillStats[_arg_1]);
        }

        private function getStateString():String
        {
            switch (this.mCombatState)
            {
                case COMBAT_STATE_NONE:
                    return ("NONE");
                case COMBAT_STATE_ROUND_FINISHED:
                    return ("ROUND_FINISHED");
                case COMBAT_STATE_WAIT_FOR_REFILL:
                    return ("WAIT_FOR_REFILL");
                case COMBAT_STATE_COMPLETED:
                    return ("COMPLETED");
                default:
                    return ("INVALID");
            };
        }

        private function switchAndRefillUnits():void
        {
            var _local_1:int;
            this.LogCombat("One or other stacks has depleted, initiating switch to upcoming units");
            if (((!(this.GetUpcomingUnitPlayer() == null)) && (this.GetUpcomingUnitPlayer().GetAmount() > 0)))
            {
                this.SetFightingUnitPlayer(this.GetUpcomingUnitPlayer());
            }
            else
            {
                this.SetFightingUnitPlayer(this.GetDefaultNextPlayerUnit());
            };
            if (this.GetFightingUnitPlayer() != null)
            {
                this.GetCombatSlotPlayer().Reset(this.GetFightingUnitPlayer(), Math.min(this.GetFightingUnitPlayer().GetAmount(), this.GetFightingUnitPlayer().GetUnitData().GetCombatBatchSize()));
                notifyPropertyObserver(SLOT_BATCH_DEPLOYED_string, this.GetCombatSlotPlayer());
            };
            if (((this.GetFightingUnitNPC() == null) || (!((((!(this.GetFightingUnitNPC().GetUnitBase() == null)) && (this.GetFightingUnitNPC().GetUnitBase().IsBoss())) && (!(this.GetCombatSlotNPC() == null))) && (this.GetCombatSlotNPC().GetHitPointsLeft() > 0)))))
            {
                this.SetFightingUnitNPC(this.GetUpcomingUnitNPC());
                if (this.GetFightingUnitNPC() != null)
                {
                    _local_1 = ((this.GetFightingUnitNPC().GetUnitData().GetCombatBatchSize() > 0) ? this.GetCombatSlotNPC().GetUnitData().GetCombatBatchSize() : this.GetCombatSlotPlayer().GetUnitData().GetCombatBatchSize());
                    this.GetCombatSlotNPC().Reset(this.GetFightingUnitNPC(), Math.min(this.GetFightingUnitNPC().GetAmount(), _local_1));
                    notifyPropertyObserver(SLOT_BATCH_DEPLOYED_string, this.GetCombatSlotNPC());
                };
            };
            if (this.GetFightingUnitNPC() != null)
            {
                this.SetUpcomingUnitNPC(this.getNextNPCUnit());
            }
            else
            {
                this.SetUpcomingUnitNPC(null);
            };
            this.SetUpcomingUnitPlayer(this.GetDefaultNextPlayerUnit());
            this.mDoUnitSwitchPause = true;
        }

        public function unitSwitchFailed():void
        {
            notifyPropertyObserver(PLAYER_UNIT_SWITCH_FAILED_string, null);
        }

        public function GetCombatSlotNPC():cCombatSlot
        {
            return (this.mCombatSlotNPC);
        }

        private function UpdateCombatState(_arg_1:int):void
        {
            if (this.mCombatState != _arg_1)
            {
                this.mCombatState = _arg_1;
                this.mSpecialistTask.mDirtyIndicator = (this.mSpecialistTask.mDirtyIndicator | DIRTY_INDICATOR.MODIFIED_BIT);
            };
        }

        public function GetFightingUnitPlayer():cSquad
        {
            return (this.mFightingUnitPlayer);
        }

        private function SetUpcomingUnitNPC(_arg_1:cSquad):void
        {
            this.mUpcomingUnitNPC = _arg_1;
            this.LogCombat((("cCombat.SetUpcomingUnitNPC: (Type: " + ((this.mUpcomingUnitNPC != null) ? this.mUpcomingUnitNPC.GetUnitBase().GetType() : "null")) + ")"));
        }

        private function SetFightingUnitPlayer(_arg_1:cSquad):void
        {
            this.mFightingUnitPlayer = _arg_1;
            this.LogCombat((("cCombat.SetFightingUnitPlayer: (Type: " + ((this.mFightingUnitPlayer != null) ? this.mFightingUnitPlayer.GetUnitBase().GetType() : "null")) + ")"));
        }

        public function GetDefaultNextPlayerUnit():cSquad
        {
            var _local_2:cSquad;
            var _local_3:cSquad;
            if (this.GetCombatSlotPlayer().GetSquad() != null)
            {
                for each (_local_3 in this.mSpecialistTask.GetOwner().GetArmy().GetSquads_vector())
                {
                    if ((((!(this.GetFightingUnitPlayer() == null)) && (this.GetFightingUnitPlayer().GetType() == _local_3.GetType())) && (_local_3.GetAmount() > 0)))
                    {
                        return (_local_3);
                    };
                };
            };
            this.LogCombat("Not enough units of current type to continue with player selection, switching...");
            var _local_1:Vector.<cSquad> = this.mSpecialistTask.GetOwner().GetArmy().GetSquads_vector();
            _local_1.sort(cSquad.SortByUniqueId);
            for each (_local_2 in _local_1)
            {
                if (((_local_2.amount > 0) && ((this.GetFightingUnitPlayer() == null) || (!(_local_2.GetType() == this.GetFightingUnitPlayer().GetType())))))
                {
                    return (_local_2);
                };
            };
            return (null);
        }

        public function GetCombatRound():int
        {
            return (this.mCombatRound);
        }

        public function GetCombatState():int
        {
            return (this.mCombatState);
        }

        private function HasUpcomingUnits():Boolean
        {
            return (((!(this.GetUpcomingUnitNPC() == null)) || ((!(this.GetFightingUnitNPC() == null)) && (this.GetFightingUnitNPC().GetAmount() > 0))) && ((!(this.GetUpcomingUnitPlayer() == null)) || ((!(this.GetFightingUnitPlayer() == null)) && (this.GetFightingUnitPlayer().GetAmount() > 0))));
        }

        public function CreateCombatVO():CombatVO
        {
            var _local_2:CombatKillStatsVO;
            var _local_1:CombatVO = new CombatVO();
            _local_1.random1 = this.mRandom.GetRandom(1);
            _local_1.random2 = this.mRandom.GetRandom(2);
            _local_1.random3 = this.mRandom.GetRandom(3);
            _local_1.randomSeed = this.mRandom.GetSeed();
            _local_1.combatRound = this.GetCombatRound();
            _local_1.combatState = this.GetCombatState();
            _local_1.combatResult = this.GetCombatResult();
            _local_1.currentFightingUnitNPC = ((this.GetFightingUnitNPC() != null) ? this.GetFightingUnitNPC().GetType() : null);
            _local_1.currentFightingUnitPlayer = ((this.GetFightingUnitPlayer() != null) ? this.GetFightingUnitPlayer().GetType() : null);
            _local_1.upcomingUnitNPC = ((this.GetUpcomingUnitNPC() != null) ? this.GetUpcomingUnitNPC().GetType() : null);
            _local_1.upcomingUnitPlayer = ((this.GetUpcomingUnitPlayer() != null) ? this.GetUpcomingUnitPlayer().GetType() : null);
            _local_1.combatSlotNPC = this.CreateCombatSlotVO(CombatSlotTypeNPC, this.GetCombatSlotNPC());
            _local_1.combatSlotPlayer = this.CreateCombatSlotVO(CombatSlotTypePlayer, this.GetCombatSlotPlayer());
            _local_1.combatKillStats = new ArrayCollection();
            for each (_local_2 in this.dKillStats)
            {
                _local_1.combatKillStats.addItem(_local_2);
            };
            _local_1.combatUnitSwitch = new ArrayCollection();
            _local_1.combatUnitSwitch.addAll(this.mCombatUnitSwitch);
            return (_local_1);
        }

        public function GetUpcomingUnitNPC():cSquad
        {
            return (this.mUpcomingUnitNPC);
        }

        public function IsDone():Boolean
        {
            return (this.GetCombatState() == COMBAT_STATE_COMPLETED);
        }

        public function GetCombatSlotPlayer():cCombatSlot
        {
            return (this.mCombatSlotPlayer);
        }

        public function Step(_arg_1:int):Boolean
        {
            var _local_2:Boolean = true;
            var _local_3:int;
            if (this.mCombatState == COMBAT_STATE_WAIT_FOR_REFILL)
            {
                _local_3 = int(int(((this.mCombatTimeBuffer + _arg_1) / global.unitSwitchPauseDuration)));
                this.mCombatTimeBuffer = ((this.mCombatTimeBuffer + _arg_1) - (_local_3 * global.unitSwitchPauseDuration));
            }
            else
            {
                _local_3 = int(int(((this.mCombatTimeBuffer + _arg_1) / global.combatLoopDurationMS)));
                this.mCombatTimeBuffer = ((this.mCombatTimeBuffer + _arg_1) - (_local_3 * global.combatLoopDurationMS));
            };
            this.LogCombat((((((((((("cCombat.Step: (CombatRound: " + this.GetCombatRound()) + " / State: ") + this.GetCombatState()) + " / _timeDelta: ") + _arg_1) + " / loopCount: ") + _local_3) + " / combatTimeBuffer: ") + this.mCombatTimeBuffer) + ")"));
            var _local_4:int;
            while (_local_4 < _local_3)
            {
                switch (this.mCombatState)
                {
                    case COMBAT_STATE_COMPLETED:
                        _local_2 = false;
                        break;
                    case COMBAT_STATE_WAIT_FOR_REFILL:
                        this.switchAndRefillUnits();
                        this.UpdateCombatState(COMBAT_STATE_ROUND_FINISHED);
                        if (((bCombatLog) && (cLog.isInfoEnabled())))
                        {
                            cLog.info("Combat state switched to COMBAT_STATE_ROUND_FINISHED");
                        };
                        break;
                    case COMBAT_STATE_NONE:
                    case COMBAT_STATE_ROUND_FINISHED:
                        if (((this.DoFightAndReturnIfStacksDepleted()) && (this.HasUpcomingUnits())))
                        {
                            this.UpdateCombatState(COMBAT_STATE_WAIT_FOR_REFILL);
                            this.CheckUpcomingPlayerUnit();
                            this.LogCombat("Combat state switched to COMBAT_STATE_WAITING_FOR_REFILL, pausing");
                        }
                        else
                        {
                            if (!this.DoCombatEvaluation())
                            {
                                this.UpdateCombatState(COMBAT_STATE_ROUND_FINISHED);
                                this.LogCombat("Combat state switched to COMBAT_STATE_ROUND_FINISHED");
                            }
                            else
                            {
                                this.UpdateCombatState(COMBAT_STATE_COMPLETED);
                                this.LogCombat("Combat state switched to COMBAT_STATE_COMPLETED");
                            };
                            _local_2 = true;
                        };
                        break;
                };
                _local_4++;
            };
            this.mSpecialistTask.mDirtyIndicator = (this.mSpecialistTask.mDirtyIndicator | DIRTY_INDICATOR.MODIFIED_BIT);
            return (_local_2);
        }

        private function IncCombatRound():int
        {
            this.mCombatRound++;
            return (this.mCombatRound);
        }

        public function GetFightingUnitNPC():cSquad
        {
            return (this.mFightingUnitNPC);
        }

        private function NPCUnitDied(_arg_1:int):Boolean
        {
            var _local_2:cSquad = this.GetCombatSlotNPC().GetSquad();
            var _local_3:Boolean;
            this.LogCombat((((((((((("cCombat.NPCUnitDied: (Round: " + this.GetCombatRound()) + " / Type: ") + this.GetCombatSlotNPC().GetSquad().GetType()) + " / Lost: ") + _arg_1) + " / LeftSlot: ") + this.GetCombatSlotNPC().GetAmount()) + " / Left: ") + Math.max(0, (_local_2.GetAmount() - _arg_1))) + ")"));
            _local_2.DecAmount(_arg_1);
            if (_local_2.GetAmount() <= 0)
            {
                this.mSpecialistTask.GetTargetBuilding().GetArmy().RemoveUnits(_local_2.GetType(), 999999);
            };
            if (this.GetCombatSlotNPC().GetAmount() <= 0)
            {
                _local_3 = true;
            };
            notifyPropertyObserver(SLOT_UNITS_DIED_string, [this.GetCombatSlotNPC(), _arg_1]);
            this.mSpecialistTask.GetOwner().IncUnitsDefeated(_arg_1);
            if (this.dKillStats[_local_2.GetUnitData().GetType()])
            {
                this.dKillStats[_local_2.GetUnitData().GetType()].killed = (this.dKillStats[_local_2.GetUnitData().GetType()].killed + _arg_1);
            };
            var _local_4:cPlayerData = this.mSpecialistTask.GetGeneralInterface().FindPlayerFromId(this.mSpecialistTask.GetOwner().getPlayerID());
            _local_4.AddXP((_arg_1 * _local_2.GetUnitData().GetXP()));
            _local_4.AddPvPXp((_arg_1 * _local_2.GetUnitData().GetPvPXP()));
            return (_local_3);
        }

        private function getNextNPCUnit():cSquad
        {
            var _local_7:cSquad;
            var _local_8:int;
            var _local_1:Boolean = true;
            var _local_2:int = this.mRandom.NextMax(100);
            if (_local_2 > global.combatUnitSwitchChance)
            {
                _local_1 = false;
            };
            var _local_3:Vector.<cSquad>;
            var _local_4:cSquad;
            var _local_5:Vector.<cSquad> = new Vector.<cSquad>();
            if (((!(this.mSpecialistTask.GetTargetBuilding() == null)) && (!(this.mSpecialistTask.GetTargetBuilding().GetArmy() == null))))
            {
                _local_3 = this.mSpecialistTask.GetTargetBuilding().GetArmy().GetSquads_vector();
            };
            var _local_6:int;
            if (this.GetFightingUnitPlayer() != null)
            {
                _local_6 = this.GetFightingUnitPlayer().GetUnitData().GetCombatBatchSize();
            };
            for each (_local_7 in _local_3)
            {
                if ((((_local_7.GetUnitBase().IsBoss()) && (_local_7.amount > 0)) && ((this.GetFightingUnitNPC() == null) || (!(_local_7.GetType() == this.GetFightingUnitNPC().GetType())))))
                {
                    _local_4 = _local_7;
                }
                else
                {
                    if ((((this.GetFightingUnitNPC() == null) || (!(_local_7.GetType() == this.GetFightingUnitNPC().GetType()))) || (((!(this.GetFightingUnitNPC() == null)) && (_local_7.GetType() == this.GetFightingUnitNPC().GetType())) && ((_local_7.amount - _local_6) > 0))))
                    {
                        _local_5.push(_local_7);
                    };
                };
            };
            _local_5.sort(cSquad.SortByCombatPriorityUnitqueIdDesc);
            if (((_local_5.length < 1) && (_local_4 == null)))
            {
                return (null);
            };
            if (((_local_5.length == 0) && (!(_local_4 == null))))
            {
                return (_local_4);
            };
            if (_local_5.length == 1)
            {
                return (_local_5[0]);
            };
            _local_8 = this.mRandom.NextMax((_local_5.length - 1));
            if (((bCombatLog) && (cLog.isInfoEnabled())))
            {
                cLog.info(("Rolling for next NPC, result : " + _local_8.toString()));
            };
            return (_local_5[_local_8]);
        }


    }
}
