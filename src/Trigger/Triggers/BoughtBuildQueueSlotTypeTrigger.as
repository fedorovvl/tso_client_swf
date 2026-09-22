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

    public class BoughtBuildQueueSlotTypeTrigger extends DeltaTrigger implements Observer 
    {

        public function BoughtBuildQueueSlotTypeTrigger(_arg_1:TriggerDeltaValue, _arg_2:Triggerable, _arg_3:TriggerVO, _arg_4:cGeneralInterface)
        {
            super(_arg_1, _arg_2, _arg_3, _arg_4);
            _arg_4.channels.TRADE.addPropertyObserver(TriggerUtils.TRADE_QUEUE_SLOT_PROPERTY_NAME, this);
            if (_arg_3.typeContains(TriggerUtils.TRADE_QUEUE_SLOT_PERMANENT_TYPE_NAME))
            {
                if (_arg_4.mCurrentPlayer.GetPermanentBuildQueueSlotsCount() > getCurrentAmount())
                {
                    getDelta().add((_arg_4.mCurrentPlayer.GetPermanentBuildQueueSlotsCount() - getCurrentAmount()));
                };
            };
        }

        override public function check():Boolean
        {
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
            var _local_4:String = (_arg_3 as String);
            if (_arg_2 == TriggerUtils.TRADE_QUEUE_SLOT_PROPERTY_NAME)
            {
                if (definition.typeContains(_local_4))
                {
                    getDelta().add(1);
                    sendTriggerValueUpdated();
                    this.check();
                };
            };
        }

        override public function dispose():void
        {
            (para as cGeneralInterface).channels.TRADE.removePropertyObserver(TriggerUtils.TRADE_QUEUE_SLOT_PROPERTY_NAME, this);
            super.dispose();
        }


    }
}
