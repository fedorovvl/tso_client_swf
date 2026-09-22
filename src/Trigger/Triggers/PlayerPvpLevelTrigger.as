package Trigger.Triggers
{
    import Trigger.InstantTrigger;
    import Model.Observer;
    import ServerState.cPlayerData;
    import Trigger.Triggerable;
    import Communication.VO.TriggerVO;
    import Interface.cGeneralInterface;
    import Model.Notifier;

    public class PlayerPvpLevelTrigger extends InstantTrigger implements Observer 
    {

        public function PlayerPvpLevelTrigger(_arg_1:Triggerable, _arg_2:TriggerVO, _arg_3:cGeneralInterface)
        {
            super(_arg_1, _arg_2, _arg_3);
            if (_arg_2.min == 0)
            {
                _arg_2.min = 1;
            };
            if (_arg_2.max == 0)
            {
                _arg_2.max = 100100100;
            };
            _arg_3.mCurrentPlayer.addPropertyObserver(cPlayerData.PLAYER_PVP_LEVEL_CHANGED, this);
        }

        public function update(_arg_1:Notifier, _arg_2:String, _arg_3:Object):void
        {
            this.check();
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

        override protected function computeCurrentAmount():Number
        {
            return ((para as cGeneralInterface).mCurrentPlayer.GetPlayerPvPLevel());
        }

        override public function dispose():void
        {
            (para as cGeneralInterface).mCurrentPlayer.removePropertyObserver(cPlayerData.PLAYER_PVP_LEVEL_CHANGED, this);
            super.dispose();
        }


    }
}
