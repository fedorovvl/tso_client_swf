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
    import Communication.VO.dResourceVO;
    import Model.Notifier;

    public class BoughtGoodsTrigger extends DeltaTrigger implements Observer 
    {

        private var mGoodsType:Array;

        public function BoughtGoodsTrigger(_arg_1:TriggerDeltaValue, _arg_2:Triggerable, _arg_3:TriggerVO, _arg_4:cGeneralInterface)
        {
            super(_arg_1, _arg_2, _arg_3, _arg_4);
            this.mGoodsType = StringUtils.split(_arg_3.item_string, StringUtils.COMMA);
            _arg_4.channels.TRADE.addPropertyObserver(TriggerUtils.BOUGHT_SUCCESSFUL_PROPERTY_NAME, this);
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
            var _local_4:dResourceVO = (_arg_3 as dResourceVO);
            if (_arg_2 == TriggerUtils.BOUGHT_SUCCESSFUL_PROPERTY_NAME)
            {
                if (((definition.item_string == "") || (TriggerUtils.contains(this.mGoodsType, _local_4.name_string))))
                {
                    getDelta().add(_local_4.amount);
                    sendTriggerValueUpdated();
                    this.check();
                };
            };
        }

        override public function dispose():void
        {
            (para as cGeneralInterface).channels.TRADE.removePropertyObserver(TriggerUtils.BOUGHT_SUCCESSFUL_PROPERTY_NAME, this);
            super.dispose();
        }


    }
}
