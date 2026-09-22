package Trigger.Triggers
{
    import Trigger.DeltaTrigger;
    import Model.Observer;
    import Interface.cGeneralInterface;
    import Utils.StringUtils;
    import BuffSystem.cBuff;
    import Trigger.TriggerDeltaValue;
    import Trigger.Triggerable;
    import Communication.VO.TriggerVO;
    import Model.Notifiers.BuffAppliedNotification;
    import BuffSystem.cBuffDefinition;
    import GO.cBuilding;
    import Model.Notifier;
    import Model.Notifiers.Channel;

    public final class BuffAppliedTrigger extends DeltaTrigger implements Observer 
    {

        private var generalInterface:cGeneralInterface;
        private var checkBuff:Boolean = false;
        private var checkBuilding:Boolean = false;
        private var checkResource:Boolean = false;

        public function BuffAppliedTrigger(_arg_1:TriggerDeltaValue, _arg_2:Triggerable, _arg_3:TriggerVO, _arg_4:cGeneralInterface)
        {
            super(_arg_1, _arg_2, _arg_3, _arg_4.channels.BUFF);
            this.generalInterface = _arg_4;
            if (_arg_3.min == 0)
            {
                _arg_3.min = 1;
            };
            if (_arg_3.max == 0)
            {
                _arg_3.max = 100100100;
            };
            this.checkBuff = (!(StringUtils.isEmpty(_arg_3.item_string)));
            this.checkBuilding = (!(StringUtils.isEmpty(_arg_3.target_string)));
            this.checkResource = (!(_arg_3.isTypeEmpty()));
            _arg_4.channels.BUFF.addPropertyObserver(cBuff.BUFF_APPLIED_string, this);
        }

        public function update(_arg_1:Notifier, _arg_2:String, _arg_3:Object):void
        {
            var _local_4:BuffAppliedNotification;
            var _local_5:cBuffDefinition;
            var _local_6:String;
            var _local_7:Boolean;
            var _local_8:Boolean;
            var _local_9:Boolean;
            var _local_10:int;
            var _local_11:String;
            var _local_12:String;
            if (_arg_2 == cBuff.BUFF_APPLIED_string)
            {
                _local_4 = (_arg_3 as BuffAppliedNotification);
                _local_5 = _local_4.buff.GetBuffDefinition();
                _local_6 = "";
                if (this.generalInterface.mHomePlayer.GetPlayerId() != _local_4.buffOwnerID)
                {
                    return;
                };
                if ((_local_4.target is cBuilding))
                {
                    _local_6 = (_local_4.target as cBuilding).GetBuildingName_string();
                };
                _local_7 = true;
                _local_8 = false;
                if (this.checkBuff)
                {
                    _local_10 = -1;
                    for each (_local_11 in definition.item_string.split(","))
                    {
                        _local_10 = _local_11.indexOf("*");
                        if (_local_10 < 0)
                        {
                            _local_8 = (_local_5.GetName_string() == _local_11);
                        }
                        else
                        {
                            if (_local_11.length == (_local_10 + 1))
                            {
                                _local_8 = (0 == int(_local_5.GetName_string().indexOf(_local_11.replace("*", ""))));
                            };
                        };
                        if (_local_8) break;
                    };
                };
                _local_9 = false;
                if (this.checkBuilding)
                {
                    for each (_local_12 in StringUtils.split(definition.target_string, ","))
                    {
                        if (StringUtils.equalsIgnoreCase(_local_6, _local_12))
                        {
                            _local_9 = true;
                            break;
                        };
                    };
                };
                _local_7 = (((!(this.checkBuff)) || (_local_8)) && ((!(this.checkBuilding)) || (_local_9)));
                if (((_local_7) && (this.checkResource)))
                {
                    _local_7 = StringUtils.equalsIgnoreCase(definition.type_string, _local_4.buff.GetResourceName_string());
                };
                if (_local_7)
                {
                    getDelta().add(_local_4.amount);
                    sendTriggerValueUpdated();
                    this.check();
                };
            };
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

        override public function dispose():void
        {
            (para as Channel).removePropertyObserver(cBuff.BUFF_APPLIED_string, this);
            super.dispose();
        }


    }
}
