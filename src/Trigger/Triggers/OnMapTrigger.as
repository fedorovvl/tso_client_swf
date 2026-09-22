package Trigger.Triggers
{
    import Trigger.InstantTrigger;
    import Model.Observer;
    import Utils.TriggerUtils;
    import Trigger.Triggerable;
    import Communication.VO.TriggerVO;
    import Interface.cGeneralInterface;
    import Utils.StringUtils;
    import Model.Notifier;
    import GO.cBuilding;

    public final class OnMapTrigger extends InstantTrigger implements Observer 
    {

        public function OnMapTrigger(_arg_1:Triggerable, _arg_2:TriggerVO, _arg_3:cGeneralInterface)
        {
            super(_arg_1, _arg_2, _arg_3);
            if (((_arg_2.min > 0) && (_arg_2.max == 0)))
            {
                _arg_2.max = 100100100;
            };
            _arg_3.channels.ZONE.addPropertyObserver(TriggerUtils.ON_MAP_NOTIFICATION_PROPERTY_NAME, this);
        }

        override public function check():Boolean
        {
            updateCurrentAmount();
            var _local_1:Number = getCurrentAmount();
            if (((_local_1 >= definition.min) && (_local_1 <= definition.max)))
            {
                trigger();
                return (true);
            };
            return (false);
        }

        public function update(_arg_1:Notifier, _arg_2:String, _arg_3:Object):void
        {
            if (((definition.item_string == _arg_3) || (StringUtils.equalsIgnoreCase(definition.type_string, "deco"))))
            {
                this.check();
            };
        }

        override protected function computeCurrentAmount():Number
        {
            var _local_2:cBuilding;
            var _local_1:int;
            for each (_local_2 in (para as cGeneralInterface).mCurrentPlayerZone.mStreetDataMap.GetBuildings_vector())
            {
                if (!((null == _local_2) || (!(_local_2.IsBuildingActive()))))
                {
                    if (!(((definition.mode_string == "free") && (!(_local_2.getPlayerID() == 0))) || ((definition.mode_string == "enemy") && (!(_local_2.getPlayerID() == -1)))))
                    {
                        if (!((!(StringUtils.isEmpty(definition.type_string))) && (!(StringUtils.equalsIgnoreCase(_local_2.ui, definition.type_string)))))
                        {
                            if (((StringUtils.isEmpty(definition.item_string)) || (StringUtils.equalsIgnoreCase(_local_2.GetBuildingName_string(), definition.item_string))))
                            {
                                _local_1++;
                            };
                        };
                    };
                };
            };
            return (_local_1);
        }

        override public function dispose():void
        {
            (para as cGeneralInterface).channels.ZONE.removePropertyObserver(TriggerUtils.ON_MAP_NOTIFICATION_PROPERTY_NAME, this);
            super.dispose();
        }


    }
}
