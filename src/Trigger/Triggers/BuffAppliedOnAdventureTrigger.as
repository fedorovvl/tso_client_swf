package Trigger.Triggers
{
    import Trigger.DeltaTrigger;
    import Model.Observer;
    import Utils.StringUtils;
    import Enums.TRIGGER_ACTION;
    import Trigger.TriggerDeltaValue;
    import Trigger.Triggerable;
    import Communication.VO.TriggerVO;
    import Interface.cGeneralInterface;
    import Model.Notifiers.BuffAppliedNotification;
    import BuffSystem.cBuffDefinition;
    import GO.cBuilding;
    import Model.Notifier;
    import Model.Notifiers.Channel;

    public class BuffAppliedOnAdventureTrigger extends DeltaTrigger implements Observer 
    {

        private var checkBuilding:Boolean = false;
        private var checkBuff:Boolean = false;
        private var playerID:int;

        public function BuffAppliedOnAdventureTrigger(_arg_1:TriggerDeltaValue, _arg_2:Triggerable, _arg_3:TriggerVO, _arg_4:cGeneralInterface)
        {
            super(_arg_1, _arg_2, _arg_3, _arg_4.channels.BUFF);
            this.playerID = _arg_4.mCurrentPlayer.GetPlayerId();
            if (_arg_3.min == 0)
            {
                _arg_3.min = 1;
            };
            if (_arg_3.max == 0)
            {
                _arg_3.max = defines.MAX_INT_VALUE;
            };
            this.checkBuff = (!(StringUtils.isEmpty(_arg_3.item_string)));
            this.checkBuilding = (!(StringUtils.isEmpty(_arg_3.target_string)));
            _arg_4.channels.BUFF.addPropertyObserver(TRIGGER_ACTION.ACTION_BUFF_APPLIED_ON_ADVENTURE_string, this);
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
            var _local_4:BuffAppliedNotification;
            var _local_5:String;
            var _local_6:cBuffDefinition;
            var _local_7:Boolean;
            var _local_8:Boolean;
            var _local_9:String;
            if (_arg_2 == TRIGGER_ACTION.ACTION_BUFF_APPLIED_ON_ADVENTURE_string)
            {
                _local_4 = (_arg_3 as BuffAppliedNotification);
                _local_5 = "";
                if (this.playerID != _local_4.buffTargetOwnerID)
                {
                    _local_6 = _local_4.buff.GetBuffDefinition();
                    _local_7 = true;
                    _local_8 = false;
                    if (this.checkBuff)
                    {
                        for each (_local_9 in definition.item_string.split(","))
                        {
                            _local_8 = (_local_6.GetName_string() == _local_9);
                            if (_local_8) break;
                        };
                    };
                    if ((_local_4.target is cBuilding))
                    {
                        _local_5 = (_local_4.target as cBuilding).GetBuildingName_string();
                    };
                    if (((this.checkBuff) && (this.checkBuilding)))
                    {
                        _local_7 = ((_local_8) && (_local_5 == definition.target_string));
                    }
                    else
                    {
                        if (this.checkBuilding)
                        {
                            _local_7 = (_local_5 == definition.target_string);
                        }
                        else
                        {
                            _local_7 = _local_8;
                        };
                    };
                    if (_local_7)
                    {
                        getDelta().add(_local_4.amount);
                        sendTriggerValueUpdated();
                        this.check();
                    };
                };
            };
        }

        override public function dispose():void
        {
            (para as Channel).removePropertyObserver(TRIGGER_ACTION.ACTION_BUFF_APPLIED_ON_ADVENTURE_string, this);
            super.dispose();
        }


    }
}
