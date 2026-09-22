package Specialists
{
    import Enums.SPECIALIST_TASK_TYPES;
    import Interface.cGeneralInterface;
    import Communication.VO.dSpecialistTask_ExploreSectorVO;
    import ServerState.cPlayerData;
    import Map.cSector;
    import Modifier.Modifier;
    import Modifier.ModifierVO;
    import Enums.AVATAR_MESSAGE_TYPE;
    import Enums.TASK_PHASES_EXPLORE_SECTOR;
    import nLib.gMisc;
    import Communication.VO.dSpecialistTaskVO;

    public class cSpecialistTask_ExploreSector extends cSpecialistTask 
    {

        private var modified:Boolean;
        private var mExploredSectorId:int = -1;

        public function cSpecialistTask_ExploreSector(_arg_1:cGeneralInterface, _arg_2:cSpecialist, _arg_3:int, _arg_4:int, _arg_5:int)
        {
            super(_arg_1, SPECIALIST_TASK_TYPES.EXPLORE, _arg_5, _arg_2, _arg_3, _arg_4);
            mNeededTime = mTaskDefinition.duration;
            _arg_2.notifyPropertyObserver(TASK_START, this);
        }

        public static function CreateTaskFromVO(_arg_1:cGeneralInterface, _arg_2:dSpecialistTask_ExploreSectorVO, _arg_3:cSpecialist):cSpecialistTask_ExploreSector
        {
            var _local_4:cSpecialistTask_ExploreSector = new cSpecialistTask_ExploreSector(_arg_1, _arg_3, (_arg_2.collectedTime + _arg_2.bonusTime), _arg_2.phase, _arg_2.subTaskID);
            _local_4.mBonusTime = _arg_2.bonusTime;
            _local_4.mExploredSectorId = _arg_2.exploredSectorId;
            return (_local_4);
        }


        private function exploreNewSector(_arg_1:cPlayerData):cSector
        {
            return (_arg_1.getNextExplorableSector((mTaskDefinition.taskType_string == "Island")));
        }

        override public function isModified():Boolean
        {
            return (this.modified);
        }

        override public function setModified(_arg_1:Modifier):void
        {
            this.modified = true;
        }

        public function GetExploredSector():cSector
        {
            if (this.mExploredSectorId == -1)
            {
                return (null);
            };
            return (mGeneralInterface.mCurrentPlayerZone.mSectorList_vector[this.mExploredSectorId]);
        }

        override public function isModifierApplyable(_arg_1:ModifierVO):Boolean
        {
            var _local_2:String = (mTaskDefinition.mainTask.taskName_string + mTaskDefinition.taskType_string);
            if (_arg_1.type_string.length > 0)
            {
                if (_local_2.indexOf(_arg_1.type_string) >= 0)
                {
                    return (true);
                };
                return (false);
            };
            return (true);
        }

        override protected function PerformTaskPhase(_arg_1:int, _arg_2:int):void
        {
            var _local_3:cPlayerData;
            switch (GetTaskPhase())
            {
                case TASK_PHASES_EXPLORE_SECTOR.EXPLORE_SECTOR:
                    if (GetCollectedTime() >= mNeededTime)
                    {
                        if (this.mExploredSectorId != -1)
                        {
                            globalFlash.gui.mAvatarMessageList.AddMessage(AVATAR_MESSAGE_TYPE.EXPLORER_FINISHED_POSITIVE, mOwner);
                            _local_3 = mGeneralInterface.FindPlayerFromId(mOwner.getPlayerID());
                            mGeneralInterface.mCurrentPlayerZone.exploreSector(_local_3, this.mExploredSectorId);
                        }
                        else
                        {
                            globalFlash.gui.mAvatarMessageList.AddMessage(AVATAR_MESSAGE_TYPE.EXPLORER_FINISHED_NEGATIVE, mOwner);
                        };
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

        override public function StartTask():void
        {
            super.StartTask();
            globalFlash.gui.mAvatarMessageList.AddMessage(AVATAR_MESSAGE_TYPE.EXPLORER_STARTED, mOwner);
        }

        public function SetExploredSector(_arg_1:cSector):void
        {
            if (_arg_1 == null)
            {
                this.mExploredSectorId = -1;
            }
            else
            {
                this.mExploredSectorId = _arg_1.GetSectorID();
            };
        }

        override public function CreateTaskVOFromSpecialistTask():dSpecialistTaskVO
        {
            var _local_1:dSpecialistTask_ExploreSectorVO = new dSpecialistTask_ExploreSectorVO();
            _local_1.type = GetType();
            _local_1.phase = GetTaskPhase();
            _local_1.collectedTime = GetCollectedTime();
            _local_1.exploredSectorId = this.mExploredSectorId;
            return (_local_1);
        }


    }
}
