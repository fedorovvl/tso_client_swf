package Trigger.Triggers
{
    import Trigger.InstantTrigger;
    import Model.Observer;
    import Utils.TriggerUtils;
    import Trigger.Triggerable;
    import Communication.VO.TriggerVO;
    import Interface.cGeneralInterface;
    import Model.Notifier;
    import Interface.cGameInterface;

    public class FillUpYourColonySlotsTrigger extends InstantTrigger implements Observer 
    {

        public function FillUpYourColonySlotsTrigger(_arg_1:Triggerable, _arg_2:TriggerVO, _arg_3:cGeneralInterface)
        {
            super(_arg_1, _arg_2, _arg_3);
            _arg_3.channels.ZONE.addPropertyObserver(TriggerUtils.COLONY_SLOTS_TOTAL, this);
        }

        public function update(_arg_1:Notifier, _arg_2:String, _arg_3:Object):void
        {
            this.check();
        }

        override public function check():Boolean
        {
            if ((para as cGameInterface).mCurrentPlayer.GetColonySlotCountUsed() >= definition.amount)
            {
                trigger();
                return (true);
            };
            return (false);
        }

        override public function dispose():void
        {
            (para as cGeneralInterface).channels.ZONE.removePropertyObserver(definition.item_string, this);
            super.dispose();
        }


    }
}
