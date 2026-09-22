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

    public class ClaimColonyTrigger extends DeltaTrigger implements Observer 
    {

        public function ClaimColonyTrigger(_arg_1:TriggerDeltaValue, _arg_2:Triggerable, _arg_3:TriggerVO, _arg_4:cGeneralInterface)
        {
            super(_arg_1, _arg_2, _arg_3, _arg_4);
            _arg_4.channels.ZONE.addPropertyObserver(TriggerUtils.COLONY_SLOTS_TOTAL, this);
        }

        public function update(_arg_1:Notifier, _arg_2:String, _arg_3:Object):void
        {
            getDelta().add(1);
            sendTriggerValueUpdated();
            this.check();
        }

        override public function check():Boolean
        {
            if (getDelta().getValue() >= definition.amount)
            {
                trigger();
                return (true);
            };
            return (false);
        }

        override public function dispose():void
        {
            (para as cGeneralInterface).channels.ZONE.removePropertyObserver(TriggerUtils.COLONY_SLOTS_TOTAL, this);
            super.dispose();
        }


    }
}
