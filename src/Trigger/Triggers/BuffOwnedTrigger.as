package Trigger.Triggers
{
    import Trigger.InstantTrigger;
    import Model.Observer;
    import Interface.cGeneralInterface;
    import Utils.TriggerUtils;
    import Trigger.Triggerable;
    import Communication.VO.TriggerVO;
    import ServerState.cPlayerData;
    import Model.Notifier;
    import BuffSystem.cBuff;

    public final class BuffOwnedTrigger extends InstantTrigger implements Observer 
    {

        private var gi:cGeneralInterface;

        public function BuffOwnedTrigger(_arg_1:Triggerable, _arg_2:TriggerVO, _arg_3:cGeneralInterface)
        {
            super(_arg_1, _arg_2, _arg_3.mCurrentPlayer);
            if (_arg_2.min == 0)
            {
                _arg_2.min = 1;
            };
            if (_arg_2.max == 0)
            {
                _arg_2.max = 100100100;
            };
            this.gi = _arg_3;
            if (_arg_3.IsAdventureZone())
            {
                _arg_3.channels.ZONE.addPropertyObserver(TriggerUtils.ZONE_VISITOR, this);
            }
            else
            {
                _arg_3.mCurrentPlayer.addPropertyObserver("mAvailableBuffs_vector", this);
            };
        }

        override public function dispose():void
        {
            if (this.gi.IsAdventureZone())
            {
                this.gi.channels.ZONE.removePropertyObserver(TriggerUtils.ZONE_VISITOR, this);
            }
            else
            {
                (para as cPlayerData).removePropertyObserver("mAvailableBuffs_vector", this);
            };
            super.dispose();
        }

        override public function check():Boolean
        {
            updateCurrentAmount();
            var _local_1:Number = getCurrentAmount();
            if (((_local_1 <= definition.max) && (_local_1 >= definition.min)))
            {
                trigger();
                return (true);
            };
            return (false);
        }

        public function update(_arg_1:Notifier, _arg_2:String, _arg_3:Object):void
        {
            this.check();
        }

        override protected function computeCurrentAmount():Number
        {
            var _local_2:cPlayerData;
            var _local_3:int;
            var _local_4:int;
            var _local_5:cBuff;
            var _local_6:String;
            var _local_1:int;
            for each (_local_2 in this.gi.GetPlayerList_vector())
            {
                _local_3 = 0;
                _local_4 = 0;
                while (_local_4 < _local_2.getAvailableBuffs_vector().length)
                {
                    _local_5 = _local_2.getAvailableBuffs_vector()[_local_4];
                    _local_6 = _local_5.GetBuffDefinition().GetName_string();
                    if (definition.item_string == _local_6)
                    {
                        _local_3 = (_local_3 + _local_5.GetAmount());
                    };
                    _local_4++;
                };
                _local_1 = Math.max(_local_1, _local_3);
            };
            return (_local_1);
        }


    }
}
