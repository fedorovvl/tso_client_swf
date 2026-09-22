package EpicWorkyard
{
    import Utils.HashMapWrapper;
    import flash.utils.Dictionary;
    import Communication.VO.epicWorkyard.EpicWorkyardVO;
    import Communication.VO.epicWorkyard.ChainGroupVO;
    import __AS3__.vec.Vector;
    import Interface.cGeneralInterface;
    import GO.epicWorkyard.EpicWorkyardSubBuilding;
    import Communication.VO.epicWorkyard.ChainVO;
    import Communication.VO.epicWorkyard.PositionVO;

    public class EpicWorkyardsManager 
    {

        private static var singletonInstance:EpicWorkyardsManager = null;

        private var mSubBuildingToChainGroup:HashMapWrapper = new HashMapWrapper();
        private var mSubBuildingToMaster:HashMapWrapper = new HashMapWrapper();
        private var mEpicMasterBuildings:Dictionary;
        private var mEpicSubBuildings:Dictionary;

        public function EpicWorkyardsManager(_arg_1:Dictionary, _arg_2:Dictionary)
        {
            var _local_3:EpicWorkyardVO;
            var _local_4:ChainGroupVO;
            super();
            this.mEpicMasterBuildings = _arg_1;
            this.mEpicSubBuildings = _arg_2;
            for each (_local_3 in this.mEpicMasterBuildings)
            {
                for each (_local_4 in _local_3.getChainGroups())
                {
                    this.mSubBuildingToMaster.putItem(_local_4.getSubbuildingId(), _local_3.getName());
                    this.mSubBuildingToChainGroup.putItem(_local_4.getSubbuildingId(), _local_4);
                };
            };
        }

        public static function getInstance():EpicWorkyardsManager
        {
            return (singletonInstance);
        }

        public static function setInstance(_arg_1:EpicWorkyardsManager):void
        {
            singletonInstance = _arg_1;
        }


        public function getRequiredQuestsByChain_vector(_arg_1:String):Vector.<String>
        {
            if (!this.getIsEpicSubBuilding(_arg_1))
            {
                return (null);
            };
            var _local_2:ChainGroupVO = (this.mSubBuildingToChainGroup.getItem(_arg_1) as ChainGroupVO);
            if (_local_2 == null)
            {
                return (null);
            };
            return (_local_2.getQuestNames_vector());
        }

        public function getRankedProductionChainsForBuilding(_arg_1:String, _arg_2:cGeneralInterface, _arg_3:EpicWorkyardSubBuilding):Vector.<ChainVO>
        {
            var _local_4:EpicWorkyardVO = this.mEpicMasterBuildings[_arg_1];
            if (_local_4 != null)
            {
                return (_local_4.getRankedProductionChains(_arg_2, _arg_3));
            };
            return (null);
        }

        public function getSubBuildingPositions(_arg_1:String):Vector.<PositionVO>
        {
            var _local_2:EpicWorkyardVO = this.getEpicMasterBuilding(_arg_1);
            if (_local_2 == null)
            {
                return (null);
            };
            return ((this.mEpicMasterBuildings[_arg_1] as EpicWorkyardVO).getSubBuildingPositions());
        }

        public function getMasterBuildings():Dictionary
        {
            return (this.mEpicMasterBuildings);
        }

        public function getIsEpicSubBuilding(_arg_1:String):Boolean
        {
            return (this.mEpicSubBuildings.hasOwnProperty(_arg_1));
        }

        private function getEpicMasterBuilding(_arg_1:String):EpicWorkyardVO
        {
            return (this.mEpicMasterBuildings[_arg_1]);
        }

        public function getIsEpicMasterBuilding(_arg_1:String):Boolean
        {
            return (this.mEpicMasterBuildings.hasOwnProperty(_arg_1));
        }

        public function getHighestRankAvailable(_arg_1:cGeneralInterface, _arg_2:String, _arg_3:String):int
        {
            var _local_4:EpicWorkyardVO = this.mEpicMasterBuildings[_arg_2];
            if (_local_4 == null)
            {
                return (0);
            };
            return (_local_4.getHighestRankAvailable(_arg_1, _arg_3));
        }

        public function getResourceCreationBuildingNameForMasterBuilding(_arg_1:String):String
        {
            var _local_2:EpicWorkyardVO = this.getEpicMasterBuilding(_arg_1);
            if (_local_2 != null)
            {
                return (_local_2.getResourceCreationBuildingName());
            };
            return (null);
        }

        public function getChainAvailable(_arg_1:cGeneralInterface, _arg_2:String, _arg_3:String, _arg_4:int):Boolean
        {
            var _local_5:EpicWorkyardVO = this.mEpicMasterBuildings[_arg_2];
            if (_local_5 == null)
            {
                return (false);
            };
            return (_local_5.getChainAvailable(_arg_1, _arg_3, _arg_4));
        }

        public function getMasterBuildingBySubBuilding_string(_arg_1:String):String
        {
            return (String(this.mSubBuildingToMaster.getItem(_arg_1)));
        }


    }
}
