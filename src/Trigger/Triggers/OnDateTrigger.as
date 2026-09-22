package Trigger.Triggers
{
    import Trigger.InstantTrigger;
    import Model.Observer;
    import Model.Notifiers.TickChannel;
    import Trigger.Triggerable;
    import Communication.VO.TriggerVO;
    import Interface.cGeneralInterface;
    import com.bluebyte.tso.util.TimeUtil;
    import Model.Notifier;

    public class OnDateTrigger extends InstantTrigger implements Observer 
    {

        public function OnDateTrigger(_arg_1:Triggerable, _arg_2:TriggerVO, _arg_3:cGeneralInterface)
        {
            super(_arg_1, _arg_2, _arg_3);
            _arg_3.channels.TICK.addPropertyObserver(TickChannel.GAME_TICK, this);
        }

        override public function check():Boolean
        {
            var _local_1:cGeneralInterface = (para as cGeneralInterface);
            if (((TimeUtil.getServerTime() > definition.dateInMiliseconds) && ((TimeUtil.getServerTime() < definition.untilInMiliseconds) || (definition.untilInMiliseconds == 0))))
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

        override public function dispose():void
        {
            var _local_1:cGeneralInterface = (para as cGeneralInterface);
            _local_1.channels.TICK.removePropertyObserver(TickChannel.GAME_TICK, this);
            super.dispose();
        }


    }
}
