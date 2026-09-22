package Specialists
{
    import Effects.EffectEnricher;
    import Communication.VO.UpdateVO.dFindEventZoneResponseVO;
    import __AS3__.vec.Vector;
    import ServerState.dResource;
    import Enums.SPECIALIST_TASK_TYPES;
    import Interface.cGeneralInterface;
    import Communication.VO.dSpecialistTask_FindEventZoneVO;
    import Enums.MAIL_TYPE;
    import Modifier.Modifier;
    import Enums.AVATAR_MESSAGE_TYPE;
    import Utils.StringUtils;
    import Modifier.ModifierVO;
    import Communication.VO.dBuffVO;
    import nLib.cLog;
    import Model.Notifiers.SpecialistNotifier;
    import Communication.VO.UpdateVO.dLootItemsVO;
    import Enums.TASK_PHASES_FIND_EVENT_ZONE;
    import nLib.gMisc;
    import Effects.Effects.StartQuest;
    import Communication.VO.EffectVO;
    import Communication.VO.dSpecialistTaskVO;
    import __AS3__.vec.*;
    import nLib.*;

    public class cSpecialistTask_FindEventZone extends cSpecialistTask implements EffectEnricher 
    {

        public static const FOUND_ADVENTURE:String = "FOUND_ADVENTURE";
        public static const FOUND_MAPPARTS:String = "FOUND_MAPPARTS";
        public static const SEARCH_ADVENTURE_FAILED:String = "SEARCH_ADVENTURE_FAILED";
        public static const SEARCH_ADVENTURE_FINISHED:String = "SEARCH_ADVENTURE_FINISHED";

        private var mFindEventZoneResponseVO:dFindEventZoneResponseVO;
        private var mailIDFoundAdventure:int = 25;
        private var costs_vector:Vector.<dResource>;
        private var mailIDFoundMapPart:int = 27;

        public function cSpecialistTask_FindEventZone(_arg_1:cGeneralInterface, _arg_2:cSpecialist, _arg_3:int, _arg_4:int, _arg_5:int)
        {
            var _local_6:dResource;
            super(_arg_1, SPECIALIST_TASK_TYPES.FIND_ADVENTURE_ZONE, _arg_5, _arg_2, _arg_3, _arg_4);
            mNeededTime = mTaskDefinition.duration;
            this.costs_vector = new Vector.<dResource>();
            for each (_local_6 in mTaskDefinition.costs)
            {
                this.costs_vector.push(_local_6.clone());
            };
            mOwner.notifyPropertyObserver(TASK_START, this);
        }

        public static function CreateTaskFromVO(_arg_1:cGeneralInterface, _arg_2:dSpecialistTask_FindEventZoneVO, _arg_3:cSpecialist):cSpecialistTask_FindEventZone
        {
            var _local_4:cSpecialistTask_FindEventZone = new cSpecialistTask_FindEventZone(_arg_1, _arg_3, (_arg_2.collectedTime + _arg_2.bonusTime), _arg_2.phase, _arg_2.subTaskID);
            _local_4.mBonusTime = _arg_2.bonusTime;
            _local_4.mFindEventZoneResponseVO = _arg_2.findEventZoneResponseVO;
            return (_local_4);
        }


        override public function isModified():Boolean
        {
            return ((this.mailIDFoundAdventure == MAIL_TYPE.FIND_ADVENTURE_LOOT_POSITIVE_SKILLED) || (this.mailIDFoundMapPart == MAIL_TYPE.FIND_ADVENTURE_LOOT_MAP_FRAGMENT_SKILLED));
        }

        override public function setModified(_arg_1:Modifier):void
        {
            if (_arg_1 != null)
            {
                appliedSkills_vector.push(_arg_1.ownerSkill.getVO());
            };
            this.mailIDFoundAdventure = MAIL_TYPE.FIND_ADVENTURE_LOOT_POSITIVE_SKILLED;
            this.mailIDFoundMapPart = MAIL_TYPE.FIND_ADVENTURE_LOOT_MAP_FRAGMENT_SKILLED;
        }

        public function SetFindEventZoneResponseVO(_arg_1:dFindEventZoneResponseVO):void
        {
            this.mFindEventZoneResponseVO = _arg_1;
        }

        override public function StartTask():void
        {
            super.StartTask();
            globalFlash.gui.mAvatarMessageList.AddMessage(AVATAR_MESSAGE_TYPE.EXPLORER_STARTED_FIND_ADVENTURE_ZONE, mOwner);
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

        public function GetFindEventZoneResponseVO():dFindEventZoneResponseVO
        {
            return (this.mFindEventZoneResponseVO);
        }

        public function getCosts_vector():Vector.<dResource>
        {
            return (this.costs_vector);
        }

        override protected function PerformTaskPhase(_arg_1:int, _arg_2:int):void
        {
            var _local_3:Vector.<dBuffVO>;
            var _local_4:Object;
            var _local_5:dBuffVO;
            switch (GetTaskPhase())
            {
                case TASK_PHASES_FIND_EVENT_ZONE.FIND_EVENT_ZONE:
                    if (GetCollectedTime() >= mNeededTime)
                    {
                        if (this.mFindEventZoneResponseVO == null)
                        {
                            cLog.info(("Waiting for result for " + this));
                            return;
                        };
                        if (this.mFindEventZoneResponseVO.foundAdventures != null)
                        {
                            mOwner.notifyPropertyObserver(SEARCH_ADVENTURE_FINISHED, this);
                            _local_3 = new Vector.<dBuffVO>();
                            for each (_local_4 in this.mFindEventZoneResponseVO.foundAdventures.items)
                            {
                                if ((_local_4 is dBuffVO))
                                {
                                    _local_5 = (_local_4 as dBuffVO);
                                    if (_local_5.buffName_string == "Adventure")
                                    {
                                        _local_3.push(_local_5);
                                    };
                                };
                            };
                            if (_local_3.length > 0)
                            {
                                globalFlash.gui.mAvatarMessageList.AddMessage(AVATAR_MESSAGE_TYPE.EXPLORER_FOUND_ADVENTURE_ZONE, mOwner);
                                mOwner.notifyPropertyObserver(FOUND_ADVENTURE, this);
                            }
                            else
                            {
                                globalFlash.gui.mAvatarMessageList.AddMessage(AVATAR_MESSAGE_TYPE.EXPLORER_FOUND_MAP_FRAGMENT, mOwner);
                                this.mailIDFoundAdventure = this.mailIDFoundMapPart;
                                mOwner.notifyPropertyObserver(FOUND_MAPPARTS, this);
                            };
                            mGeneralInterface.channels.SPECIALIST.notify(SpecialistNotifier.SPECIALIST_TASK_FINISHED_string, (SPECIALIST_TASK_TYPES.toString(SPECIALIST_TASK_TYPES.FIND_ADVENTURE_ZONE) + mTaskDefinition.taskType_string));
                        }
                        else
                        {
                            cLog.error(("On FindEventZone Task. NO loot was drawn from Loottable! - Investigate!" + this));
                            this.mFindEventZoneResponseVO.foundAdventures = new dLootItemsVO();
                            globalFlash.gui.mAvatarMessageList.AddMessage(AVATAR_MESSAGE_TYPE.EXPLORER_DID_NOT_FIND_ADVENTURE_ZONE, mOwner);
                            mOwner.notifyPropertyObserver(SEARCH_ADVENTURE_FAILED, this);
                            this.mailIDFoundAdventure = MAIL_TYPE.FIND_ADVENTURE_LOOT_NEGATIVE;
                        };
                        NextPhase();
                    };
                    return;
                case TASK_PHASES_FIND_EVENT_ZONE.WAIT_FOR_ORDERS:
                    mOwner.SetTask(null);
                    return;
                default:
                    gMisc.Assert(false, (("Could not interpret task phase " + GetTaskPhase()) + "!"));
            };
        }

        public function enrichEffect(_arg_1:EffectVO):EffectVO
        {
            var _local_2:String;
            var _local_3:Object;
            var _local_4:dBuffVO;
            if (((!(this.mFindEventZoneResponseVO == null)) && (_arg_1.effect_string == StartQuest.XML_string)))
            {
                _local_2 = null;
                for each (_local_3 in this.mFindEventZoneResponseVO.foundAdventures.items)
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

        public function enrichExtraEffects(_arg_1:EffectVO):Vector.<EffectVO>
        {
            return (null);
        }

        override public function CreateTaskVOFromSpecialistTask():dSpecialistTaskVO
        {
            var _local_1:dSpecialistTask_FindEventZoneVO = new dSpecialistTask_FindEventZoneVO();
            _local_1.type = GetType();
            _local_1.subTaskID = GetSubType();
            _local_1.phase = GetTaskPhase();
            _local_1.collectedTime = GetCollectedTime();
            _local_1.findEventZoneResponseVO = this.mFindEventZoneResponseVO;
            return (_local_1);
        }


    }
}
