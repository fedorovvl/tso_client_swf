package Trigger.Triggers
{
    import Trigger.InstantTrigger;
    import Model.Observer;
    import Interface.cGeneralInterface;
    import Model.Notifiers.ZoneChannel;
    import Trigger.Triggerable;
    import Communication.VO.TriggerVO;
    import Enums.FILTER;
    import Model.Notifier;

    public class FilterActiveTrigger extends InstantTrigger implements Observer 
    {

        public function FilterActiveTrigger(_arg_1:Triggerable, _arg_2:TriggerVO, _arg_3:Object)
        {
            super(_arg_1, _arg_2, _arg_3);
            _arg_2.min = (_arg_2.max = 1);
            (_arg_3 as cGeneralInterface).channels.ZONE.addPropertyObserver(ZoneChannel.FILTER_APPLIED, this);
        }

        override public function check():Boolean
        {
            if ((para as cGeneralInterface).mCurrentPlayerZone.filter == FILTER.toInt(definition.type_string))
            {
                trigger();
                return (true);
            };
            return (false);
        }

        public function update(_arg_1:Notifier, _arg_2:String, _arg_3:Object):void
        {
            if (_arg_3 == definition.type_string)
            {
                trigger();
            };
        }

        override public function dispose():void
        {
            (para as cGeneralInterface).channels.ZONE.removePropertyObserver(ZoneChannel.FILTER_APPLIED, this);
            super.dispose();
        }


    }
}
