package Trigger.Triggers
{
    import Trigger.DeltaTrigger;
    import Model.Observer;
    import Interface.cGeneralInterface;
    import Model.Notifiers.ResourceChannel;
    import Trigger.TriggerDeltaValue;
    import Trigger.Triggerable;
    import Communication.VO.TriggerVO;
    import Utils.StringUtils;
    import Model.Notifier;

    public class RefillDepositsTrigger extends DeltaTrigger implements Observer 
    {

        private var gi:cGeneralInterface;

        public function RefillDepositsTrigger(_arg_1:TriggerDeltaValue, _arg_2:Triggerable, _arg_3:TriggerVO, _arg_4:cGeneralInterface)
        {
            super(_arg_1, _arg_2, _arg_3, null);
            this.gi = _arg_4;
            _arg_4.channels.RESOURCE.addPropertyObserver(ResourceChannel.DEPOSIT_CHANGED_AMOUNT_string, this);
        }

        override public function dispose():void
        {
            this.gi.channels.RESOURCE.removePropertyObserver(ResourceChannel.DEPOSIT_CHANGED_AMOUNT_string, this);
            super.dispose();
        }

        override public function check():Boolean
        {
            if (getDelta().getValue() >= definition.amount)
            {
                trigger();
                return (true);
            };
            return (false);
        }

        public function update(_arg_1:Notifier, _arg_2:String, _arg_3:Object):void
        {
            var _local_4:String = (_arg_3[0] as String);
            var _local_5:int = (_arg_3[1] as int);
            if (((_local_5 > 0) && (StringUtils.equalsIgnoreCase(_local_4, definition.item_string))))
            {
                getDelta().add(_local_5);
                sendTriggerValueUpdated();
                this.check();
            };
        }


    }
}
