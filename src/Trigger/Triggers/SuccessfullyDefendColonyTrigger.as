package Trigger.Triggers
{
    import Trigger.DeltaTrigger;
    import Model.Observer;
    import Utils.TriggerUtils;
    import Trigger.TriggerDeltaValue;
    import Trigger.Triggerable;
    import Communication.VO.TriggerVO;
    import Interface.cGeneralInterface;
    import Communication.VO.ColonyVO;
    import Model.Notifier;

    public class SuccessfullyDefendColonyTrigger extends DeltaTrigger implements Observer 
    {

        public function SuccessfullyDefendColonyTrigger(_arg_1:TriggerDeltaValue, _arg_2:Triggerable, _arg_3:TriggerVO, _arg_4:cGeneralInterface)
        {
            super(_arg_1, _arg_2, _arg_3, _arg_4);
            _arg_4.mCurrentPlayerZone.addPropertyObserver(TriggerUtils.ADVENTURE_DEFENDED_PROPERTY_NAME, this);
        }

        private function checkType(_arg_1:ColonyVO):Boolean
        {
            return ((definition.isTypeEmpty()) || (TriggerUtils.CheckAdventureSize(definition.GetTypeString(), _arg_1.mapLevel)));
        }

        override public function dispose():void
        {
            (this.para as cGeneralInterface).mCurrentPlayerZone.removePropertyObserver(TriggerUtils.ADVENTURE_DEFENDED_PROPERTY_NAME, this);
            super.dispose();
        }

        override public function check():Boolean
        {
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
            var _local_4:ColonyVO = (_arg_3 as ColonyVO);
            if (this.checkType(_local_4))
            {
                getDelta().add(1);
                sendTriggerValueUpdated();
                this.check();
            };
        }


    }
}
