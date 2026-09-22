package Trigger.Triggers
{
    import Trigger.DeltaTrigger;
    import Model.Observer;
    import Map.cPlayerZoneScreen;
    import Utils.TriggerUtils;
    import Trigger.TriggerDeltaValue;
    import Trigger.Triggerable;
    import Communication.VO.TriggerVO;
    import Interface.cGeneralInterface;
    import Communication.VO.UpdateVO.dRemovedAdventureVO;
    import Model.Notifier;

    public class ContestPvPColonyTrigger extends DeltaTrigger implements Observer 
    {

        private var playerZone:cPlayerZoneScreen;

        public function ContestPvPColonyTrigger(_arg_1:TriggerDeltaValue, _arg_2:Triggerable, _arg_3:TriggerVO, _arg_4:cGeneralInterface)
        {
            super(_arg_1, _arg_2, _arg_3, _arg_4);
            this.playerZone = _arg_4.mCurrentPlayerZone;
            this.playerZone.addPropertyObserver(TriggerUtils.ADVENTURE_COMPLETED_PROPERTY_NAME, this);
        }

        private function checkType(_arg_1:dRemovedAdventureVO):Boolean
        {
            return ((definition.isTypeEmpty()) || (TriggerUtils.CheckAdventureSize(definition.GetTypeString(), _arg_1.mapLevel)));
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
            var _local_4:dRemovedAdventureVO = (_arg_3 as dRemovedAdventureVO);
            if (((_local_4.contestedPvPColony) && (this.checkType(_local_4))))
            {
                getDelta().add(1);
                sendTriggerValueUpdated();
                this.check();
            };
        }

        override public function dispose():void
        {
            if (this.playerZone != null)
            {
                this.playerZone.removePropertyObserver(TriggerUtils.ADVENTURE_COMPLETED_PROPERTY_NAME, this);
                this.playerZone = null;
            };
            super.dispose();
        }


    }
}
