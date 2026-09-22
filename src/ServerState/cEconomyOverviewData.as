package ServerState
{
    import Economy.BuildingEnumerator;
    import Interface.cGeneralInterface;
    import Economy.ResourceProductionValueVisitor;
    import Economy.CreateBuildingListVisitor;
    import GO.cBuilding;
    import Interface.cGameInterface;

    public class cEconomyOverviewData 
    {

        private var mBuildingEnumerator:BuildingEnumerator = null;
        private var mGeneralInterface:cGeneralInterface;

        public function cEconomyOverviewData(_arg_1:cGeneralInterface=null)
        {
            super();
            this.mGeneralInterface = ((_arg_1 != null) ? _arg_1 : global.ui);
            this.mBuildingEnumerator = new BuildingEnumerator(this.mGeneralInterface.mCurrentPlayer.GetPlayerId(), this.mGeneralInterface.mCurrentPlayerZone.mStreetDataMap);
        }

        public function GetResourceProductionAndConsumptionValues(_arg_1:String, _arg_2:String):dEconomyOverviewDataResult
        {
            var _local_3:dEconomyOverviewDataResult = new dEconomyOverviewDataResult();
            var _local_4:ResourceProductionValueVisitor = new ResourceProductionValueVisitor();
            this.mBuildingEnumerator.visitBuildingsByName(this.mGeneralInterface, _local_4, _arg_1, _arg_2);
            _local_3.mProductionValue = _local_4.getProductionValue();
            _local_3.mBuffedProductionValue = _local_4.getBuffedProductionValue();
            _local_3.mConsumptionValue = _local_4.getConsumptionValue();
            return (_local_3);
        }

        private function IsStableResourceChainRecursive(_arg_1:String):Boolean
        {
            var _local_4:dResource;
            var _local_5:dResource;
            var _local_6:int;
            var _local_7:dEconomyOverviewDataResult;
            var _local_2:Boolean = true;
            var _local_3:dResourceCreationDefinition = gEconomics.GetResourcesCreationDefinitionForResource(_arg_1);
            if (((!(_local_3 == null)) && (_local_3.amountRemoved >= 0)))
            {
                if (_local_3.externalResource_string == "")
                {
                    for each (_local_4 in _local_3.necessaryResources_vector)
                    {
                        _local_5 = this.GetPlayerSpecificResource(_local_4.name_string);
                        _local_6 = globalFlash.gui.mEconomyOverview.mResourceProductionData[_local_5.name_string];
                        if (((_local_5.amount >= _local_5.maxLimit) || (_local_6 >= 0)))
                        {
                            _local_2 = this.IsStableResourceChainRecursive(_local_5.name_string);
                        }
                        else
                        {
                            _local_2 = false;
                        };
                        if (!_local_2) break;
                    };
                }
                else
                {
                    if (_arg_1 == defines.WOOD_RESOURCE_NAME_string)
                    {
                        _local_7 = this.GetResourceProductionAndConsumptionValues(null, ("Deposit" + _arg_1));
                        _local_2 = (_local_7.mBuffedProductionValue >= _local_7.mConsumptionValue);
                    };
                };
            };
            return (_local_2);
        }

        public function GetUniqueConsumptionBuildingList(_arg_1:String, _arg_2:String):Array
        {
            var _local_3:CreateBuildingListVisitor = new CreateBuildingListVisitor(new Array(), CreateBuildingListVisitor.ECONOMY_TYPE_CONSUMPTION, true);
            this.mBuildingEnumerator.visitBuildingsByName(this.mGeneralInterface, _local_3, _arg_1, _arg_2);
            return (_local_3.getBuildingList());
        }

        public function GetBuildingList(_arg_1:String):Array
        {
            var _local_2:CreateBuildingListVisitor = new CreateBuildingListVisitor(new Array(), CreateBuildingListVisitor.ECONOMY_TYPE_ALL, false);
            this.mBuildingEnumerator.visitBuildingsByName(this.mGeneralInterface, _local_2, _arg_1, null);
            return (_local_2.getBuildingList());
        }

        public function GetBuildingProductionAndConsumptionValues(_arg_1:cBuilding, _arg_2:String):dEconomyOverviewDataResult
        {
            var _local_3:dEconomyOverviewDataResult = new dEconomyOverviewDataResult();
            var _local_4:ResourceProductionValueVisitor = new ResourceProductionValueVisitor();
            _local_4.visitBuilding(this.mGeneralInterface, _arg_1, _arg_2);
            _local_3.mProductionValue = _local_4.getProductionValue();
            _local_3.mBuffedProductionValue = _local_4.getBuffedProductionValue();
            _local_3.mConsumptionValue = _local_4.getConsumptionValue();
            return (_local_3);
        }

        public function GetBuildingProductionCount(_arg_1:cBuilding):int
        {
            var _local_2:ResourceProductionValueVisitor;
            if (_arg_1.IsBuildingSelectable())
            {
                _local_2 = new ResourceProductionValueVisitor();
                _local_2.visitBuilding(this.mGeneralInterface, _arg_1, null);
                return (_local_2.getBuffedProductionValue());
            };
            return (0);
        }

        public function IsStableResourceChain(_arg_1:String):Boolean
        {
            return (this.IsStableResourceChainRecursive(_arg_1));
        }

        public function GetUniqueProductionBuildingList(_arg_1:String, _arg_2:String):Array
        {
            var _local_3:CreateBuildingListVisitor = new CreateBuildingListVisitor(new Array(), CreateBuildingListVisitor.ECONOMY_TYPE_PRODUCTION, true);
            this.mBuildingEnumerator.visitBuildingsByName(this.mGeneralInterface, _local_3, _arg_1, _arg_2);
            return (_local_3.getBuildingList());
        }

        public function GetResourceProductionValue(_arg_1:String, _arg_2:String):int
        {
            var _local_3:ResourceProductionValueVisitor = new ResourceProductionValueVisitor();
            this.mBuildingEnumerator.visitBuildingsByName(this.mGeneralInterface, _local_3, _arg_1, _arg_2);
            return (_local_3.getBuffedProductionValue());
        }

        public function GetPlayerSpecificResource(_arg_1:String):dResource
        {
            var _local_2:cGameInterface = (this.mGeneralInterface as cGameInterface);
            var _local_3:cResources = _local_2.mCurrentPlayerZone.GetResources(_local_2.mCurrentPlayer);
            return (_local_3.GetPlayerResource(_arg_1));
        }

        public function GetResourceConsumptionValue(_arg_1:String, _arg_2:String):int
        {
            var _local_3:ResourceProductionValueVisitor = new ResourceProductionValueVisitor();
            this.mBuildingEnumerator.visitBuildingsByName(this.mGeneralInterface, _local_3, _arg_1, _arg_2);
            return (_local_3.getConsumptionValue());
        }


    }
}
