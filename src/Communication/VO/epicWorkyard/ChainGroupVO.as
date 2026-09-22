package Communication.VO.epicWorkyard
{
    import __AS3__.vec.Vector;
    import Utils.StringUtils;
    import Interface.cGeneralInterface;
    import GO.epicWorkyard.EpicWorkyardSubBuilding;
    import __AS3__.vec.*;

    public class ChainGroupVO 
    {

        private var showWithQuestInactive:Boolean;
        private var subBuildingId:String;
        private var chains:Vector.<ChainVO>;
        private var displayedChains:int;
        private var rankedChains:Vector.<ChainVO>;

        public function ChainGroupVO(_arg_1:Boolean, _arg_2:int, _arg_3:String)
        {
            super();
            this.showWithQuestInactive = _arg_1;
            this.displayedChains = _arg_2;
            this.subBuildingId = _arg_3;
            this.chains = new Vector.<ChainVO>();
        }

        public function addChain(_arg_1:ChainVO):void
        {
            this.chains.push(_arg_1);
        }

        public function getChains():Vector.<ChainVO>
        {
            return (this.chains);
        }

        public function getQuestNames_vector():Vector.<String>
        {
            var _local_2:ChainVO;
            var _local_1:Vector.<String> = new Vector.<String>();
            for each (_local_2 in this.getChains())
            {
                if (!StringUtils.isEmpty(_local_2.getRequirementQuest_string()))
                {
                    _local_1.push(_local_2.getRequirementQuest_string());
                };
            };
            return (_local_1);
        }

        public function getAvailableRankedChains(_arg_1:cGeneralInterface, _arg_2:EpicWorkyardSubBuilding):Vector.<ChainVO>
        {
            var _local_5:int;
            var _local_11:ChainVO;
            var _local_3:int = this.rankedChains.length;
            var _local_4:int = (_local_3 - 1);
            var _local_6:int;
            var _local_7:Vector.<ChainVO> = new Vector.<ChainVO>();
            var _local_8:Boolean;
            var _local_9:Boolean = ((!(_arg_2 == null)) && (_arg_2.GetBuildingName_string() == this.subBuildingId));
            var _local_10:Boolean;
            while (_local_4 >= 0)
            {
                if (this.rankedChains[_local_4].getIsUnlocked(_arg_1))
                {
                    _local_7.push(this.rankedChains[_local_4]);
                    _local_6++;
                    if (((_local_9) && (this.rankedChains[_local_4].getChainIsEquivalentToBuilding(_arg_2))))
                    {
                        _local_10 = true;
                    };
                    if (this.displayedChains > 0)
                    {
                        _local_5 = (_local_4 + 1);
                        while (_local_5 < _local_3)
                        {
                            _local_7.push(this.rankedChains[_local_5]);
                            _local_6++;
                            if (((_local_9) && (this.rankedChains[_local_4].getChainIsEquivalentToBuilding(_arg_2))))
                            {
                                _local_10 = true;
                            };
                            if (_local_6 >= this.displayedChains) break;
                            _local_5++;
                        };
                    };
                    if (((_local_9) && (!(_local_10))))
                    {
                        _local_5 = 0;
                        while (_local_5 < _local_3)
                        {
                            if (this.rankedChains[_local_5].getChainIsEquivalentToBuilding(_arg_2))
                            {
                                _local_10 = true;
                                _local_7.unshift(this.rankedChains[_local_5]);
                                break;
                            };
                            _local_5++;
                        };
                    };
                    _local_8 = true;
                    break;
                };
                if (_local_8) break;
                _local_4--;
            };
            if (!_local_8)
            {
                _local_11 = this.rankedChains[0];
                if (((this.showWithQuestInactive) || ((_local_11.getRequirementsAvailable(_arg_1)) && (this.displayedChains > 0))))
                {
                    _local_7.push(this.rankedChains[0]);
                };
            };
            return (_local_7);
        }

        public function createRankedChains():void
        {
            this.rankedChains = this.chains.sort(ChainRankComparator.compare);
        }

        public function getSubbuildingId():String
        {
            return (this.subBuildingId);
        }


    }
}
