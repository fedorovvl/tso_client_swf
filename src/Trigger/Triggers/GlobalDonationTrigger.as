package Trigger.Triggers
{
    import Trigger.InstantTrigger;
    import Model.Observer;
    import Model.Notifiers.TickChannel;
    import Trigger.Triggerable;
    import Communication.VO.TriggerVO;
    import Interface.cGeneralInterface;
    import Communication.VO.EventDonationPhaseVO;
    import Enums.EVENT_DONATION_PHASE_STATE;
    import Model.Notifier;

    public class GlobalDonationTrigger extends InstantTrigger implements Observer 
    {

        public static const XML_string:String = "globaldonation";

        public function GlobalDonationTrigger(_arg_1:Triggerable, _arg_2:TriggerVO, _arg_3:cGeneralInterface)
        {
            super(_arg_1, _arg_2, _arg_3);
            _arg_3.channels.TICK.addPropertyObserver(TickChannel.DELAYED_COMPUTE_TICK, this);
        }

        override public function check():Boolean
        {
            var _local_1:EventDonationPhaseVO = global.eventDonations.getPhase(definition.id);
            if (_local_1 != null)
            {
                if (definition.target_string == "lost")
                {
                    if (_local_1.state == EVENT_DONATION_PHASE_STATE.FINISHED_FAILED)
                    {
                        trigger();
                        return (true);
                    };
                }
                else
                {
                    if (_local_1.isReached())
                    {
                        trigger();
                        return (true);
                    };
                };
            };
            return (false);
        }

        public function update(_arg_1:Notifier, _arg_2:String, _arg_3:Object):void
        {
            this.check();
        }

        override public function dispose():void
        {
            (para as cGeneralInterface).channels.TICK.removePropertyObserver(TickChannel.DELAYED_COMPUTE_TICK, this);
            super.dispose();
        }


    }
}
