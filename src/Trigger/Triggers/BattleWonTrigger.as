package Trigger.Triggers
{
    import Trigger.DeltaTrigger;
    import Model.Observer;
    import Utils.StringUtils;
    import Model.Notifiers.SpecialistNotifier;
    import Trigger.TriggerDeltaValue;
    import Trigger.Triggerable;
    import Communication.VO.TriggerVO;
    import Interface.cGeneralInterface;
    import Communication.VO.Achievements.BattleStatusVO;
    import Utils.TriggerUtils;
    import Model.Notifier;

    public final class BattleWonTrigger extends DeltaTrigger implements Observer 
    {

        private var mBattlesType:Array;

        public function BattleWonTrigger(_arg_1:TriggerDeltaValue, _arg_2:Triggerable, _arg_3:TriggerVO, _arg_4:cGeneralInterface)
        {
            super(_arg_1, _arg_2, _arg_3, _arg_4.channels.SPECIALIST);
            this.mBattlesType = StringUtils.split(_arg_3.item_string, StringUtils.COMMA);
            _arg_4.channels.SPECIALIST.addPropertyObserver(SpecialistNotifier.GENERAL_WON_string, this);
        }

        override public function dispose():void
        {
            (para as SpecialistNotifier).removePropertyObserver(SpecialistNotifier.GENERAL_WON_string, this);
            super.dispose();
        }

        public function update(_arg_1:Notifier, _arg_2:String, _arg_3:Object):void
        {
            var _local_4:BattleStatusVO = (_arg_3 as BattleStatusVO);
            if (_arg_2 == SpecialistNotifier.GENERAL_WON_string)
            {
                if (((definition.item_string == "") || (TriggerUtils.contains(this.mBattlesType, _local_4.getTargetName()))))
                {
                    if (((definition.target_string == "") || (definition.target_string == _local_4.getZoneName())))
                    {
                        getDelta().add(1);
                        sendTriggerValueUpdated();
                        this.check();
                    };
                };
            };
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


    }
}
