package Specialists
{
    import Effects.EffectEnricher;
    import GO.cDeposit;
    import __AS3__.vec.Vector;
    import Enums.SPECIALIST_TASK_TYPES;
    import Interface.cGeneralInterface;
    import Communication.VO.dSpecialistTask_FindDepositVO;
    import Modifier.Modifier;
    import Enums.DIRTY_INDICATOR;
    import nLib.cLog;
    import Enums.AVATAR_MESSAGE_TYPE;
    import Modifier.ModifierVO;
    import Enums.TASK_PHASES_FIND_DEPOSIT;
    import nLib.gMisc;
    import Communication.VO.EffectVO;
    import Communication.VO.dSpecialistTaskVO;
    import __AS3__.vec.*;

    public class cSpecialistTask_FindDeposit extends cSpecialistTask implements EffectEnricher 
    {

        public static const SEARCH_DEPOSIT_SUCCESSFUL:String = "SEARCH_DEPOSIT_SUCCESSFUL";
        public static const SEARCH_DEPOSIT_SET:String = "SEARCH_DEPOSIT_SET";

        private var mExploredDeposit:cDeposit = null;
        public var failOverrideDepositGroupID:int;
        private var modified:Boolean;
        public var numberOfExtraDeposits:int = 0;
        private var mExtraExploredDeposits:Vector.<cDeposit> = new Vector.<cDeposit>();
        private var mExploredDepositResult:int = 0;

        public function cSpecialistTask_FindDeposit(_arg_1:cGeneralInterface, _arg_2:cSpecialist, _arg_3:int, _arg_4:int, _arg_5:int)
        {
            super(_arg_1, SPECIALIST_TASK_TYPES.DEPOSIT_SEARCH, _arg_5, _arg_2, _arg_3, _arg_4);
            mNeededTime = mTaskDefinition.duration;
            this.numberOfExtraDeposits = 0;
            _arg_2.notifyPropertyObserver(TASK_START, this);
        }

        public static function CreateTaskFromVO(_arg_1:cGeneralInterface, _arg_2:dSpecialistTask_FindDepositVO, _arg_3:cSpecialist):cSpecialistTask_FindDeposit
        {
            var _local_4:cSpecialistTask_FindDeposit = new cSpecialistTask_FindDeposit(_arg_1, _arg_3, (_arg_2.collectedTime + _arg_2.bonusTime), _arg_2.phase, _arg_2.subTaskID);
            _local_4.mBonusTime = _arg_2.bonusTime;
            return (_local_4);
        }


        public function SetExploredDepositResult(_arg_1:int, _arg_2:cDeposit):void
        {
            this.mExploredDepositResult = _arg_1;
            this.mExploredDeposit = _arg_2;
        }

        override public function setModified(_arg_1:Modifier):void
        {
            this.modified = true;
        }

        public function GetExtraExploredDeposits():Vector.<cDeposit>
        {
            return (this.mExtraExploredDeposits);
        }

        override public function isModified():Boolean
        {
            return (this.modified);
        }

        public function GetExploredDepositResult():int
        {
            return (this.mExploredDepositResult);
        }

        public function ResetExtraDeposits():void
        {
            this.mExtraExploredDeposits = new Vector.<cDeposit>();
        }

        public function GetExploredDeposit():cDeposit
        {
            return (this.mExploredDeposit);
        }

        public function AddExtraExploredDeposit(_arg_1:cDeposit):void
        {
            this.mExtraExploredDeposits.push(_arg_1);
            mDirtyIndicator = (mDirtyIndicator | DIRTY_INDICATOR.MODIFIED_BIT);
        }

        override public function StartTask():void
        {
            super.StartTask();
            if (cLog.isInfoEnabled())
            {
                cLog.info(((("Geologist " + mOwner.GetUniqueID()) + " starts to search for ") + this.GetDepositToSearch_string()));
            };
            globalFlash.gui.mAvatarMessageList.AddMessage(AVATAR_MESSAGE_TYPE.GEOLOGIST_STARTED_FIND_DEPOSIT, mOwner);
        }

        public function toString():String
        {
            return (((("<cSpecialistTask_FindDeposit subType=" + mTaskDefinition.subTaskID) + ", mExploredDeposit=") + this.mExploredDeposit) + " >");
        }

        override public function isModifierApplyable(_arg_1:ModifierVO):Boolean
        {
            var _local_2:String = (mTaskDefinition.mainTask.taskName_string + mTaskDefinition.taskType_string);
            if (((_arg_1.type_string.length > 0) && (!(_arg_1.type_string == _local_2))))
            {
                return (false);
            };
            return (true);
        }

        public function GetDepositToSearch_string():String
        {
            return (mTaskDefinition.taskType_string);
        }

        override protected function PerformTaskPhase(_arg_1:int, _arg_2:int):void
        {
            switch (GetTaskPhase())
            {
                case TASK_PHASES_FIND_DEPOSIT.SEARCH_DEPOSIT:
                    if (GetCollectedTime() >= mNeededTime)
                    {
                        NextPhase();
                    };
                    return;
                case TASK_PHASES_FIND_DEPOSIT.WAIT_FOR_ORDERS:
                    mOwner.SetTask(null);
                    return;
                default:
                    gMisc.Assert(false, (("Could not interpret Search deposit task phase " + GetTaskPhase()) + "!"));
            };
        }

        public function enrichEffect(_arg_1:EffectVO):EffectVO
        {
            if (((_arg_1.index == 0) && (!(this.GetExploredDeposit() == null))))
            {
                _arg_1.index = this.GetExploredDeposit().GetGrid();
            };
            return (_arg_1);
        }

        public function enrichExtraEffects(_arg_1:EffectVO):Vector.<EffectVO>
        {
            var _local_3:cDeposit;
            var _local_4:EffectVO;
            var _local_2:Vector.<EffectVO> = new Vector.<EffectVO>();
            for each (_local_3 in this.mExtraExploredDeposits)
            {
                _local_4 = _arg_1.clone();
                _local_4.index = _local_3.GetGrid();
                _local_2.push(_local_4);
            };
            return (_local_2);
        }

        override public function CreateTaskVOFromSpecialistTask():dSpecialistTaskVO
        {
            var _local_1:dSpecialistTask_FindDepositVO = new dSpecialistTask_FindDepositVO();
            _local_1.type = GetType();
            _local_1.subTaskID = GetSubType();
            _local_1.phase = GetTaskPhase();
            _local_1.collectedTime = GetCollectedTime();
            return (_local_1);
        }


    }
}
