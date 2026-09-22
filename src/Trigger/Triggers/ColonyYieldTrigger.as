package Trigger.Triggers
{
    import Trigger.DeltaTrigger;
    import Model.Observer;
    import Utils.TriggerUtils;
    import Trigger.TriggerDeltaValue;
    import Trigger.Triggerable;
    import Communication.VO.TriggerVO;
    import Interface.cGeneralInterface;
    import Communication.VO.dPickupItemVO;
    import Enums.PICKUP_PROVIDER_TYPE;
    import Model.Notifier;
    import Interface.cGameInterface;

    public class ColonyYieldTrigger extends DeltaTrigger implements Observer 
    {

        public function ColonyYieldTrigger(_arg_1:TriggerDeltaValue, _arg_2:Triggerable, _arg_3:TriggerVO, _arg_4:cGeneralInterface)
        {
            super(_arg_1, _arg_2, _arg_3, _arg_4);
            _arg_4.pickupManager.addPropertyObserver(TriggerUtils.RESOURCE_MANAGER_ADD_RESOURCE_NAME, this);
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
            var _local_4:dPickupItemVO = (_arg_3 as dPickupItemVO);
            if ((((_local_4.providerType == PICKUP_PROVIDER_TYPE.PVP_COLONY) && (_local_4.item_string == definition.item_string)) && (_local_4.amount > 0)))
            {
                getDelta().add(_local_4.amount);
                sendTriggerValueUpdated();
                this.check();
            };
        }

        override public function dispose():void
        {
            (para as cGameInterface).pickupManager.removePropertyObserver(TriggerUtils.RESOURCE_MANAGER_ADD_RESOURCE_NAME, this);
            super.dispose();
        }


    }
}
