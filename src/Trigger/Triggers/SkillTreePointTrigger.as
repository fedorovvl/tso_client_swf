package Trigger.Triggers
{
    import Trigger.InstantTrigger;
    import Model.Observer;
    import Utils.TriggerUtils;
    import Trigger.Triggerable;
    import Communication.VO.TriggerVO;
    import Interface.cGeneralInterface;
    import Skill.cSkillTree;
    import Skill.cSkillList;
    import Skill.cSkill;
    import Model.Notifier;

    public final class SkillTreePointTrigger extends InstantTrigger implements Observer 
    {

        public function SkillTreePointTrigger(_arg_1:Triggerable, _arg_2:TriggerVO, _arg_3:cGeneralInterface)
        {
            super(_arg_1, _arg_2, _arg_3);
            if (_arg_2.max == 0)
            {
                _arg_2.max = 100100100;
            };
            _arg_3.channels.SKILL.addPropertyObserver(TriggerUtils.SKILL_CHANGED_PROPERTY_NAME, this);
        }

        override public function dispose():void
        {
            (para as cGeneralInterface).channels.SKILL.removePropertyObserver(TriggerUtils.SKILL_CHANGED_PROPERTY_NAME, this);
            super.dispose();
        }

        private function checkSkillList(_arg_1:cSkillList):Boolean
        {
            var _local_3:Number;
            var _local_2:cSkillTree = (_arg_1 as cSkillTree);
            if (((!(_local_2 == null)) && (_local_2.getDefinition().name_string == definition.item_string)))
            {
                _local_3 = getCurrentAmount();
                currentAmount = _local_2.getSumPointsByType(definition.GetTypeString());
                checkSendTriggerValueUpdated(_local_3, currentAmount);
                if (((currentAmount >= definition.min) && (currentAmount <= definition.max)))
                {
                    trigger();
                    return (true);
                };
            };
            return (false);
        }

        override public function check():Boolean
        {
            updateCurrentAmount();
            var _local_1:Number = getCurrentAmount();
            if (((_local_1 >= definition.min) && (_local_1 <= definition.max)))
            {
                trigger();
                return (true);
            };
            return (false);
        }

        public function update(_arg_1:Notifier, _arg_2:String, _arg_3:Object):void
        {
            var _local_4:cSkill = (_arg_3 as cSkill);
            var _local_5:cSkillList = _local_4.getSkillTree();
            this.checkSkillList(_local_5);
        }

        override protected function computeCurrentAmount():Number
        {
            var _local_3:cSkillList;
            var _local_4:cSkillTree;
            var _local_1:cGeneralInterface = (para as cGeneralInterface);
            var _local_2:int;
            for each (_local_3 in _local_1.skillLists_vector)
            {
                if ((_local_3 is cSkillTree))
                {
                    _local_4 = (_local_3 as cSkillTree);
                    if ((((!(_local_4 == null)) && (!(_local_4.getDefinition() == null))) && (_local_4.getDefinition().name_string == definition.item_string)))
                    {
                        _local_2 = Math.max(_local_2, _local_4.getSumPointsByType(definition.GetTypeString()));
                    };
                };
            };
            return (_local_2);
        }


    }
}
