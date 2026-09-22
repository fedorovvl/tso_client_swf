package Trigger.Triggers
{
    import Trigger.DeltaTrigger;
    import Model.Observer;
    import GO.cBuilding;
    import Trigger.TriggerDeltaValue;
    import Trigger.Triggerable;
    import Communication.VO.TriggerVO;
    import Interface.cGeneralInterface;
    import Model.Notifier;
    import Model.Notifiers.Channel;

    public final class BuildingDestroyedTrigger extends DeltaTrigger implements Observer 
    {

        public function BuildingDestroyedTrigger(_arg_1:TriggerDeltaValue, _arg_2:Triggerable, _arg_3:TriggerVO, _arg_4:cGeneralInterface)
        {
            super(_arg_1, _arg_2, _arg_3, _arg_4.channels.BUILDING);
            if (_arg_3.min == 0)
            {
                _arg_3.min = 1;
            };
            if (_arg_3.max == 0)
            {
                _arg_3.max = 100100100;
            };
            _arg_4.channels.BUILDING.addPropertyObserver(cBuilding.BUILDING_DESTROYED_string, this);
        }

        override public function check():Boolean
        {
            var _local_1:Number = getCurrentAmount();
            if (((_local_1 >= definition.min) && (_local_1 <= definition.min)))
            {
                trigger();
                return (true);
            };
            return (false);
        }

        public function update(_arg_1:Notifier, _arg_2:String, _arg_3:Object):void
        {
            var _local_4:cBuilding;
            var _local_5:String;
            if (_arg_2 == cBuilding.BUILDING_DESTROYED_string)
            {
                _local_4 = (_arg_3 as cBuilding);
                for each (_local_5 in definition.item_string.split(","))
                {
                    if (_local_4.GetBuildingName_string() == _local_5)
                    {
                        getDelta().add(1);
                        sendTriggerValueUpdated();
                        this.check();
                        break;
                    };
                };
            };
        }

        override public function dispose():void
        {
            (para as Channel).removePropertyObserver(cBuilding.BUILDING_DESTROYED_string, this);
            super.dispose();
        }


    }
}
