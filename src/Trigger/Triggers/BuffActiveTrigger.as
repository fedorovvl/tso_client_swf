package Trigger.Triggers
{
    import Trigger.InstantTrigger;
    import Model.Observer;
    import BuffSystem.cBuff;
    import Trigger.Triggerable;
    import Communication.VO.TriggerVO;
    import Interface.cGeneralInterface;
    import Model.Notifier;
    import GO.cBuilding;
    import Utils.StringUtils;

    public class BuffActiveTrigger extends InstantTrigger implements Observer 
    {

        public static const XML_string:String = "buffactive";

        public function BuffActiveTrigger(_arg_1:Triggerable, _arg_2:TriggerVO, _arg_3:cGeneralInterface)
        {
            super(_arg_1, _arg_2, _arg_3);
            if (_arg_2.max == 0)
            {
                _arg_2.max = 100100100;
            };
            _arg_3.channels.BUFF.addPropertyObserver(cBuff.BUFF_APPLIED_string, this);
            _arg_3.channels.BUFF.addPropertyObserver(cBuff.BUFF_EXPIRED_string, this);
        }

        public function update(_arg_1:Notifier, _arg_2:String, _arg_3:Object):void
        {
            this.check();
        }

        override public function dispose():void
        {
            (para as cGeneralInterface).channels.BUFF.removePropertyObserver(cBuff.BUFF_APPLIED_string, this);
            (para as cGeneralInterface).channels.BUFF.removePropertyObserver(cBuff.BUFF_EXPIRED_string, this);
            super.dispose();
        }

        override public function check():Boolean
        {
            updateCurrentAmount();
            if (((getCurrentAmount() >= definition.min) && (getCurrentAmount() <= definition.max)))
            {
                trigger();
                return (true);
            };
            return (false);
        }

        override protected function computeCurrentAmount():Number
        {
            var _local_3:cBuilding;
            var _local_4:String;
            var _local_1:int;
            var _local_2:Boolean = StringUtils.isEmpty(definition.type_string);
            for each (_local_3 in (para as cGeneralInterface).mCurrentPlayerZone.mStreetDataMap.GetBuildings_vector())
            {
                if (!((_local_3 == null) || ((!(_local_2)) && (!(definition.typeContains(_local_3.GetBuildingName_string()))))))
                {
                    for each (_local_4 in StringUtils.split(definition.name_string, ","))
                    {
                        if (_local_3.hasBuff(_local_4))
                        {
                            _local_1++;
                        };
                    };
                };
            };
            return (_local_1);
        }


    }
}
