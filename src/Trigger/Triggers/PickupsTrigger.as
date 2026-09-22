package Trigger.Triggers
{
    import Trigger.InstantTrigger;
    import Model.Observer;
    import Model.Notifiers.ZoneChannel;
    import Trigger.Triggerable;
    import Communication.VO.TriggerVO;
    import Interface.cGeneralInterface;
    import Model.Notifier;

    public final class PickupsTrigger extends InstantTrigger implements Observer 
    {

        public function PickupsTrigger(_arg_1:Triggerable, _arg_2:TriggerVO, _arg_3:cGeneralInterface)
        {
            super(_arg_1, _arg_2, _arg_3);
            _arg_3.channels.ZONE.addPropertyObserver(ZoneChannel.COLLECTIBLES_UPDATED, this);
        }

        override public function check():Boolean
        {
            updateCurrentAmount();
            var _local_1:Number = getCurrentAmount();
            if (_local_1 >= definition.min)
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
            return ((para as cGeneralInterface).mCurrentPlayerZone.mStreetDataMap.getInitialNbOfPickups(definition.id));
        }

        override public function dispose():void
        {
            if (para != null)
            {
                (para as cGeneralInterface).channels.ZONE.removePropertyObserver(ZoneChannel.COLLECTIBLES_UPDATED, this);
            };
            super.dispose();
        }


    }
}
