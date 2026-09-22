package Trigger.Triggers
{
    import Trigger.InstantTrigger;
    import Model.Observer;
    import Model.Notifiers.ZoneChannel;
    import Trigger.Triggerable;
    import Communication.VO.TriggerVO;
    import Interface.cGeneralInterface;
    import Model.Notifier;
    import Map.cSector;
    import Utils.HashSetWrapper;
    import nLib.gMisc;

    public final class SectorLiberatedTrigger extends InstantTrigger implements Observer 
    {

        public function SectorLiberatedTrigger(_arg_1:Triggerable, _arg_2:TriggerVO, _arg_3:cGeneralInterface)
        {
            super(_arg_1, _arg_2, _arg_3);
            if (_arg_2.min == 0)
            {
                _arg_2.min = 1;
            };
            if (_arg_2.max == 0)
            {
                _arg_2.max = 100100100;
            };
            _arg_3.channels.ZONE.addPropertyObserver(ZoneChannel.SECTOR_LIBERATED, this);
        }

        override public function dispose():void
        {
            (para as cGeneralInterface).channels.ZONE.removePropertyObserver(ZoneChannel.SECTOR_LIBERATED, this);
            super.dispose();
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
            this.check();
        }

        override protected function computeCurrentAmount():Number
        {
            var _local_4:cSector;
            var _local_5:String;
            var _local_1:int;
            var _local_2:HashSetWrapper = new HashSetWrapper();
            if (definition.id != -1)
            {
                _local_2.add(definition.id);
            }
            else
            {
                if (definition.id_vector != null)
                {
                    for each (_local_5 in definition.id_vector)
                    {
                        _local_2.add(gMisc.ParseInt(_local_5));
                    };
                }
                else
                {
                    _local_2 = null;
                };
            };
            var _local_3:cGeneralInterface = (para as cGeneralInterface);
            for each (_local_4 in _local_3.mCurrentPlayerZone.mSectorList_vector)
            {
                if (((_local_2 == null) || (_local_2.contains(_local_4.GetSectorID()))))
                {
                    if (_local_4.GetOwnerPlayerID() >= 0)
                    {
                        _local_1++;
                    };
                };
            };
            return (_local_1);
        }


    }
}
