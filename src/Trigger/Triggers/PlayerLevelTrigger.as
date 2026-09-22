package Trigger.Triggers
{
    import Trigger.InstantTrigger;
    import Model.Observer;
    import Interface.cGeneralInterface;
    import ServerState.cPlayerData;
    import Trigger.Triggerable;
    import Communication.VO.TriggerVO;
    import Model.Notifier;

    public final class PlayerLevelTrigger extends InstantTrigger implements Observer 
    {

        private var gi:cGeneralInterface;

        public function PlayerLevelTrigger(_arg_1:Triggerable, _arg_2:TriggerVO, _arg_3:cGeneralInterface)
        {
            super(_arg_1, _arg_2, _arg_3.mCurrentPlayer);
            this.gi = _arg_3;
            if (_arg_2.min == 0)
            {
                _arg_2.min = 1;
            };
            if (_arg_2.max == 0)
            {
                _arg_2.max = 100100100;
            };
            _arg_3.mCurrentPlayer.addPropertyObserver(cPlayerData.PLAYER_LEVEL_CHANGED, this);
        }

        override public function dispose():void
        {
            (para as cPlayerData).removePropertyObserver("mPlayerLevel", this);
            super.dispose();
        }

        override public function check():Boolean
        {
            updateCurrentAmount();
            var _local_1:Number = getCurrentAmount();
            if (((_local_1 >= definition.min) && (_local_1 <= definition.max)))
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
            var _local_1:cPlayerData = (para as cPlayerData);
            if (!this.gi.IsAdventureZoneID(_local_1.GetPlayerId()))
            {
                return (_local_1.GetPlayerLevel());
            };
            for each (_local_2 in this.gi.GetPlayerList_vector())
            {
                if (_local_2.GetPlayerId() != _local_1.GetPlayerId())
                {
                    return (_local_2.GetPlayerLevelHomeZone());
                };
            };
            return (1);
        }


    }
}
