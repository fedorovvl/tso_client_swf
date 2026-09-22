package Trigger.Triggers
{
    import Trigger.DeltaTrigger;
    import Model.Observer;
    import Utils.TriggerUtils;
    import Trigger.TriggerDeltaValue;
    import Trigger.Triggerable;
    import Communication.VO.TriggerVO;
    import Interface.cGeneralInterface;
    import Model.Notifier;

    public final class AdmiralTravelTrigger extends DeltaTrigger implements Observer 
    {

        public function AdmiralTravelTrigger(_arg_1:TriggerDeltaValue, _arg_2:Triggerable, _arg_3:TriggerVO, _arg_4:cGeneralInterface)
        {
            super(_arg_1, _arg_2, _arg_3, _arg_4);
            _arg_4.channels.SPECIALIST.addPropertyObserver(TriggerUtils.ADMIRAL_TRAVEL_PROPERTY_NAME, this);
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
            getDelta().add((_arg_3 as int));
            sendTriggerValueUpdated();
            this.check();
        }

        override public function dispose():void
        {
            (para as cGeneralInterface).channels.SPECIALIST.removePropertyObserver(TriggerUtils.ADMIRAL_TRAVEL_PROPERTY_NAME, this);
            super.dispose();
        }


    }
}
