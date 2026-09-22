package Communication.VO.epicWorkyard
{
    import __AS3__.vec.Vector;
    import ServerState.dResourceCreationDefinition;
    import ServerState.gEconomics;
    import Interface.cGeneralInterface;
    import GO.epicWorkyard.EpicWorkyardSubBuilding;
    import __AS3__.vec.*;

    public class EpicWorkyardVO 
    {

        private var mAutoupgrade:Boolean;
        private var mSubBuildingPositions:Vector.<PositionVO>;
        private var mChainGroups:Vector.<ChainGroupVO>;
        private var mBuildingName:String;
        private var mSubBuildings:int;

        public function EpicWorkyardVO(_arg_1:String, _arg_2:int, _arg_3:Vector.<PositionVO>, _arg_4:Boolean)
        {
            super();
            this.mBuildingName = _arg_1;
            this.mSubBuildings = _arg_2;
            this.mSubBuildingPositions = _arg_3;
            this.mChainGroups = new Vector.<ChainGroupVO>();
            this.mAutoupgrade = _arg_4;
        }

        public function getName():String
        {
            return (this.mBuildingName);
        }

        public function getResourceCreationBuildingName():String
        {
            var _local_1:ChainGroupVO;
            var _local_2:dResourceCreationDefinition;
            var _local_3:Vector.<ChainVO>;
            var _local_4:ChainVO;
            for each (_local_1 in this.mChainGroups)
            {
                _local_2 = gEconomics.GetResourcesCreationDefinitionForBuilding(_local_1.getSubbuildingId());
                if (_local_2.externalResource_string == "")
                {
                    _local_3 = _local_1.getChains();
                    _local_4 = _local_3[0];
                    return (_local_4.getName());
                };
            };
            if (this.mChainGroups.length > 0)
            {
                return (this.mChainGroups[0].getChains()[0].getName());
            };
            return (null);
        }

        public function getSubBuildingPositions():Vector.<PositionVO>
        {
            return (this.mSubBuildingPositions);
        }

        public function isAutoupgrade():Boolean
        {
            return (this.mAutoupgrade);
        }

        public function getChainGroups():Vector.<ChainGroupVO>
        {
            return (this.mChainGroups);
        }

        public function getHighestRankAvailable(_arg_1:cGeneralInterface, _arg_2:String):int
        {
            var _local_4:ChainGroupVO;
            var _local_5:ChainVO;
            var _local_3:int;
            for each (_local_4 in this.mChainGroups)
            {
                if (_local_4.getSubbuildingId() == _arg_2)
                {
                    for each (_local_5 in _local_4.getChains())
                    {
                        if (_local_5.getIsUnlocked(_arg_1))
                        {
                            _local_3 = _local_5.getRank();
                        }
                        else
                        {
                            break;
                        };
                    };
                    break;
                };
            };
            return (_local_3);
        }

        public function getSubBuildings():int
        {
            return (this.mSubBuildings);
        }

        public function addChainGroup(_arg_1:ChainGroupVO):void
        {
            this.mChainGroups.push(_arg_1);
        }

        public function getRankedProductionChains(_arg_1:cGeneralInterface, _arg_2:EpicWorkyardSubBuilding):Vector.<ChainVO>
        {
            var _local_4:ChainGroupVO;
            var _local_3:Vector.<ChainVO> = new Vector.<ChainVO>();
            for each (_local_4 in this.mChainGroups)
            {
                _local_3 = _local_3.concat(_local_4.getAvailableRankedChains(_arg_1, _arg_2));
            };
            return (_local_3);
        }

        public function getChainAvailable(_arg_1:cGeneralInterface, _arg_2:String, _arg_3:int):Boolean
        {
            var _local_4:ChainGroupVO;
            var _local_5:ChainVO;
            for each (_local_4 in this.mChainGroups)
            {
                if (_local_4.getSubbuildingId() == _arg_2)
                {
                    for each (_local_5 in _local_4.getChains())
                    {
                        if (_local_5.getRank() == _arg_3)
                        {
                            return (_local_5.getIsUnlocked(_arg_1));
                        };
                    };
                };
            };
            return (false);
        }


    }
}
