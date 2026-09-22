package Economy
{
    import Map.SubMaps.cStreetDataMap;
    import GO.cBuilding;
    import __AS3__.vec.Vector;
    import Interface.cGeneralInterface;

    public class BuildingEnumerator 
    {

        private var mPlayerID:int;
        private var mStreetDataMap:cStreetDataMap = null;

        public function BuildingEnumerator(_arg_1:int, _arg_2:cStreetDataMap)
        {
            super();
            this.mPlayerID = _arg_1;
            this.mStreetDataMap = _arg_2;
        }

        public function visitBuildingsByName(_arg_1:cGeneralInterface, _arg_2:BuildingVisitorInterface, _arg_3:String, _arg_4:String):void
        {
            var _local_6:cBuilding;
            var _local_5:Vector.<cBuilding> = this.mStreetDataMap.getBuildingsByName_vector(_arg_3);
            if (_local_5 == null)
            {
                return;
            };
            for each (_local_6 in _local_5)
            {
                if (null != _local_6)
                {
                    if (_local_6.getPlayerID() == this.mPlayerID)
                    {
                        if (!((_local_6.IsInConstructionMode()) || (_local_6.IsInDestruction())))
                        {
                            if (!_arg_2.visitBuilding(_arg_1, _local_6, _arg_4)) break;
                        };
                    };
                };
            };
        }


    }
}
