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
    import Model.Notifiers.BuffAppliedNotification;
    import BuffSystem.cBuffDefinition;
    import Collections.CollectionsConsts;
    import Model.Notifier;
    import Model.Notifiers.Channel;

    public class BuffAppliedOnFriendTrigger extends DeltaTrigger implements Observer 
    {

        private var checkBuff:Boolean = false;
        private var playerID:int;

        public function BuffAppliedOnFriendTrigger(_arg_1:TriggerDeltaValue, _arg_2:Triggerable, _arg_3:TriggerVO, _arg_4:cGeneralInterface)
        {
            super(_arg_1, _arg_2, _arg_3, _arg_4.channels.BUFF);
            this.playerID = _arg_4.mCurrentPlayer.GetPlayerId();
            if (_arg_3.amount == 0)
            {
                _arg_3.amount = 1;
            };
            this.checkBuff = (!(StringUtils.isEmpty(_arg_3.item_string)));
            _arg_4.channels.BUFF.addPropertyObserver(TriggerUtils.BUFF_APPLIED_ON_FRIEND_PROPERTY_NAME, this);
        }

        public function update(_arg_1:Notifier, _arg_2:String, _arg_3:Object):void
        {
            var _local_4:BuffAppliedNotification;
            var _local_5:cBuffDefinition;
            var _local_6:Boolean;
            var _local_7:String;
            if (((_arg_2 == TriggerUtils.BUFF_APPLIED_ON_FRIEND_PROPERTY_NAME) && (!((_arg_3 as BuffAppliedNotification).buff.GetBuffDefinition().GetName_string() == CollectionsConsts.REVEAL_FRIENDS_COLLECTIBLES_BUFF))))
            {
                _local_4 = (_arg_3 as BuffAppliedNotification);
                if (this.playerID != _local_4.buffTargetOwnerID)
                {
                    _local_5 = _local_4.buff.GetBuffDefinition();
                    _local_6 = true;
                    if (this.checkBuff)
                    {
                        for each (_local_7 in definition.item_string.split(","))
                        {
                            _local_6 = (_local_5.GetName_string() == _local_7);
                            if (_local_6) break;
                        };
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

        override public function dispose():void
        {
            (para as Channel).removePropertyObserver(TriggerUtils.BUFF_APPLIED_ON_FRIEND_PROPERTY_NAME, this);
            super.dispose();
        }

        override public function check():Boolean
        {
            updateCurrentAmount();
            var _local_1:Number = getCurrentAmount();
            if (_local_1 >= definition.amount)
            {
                trigger();
                return (true);
            };
            return (false);
        }


    }
}
