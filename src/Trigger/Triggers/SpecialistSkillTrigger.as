package Trigger.Triggers
{
    import Trigger.InstantTrigger;
    import Model.Observer;
    import Utils.StringUtils;
    import Utils.TriggerUtils;
    import Trigger.Triggerable;
    import Communication.VO.TriggerVO;
    import Interface.cGeneralInterface;
    import Skill.cSkillTree;
    import Model.Notifier;
    import Skill.cSkillList;

    public class SpecialistSkillTrigger extends InstantTrigger implements Observer 
    {

        private var specialistList:Array;

        public function SpecialistSkillTrigger(_arg_1:Triggerable, _arg_2:TriggerVO, _arg_3:cGeneralInterface)
        {
            super(_arg_1, _arg_2, _arg_3);
            this.specialistList = StringUtils.split(_arg_2.item_string, StringUtils.COMMA);
            _arg_3.channels.SPECIALIST.addPropertyObserver(TriggerUtils.SKILL_CHANGED_PROPERTY_NAME, this);
        }

        override public function check():Boolean
        {
            updateCurrentAmount();
            var _local_1:Number = getCurrentAmount();
            if (_local_1 >= definition.amount)
            {
                trigger();
                return (true);
            };
            return (false);
        }

        public function update(_arg_1:Notifier, _arg_2:String, _arg_3:Object):void
        {
            var _local_4:String;
            if (_arg_2 == TriggerUtils.SKILL_CHANGED_PROPERTY_NAME)
            {
                _local_4 = (_arg_3 as cSkillTree).getDefinition().name_string;
                if (((this.specialistList.length == 0) || (TriggerUtils.contains(this.specialistList, _local_4))))
                {
                    this.check();
                };
            };
        }

        override protected function computeCurrentAmount():Number
        {
            var _local_3:cSkillTree;
            var _local_4:cSkillList;
            var _local_1:cGeneralInterface = (para as cGeneralInterface);
            var _local_2:int;
            for each (_local_4 in _local_1.skillLists_vector)
            {
                if ((_local_4 is cSkillTree))
                {
                    _local_3 = (_local_4 as cSkillTree);
                    if (_local_3.getDefinition().id != 0)
                    {
                        if (this.specialistList.length > 0)
                        {
                            if (TriggerUtils.contains(this.specialistList, _local_3.getDefinition().name_string))
                            {
                                if (definition.isTypeEmpty())
                                {
                                    if (_local_3.getSumPoints() >= definition.min)
                                    {
                                        _local_2++;
                                    };
                                }
                                else
                                {
                                    if (_local_3.IsFullySkilled())
                                    {
                                        _local_2++;
                                    };
                                };
                            };
                        }
                        else
                        {
                            if (definition.isTypeEmpty())
                            {
                                if (_local_3.getSumPoints() >= definition.min)
                                {
                                    _local_2++;
                                };
                            }
                            else
                            {
                                if (_local_3.IsFullySkilled())
                                {
                                    _local_2++;
                                };
                            };
                        };
                    };
                };
            };
            return (_local_2);
        }


    }
}
