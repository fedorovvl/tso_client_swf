package Specialists
{
    import Enums.SPECIALIST_TASK_TYPES;
    import Interface.cGeneralInterface;
    import Communication.VO.dSpecialistTask_ExpeditionRecoverVO;
    import Communication.VO.dSpecialistTaskVO;
    import Enums.TASK_PHASES_RECOVER;
    import Modifier.Modifier;
    import Enums.TASK_PHASES_EXPEDITION_RECOVER;
    import Modifier.ModifierVO;

    public class cSpecialistTask_ExpeditionRecover extends cSpecialistTask 
    {

        private var modified:Boolean;

        public function cSpecialistTask_ExpeditionRecover(_arg_1:cGeneralInterface, _arg_2:cSpecialist, _arg_3:int, _arg_4:int)
        {
            super(_arg_1, SPECIALIST_TASK_TYPES.EXPEDITION_RECOVER, 0, _arg_2, _arg_3, _arg_4);
            mNeededTime = mTaskDefinition.duration;
            _arg_2.notifyPropertyObserver(TASK_START, this);
        }

        public static function CreateTaskFromVO(_arg_1:cGeneralInterface, _arg_2:dSpecialistTask_ExpeditionRecoverVO, _arg_3:cSpecialist):cSpecialistTask_ExpeditionRecover
        {
            var _local_4:cSpecialistTask_ExpeditionRecover = new cSpecialistTask_ExpeditionRecover(_arg_1, _arg_3, (_arg_2.collectedTime + _arg_2.bonusTime), _arg_2.phase);
            _local_4.mBonusTime = _arg_2.bonusTime;
            return (_local_4);
        }


        override public function CreateTaskVOFromSpecialistTask():dSpecialistTaskVO
        {
            var _local_1:dSpecialistTask_ExpeditionRecoverVO = new dSpecialistTask_ExpeditionRecoverVO();
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
            super.StartTask();
        }

        override protected function PerformTaskPhase(_arg_1:int, _arg_2:int):void
        {
            switch (GetTaskPhase())
            {
                case TASK_PHASES_EXPEDITION_RECOVER.RECOVER:
                    if (GetCollectedTime() >= mNeededTime)
                    {
                        NextPhase();
                    };
                    return;
                default:
                    mOwner.SetTask(null);
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
