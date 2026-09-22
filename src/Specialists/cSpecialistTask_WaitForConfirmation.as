package Specialists
{
    import Enums.SPECIALIST_TASK_TYPES;
    import Enums.TASK_PHASES_WAIT_FOR_CONFIRMATION;
    import Interface.cGeneralInterface;
    import Communication.VO.dSpecialistTask_WaitForConfirmationVO;
    import Communication.VO.dSpecialistTaskVO;
    import Enums.TASK_PHASES_EXPLORE_SECTOR;
    import nLib.gMisc;

    public class cSpecialistTask_WaitForConfirmation extends cSpecialistTask 
    {

        private var originalType:int;

        public function cSpecialistTask_WaitForConfirmation(_arg_1:cGeneralInterface, _arg_2:cSpecialist, _arg_3:int, _arg_4:int)
        {
            super(_arg_1, SPECIALIST_TASK_TYPES.WAIT_FOR_CONFIRMATION, 0, _arg_2, _arg_3, TASK_PHASES_WAIT_FOR_CONFIRMATION.WAIT_FOR_CONFIRMATION);
            mNeededTime = mTaskDefinition.duration;
            this.originalType = _arg_4;
        }

        override public function GetOriginalType():int
        {
            return (this.originalType);
        }

        override public function CreateTaskVOFromSpecialistTask():dSpecialistTaskVO
        {
            var _local_1:dSpecialistTask_WaitForConfirmationVO = new dSpecialistTask_WaitForConfirmationVO();
            _local_1.type = GetType();
            _local_1.phase = GetTaskPhase();
            _local_1.collectedTime = GetCollectedTime();
            return (_local_1);
        }

        override protected function PerformTaskPhase(_arg_1:int, _arg_2:int):void
        {
            switch (GetTaskPhase())
            {
                case TASK_PHASES_WAIT_FOR_CONFIRMATION.WAIT_FOR_CONFIRMATION:
                    if (GetCollectedTime() >= mNeededTime)
                    {
                        NextPhase();
                    };
                    return;
                case TASK_PHASES_EXPLORE_SECTOR.WAIT_FOR_ORDERS:
                    mOwner.SetTask(null);
                    return;
                default:
                    gMisc.Assert(false, (("Could not interpret task phase " + GetTaskPhase()) + "!"));
            };
        }


    }
}
