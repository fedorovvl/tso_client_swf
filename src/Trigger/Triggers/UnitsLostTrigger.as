package Trigger.Triggers
{
    import Trigger.DeltaTrigger;
    import Model.Observer;
    import Model.Notifiers.SpecialistNotifier;
    import Trigger.TriggerDeltaValue;
    import Trigger.Triggerable;
    import Communication.VO.TriggerVO;
    import Interface.cGeneralInterface;
    import Communication.VO.Achievements.BattleStatusVO;
    import Model.Notifier;

    public final class UnitsLostTrigger extends DeltaTrigger implements Observer 
    {

        public function UnitsLostTrigger(_arg_1:TriggerDeltaValue, _arg_2:Triggerable, _arg_3:TriggerVO, _arg_4:cGeneralInterface)
        {
            super(_arg_1, _arg_2, _arg_3, _arg_4.channels.SPECIALIST);
            _arg_4.channels.SPECIALIST.addPropertyObserver(SpecialistNotifier.GENERAL_CASUALTIES_STRING, this);
        }

        override public function check():Boolean
        {
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
            var _local_4:BattleStatusVO = (_arg_3 as BattleStatusVO);
            if (_arg_2 == SpecialistNotifier.GENERAL_CASUALTIES_STRING)
            {
                if (((definition.target_string == "") || (definition.target_string == _local_4.getZoneName())))
                {
                    if (_local_4.getCasualties() > 0)
                    {
                        getDelta().add(_local_4.getCasualties());
                        sendTriggerValueUpdated();
                        this.check();
                    };
                };
            };
        }

        override public function dispose():void
        {
            (para as SpecialistNotifier).removePropertyObserver(SpecialistNotifier.GENERAL_CASUALTIES_STRING, this);
            super.dispose();
        }


    }
}
