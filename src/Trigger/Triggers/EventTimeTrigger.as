package Trigger.Triggers
{
    import Trigger.InstantTrigger;
    import Model.Observer;
    import Events.EventManager;
    import Trigger.Triggerable;
    import Communication.VO.TriggerVO;
    import Interface.cGeneralInterface;
    import Model.Notifier;
    import com.bluebyte.tso.util.TimeUtil;

    public class EventTimeTrigger extends InstantTrigger implements Observer 
    {

        public static const XML_string:String = "eventtime";

        public function EventTimeTrigger(_arg_1:Triggerable, _arg_2:TriggerVO, _arg_3:cGeneralInterface)
        {
            super(_arg_1, _arg_2, _arg_3);
            _arg_2.min = 1;
            _arg_2.max = 2;
            _arg_3.mEventManager.addPropertyObserver(((_arg_2.type_string == "start") ? EventManager.EVENT_STARTED : EventManager.EVENT_STOPPED), this);
        }

        override public function dispose():void
        {
            (para as cGeneralInterface).mEventManager.removePropertyObserver(((definition.type_string == "start") ? EventManager.EVENT_STARTED : EventManager.EVENT_STOPPED), this);
            super.dispose();
        }

        override public function check():Boolean
        {
            if (this.getCurrentAmount() > 0)
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

        override public function getCurrentAmount():Number
        {
            var _local_1:cGeneralInterface = (para as cGeneralInterface);
            var _local_2:Number = 0;
            if (definition.type_string == "start")
            {
                _local_2 = _local_1.mEventManager.GetEventStartDate(definition.name_string);
            }
            else
            {
                _local_2 = _local_1.mEventManager.GetEventStopDate(definition.name_string);
            };
            if (_local_2 == 0)
            {
                return (0);
            };
            if (TimeUtil.getServerTime() >= _local_2)
            {
                return (1);
            };
            return (0);
        }


    }
}
