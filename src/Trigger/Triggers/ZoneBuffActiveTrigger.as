package Trigger.Triggers
{
    import Trigger.InstantTrigger;
    import Model.Observer;
    import ZoneBuff.ZoneBuffManager;
    import Trigger.Triggerable;
    import Communication.VO.TriggerVO;
    import Interface.cGeneralInterface;
    import Model.Notifier;

    public class ZoneBuffActiveTrigger extends InstantTrigger implements Observer 
    {

        public function ZoneBuffActiveTrigger(_arg_1:Triggerable, _arg_2:TriggerVO, _arg_3:cGeneralInterface)
        {
            super(_arg_1, _arg_2, _arg_3);
            _arg_3.mZoneBuffManager.addPropertyObserver(ZoneBuffManager.PROPERTY_ZONE_BUFF_ADDED, this);
            _arg_3.mZoneBuffManager.addPropertyObserver(ZoneBuffManager.PROPERTY_ZONE_BUFF_REMOVED, this);
        }

        override public function dispose():void
        {
            (para as cGeneralInterface).mZoneBuffManager.removePropertyObserver(ZoneBuffManager.PROPERTY_ZONE_BUFF_ADDED, this);
            (para as cGeneralInterface).mZoneBuffManager.removePropertyObserver(ZoneBuffManager.PROPERTY_ZONE_BUFF_REMOVED, this);
            super.dispose();
        }

        override public function check():Boolean
        {
            updateCurrentAmount();
            var _local_1:Number = getCurrentAmount();
            if (_local_1 == definition.amount)
            {
                trigger();
                return (true);
            };
            return (false);
        }

        public function update(_arg_1:Notifier, _arg_2:String, _arg_3:Object):void
        {
            if (definition.name_string == _arg_3)
            {
                this.check();
            };
        }

        override protected function computeCurrentAmount():Number
        {
            return (((para as cGeneralInterface).mZoneBuffManager.isBuffRunning(definition.name_string)) ? 1 : 0);
        }


    }
}
