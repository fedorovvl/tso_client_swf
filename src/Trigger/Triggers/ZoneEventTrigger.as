package Trigger.Triggers
{
    import Trigger.InstantTrigger;
    import Model.Observer;
    import Trigger.Triggerable;
    import Communication.VO.TriggerVO;
    import Interface.cGeneralInterface;
    import Model.Notifier;

    public class ZoneEventTrigger extends InstantTrigger implements Observer 
    {

        private var mTriggered:Boolean;

        public function ZoneEventTrigger(_arg_1:Triggerable, _arg_2:TriggerVO, _arg_3:cGeneralInterface)
        {
            super(_arg_1, _arg_2, _arg_3);
            _arg_3.channels.ZONE.addPropertyObserver(_arg_2.item_string, this);
        }

        public function update(_arg_1:Notifier, _arg_2:String, _arg_3:Object):void
        {
            this.mTriggered = true;
            this.check();
        }

        override public function dispose():void
        {
            (para as cGeneralInterface).channels.ZONE.removePropertyObserver(definition.item_string, this);
            super.dispose();
        }

        override public function check():Boolean
        {
            if (this.mTriggered)
            {
                trigger();
            };
            return (this.mTriggered);
        }


    }
}
