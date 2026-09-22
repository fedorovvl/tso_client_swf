package Trigger.Triggers
{
    import Trigger.DeltaTrigger;
    import Model.Observer;
    import Model.Notifiers.TickChannel;
    import Trigger.TriggerDeltaValue;
    import Trigger.Triggerable;
    import Communication.VO.TriggerVO;
    import Interface.cGeneralInterface;
    import Model.Notifier;

    public class HoursElapsedTrigger extends DeltaTrigger implements Observer 
    {

        public function HoursElapsedTrigger(_arg_1:TriggerDeltaValue, _arg_2:Triggerable, _arg_3:TriggerVO, _arg_4:cGeneralInterface)
        {
            super(_arg_1, _arg_2, _arg_3, _arg_4);
            _arg_4.channels.TICK.addPropertyObserver(TickChannel.DELAYED_COMPUTE_TICK, this);
            if (((_arg_1.getValue() == 0) || (_arg_1.getValue() > _arg_4.GetCurrentDateInHours())))
            {
                _arg_1.setValue(_arg_4.GetCurrentDateInHours());
            };
        }

        override public function dispose():void
        {
            (para as cGeneralInterface).channels.TICK.removePropertyObserver(TickChannel.DELAYED_COMPUTE_TICK, this);
            super.dispose();
        }

        override public function check():Boolean
        {
            var _local_1:Number = getDelta().getValue();
            var _local_2:Number = this.getCurrentAmount();
            return (false);
        }

        public function update(_arg_1:Notifier, _arg_2:String, _arg_3:Object):void
        {
            this.check();
        }

        override public function getCurrentAmount():Number
        {
            if (getDelta().getValue() == 0)
            {
                return (-1);
            };
            var _local_1:Number = super.getCurrentAmount();
            var _local_2:Number = (para as cGeneralInterface).GetCurrentDateInHours();
            return (_local_2 - _local_1);
        }


    }
}
