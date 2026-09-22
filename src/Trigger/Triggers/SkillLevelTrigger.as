package Trigger.Triggers
{
    import Trigger.InstantTrigger;
    import Model.Observer;
    import Utils.TriggerUtils;
    import Trigger.Triggerable;
    import Communication.VO.TriggerVO;
    import Interface.cGeneralInterface;
    import Skill.cSkill;
    import Model.Notifier;
    import Skill.cSkillList;
    import __AS3__.vec.Vector;

    public final class SkillLevelTrigger extends InstantTrigger implements Observer 
    {

        public function SkillLevelTrigger(_arg_1:Triggerable, _arg_2:TriggerVO, _arg_3:cGeneralInterface)
        {
            super(_arg_1, _arg_2, _arg_3);
            if (_arg_2.max == 0)
            {
                _arg_2.max = 100100100;
            };
            _arg_3.channels.SKILL.addPropertyObserver(TriggerUtils.SKILL_CHANGED_PROPERTY_NAME, this);
        }

        public function update(_arg_1:Notifier, _arg_2:String, _arg_3:Object):void
        {
            var _local_4:cSkill = (_arg_3 as cSkill);
            this.checkSkill(_local_4);
        }

        override public function check():Boolean
        {
            updateCurrentAmount();
            var _local_1:Number = getCurrentAmount();
            if (((_local_1 >= definition.min) && (_local_1 <= definition.max)))
            {
                (para as cGeneralInterface).channels.SKILL.removePropertyObserver(TriggerUtils.SKILL_CHANGED_PROPERTY_NAME, this);
                trigger();
                return (true);
            };
            return (false);
        }

        private function checkSkill(_arg_1:cSkill):Boolean
        {
            var _local_2:Number;
            if (_arg_1.getName() == definition.item_string)
            {
                _local_2 = getCurrentAmount();
                currentAmount = _arg_1.getLevel();
                checkSendTriggerValueUpdated(_local_2, currentAmount);
                if (((currentAmount >= definition.min) && (currentAmount <= definition.max)))
                {
                    (para as cGeneralInterface).channels.SKILL.removePropertyObserver(TriggerUtils.SKILL_CHANGED_PROPERTY_NAME, this);
                    trigger();
                    return (true);
                };
            };
            return (false);
        }

        override protected function computeCurrentAmount():Number
        {
            var _local_3:cSkillList;
            var _local_4:Vector.<cSkill>;
            var _local_5:cSkill;
            var _local_1:int;
            var _local_2:cGeneralInterface = (para as cGeneralInterface);
            for each (_local_3 in _local_2.skillLists_vector)
            {
                _local_4 = _local_3.getItems_vector();
                for each (_local_5 in _local_4)
                {
                    if (((_local_5.getName() == definition.item_string) && (_local_5.getLevel() > _local_1)))
                    {
                        _local_1 = _local_5.getLevel();
                    };
                };
            };
            return (_local_1);
        }


    }
}
