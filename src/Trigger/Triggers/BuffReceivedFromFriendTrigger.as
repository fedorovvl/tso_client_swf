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
    import GO.cBuilding;
    import Collections.CollectionsConsts;
    import Model.Notifier;
    import Model.Notifiers.Channel;

    public class BuffReceivedFromFriendTrigger extends DeltaTrigger implements Observer 
    {

        private var checkBuff:Boolean = false;
        private var checkBuilding:Boolean = false;

        public function BuffReceivedFromFriendTrigger(_arg_1:TriggerDeltaValue, _arg_2:Triggerable, _arg_3:TriggerVO, _arg_4:cGeneralInterface)
        {
            super(_arg_1, _arg_2, _arg_3, _arg_4.channels.BUFF);
            this.checkBuff = (!(StringUtils.isEmpty(_arg_3.item_string)));
            this.checkBuilding = (!(StringUtils.isEmpty(_arg_3.target_string)));
            _arg_4.channels.BUFF.addPropertyObserver(TriggerUtils.BUFF_RECEIVED_FROM_FRIEND_PROPERTY_NAME, this);
        }

        private function isBuildingValid(_arg_1:String):Boolean
        {
            var _local_2:String;
            if (StringUtils.isEmpty(_arg_1))
            {
                return (false);
            };
            for each (_local_2 in StringUtils.split(definition.target_string, ","))
            {
                if (StringUtils.equalsIgnoreCase(_local_2, _arg_1))
                {
                    return (true);
                };
            };
            return (false);
        }

        public function update(_arg_1:Notifier, _arg_2:String, _arg_3:Object):void
        {
            var _local_4:BuffAppliedNotification = (_arg_3 as BuffAppliedNotification);
            var _local_5:String = _local_4.buff.GetBuffDefinition().GetName_string();
            var _local_6:* = "";
            if (((this.checkBuilding) && (_local_4.target is cBuilding)))
            {
                _local_6 = (_local_4.target as cBuilding).GetBuildingName_string();
            };
            if (((((_arg_2 == TriggerUtils.BUFF_RECEIVED_FROM_FRIEND_PROPERTY_NAME) && (!(_local_5 == CollectionsConsts.REVEAL_FRIENDS_COLLECTIBLES_BUFF))) && ((!(this.checkBuff)) || (StringUtils.contains(_local_5, definition.item_string)))) && ((!(this.checkBuilding)) || (this.isBuildingValid(_local_6)))))
            {
                getDelta().add(_local_4.amount);
                sendTriggerValueUpdated();
                this.check();
            };
        }

        override public function dispose():void
        {
            (para as Channel).removePropertyObserver(TriggerUtils.BUFF_RECEIVED_FROM_FRIEND_PROPERTY_NAME, this);
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
