package Trigger.Triggers
{
    import Trigger.InstantTrigger;
    import Model.Observer;
    import Events.EventManager;
    import Trigger.Triggerable;
    import Communication.VO.TriggerVO;
    import Interface.cGeneralInterface;
    import Model.Notifier;

    public class EventRunningTrigger extends InstantTrigger implements Observer 
    {

        public function EventRunningTrigger(_arg_1:Triggerable, _arg_2:TriggerVO, _arg_3:cGeneralInterface)
        {
            super(_arg_1, _arg_2, _arg_3);
            _arg_3.mEventManager.addPropertyObserver(EventManager.EVENT_STARTED, this);
            _arg_3.mEventManager.addPropertyObserver(EventManager.EVENT_STOPPED, this);
        }

        public function update(_arg_1:Notifier, _arg_2:String, _arg_3:Object):void
        {
            this.check();
        }

        override public function check():Boolean
        {
            if ((para as cGeneralInterface).mEventManager.isEventStarted(definition.name_string))
            {
                trigger();
                return (true);
            };
            return (false);
        }

        override public function dispose():void
        {
            (para as cGeneralInterface).mEventManager.removePropertyObserver(EventManager.EVENT_STARTED, this);
            (para as cGeneralInterface).mEventManager.removePropertyObserver(EventManager.EVENT_STOPPED, this);
            super.dispose();
        }


    }
}
