package Trigger.Triggers
{
    import Trigger.InstantTrigger;
    import Model.Observer;
    import Trigger.Triggerable;
    import Communication.VO.TriggerVO;
    import Interface.cGeneralInterface;
    import Model.Notifier;

    public class PremiumAccountDurationTrigger extends InstantTrigger implements Observer 
    {

        public function PremiumAccountDurationTrigger(_arg_1:Triggerable, _arg_2:TriggerVO, _arg_3:cGeneralInterface)
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
            _arg_3.mCurrentPlayer.addPropertyObserver("mPremiumAccountDuration", this);
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
            return ((para as cGeneralInterface).mCurrentPlayer.getPremiumDurationInHours());
        }

        override public function dispose():void
        {
            (para as cGeneralInterface).mCurrentPlayer.removePropertyObserver("mPremiumAccountDuration", this);
            super.dispose();
        }


    }
}
