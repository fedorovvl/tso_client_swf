package Specialists
{
    import Effects.EffectEnricher;
    import Communication.VO.UpdateVO.dFindTreasureResponseVO;
    import Enums.SPECIALIST_TASK_TYPES;
    import Interface.cGeneralInterface;
    import Communication.VO.dSpecialistTask_FindTreasureVO;
    import Enums.MAIL_TYPE;
    import Enums.AVATAR_MESSAGE_TYPE;
    import Utils.StringUtils;
    import Modifier.ModifierVO;
    import Modifier.Modifier;
    import Enums.TASK_PHASES_FIND_TREASURE;
    import nLib.gMisc;
    import Communication.VO.EffectVO;
    import __AS3__.vec.Vector;
    import Communication.VO.dSpecialistTaskVO;

    public class cSpecialistTask_FindTreasure extends cSpecialistTask implements EffectEnricher 
    {

        public static const SEARCH_TREASURE_SUCCESS:String = "SEARCH_TREASURE_SUCCESS";
        public static const SEARCH_TREASURE_FAILED:String = "SEARCH_TREASURE_FAILED";

        public var activeTwoStepEventAtStartUp:String;
        private var mFindTreasureResponseVO:dFindTreasureResponseVO;
        private var mailIDTresureFound:int = 6;

        public function cSpecialistTask_FindTreasure(_arg_1:cGeneralInterface, _arg_2:cSpecialist, _arg_3:int, _arg_4:int, _arg_5:int, _arg_6:String)
        {
            super(_arg_1, SPECIALIST_TASK_TYPES.FIND_TREASURE, _arg_5, _arg_2, _arg_3, _arg_4);
            mNeededTime = mTaskDefinition.duration;
            _arg_2.notifyPropertyObserver(TASK_START, this);
            this.activeTwoStepEventAtStartUp = _arg_6;
        }

        public static function CreateTaskFromVO(_arg_1:cGeneralInterface, _arg_2:dSpecialistTask_FindTreasureVO, _arg_3:cSpecialist):cSpecialistTask_FindTreasure
        {
            var _local_4:cSpecialistTask_FindTreasure = new cSpecialistTask_FindTreasure(_arg_1, _arg_3, (_arg_2.collectedTime + _arg_2.bonusTime), _arg_2.phase, _arg_2.subTaskID, _arg_2.activeTwoStepEvent);
            _local_4.mBonusTime = _arg_2.bonusTime;
            _local_4.mFindTreasureResponseVO = _arg_2.findTreasureResponseVO;
            return (_local_4);
        }


        override public function isModified():Boolean
        {
            return (!(this.mailIDTresureFound == MAIL_TYPE.TREASURE_LOOT));
        }

        override public function StartTask():void
        {
            super.StartTask();
            globalFlash.gui.mAvatarMessageList.AddMessage(AVATAR_MESSAGE_TYPE.EXPLORER_STARTED_FIND_TREASURE, mOwner);
        }

        public function SetFindTreasureResponseVO(_arg_1:dFindTreasureResponseVO):void
        {
            this.mFindTreasureResponseVO = _arg_1;
        }

        override public function isModifierApplyable(_arg_1:ModifierVO):Boolean
        {
            var _local_2:String = (mTaskDefinition.mainTask.taskName_string + mTaskDefinition.taskType_string);
            if (_arg_1.type_string.length > 0)
            {
                if (StringUtils.equalsCase(_local_2, _arg_1.type_string))
                {
                    return (true);
                };
                return (false);
            };
            return (true);
        }

        override public function setModified(_arg_1:Modifier):void
        {
            if (_arg_1 != null)
            {
                appliedSkills_vector.push(_arg_1.ownerSkill.getVO());
            };
        }

        override protected function PerformTaskPhase(_arg_1:int, _arg_2:int):void
        {
            switch (GetTaskPhase())
            {
                case TASK_PHASES_FIND_TREASURE.FIND_TREASURE:
                    if (GetCollectedTime() >= mNeededTime)
                    {
                        if (this.mFindTreasureResponseVO != null)
                        {
                            globalFlash.gui.mAvatarMessageList.AddMessage(AVATAR_MESSAGE_TYPE.EXPLORER_FOUND_TREASURE, mOwner);
                            mOwner.notifyPropertyObserver(SEARCH_TREASURE_SUCCESS, this);
                            if (appliedSkills_vector.length > 0)
                            {
                                this.mailIDTresureFound = MAIL_TYPE.TREASURE_LOOT_SKILLED;
                            };
                            if (mTaskDefinition.subTaskID == 4)
                            {
                                this.mailIDTresureFound = MAIL_TYPE.TREASURE_LOOT_TRAVELLINGERUDITE;
                            }
                            else
                            {
                                if (mTaskDefinition.subTaskID == 5)
                                {
                                    this.mailIDTresureFound = MAIL_TYPE.TREASURE_LOOT_BEANACOLOADA;
                                };
                            };
                            NextPhase();
                        }
                        else
                        {
                            globalFlash.gui.mAvatarMessageList.AddMessage(AVATAR_MESSAGE_TYPE.EXPLORER_DID_NOT_FIND_TREASURE, mOwner);
                            mOwner.notifyPropertyObserver(SEARCH_TREASURE_FAILED, this);
                            NextPhase();
                        };
                    };
                    return;
                case TASK_PHASES_FIND_TREASURE.WAIT_FOR_ORDERS:
                    mOwner.SetTask(null);
                    return;
                default:
                    gMisc.Assert(false, (("Could not interpret task phase " + GetTaskPhase()) + "!"));
            };
        }

        public function enrichEffect(_arg_1:EffectVO):EffectVO
        {
            return (_arg_1);
        }

        public function enrichExtraEffects(_arg_1:EffectVO):Vector.<EffectVO>
        {
            return (null);
        }

        override public function CreateTaskVOFromSpecialistTask():dSpecialistTaskVO
        {
            var _local_1:dSpecialistTask_FindTreasureVO = new dSpecialistTask_FindTreasureVO();
            _local_1.type = GetType();
            _local_1.subTaskID = GetSubType();
            _local_1.phase = GetTaskPhase();
            _local_1.collectedTime = GetCollectedTime();
            _local_1.findTreasureResponseVO = this.mFindTreasureResponseVO;
            return (_local_1);
        }

        public function GetFindTreasureResponseVO():dFindTreasureResponseVO
        {
            return (this.mFindTreasureResponseVO);
        }


    }
}
