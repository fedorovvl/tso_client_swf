package Trigger.Triggers
{
    import Trigger.InstantTrigger;
    import Model.Observer;
    import Interface.cGeneralInterface;
    import Model.Notifiers.CalendarChannel;
    import Model.Notifiers.ZoneChannel;
    import Trigger.Triggerable;
    import Communication.VO.TriggerVO;
    import Communication.VO.dAdventCalendarDoorVO;
    import Model.Notifier;

    public class CalendarDoorOpenedTrigger extends InstantTrigger implements Observer 
    {

        private var gi:cGeneralInterface;

        public function CalendarDoorOpenedTrigger(_arg_1:Triggerable, _arg_2:TriggerVO, _arg_3:cGeneralInterface)
        {
            super(_arg_1, _arg_2, _arg_3);
            this.gi = _arg_3;
            _arg_2.max = (_arg_2.min = 1);
            this.gi.channels.CALENDAR.addPropertyObserver(CalendarChannel.DOOR_OPENED, this);
            this.gi.channels.CALENDAR.addPropertyObserver(CalendarChannel.CALENDAR_LOADED, this);
            this.gi.channels.ZONE.addPropertyObserver(ZoneChannel.ZONE_REFRESHED, this);
        }

        override public function check():Boolean
        {
            var _local_1:dAdventCalendarDoorVO = this.gi.mAdventCalendarManager.GetDoorById(definition.item_string);
            if (((!(_local_1 == null)) && (_local_1.isOpened())))
            {
                trigger();
                return (true);
            };
            return (false);
        }

        public function update(_arg_1:Notifier, _arg_2:String, _arg_3:Object):void
        {
            this.check();
        }

        override public function dispose():void
        {
            this.gi.channels.CALENDAR.removePropertyObserver(CalendarChannel.DOOR_OPENED, this);
            this.gi.channels.CALENDAR.removePropertyObserver(CalendarChannel.CALENDAR_LOADED, this);
            this.gi.channels.ZONE.removePropertyObserver(ZoneChannel.ZONE_REFRESHED, this);
            super.dispose();
        }


    }
}
