package Trigger.Triggers
{
    import Trigger.InstantTrigger;
    import Model.Observer;
    import Enums.SPECIALIST_TYPE;
    import Model.Notifiers.SpecialistNotifier;
    import Trigger.Triggerable;
    import Communication.VO.TriggerVO;
    import Interface.cGeneralInterface;
    import Specialists.cSpecialist;
    import Model.Notifier;

    public final class GeneralTrigger extends InstantTrigger implements Observer 
    {

        private var baseType:int = 0;

        public function GeneralTrigger(_arg_1:Triggerable, _arg_2:TriggerVO, _arg_3:cGeneralInterface)
        {
            super(_arg_1, _arg_2, _arg_3.channels.SPECIALIST);
            if (((_arg_2.min == 0) && (_arg_2.max == 0)))
            {
                _arg_2.min = 1;
            };
            if (((_arg_2.min > 0) && (_arg_2.max == 0)))
            {
                _arg_2.max = 100100100;
            };
            if (!_arg_2.isTypeEmpty())
            {
                if (_arg_2.typeContains("general"))
                {
                    this.baseType = SPECIALIST_TYPE.GENERAL;
                }
                else
                {
                    this.baseType = SPECIALIST_TYPE.ADMIRAL;
                };
            };
            _arg_3.channels.SPECIALIST.addPropertyObserver(SpecialistNotifier.GENERAL_LOST_string, this);
        }

        override public function check():Boolean
        {
            return (false);
        }

        public function update(_arg_1:Notifier, _arg_2:String, _arg_3:Object):void
        {
            var _local_4:cSpecialist = (_arg_3 as cSpecialist);
            if ((((_arg_2 == SpecialistNotifier.GENERAL_LOST_string) && (definition.item_string == "lost")) && (((this.baseType == 0) || (_local_4 == null)) || (_local_4.GetBaseType() == this.baseType))))
            {
                trigger();
            };
        }

        override public function dispose():void
        {
            (para as SpecialistNotifier).removePropertyObserver(SpecialistNotifier.GENERAL_LOST_string, this);
            super.dispose();
        }


    }
}
