package Trigger.Triggers
{
    import Trigger.InstantTrigger;
    import Model.Observer;
    import GO.cBuilding;
    import Trigger.Triggerable;
    import Communication.VO.TriggerVO;
    import Interface.cGeneralInterface;
    import Utils.StringUtils;
    import Model.Notifier;
    import Model.Notifiers.Channel;

    public final class BuildingUpgradedTrigger extends InstantTrigger implements Observer 
    {

        public function BuildingUpgradedTrigger(_arg_1:Triggerable, _arg_2:TriggerVO, _arg_3:cGeneralInterface)
        {
            super(_arg_1, _arg_2, _arg_3.channels.BUILDING);
            _arg_2.min = (_arg_2.max = 1);
            _arg_3.channels.BUILDING.addPropertyObserver(cBuilding.BUILDING_UPGRADED_string, this);
        }

        override public function check():Boolean
        {
            return (false);
        }

        public function update(_arg_1:Notifier, _arg_2:String, _arg_3:Object):void
        {
            var _local_4:cBuilding;
            if (_arg_2 == cBuilding.BUILDING_UPGRADED_string)
            {
                _local_4 = (_arg_3 as cBuilding);
                if (((StringUtils.isEmpty(definition.item_string)) || (_local_4.GetBuildingName_string() == definition.item_string)))
                {
                    trigger();
                };
            };
        }

        override public function dispose():void
        {
            (para as Channel).removePropertyObserver(cBuilding.BUILDING_UPGRADED_string, this);
            super.dispose();
        }


    }
}
