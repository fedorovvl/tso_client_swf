package Trigger.Triggers
{
    import Trigger.DeltaTrigger;
    import Model.Observer;
    import Utils.StringUtils;
    import Utils.TriggerUtils;
    import Trigger.TriggerDeltaValue;
    import Trigger.Triggerable;
    import Communication.VO.TriggerVO;
    import Interface.cGeneralInterface;
    import Model.Notifiers.Channel;
    import TimedProduction.iProductionOrder;
    import TimedProduction.cTimedProduction;
    import Communication.VO.collectibles.CollectionVO;
    import Model.Notifier;

    public class ProducedItemListTrigger extends DeltaTrigger implements Observer 
    {

        private var itemList:Array;

        public function ProducedItemListTrigger(_arg_1:TriggerDeltaValue, _arg_2:Triggerable, _arg_3:TriggerVO, _arg_4:cGeneralInterface)
        {
            super(_arg_1, _arg_2, _arg_3, _arg_4.channels.TIMED_PRODUCTION);
            this.itemList = StringUtils.split(_arg_3.item_string, ",");
            _arg_4.channels.TIMED_PRODUCTION.addPropertyObserver(TriggerUtils.TIMED_PRODUCED_ITEMS_PROPERTY_NAME, this);
            _arg_4.channels.TIMED_PRODUCTION.addPropertyObserver(TriggerUtils.COLLECTION_BOUGHT_PROPERTY_NAME, this);
        }

        override public function dispose():void
        {
            (para as Channel).removePropertyObserver(TriggerUtils.TIMED_PRODUCED_ITEMS_PROPERTY_NAME, this);
            (para as Channel).removePropertyObserver(TriggerUtils.COLLECTION_BOUGHT_PROPERTY_NAME, this);
            super.dispose();
        }

        override public function check():Boolean
        {
            if (getCurrentAmount() >= definition.amount)
            {
                trigger();
                return (true);
            };
            return (false);
        }

        public function update(_arg_1:Notifier, _arg_2:String, _arg_3:Object):void
        {
            var _local_6:iProductionOrder;
            var _local_4:* = "";
            var _local_5:int;
            if (_arg_2 == TriggerUtils.TIMED_PRODUCED_ITEMS_PROPERTY_NAME)
            {
                _local_6 = (_arg_3 as cTimedProduction).GetProductionOrder();
                _local_4 = _local_6.GetResourceName();
                _local_5 = _local_6.GetResourceAmount();
            }
            else
            {
                if (_arg_2 == TriggerUtils.COLLECTION_BOUGHT_PROPERTY_NAME)
                {
                    _local_4 = (_arg_3 as CollectionVO).getName();
                    _local_5 = 1;
                };
            };
            if (_local_5 > 0)
            {
                if (this.itemList.length > 0)
                {
                    if (TriggerUtils.contains(this.itemList, _local_4))
                    {
                        getDelta().add(_local_5);
                        sendTriggerValueUpdated();
                        this.check();
                    };
                }
                else
                {
                    getDelta().add(_local_5);
                    sendTriggerValueUpdated();
                    this.check();
                };
            };
        }


    }
}
