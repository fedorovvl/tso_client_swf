package Specialists
{
    import Effects.EffectEnricher;
    import Communication.VO.UpdateVO.dFindExpeditionResponseVO;
    import __AS3__.vec.Vector;
    import ServerState.dResource;
    import Enums.SPECIALIST_TASK_TYPES;
    import Enums.AVATAR_MESSAGE_TYPE;
    import Interface.cGeneralInterface;
    import Communication.VO.dSpecialistTask_FindExpeditionVO;
    import Enums.MAIL_TYPE;
    import Modifier.Modifier;
    import com.bluebyte.tso.service.ServiceManager;
    import Communication.VO.dBuffVO;
    import nLib.cLog;
    import Communication.VO.UpdateVO.dLootItemsVO;
    import Enums.TASK_PHASES_FIND_EXPEDITION;
    import Enums.TASK_PHASES_EXPEDITION_RECOVER;
    import nLib.gMisc;
    import Communication.VO.EffectVO;
    import Communication.VO.dSpecialistTaskVO;
    import Utils.StringUtils;
    import Effects.Effects.StartQuest;
    import Modifier.ModifierVO;
    import __AS3__.vec.*;
    import nLib.*;

    public class cSpecialistTask_FindExpedition extends cSpecialistTask implements EffectEnricher 
    {

        public static const FOUND_EXPEDITION:String = "FOUND_EXPEDITION";
        public static const SEARCH_EXPEDITION_FAILED:String = "SEARCH_EXPEDITION_FAILED";
        public static const SEARCH_EXPEDITION_FINISHED:String = "SEARCH_EXPEDITION_FINISHED";

        private var mFindExpeditionResponseVO:dFindExpeditionResponseVO;
        private var mAvatarFindExpeditionMessage:String = "";
        private var costs_vector:Vector.<dResource>;
        private var mailIDFoundExpedition:int = 53;

        public function cSpecialistTask_FindExpedition(_arg_1:cGeneralInterface, _arg_2:cSpecialist, _arg_3:int, _arg_4:int, _arg_5:int)
        {
            var _local_6:dResource;
            super(_arg_1, SPECIALIST_TASK_TYPES.FIND_EXPEDITION, _arg_5, _arg_2, _arg_3, _arg_4);
            mNeededTime = mTaskDefinition.duration;
            this.costs_vector = new Vector.<dResource>();
            for each (_local_6 in mTaskDefinition.costs)
            {
                this.costs_vector.push(_local_6.clone());
            };
            mOwner.notifyPropertyObserver(TASK_START, this);
            this.mAvatarFindExpeditionMessage = AVATAR_MESSAGE_TYPE.EXPLORER_STARTED_FIND_EXPEDITION_ZONE;
        }

        public static function CreateTaskFromVO(_arg_1:cGeneralInterface, _arg_2:dSpecialistTask_FindExpeditionVO, _arg_3:cSpecialist):cSpecialistTask_FindExpedition
        {
            var _local_4:cSpecialistTask_FindExpedition = new cSpecialistTask_FindExpedition(_arg_1, _arg_3, (_arg_2.collectedTime + _arg_2.bonusTime), _arg_2.phase, _arg_2.subTaskID);
            _local_4.mBonusTime = _arg_2.bonusTime;
            _local_4.mFindExpeditionResponseVO = _arg_2.findExpeditionResponseVO;
            return (_local_4);
        }


        public function GetFindExpeditionResponseVO():dFindExpeditionResponseVO
        {
            return (this.mFindExpeditionResponseVO);
        }

        override public function setModified(_arg_1:Modifier):void
        {
            if (_arg_1 != null)
            {
                appliedSkills_vector.push(_arg_1.ownerSkill.getVO());
            };
            this.mailIDFoundExpedition = MAIL_TYPE.FIND_ADVENTURE_LOOT_POSITIVE_SKILLED;
        }

        public function getCosts_vector():Vector.<dResource>
        {
            return (this.costs_vector);
        }

        public function SetFindExpeditionResponseVO(_arg_1:dFindExpeditionResponseVO):void
        {
            this.mFindExpeditionResponseVO = _arg_1;
        }

        override public function isModified():Boolean
        {
            return (this.mailIDFoundExpedition == MAIL_TYPE.FIND_ADVENTURE_LOOT_POSITIVE_SKILLED);
        }

        override public function StartTask():void
        {
            super.StartTask();
            this.PerformTaskPhase(0, 0);
            if (this.taskIsPvP())
            {
                ServiceManager.getInstance().colony.getPvPColonies(mTaskDefinition.subTaskID, -1);
                globalFlash.gui.TogglePvPColoniesWindow();
            }
            else
            {
                globalFlash.gui.mAvatarMessageList.AddMessage(this.mAvatarFindExpeditionMessage);
            };
        }

        override protected function PerformTaskPhase(_arg_1:int, _arg_2:int):void
        {
            var _local_3:Boolean;
            var _local_4:Object;
            var _local_5:dBuffVO;
            switch (GetTaskPhase())
            {
                case TASK_PHASES_FIND_EXPEDITION.FIND_EXPEDITION:
                    if (GetCollectedTime() >= mNeededTime)
                    {
                        if (this.mFindExpeditionResponseVO == null)
                        {
                            cLog.info(("Waiting for result for " + this));
                            return;
                        };
                        if (this.mFindExpeditionResponseVO.foundExpeditions != null)
                        {
                            mOwner.notifyPropertyObserver(SEARCH_EXPEDITION_FINISHED, this);
                            _local_3 = false;
                            for each (_local_4 in this.mFindExpeditionResponseVO.foundExpeditions.items)
                            {
                                if ((_local_4 is dBuffVO))
                                {
                                    _local_5 = (_local_4 as dBuffVO);
                                    if (_local_5.buffName_string == "Adventure")
                                    {
                                        _local_3 = true;
                                    };
                                    break;
                                };
                            };
                            if (_local_3)
                            {
                                mOwner.notifyPropertyObserver(FOUND_EXPEDITION, this);
                                globalFlash.gui.mAvatarMessageList.AddMessage(AVATAR_MESSAGE_TYPE.EXPLORER_FOUND_EXPEDITION_ZONE);
                            }
                            else
                            {
                                cLog.info("Expedition came back empty. Probably PvP. Or MapFragments.");
                            };
                        }
                        else
                        {
                            cLog.error(("On FindExpedition Task. NO loot was drawn from Loottable! - Investigate!" + this));
                            this.mFindExpeditionResponseVO.foundExpeditions = new dLootItemsVO();
                            globalFlash.gui.mAvatarMessageList.AddMessage(AVATAR_MESSAGE_TYPE.EXPLORER_DID_NOT_FIND_EXPEDITION_ZONE, mOwner);
                            mOwner.notifyPropertyObserver(SEARCH_EXPEDITION_FAILED, this);
                            this.mailIDFoundExpedition = MAIL_TYPE.FIND_EXPEDITION_LOOT_NEGATIVE;
                        };
                        NextPhase();
                    };
                    return;
                case TASK_PHASES_FIND_EXPEDITION.RECOVER_AFTER_FOUND:
                    if (this.taskIsPvP())
                    {
                        mOwner.SetTask(new cSpecialistTask_ExpeditionRecover(mGeneralInterface, mOwner, 0, TASK_PHASES_EXPEDITION_RECOVER.RECOVER));
                    }
                    else
                    {
                        NextPhase();
                    };
                    return;
                case TASK_PHASES_FIND_EXPEDITION.WAIT_FOR_ORDERS:
                    mOwner.SetTask(null);
                    return;
                default:
                    gMisc.Assert(false, (("Could not interpret task phase " + GetTaskPhase()) + "!"));
            };
        }

        public function enrichExtraEffects(_arg_1:EffectVO):Vector.<EffectVO>
        {
            return (null);
        }

        override public function CreateTaskVOFromSpecialistTask():dSpecialistTaskVO
        {
            var _local_1:dSpecialistTask_FindExpeditionVO = new dSpecialistTask_FindExpeditionVO();
            _local_1.type = GetType();
            _local_1.subTaskID = GetSubType();
            _local_1.phase = GetTaskPhase();
            _local_1.collectedTime = GetCollectedTime();
            _local_1.findExpeditionResponseVO = this.mFindExpeditionResponseVO;
            return (_local_1);
        }

        private function taskIsPvP():Boolean
        {
            return (StringUtils.startsWith(mTaskDefinition.taskType_string, "PvP"));
        }

        public function enrichEffect(_arg_1:EffectVO):EffectVO
        {
            var _local_2:String;
            var _local_3:Object;
            var _local_4:dBuffVO;
            if (((!(this.mFindExpeditionResponseVO == null)) && (_arg_1.effect_string == StartQuest.XML_string)))
            {
                _local_2 = null;
                for each (_local_3 in this.mFindExpeditionResponseVO.foundExpeditions.items)
                {
                    _local_4 = (_local_3 as dBuffVO);
                    if (((!(_local_4 == null)) && (_local_4.buffName_string == "Adventure")))
                    {
                        _local_2 = _local_4.resourceName_string;
                    };
                };
                if (((!(_local_2 == null)) && (_local_2.length > 0)))
                {
                    _arg_1.item_string = _local_2;
                };
            };
            return (_arg_1);
        }

        override public function isModifierApplyable(_arg_1:ModifierVO):Boolean
        {
            var _local_2:String = (mTaskDefinition.mainTask.taskName_string + mTaskDefinition.taskType_string);
            if (_arg_1.type_string.length > 0)
            {
                if (StringUtils.startsWith(_local_2, _arg_1.type_string))
                {
                    return (true);
                };
                return (false);
            };
            return (true);
        }


    }
}
