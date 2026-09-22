package Specialists
{
    import Enums.SPECIALIST_TASK_TYPES;
    import Interface.cGeneralInterface;
    import Communication.VO.dSpecialistTask_RecoverVO;
    import Communication.VO.dSpecialistTaskVO;
    import Enums.TASK_PHASES_RECOVER;
    import Modifier.Modifier;
    import Modifier.ModifierVO;
    import nLib.gMisc;
    import Enums.ZONE_SPECIALIST_ACTIVITY_TYPE;
    import Enums.AVATAR_MESSAGE_TYPE;
    import MilitarySystem.cMilitaryUnitBase;

    public class cSpecialistTask_Recover extends cSpecialistTask 
    {

        public static const NOTIFY_STRING:String = "generalRecoverStart";

        private var modified:Boolean;

        public function cSpecialistTask_Recover(_arg_1:cGeneralInterface, _arg_2:cSpecialist, _arg_3:int, _arg_4:int)
        {
            super(_arg_1, SPECIALIST_TASK_TYPES.RECOVER, 0, _arg_2, _arg_3, _arg_4);
            mNeededTime = GetOwner().GetSpecialistDescription().GetTimeOverwriteRecover();
            if (mNeededTime <= 0)
            {
                mNeededTime = mTaskDefinition.duration;
            };
            mOwner.notifyPropertyObserver(TASK_START, this);
            mOwner.notifyPropertyObserver(NOTIFY_STRING, this);
        }

        public static function CreateTaskFromVO(_arg_1:cGeneralInterface, _arg_2:dSpecialistTask_RecoverVO, _arg_3:cSpecialist):cSpecialistTask_Recover
        {
            var _local_4:cSpecialistTask_Recover = new cSpecialistTask_Recover(_arg_1, _arg_3, (_arg_2.collectedTime + _arg_2.bonusTime), _arg_2.phase);
            _local_4.mBonusTime = _arg_2.bonusTime;
            return (_local_4);
        }


        override public function CreateTaskVOFromSpecialistTask():dSpecialistTaskVO
        {
            var _local_1:dSpecialistTask_RecoverVO = new dSpecialistTask_RecoverVO();
            _local_1.type = GetType();
            _local_1.phase = GetTaskPhase();
            _local_1.collectedTime = GetCollectedTime();
            return (_local_1);
        }

        public function Done():void
        {
            SetTaskPhase(TASK_PHASES_RECOVER.WAIT_FOR_ORDERS);
        }

        override public function setModified(_arg_1:Modifier):void
        {
            this.modified = true;
        }

        override public function isModified():Boolean
        {
            return (this.modified);
        }

        override public function StartTask():void
        {
            var _local_2:Number;
            var _local_3:int;
            super.StartTask();
            var _local_1:ModifierVO = mOwner.GetModifier("CombatModifier", "InstantRecover");
            if (_local_1 != null)
            {
                _local_2 = gMisc.getPseudoRandom(mGeneralInterface.getSeed());
                _local_3 = mGeneralInterface.mZoneSpecialistActivityTracker.GetActivityCount(mGeneralInterface.mCurrentViewedZoneID, mOwner.getPlayerID(), mOwner.GetUniqueID(), ZONE_SPECIALIST_ACTIVITY_TYPE.ONEUP_SKILL_PROC);
                if ((((_local_2 <= _local_1.chance) && (_local_3 < _local_1.value)) && (mGeneralInterface.IsAdventureZone())))
                {
                    mNeededTime = 1;
                    mGeneralInterface.mZoneSpecialistActivityTracker.RegisterActivity(mGeneralInterface.mCurrentViewedZoneID, mOwner.getPlayerID(), mOwner.GetUniqueID(), ZONE_SPECIALIST_ACTIVITY_TYPE.ONEUP_SKILL_PROC, 1);
                };
            };
        }

        override protected function PerformTaskPhase(_arg_1:int, _arg_2:int):void
        {
            switch (GetTaskPhase())
            {
                case TASK_PHASES_RECOVER.RECOVER:
                    if (GetCollectedTime() >= mNeededTime)
                    {
                        if (mNeededTime < 2)
                        {
                            globalFlash.gui.mAvatarMessageList.AddMessage(AVATAR_MESSAGE_TYPE.GENERAL_INSTANT_RECOVER, null);
                        };
                        NextPhase();
                    };
                    return;
                default:
                    mOwner.SetTask(null);
                    mOwner.SetCurrentHitPoints(cMilitaryUnitBase.GetHitPointsForUnit(mOwner.GetSpecialistDescription().GetMilitaryUnitType_string()));
                    globalFlash.gui.mSpecialistPanel.Refresh(mOwner);
            };
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


    }
}
