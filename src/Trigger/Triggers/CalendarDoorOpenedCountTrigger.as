package Trigger.Triggers
{
    import Trigger.DeltaTrigger;
    import Model.Observer;
    import Interface.cGeneralInterface;
    import Model.Notifiers.CalendarChannel;
    import Model.Notifiers.ZoneChannel;
    import Trigger.TriggerDeltaValue;
    import Trigger.Triggerable;
    import Communication.VO.TriggerVO;
    import Model.Notifier;

    public class CalendarDoorOpenedCountTrigger extends DeltaTrigger implements Observer 
    {

        private var gi:cGeneralInterface;

        public function CalendarDoorOpenedCountTrigger(_arg_1:TriggerDeltaValue, _arg_2:Triggerable, _arg_3:TriggerVO, _arg_4:cGeneralInterface)
        {
            super(_arg_1, _arg_2, _arg_3, _arg_4);
            this.gi = _arg_4;
            this.gi.channels.CALENDAR.addPropertyObserver(CalendarChannel.DOOR_OPENED, this);
            this.gi.channels.ZONE.addPropertyObserver(ZoneChannel.ZONE_REFRESHED, this);
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

        public function update(_arg_1:Notifier, _arg_2:String, _arg_3:Object):void
        {
            getDelta().setValue(this.gi.mAdventCalendarManager.GetOpenDoorCount());
            sendTriggerValueUpdated();
            this.check();
        }

        override public function dispose():void
        {
            this.gi.channels.CALENDAR.removePropertyObserver(CalendarChannel.DOOR_OPENED, this);
            this.gi.channels.ZONE.removePropertyObserver(ZoneChannel.ZONE_REFRESHED, this);
            super.dispose();
        }


    }
}
