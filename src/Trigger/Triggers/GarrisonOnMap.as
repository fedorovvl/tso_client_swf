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

    public final class GarrisonOnMap extends InstantTrigger implements Observer 
    {

        public function GarrisonOnMap(_arg_1:Triggerable, _arg_2:TriggerVO, _arg_3:cGeneralInterface)
        {
            super(_arg_1, _arg_2, _arg_3);
            if (((_arg_2.min == 0) && (_arg_2.max == 0)))
            {
                _arg_2.min = 1;
            };
            if (((_arg_2.min > 0) && (_arg_2.max == 0)))
            {
                _arg_2.max = 100100100;
            };
            _arg_3.channels.ZONE.addPropertyObserver(TriggerUtils.ON_MAP_NOTIFICATION_PROPERTY_NAME, this);
        }

        override public function check():Boolean
        {
            updateCurrentAmount();
            var _local_1:Number = getCurrentAmount();
            if (((_local_1 >= definition.min) && (_local_1 <= definition.max)))
            {
                trigger();
                return (true);
            };
            return (false);
        }

        public function update(_arg_1:Notifier, _arg_2:String, _arg_3:Object):void
        {
            var _local_4:String = (_arg_3 as String);
            if (_local_4.indexOf("Garrison") > -1)
            {
                this.check();
            };
        }

        override protected function computeCurrentAmount():Number
        {
            var _local_2:cSpecialist;
            var _local_1:int;
            for each (_local_2 in (para as cGeneralInterface).mCurrentPlayerZone.GetSpecialists_vector())
            {
                if (_local_2.GetGarrisonGridIdx() > -1)
                {
                    _local_1++;
                };
            };
            return (_local_1);
        }

        override public function dispose():void
        {
            (para as cGeneralInterface).channels.ZONE.removePropertyObserver(TriggerUtils.ON_MAP_NOTIFICATION_PROPERTY_NAME, this);
            super.dispose();
        }


    }
}
