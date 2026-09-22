package Trigger.Triggers
{
    import Trigger.DeltaTrigger;
    import Model.Observer;
    import Utils.StringUtils;
    import BuffSystem.cBuff;
    import Trigger.TriggerDeltaValue;
    import Trigger.Triggerable;
    import Communication.VO.TriggerVO;
    import Interface.cGeneralInterface;
    import Model.Notifiers.Channel;
    import Model.Notifiers.BuffProducedNotification;
    import Model.Notifier;

    public final class BuffProducedTrigger extends DeltaTrigger implements Observer 
    {

        private var checkGroup:Boolean = false;
        private var checkBuff:Boolean = false;

        public function BuffProducedTrigger(_arg_1:TriggerDeltaValue, _arg_2:Triggerable, _arg_3:TriggerVO, _arg_4:cGeneralInterface)
        {
            super(_arg_1, _arg_2, _arg_3, _arg_4.channels.BUFF);
            if (_arg_3.min == 0)
            {
                _arg_3.min = 1;
            };
            if (_arg_3.max == 0)
            {
                _arg_3.max = 100100100;
            };
            this.checkBuff = (!(StringUtils.isEmpty(_arg_3.item_string)));
            this.checkGroup = (!(_arg_3.isTypeEmpty()));
            _arg_4.channels.BUFF.addPropertyObserver(cBuff.BUFF_PRODUCED_string, this);
            _arg_4.channels.BUFF.addPropertyObserver(cBuff.COLLECTION_PRODUCED_string, this);
        }

        override public function dispose():void
        {
            (para as Channel).removePropertyObserver(cBuff.COLLECTION_PRODUCED_string, this);
            (para as Channel).removePropertyObserver(cBuff.BUFF_PRODUCED_string, this);
            super.dispose();
        }

        override public function check():Boolean
        {
            var _local_1:Number = getDelta().getValue();
            if (((_local_1 <= definition.max) && (_local_1 >= definition.min)))
            {
                trigger();
                return (true);
            };
            return (false);
        }

        public function update(_arg_1:Notifier, _arg_2:String, _arg_3:Object):void
        {
            var _local_4:BuffProducedNotification;
            var _local_5:String;
            var _local_6:Boolean;
            if ((((_arg_2 == cBuff.BUFF_PRODUCED_string) || (_arg_2 == cBuff.COLLECTION_PRODUCED_string)) && (_arg_3 is BuffProducedNotification)))
            {
                _local_4 = (_arg_3 as BuffProducedNotification);
                if (((_local_4.definition.IsProducible()) || (_arg_2 == cBuff.COLLECTION_PRODUCED_string)))
                {
                    _local_5 = _local_4.definition.GetName_string();
                    _local_6 = true;
                    if (this.checkBuff)
                    {
                        _local_6 = (definition.item_string == _local_5);
                    };
                    if (this.checkGroup)
                    {
                        _local_6 = ((_local_6) && (definition.typeContains(_local_4.definition.GetGroup_string())));
                    };
                    if (_local_6)
                    {
                        getDelta().add(_local_4.amount);
                        sendTriggerValueUpdated();
                        this.check();
                    };
                };
            };
        }


    }
}
