package Trigger.Triggers
{
    import Trigger.InstantTrigger;
    import Model.Observer;
    import Utils.TriggerUtils;
    import Trigger.Triggerable;
    import Communication.VO.TriggerVO;
    import Interface.cGeneralInterface;
    import Model.Notifier;

    public class HaveFriendsTrigger extends InstantTrigger implements Observer 
    {

        private var currentPlayerID:int;

        public function HaveFriendsTrigger(_arg_1:Triggerable, _arg_2:TriggerVO, _arg_3:cGeneralInterface)
        {
            super(_arg_1, _arg_2, _arg_3);
            if (_arg_2.min == 0)
            {
                _arg_2.min = 1;
            };
            if (_arg_2.max == 0)
            {
                _arg_2.max = 1000000;
            };
            this.currentPlayerID = _arg_3.mCurrentPlayer.GetPlayerId();
            _arg_3.channels.GUILD.addPropertyObserver(TriggerUtils.NON_GUILD_FRIENDS_PROPERTY_NAME, this);
        }

        override protected function computeCurrentAmount():Number
        {
            return (0);
        }

        override public function dispose():void
        {
            (para as cGeneralInterface).channels.GUILD.removePropertyObserver(TriggerUtils.NON_GUILD_FRIENDS_PROPERTY_NAME, this);
            super.dispose();
        }

        override public function check():Boolean
        {
            updateCurrentAmount();
            var _local_1:int = (getCurrentAmount() as int);
            if (((_local_1 <= definition.max) && (_local_1 >= definition.min)))
            {
                trigger();
                return (true);
            };
            return (false);
        }

        public function update(_arg_1:Notifier, _arg_2:String, _arg_3:Object):void
        {
            if (_arg_2 == TriggerUtils.NON_GUILD_FRIENDS_PROPERTY_NAME)
            {
                this.check();
            };
        }


    }
}
