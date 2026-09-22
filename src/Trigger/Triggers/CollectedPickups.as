package Trigger.Triggers
{
    import Trigger.DeltaTrigger;
    import Model.Observer;
    import Utils.StringUtils;
    import com.bluebyte.tso.logic.PickupManager;
    import Utils.TriggerUtils;
    import Trigger.TriggerDeltaValue;
    import Trigger.Triggerable;
    import Communication.VO.TriggerVO;
    import Interface.cGeneralInterface;
    import GO.cBuilding;
    import Model.Notifier;

    public class CollectedPickups extends DeltaTrigger implements Observer 
    {

        private var checkbuilding:Boolean = false;

        public function CollectedPickups(_arg_1:TriggerDeltaValue, _arg_2:Triggerable, _arg_3:TriggerVO, _arg_4:cGeneralInterface)
        {
            super(_arg_1, _arg_2, _arg_3, _arg_4.pickupManager);
            if (_arg_3.amount == 0)
            {
                _arg_3.amount = 1;
            };
            this.checkbuilding = (!(StringUtils.isEmpty(_arg_3.item_string)));
            (para as PickupManager).addPropertyObserver(TriggerUtils.COLLECTED_PICKUP_NAME, this);
        }

        override public function dispose():void
        {
            (para as PickupManager).removePropertyObserver(TriggerUtils.COLLECTED_PICKUP_NAME, this);
            super.dispose();
        }

        override public function check():Boolean
        {
            updateCurrentAmount();
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
            var _local_6:String;
            var _local_4:cBuilding = (_arg_3 as cBuilding);
            var _local_5:Boolean = true;
            if (this.checkbuilding)
            {
                for each (_local_6 in definition.item_string.split(","))
                {
                    _local_5 = (_local_4.GetBuildingName_string() == _local_6);
                    if (_local_5) break;
                };
            };
            if (_local_5)
            {
                getDelta().add(1);
                sendTriggerValueUpdated();
                this.check();
            };
        }


    }
}
