package Specialists
{
    import Modifier.LootSkillHolder;
    import Interface.cGeneralInterface;
    import Skill.cSkillList;
    import __AS3__.vec.Vector;
    import Communication.VO.Skill.SkillVO;
    import Communication.VO.dSpecialistTask_FindDepositVO;
    import Communication.VO.dSpecialistTask_FindTreasureVO;
    import Communication.VO.dSpecialistTask_FindExpeditionVO;
    import Communication.VO.dSpecialistTask_FindEventZoneVO;
    import Communication.VO.dSpecialistTask_ExploreSectorVO;
    import Communication.VO.dSpecialistTask_MoveVO;
    import Communication.VO.dSpecialistTask_AttackBuildingNewCombatVO;
    import Communication.VO.dSpecialistTask_AttackBuildingVO;
    import Communication.VO.dSpecialistTask_RecoverVO;
    import Communication.VO.dSpecialistTask_ExpeditionRecoverVO;
    import Communication.VO.dSpecialistTask_TravelToZoneVO;
    import Communication.VO.dSpecialistTask_TravelToStarMenuVO;
    import Enums.SPECIALIST_TASK_TYPES;
    import nLib.gMisc;
    import Communication.VO.dSpecialistTaskVO;
    import LootTableSystem.cLootTable;
    import Enums.DIRTY_INDICATOR;
    import nLib.cLog;
    import Modifier.ModifierVO;
    import Modifier.Modifier;
    import __AS3__.vec.*;

    public class cSpecialistTask implements LootSkillHolder 
    {

        public static const TASK_START:String = "TASK_START";
        public static const TASK_END:String = "TASK_END";
        public static const TASK_RUNNING_UPDATE:String = "TASK_RUNNING_UPDATE";

        protected var mTaskDefinition:cSpecialistSubTaskDefinition;
        protected var mTaskPhase:int = 0;
        protected var mBonusTime:int = 0;
        public var mDirtyIndicator:int;
        protected var mGeneralInterface:cGeneralInterface;
        public var skills:cSkillList;
        protected var mOwner:cSpecialist;
        protected var mCollectedTime:int = 0;
        private var modified:Boolean;
        private var mTaskProgress:Number = 0;
        public var appliedSkills_vector:Vector.<SkillVO> = new Vector.<SkillVO>();
        protected var mNeededTime:int = 1;

        public function cSpecialistTask(_arg_1:cGeneralInterface, _arg_2:int, _arg_3:int, _arg_4:cSpecialist, _arg_5:int, _arg_6:int)
        {
            super();
            this.mGeneralInterface = _arg_1;
            this.mTaskDefinition = global.specialistTaskDefinitions_vector[_arg_2].subtasks_vector[_arg_3];
            this.mOwner = _arg_4;
            this.mCollectedTime = _arg_5;
            this.mTaskPhase = _arg_6;
            this.skills = new cSkillList(_arg_1);
        }

        public static function CreateTaskFromVO(_arg_1:cGeneralInterface, _arg_2:dSpecialistTaskVO, _arg_3:cSpecialist):cSpecialistTask
        {
            var _local_5:dSpecialistTask_FindDepositVO;
            var _local_6:dSpecialistTask_FindTreasureVO;
            var _local_7:dSpecialistTask_FindExpeditionVO;
            var _local_8:dSpecialistTask_FindEventZoneVO;
            var _local_9:dSpecialistTask_ExploreSectorVO;
            var _local_10:dSpecialistTask_MoveVO;
            var _local_11:dSpecialistTask_AttackBuildingNewCombatVO;
            var _local_12:dSpecialistTask_AttackBuildingVO;
            var _local_13:dSpecialistTask_RecoverVO;
            var _local_14:dSpecialistTask_ExpeditionRecoverVO;
            var _local_15:dSpecialistTask_TravelToZoneVO;
            var _local_16:dSpecialistTask_TravelToStarMenuVO;
            var _local_4:cSpecialistTask;
            if (_arg_2 != null)
            {
                switch (_arg_2.type)
                {
                    case SPECIALIST_TASK_TYPES.DEPOSIT_SEARCH:
                        _local_5 = (_arg_2 as dSpecialistTask_FindDepositVO);
                        _local_4 = cSpecialistTask_FindDeposit.CreateTaskFromVO(_arg_1, _local_5, _arg_3);
                        break;
                    case SPECIALIST_TASK_TYPES.FIND_TREASURE:
                        _local_6 = (_arg_2 as dSpecialistTask_FindTreasureVO);
                        _local_4 = cSpecialistTask_FindTreasure.CreateTaskFromVO(_arg_1, _local_6, _arg_3);
                        break;
                    case SPECIALIST_TASK_TYPES.FIND_EXPEDITION:
                        _local_7 = (_arg_2 as dSpecialistTask_FindExpeditionVO);
                        _local_4 = cSpecialistTask_FindExpedition.CreateTaskFromVO(_arg_1, _local_7, _arg_3);
                        break;
                    case SPECIALIST_TASK_TYPES.FIND_ADVENTURE_ZONE:
                        _local_8 = (_arg_2 as dSpecialistTask_FindEventZoneVO);
                        _local_4 = cSpecialistTask_FindEventZone.CreateTaskFromVO(_arg_1, _local_8, _arg_3);
                        break;
                    case SPECIALIST_TASK_TYPES.EXPLORE:
                        _local_9 = (_arg_2 as dSpecialistTask_ExploreSectorVO);
                        _local_4 = cSpecialistTask_ExploreSector.CreateTaskFromVO(_arg_1, _local_9, _arg_3);
                        break;
                    case SPECIALIST_TASK_TYPES.MOVE:
                        _local_10 = (_arg_2 as dSpecialistTask_MoveVO);
                        _local_4 = cSpecialistTask_Move.CreateTaskFromVO(_arg_1, _local_10, _arg_3);
                        break;
                    case SPECIALIST_TASK_TYPES.ATTACK_BUILDING_NEW_COMBAT:
                        _local_11 = (_arg_2 as dSpecialistTask_AttackBuildingNewCombatVO);
                        _local_4 = cSpecialistTask_AttackBuildingNewCombat.CreateTaskFromVO(_arg_1, _local_11, _arg_3);
                        break;
                    case SPECIALIST_TASK_TYPES.ATTACK_BUILDING:
                        _local_12 = (_arg_2 as dSpecialistTask_AttackBuildingVO);
                        _local_4 = cSpecialistTask_AttackBuilding.CreateTaskFromVO(_arg_1, _local_12, _arg_3);
                        break;
                    case SPECIALIST_TASK_TYPES.RECOVER:
                        _local_13 = (_arg_2 as dSpecialistTask_RecoverVO);
                        _local_4 = cSpecialistTask_Recover.CreateTaskFromVO(_arg_1, _local_13, _arg_3);
                        break;
                    case SPECIALIST_TASK_TYPES.EXPEDITION_RECOVER:
                        _local_14 = (_arg_2 as dSpecialistTask_ExpeditionRecoverVO);
                        _local_4 = cSpecialistTask_ExpeditionRecover.CreateTaskFromVO(_arg_1, _local_14, _arg_3);
                        break;
                    case SPECIALIST_TASK_TYPES.TRAVEL_TO_ZONE:
                        _local_15 = (_arg_2 as dSpecialistTask_TravelToZoneVO);
                        _local_4 = cSpecialistTask_TravelToZone.CreateTaskFromVO(_arg_1, _local_15, _arg_3);
                        break;
                    case SPECIALIST_TASK_TYPES.TRAVEL_TO_STAR_MENU:
                        _local_16 = (_arg_2 as dSpecialistTask_TravelToStarMenuVO);
                        _local_4 = cSpecialistTask_TravelToStarMenu.CreateTaskFromVO(_arg_1, _local_16, _arg_3);
                        break;
                    default:
                        gMisc.Assert(false, ("Could not interpret task type " + _arg_2));
                };
            };
            return (_local_4);
        }


        public function GetOriginalType():int
        {
            return (this.GetType());
        }

        public function GetGeneralInterface():cGeneralInterface
        {
            return (this.mGeneralInterface);
        }

        public function SetNeededTime(_arg_1:int):void
        {
            this.mNeededTime = _arg_1;
        }

        public function GetType():int
        {
            return (SPECIALIST_TASK_TYPES.parse(this.mTaskDefinition.mainTask.taskName_string));
        }

        public function GetSubType():int
        {
            return (this.mTaskDefinition.subTaskID);
        }

        public function SetCollectedTime(_arg_1:int):void
        {
            this.mCollectedTime = _arg_1;
        }

        public function applyLootSkills(_arg_1:cLootTable):void
        {
            var _local_2:SkillVO;
            this.GetOwner().notifyPropertyObserver(cLootTable.USE_LOOTTABLE, _arg_1);
            for each (_local_2 in _arg_1.appliedSkills_vector)
            {
                this.appliedSkills_vector.push(_local_2);
            };
            if (this.appliedSkills_vector.length > 0)
            {
                this.setModified(null);
            };
        }

        public function getSpeedUpCosts():int
        {
            return (this.mTaskDefinition.speedUpCosts);
        }

        public function PrepareTask():void
        {
        }

        public function GetOwner():cSpecialist
        {
            return (this.mOwner);
        }

        public function GetCollectedTime():int
        {
            return (this.mCollectedTime);
        }

        public function isModified():Boolean
        {
            return (this.modified);
        }

        protected function NextPhase():void
        {
            this.mTaskPhase++;
            this.mDirtyIndicator = (this.mDirtyIndicator | DIRTY_INDICATOR.MODIFIED_BIT);
        }

        public function getTaskDefinition():cSpecialistSubTaskDefinition
        {
            return (this.mTaskDefinition);
        }

        public function GetTaskProgress():Number
        {
            return (this.mTaskProgress);
        }

        protected function PerformTaskPhase(_arg_1:int, _arg_2:int):void
        {
        }

        public function isModifierApplyable(_arg_1:ModifierVO):Boolean
        {
            if (cLog.isInfoEnabled())
            {
                cLog.info(((("Modifier precheck is NOT overriden! Dont modify: " + _arg_1) + " on: ") + this));
            };
            return (false);
        }

        public function Perform(_arg_1:int):void
        {
            this.mCollectedTime = (this.mCollectedTime + ((this.mGeneralInterface.mClientDeltaTime * this.mOwner.GetSpecialistDescription().GetTimeBonus()) / 100));
            if (this.GetNeededTime() > 0)
            {
                this.mTaskProgress = (this.mCollectedTime / this.GetNeededTime());
            }
            else
            {
                this.mTaskProgress = 1;
            };
            if (this.mCollectedTime >= this.mNeededTime)
            {
                this.mOwner.notifyPropertyObserver(TASK_END, this);
            };
            this.PerformTaskPhase(this.mGeneralInterface.mClientDeltaTime, _arg_1);
        }

        public function setModified(_arg_1:Modifier):void
        {
            this.modified = true;
        }

        public function getAppliedSkills_vector():Vector.<SkillVO>
        {
            return (this.appliedSkills_vector);
        }

        protected function SetTaskPhase(_arg_1:int):void
        {
            this.mTaskPhase = _arg_1;
            this.mDirtyIndicator = (this.mDirtyIndicator | DIRTY_INDICATOR.MODIFIED_BIT);
        }

        public function GetRemainingTime():int
        {
            return (int(((((this.GetNeededTime() - this.GetCollectedTime()) / global.initGlobalTimeScale) / this.mOwner.GetSpecialistDescription().GetTimeBonus()) * 100)));
        }

        public function GetSortValue():Number
        {
            return (0);
        }

        public function GetTaskPhase():int
        {
            return (this.mTaskPhase);
        }

        public function StartTask():void
        {
            this.mDirtyIndicator = (this.mDirtyIndicator | DIRTY_INDICATOR.CREATED_BIT);
        }

        public function IncBonusTime(_arg_1:int):void
        {
            this.mBonusTime = (this.mBonusTime + _arg_1);
        }

        public function GetBonusTime():int
        {
            return (this.mBonusTime);
        }

        public function GetNeededTime():int
        {
            return (this.mNeededTime);
        }

        public function CreateTaskVOFromSpecialistTask():dSpecialistTaskVO
        {
            gMisc.Assert(false, "Must not call CreateTaskVOFromSpecialistTask() directly!");
            return (null);
        }

        public function getSpeedUpFactor():int
        {
            return (this.mTaskDefinition.speedUpFactor);
        }


    }
}
