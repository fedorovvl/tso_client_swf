package Economy
{
    import ServerState.dResource;
    import ServerState.cResourceCreation;
    import ServerState.dResourceCreationDefinition;
    import Enums.HALLOWEEN_EVENT;
    import Interface.cGeneralInterface;
    import GO.cBuilding;

    public class ResourceProductionValueVisitor implements BuildingVisitorInterface 
    {

        private var mConsumptionValue:int = 0;
        private var mProductionValue:int = 0;
        private var mBuffedProductionValue:int = 0;


        public function getProductionValue():int
        {
            return (this.mProductionValue);
        }

        public function getConsumptionValue():int
        {
            return (this.mConsumptionValue);
        }

        public function visitBuilding(_arg_1:cGeneralInterface, _arg_2:cBuilding, _arg_3:String):Boolean
        {
            var _local_4:String;
            var _local_10:int;
            var _local_11:dResource;
            var _local_5:cResourceCreation = _arg_2.GetResourceCreation();
            if (_local_5 == null)
            {
                return (true);
            };
            var _local_6:dResourceCreationDefinition = _local_5.GetResourceCreationDefinition();
            if (_local_6 == null)
            {
                return (true);
            };
            if (((((!(_local_5.GetAssignedSettler())) || (!(_arg_2.IsProductionActive()))) || (!(_arg_2.IsBuildingActive()))) || (_arg_2.IsProductionLevelTooLow())))
            {
                return (true);
            };
            if (((_arg_2.hasBuff(HALLOWEEN_EVENT.BUFF_HORROR)) || (_arg_2.hasBuff(HALLOWEEN_EVENT.BUFF_DARKNESS))))
            {
                return (true);
            };
            if (_arg_3 == null)
            {
                if (((_local_6.externalResource_string == "") || (!(_local_6.amountRemoved == -1))))
                {
                    _arg_3 = _local_6.defaultSetting.resourceName_string;
                }
                else
                {
                    _arg_3 = _local_6.externalResourceDeposit_string;
                };
            };
            var _local_7:Number = _arg_2.CalculateWays();
            if (_local_7 < 0)
            {
                return (true);
            };
            _local_7 = (_local_7 * _arg_1.mGlobalTimeScale);
            var _local_8:Number = (_local_7 / 1000);
            var _local_9:int = int((global.economyCalculationTime / _local_8));
            if (_arg_3 != null)
            {
                if (((_local_6.externalResource_string == "") || (!(_local_6.amountRemoved == -1))))
                {
                    if (_local_6.defaultSetting.resourceName_string == _arg_3)
                    {
                        this.mProductionValue = (this.mProductionValue + (_arg_2.GetExactOutputFactor() * _local_9));
                        this.mBuffedProductionValue = (this.mBuffedProductionValue + (_arg_2.GetResourceOutputFactor() * _local_9));
                    };
                }
                else
                {
                    if (_local_6.amountRemoved == -1)
                    {
                        _local_4 = _local_6.externalResourceDeposit_string;
                        if (_local_4 == _arg_3)
                        {
                            this.mProductionValue = (this.mProductionValue + (_arg_2.GetExactOutputFactor() * _local_9));
                            this.mBuffedProductionValue = (this.mBuffedProductionValue + (_arg_2.GetResourceOutputFactor() * _local_9));
                        };
                    };
                };
                if (_local_6.amountRemoved != 0)
                {
                    if (_local_6.externalResource_string == "")
                    {
                        _local_10 = 0;
                        while (_local_10 < _local_6.necessaryResources_vector.length)
                        {
                            _local_11 = _local_6.necessaryResources_vector[_local_10];
                            if (_arg_3 == _local_11.name_string)
                            {
                                this.mConsumptionValue = (this.mConsumptionValue + Math.abs(((_local_11.amount * _arg_2.GetResourceInputFactor()) * _local_9)));
                                break;
                            };
                            _local_10++;
                        };
                    }
                    else
                    {
                        if (_local_6.amountRemoved != -1)
                        {
                            _local_4 = _local_6.externalResourceDeposit_string;
                            if (_local_4 == _arg_3)
                            {
                                this.mConsumptionValue = (this.mConsumptionValue + Math.abs(((Math.max(_local_6.amountRemoved, 1) * _arg_2.GetResourceInputFactor()) * _local_9)));
                            };
                        };
                    };
                };
            };
            return (true);
        }

        public function getBuffedProductionValue():int
        {
            return (this.mBuffedProductionValue);
        }


    }
}
