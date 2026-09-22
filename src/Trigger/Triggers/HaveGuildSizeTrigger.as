package Trigger.Triggers
{
    import Trigger.InstantTrigger;
    import Model.Observer;
    import Communication.VO.Guild.dGuildVO;
    import Model.Notifier;
    import Utils.TriggerUtils;
    import Trigger.Triggerable;
    import Communication.VO.TriggerVO;
    import Interface.cGeneralInterface;

    public class HaveGuildSizeTrigger extends InstantTrigger implements Observer 
    {

        private var guild:dGuildVO;
        private var guildNotifier:Notifier;
        private var playerId:int;

        public function HaveGuildSizeTrigger(_arg_1:Triggerable, _arg_2:TriggerVO, _arg_3:cGeneralInterface)
        {
            super(_arg_1, _arg_2, _arg_3);
            this.playerId = _arg_3.mCurrentPlayer.GetPlayerId();
            this.guildNotifier = _arg_3.channels.GUILD;
            this.guildNotifier.addPropertyObserver(TriggerUtils.GUILD_UPDATED_PROPERTY_NAME, this);
        }

        override protected function computeCurrentAmount():Number
        {
            return (0);
        }

        public function update(_arg_1:Notifier, _arg_2:String, _arg_3:Object):void
        {
            this.guild = (_arg_3 as dGuildVO);
            this.check();
            this.guild = null;
        }

        override public function dispose():void
        {
            if (this.guildNotifier != null)
            {
                this.guildNotifier.removePropertyObserver(TriggerUtils.GUILD_UPDATED_PROPERTY_NAME, this);
                this.guildNotifier = null;
            };
            this.guild = null;
            super.dispose();
        }

        override public function check():Boolean
        {
            updateCurrentAmount();
            var _local_1:int = (getCurrentAmount() as int);
            if (_local_1 >= definition.amount)
            {
                trigger();
                return (true);
            };
            return (false);
        }


    }
}
