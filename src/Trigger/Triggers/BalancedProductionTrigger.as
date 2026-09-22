package Trigger.Triggers
{
    import Trigger.TimedTrigger;
    import Utils.StringUtils;
    import Trigger.Triggerable;
    import Communication.VO.TriggerVO;
    import Interface.cGeneralInterface;
    import ServerState.dEconomyOverviewDataResult;
    import ServerState.cEconomyOverviewData;

    public class BalancedProductionTrigger extends TimedTrigger 
    {

        private var mResourcesType:Array;
        private var mBuildingsType:Array;

        public function BalancedProductionTrigger(_arg_1:Triggerable, _arg_2:TriggerVO, _arg_3:cGeneralInterface)
        {
            super(_arg_1, _arg_2, _arg_3);
            this.mResourcesType = StringUtils.split(_arg_2.item_string, StringUtils.COMMA);
            if (_arg_2.target_string != "")
            {
                this.mBuildingsType = StringUtils.split(_arg_2.target_string, StringUtils.COMMA);
            };
        }

        override public function dispose():void
        {
            super.dispose();
        }

        override protected function computeCurrentAmount():Number
        {
            var _local_2:dEconomyOverviewDataResult;
            var _local_6:String;
            var _local_7:String;
            var _local_1:cEconomyOverviewData = new cEconomyOverviewData((para as cGeneralInterface));
            var _local_3:int;
            var _local_4:int;
            var _local_5:int;
            if (definition.target_string != "")
            {
                _local_5 = this.mBuildingsType.length;
            };
            for each (_local_6 in this.mResourcesType)
            {
                _local_4 = 0;
                if (_local_5 == 0)
                {
                    _local_2 = _local_1.GetResourceProductionAndConsumptionValues(null, _local_6);
                    _local_4 = (_local_4 + (_local_2.mBuffedProductionValue - _local_2.mConsumptionValue));
                }
                else
                {
                    for each (_local_7 in this.mBuildingsType)
                    {
                        _local_2 = _local_1.GetResourceProductionAndConsumptionValues(_local_7, _local_6);
                        _local_4 = (_local_4 + (_local_2.mBuffedProductionValue - _local_2.mConsumptionValue));
                    };
                };
                if (((!(_local_4 == 0)) && (_local_4 >= definition.min)))
                {
                    _local_3++;
                };
            };
            return (_local_3);
        }

        override public function check():Boolean
        {
            updateCurrentAmount();
            var _local_1:Number = getCurrentAmount();
            if (_local_1 >= this.mResourcesType.length)
            {
                trigger();
                return (true);
            };
            return (false);
        }


    }
}
