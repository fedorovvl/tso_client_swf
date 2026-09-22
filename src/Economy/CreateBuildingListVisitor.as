package Economy
{
    import ServerState.dResource;
    import GO.cBuilding;
    import ServerState.cResourceCreation;
    import ServerState.dResourceCreationDefinition;
    import Interface.cGeneralInterface;

    public class CreateBuildingListVisitor implements BuildingVisitorInterface 
    {

        public static const ECONOMY_TYPE_ALL:int = 0;
        public static const ECONOMY_TYPE_PRODUCTION:int = 1;
        public static const ECONOMY_TYPE_CONSUMPTION:int = 2;

        private var mBuildingList:Array;
        private var mEconomyType:int;
        private var mUniqueByType:Boolean;

        public function CreateBuildingListVisitor(_arg_1:Array, _arg_2:int, _arg_3:Boolean)
        {
            super();
            this.mBuildingList = _arg_1;
            this.mEconomyType = _arg_2;
            this.mUniqueByType = _arg_3;
        }

        public function visitBuilding(_arg_1:cGeneralInterface, _arg_2:cBuilding, _arg_3:String):Boolean
        {
            var _local_5:String;
            var _local_8:dResource;
            var _local_9:cBuilding;
            var _local_4:Boolean;
            var _local_6:cResourceCreation = _arg_2.GetResourceCreation();
            if (_local_6 == null)
            {
                return (true);
            };
            var _local_7:dResourceCreationDefinition = _local_6.GetResourceCreationDefinition();
            if (_local_7 == null)
            {
                return (true);
            };
            switch (this.mEconomyType)
            {
                case ECONOMY_TYPE_ALL:
                    _local_4 = true;
                    break;
                case ECONOMY_TYPE_PRODUCTION:
                    if (_local_7.amountRemoved >= 0)
                    {
                        if (_local_7.defaultSetting.resourceName_string == _arg_3)
                        {
                            _local_4 = true;
                        };
                    }
                    else
                    {
                        _local_5 = ("Deposit" + _local_7.defaultSetting.resourceName_string);
                        if (_arg_3 == _local_5)
                        {
                            _local_4 = true;
                        };
                    };
                    break;
                case ECONOMY_TYPE_CONSUMPTION:
                    if (_local_7.externalResource_string == "")
                    {
                        for each (_local_8 in _local_7.necessaryResources_vector)
                        {
                            if (_local_8.name_string == _arg_3)
                            {
                                _local_4 = true;
                            };
                        };
                    }
                    else
                    {
                        _local_5 = ("Deposit" + _local_7.defaultSetting.resourceName_string);
                        if (_arg_3 == _local_5)
                        {
                            if (_local_7.amountRemoved > 0)
                            {
                                _local_4 = true;
                            };
                        };
                    };
                    break;
            };
            if (!_local_4)
            {
                return (true);
            };
            if (this.mUniqueByType)
            {
                for each (_local_9 in this.mBuildingList)
                {
                    if (_local_9.GetBuildingName_string() == _arg_2.GetBuildingName_string())
                    {
                        return (true);
                    };
                };
            };
            this.mBuildingList.push(_arg_2);
            return (true);
        }

        public function getBuildingList():Array
        {
            return (this.mBuildingList);
        }


    }
}
