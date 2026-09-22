package GO.epicWorkyard
{
    import Model.Observer;
    import Interface.cGeneralInterface;
    import Model.Notifiers.ZoneChannel;
    import Communication.VO.epicWorkyard.EpicWorkyardVO;
    import EpicWorkyard.EpicWorkyardsManager;
    import flash.utils.Dictionary;
    import Model.Notifier;
    import Communication.VO.epicWorkyard.EpicWorkyardChangeProductionVO;
    import Enums.COMMAND;

    public class EpicWorkyardAutoUpgrader implements Observer 
    {

        private var gi:cGeneralInterface;

        public function EpicWorkyardAutoUpgrader(_arg_1:cGeneralInterface)
        {
            super();
            this.gi = _arg_1;
            _arg_1.channels.REQUIREMENTS.addPropertyObserver("chain", this);
            _arg_1.channels.ZONE.addPropertyObserver(ZoneChannel.LEVELUP, this);
        }

        public function update(_arg_1:Notifier, _arg_2:String, _arg_3:Object):void
        {
            var _local_5:String;
            var _local_6:EpicWorkyardVO;
            var _local_4:Dictionary = EpicWorkyardsManager.getInstance().getMasterBuildings();
            for (_local_5 in _local_4)
            {
                _local_6 = (_local_4[_local_5] as EpicWorkyardVO);
                if (_local_6.isAutoupgrade())
                {
                    this.upgradeWorkyard(_local_6);
                };
            };
        }

        private function upgradeWorkyard(_arg_1:EpicWorkyardVO):void
        {
            var _local_2:EpicWorkyardMasterBuilding;
            var _local_3:EpicWorkyardSubBuilding;
            var _local_4:int;
            if (this.gi.mCurrentPlayerZone.mStreetDataMap != null)
            {
                _local_2 = (this.gi.mCurrentPlayerZone.mStreetDataMap.getBuildingByName(_arg_1.getName()) as EpicWorkyardMasterBuilding);
                if (_local_2 != null)
                {
                    for each (_local_3 in _local_2.getSubBuildings())
                    {
                        _local_4 = EpicWorkyardsManager.getInstance().getHighestRankAvailable(this.gi, _local_2.GetBuildingName_string(), _local_3.GetBuildingName_string());
                        if (_local_4 > _local_3.GetUpgradeLevel())
                        {
                            this.upgradeSubBuilding(_local_3, _local_4);
                        };
                    };
                };
            };
        }

        private function upgradeSubBuilding(_arg_1:EpicWorkyardSubBuilding, _arg_2:int):void
        {
            var _local_3:EpicWorkyardChangeProductionVO = new EpicWorkyardChangeProductionVO();
            _local_3.masterBuildingGridPosition = _arg_1.getMasterBuilding().GetGrid();
            _local_3.subBuildingGridPosition = _arg_1.GetGrid();
            _local_3.productionChainSubBuildingName = _arg_1.GetBuildingName_string();
            _local_3.productionChainSubBuildingRank = _arg_2;
            this.gi.CreateImmediateGameTickCommand(this.gi.mCurrentViewedZoneID, COMMAND.EPIC_WORKYARD_CHANGE_PRODUCTION_CHAIN, _local_3, 0);
        }


    }
}
