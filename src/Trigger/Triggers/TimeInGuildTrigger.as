package Trigger.Triggers
{
    import Trigger.InstantTrigger;
    import Model.Observer;
    import Model.Notifiers.SpecialistNotifier;
    import Trigger.Triggerable;
    import Communication.VO.TriggerVO;
    import Interface.cGeneralInterface;
    import Model.Notifier;

    public class TimeInGuildTrigger extends InstantTrigger implements Observer 
    {

        private static var ONE_DAY_IN_MSEC:int = 86400000;

        private var playerID:int;

        public function TimeInGuildTrigger(_arg_1:Triggerable, _arg_2:TriggerVO, _arg_3:cGeneralInterface)
        {
            super(_arg_1, _arg_2, _arg_3);
            this.playerID = _arg_3.mCurrentPlayer.GetPlayerId();
            _arg_3.channels.SPECIALIST.addPropertyObserver(SpecialistNotifier.IN_GUILD, this);
        }

        override public function dispose():void
        {
            (para as cGeneralInterface).channels.SPECIALIST.removePropertyObserver(SpecialistNotifier.IN_GUILD, this);
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

        public function update(_arg_1:Notifier, _arg_2:String, _arg_3:Object):void
        {
            this.check();
        }

        override protected function computeCurrentAmount():Number
        {
            return (-1);
        }


    }
}
