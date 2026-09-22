package Trigger.Triggers
{
    import Trigger.InstantTrigger;
    import Model.Observer;
    import Utils.TriggerUtils;
    import Trigger.Triggerable;
    import Communication.VO.TriggerVO;
    import Interface.cGeneralInterface;
    import Model.Notifier;
    import Specialists.cSpecialist;
    import Skill.cSkill;

    public final class SpecialistHasSkillTrigger extends InstantTrigger implements Observer 
    {

        public static const XML_string:String = "specialistHasSkill";

        public function SpecialistHasSkillTrigger(_arg_1:Triggerable, _arg_2:TriggerVO, _arg_3:cGeneralInterface)
        {
            super(_arg_1, _arg_2, _arg_3);
            _arg_3.channels.SKILL.addPropertyObserver(TriggerUtils.SKILL_CHANGED_PROPERTY_NAME, this);
        }

        public function update(_arg_1:Notifier, _arg_2:String, _arg_3:Object):void
        {
            this.check();
        }

        override public function dispose():void
        {
            (para as cGeneralInterface).channels.SKILL.removePropertyObserver(TriggerUtils.SKILL_CHANGED_PROPERTY_NAME, this);
            super.dispose();
        }

        override public function check():Boolean
        {
            var _local_1:cSpecialist;
            if (definition.targetGridIdx > -1)
            {
                _local_1 = (para as cGeneralInterface).mCurrentPlayerZone.getSpecialistByGarrison(definition.targetGridIdx);
                if (((!(_local_1 == null)) && (this.checkSkill(_local_1))))
                {
                    trigger();
                    return (true);
                };
            };
            return (false);
        }

        private function checkSkill(_arg_1:cSpecialist):Boolean
        {
            var _local_2:cSkill = _arg_1.getSkillTree().getItemByID(definition.id);
            if (((!(_local_2 == null)) && (_local_2.getLevel() > 0)))
            {
                return (true);
            };
            _local_2 = _arg_1.skills.getItemByID(definition.id);
            return ((!(_local_2 == null)) && (_local_2.getLevel() > 0));
        }


    }
}
