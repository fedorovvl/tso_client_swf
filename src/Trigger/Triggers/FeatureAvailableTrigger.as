package Trigger.Triggers
{
    import Trigger.InstantTrigger;
    import Model.Observer;
    import Model.Notifiers.TickChannel;
    import Trigger.Triggerable;
    import Communication.VO.TriggerVO;
    import Interface.cGeneralInterface;
    import Model.Notifier;
    import Utils.StringUtils;

    public class FeatureAvailableTrigger extends InstantTrigger implements Observer 
    {

        public function FeatureAvailableTrigger(_arg_1:Triggerable, _arg_2:TriggerVO, _arg_3:cGeneralInterface)
        {
            super(_arg_1, _arg_2, _arg_3);
            _arg_3.channels.TICK.addPropertyObserver(TickChannel.GAME_TICK, this);
        }

        public function update(_arg_1:Notifier, _arg_2:String, _arg_3:Object):void
        {
            this.check();
        }

        override public function check():Boolean
        {
            var _local_2:String;
            var _local_1:Boolean;
            for each (_local_2 in StringUtils.split(definition.name_string, ","))
            {
                if ((para as cGeneralInterface).killswitch.isLocked(_local_2))
                {
                    _local_1 = true;
                    break;
                };
            };
            if (!_local_1)
            {
                trigger();
                return (true);
            };
            return (false);
        }

        override public function dispose():void
        {
            (para as cGeneralInterface).channels.TICK.removePropertyObserver(TickChannel.GAME_TICK, this);
            super.dispose();
        }


    }
}
