package Trigger.Triggers
{
    import Trigger.InstantTrigger;
    import Model.Observer;
    import GO.cBuilding;
    import Trigger.Triggerable;
    import Communication.VO.TriggerVO;
    import Interface.cGeneralInterface;
    import Model.Notifier;
    import Model.Notifiers.Channel;

    public final class BuildingSelectedTrigger extends InstantTrigger implements Observer 
    {

        public function BuildingSelectedTrigger(_arg_1:Triggerable, _arg_2:TriggerVO, _arg_3:cGeneralInterface)
        {
            super(_arg_1, _arg_2, _arg_3.channels.BUILDING);
            _arg_2.min = (_arg_2.max = 1);
            _arg_3.channels.BUILDING.addPropertyObserver(cBuilding.BUILDING_SELECTED_string, this);
        }

        override public function check():Boolean
        {
            return (false);
        }

        public function update(_arg_1:Notifier, _arg_2:String, _arg_3:Object):void
        {
            var _local_4:cBuilding;
            var _local_5:String;
            if (_arg_2 == cBuilding.BUILDING_SELECTED_string)
            {
                _local_4 = (_arg_3 as cBuilding);
                if (((_local_4 == null) || (_local_4.GetBuildingName_string() == null)))
                {
                    return;
                };
                for each (_local_5 in definition.item_string.split(","))
                {
                    if (_local_4.GetBuildingName_string() == _local_5)
                    {
                        trigger();
                        break;
                    };
                };
            };
        }

        override public function dispose():void
        {
            (para as Channel).removePropertyObserver(cBuilding.BUILDING_SELECTED_string, this);
            super.dispose();
        }


    }
}
