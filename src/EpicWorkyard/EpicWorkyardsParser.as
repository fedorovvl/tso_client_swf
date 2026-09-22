package EpicWorkyard
{
    import flash.utils.Dictionary;
    import nLib.cXML;
    import __AS3__.vec.Vector;
    import Communication.VO.epicWorkyard.PositionVO;
    import Communication.VO.epicWorkyard.EpicWorkyardVO;
    import Communication.VO.epicWorkyard.ChainGroupVO;
    import Communication.VO.epicWorkyard.ChainVO;
    import nLib.gMisc;
    import __AS3__.vec.*;

    public class EpicWorkyardsParser 
    {

        private static const NAME_ELEMENT_EPICWORKYARDS:String = "epicWorkyards";
        private static const NAME_ELEMENT_POSITIONS:String = "positions";
        private static const NAME_POSITION_NAME:String = "name";
        private static const NAME_POSITION_X:String = "x";
        private static const NAME_POSITION_Y:String = "y";
        private static const NAME_POSITION_ICON_X:String = "iconX";
        private static const NAME_POSITION_ICON_Y:String = "iconY";
        private static const NAME_EPICWORKYARD_BUILDING_ID:String = "buildingId";
        private static const NAME_EPICWORKYARD_AUTOUPGRADE:String = "autoupgrade";
        private static const NAME_EPICWORKYARD_SUBBUILDINGS:String = "subBuildings";
        private static const NAME_EPICWORKYARD_SUBBUILDING_POSITIONS:String = "subBuildingPositions";
        private static const NAME_EPICWORKYARD_GROUP_CHAIN_DISPLAYED_CHAINS:String = "displayedChains";
        private static const NAME_EPICWORKYARD_GROUP_CHAIN_SHOW_QUEST_INACTIVE:String = "showWithQuestInactive";
        private static const NAME_EPICWORKYARD_CHAIN_SUBBUILDING_ID:String = "subBuildingId";
        private static const NAME_EPICWORKYARD_CHAIN_TOOLTIP_LOCA:String = "unlockToolTipLoca";
        private static const NAME_EPICWORKYARD_CHAIN_REQUIREMENT_QUEST:String = "requirementQuest";
        private static const NAME_EPICWORKYARD_CHAIN_REQUIREMENT_LEVEL:String = "requirementLevel";
        private static const NAME_EPICWORKYARD_CHAIN_RANK:String = "rank";

        private var mEpicWorkyards:Dictionary = new Dictionary();
        private var mPositions:Dictionary = new Dictionary();
        private var mEpicSubBuildings:Dictionary = new Dictionary();

        public function EpicWorkyardsParser(_arg_1:cXML)
        {
            super();
            this.parseXML(_arg_1);
        }

        private function parseEpicWorkyards(_arg_1:cXML):void
        {
            var _local_3:cXML;
            var _local_4:Vector.<PositionVO>;
            var _local_5:String;
            var _local_6:Array;
            var _local_7:String;
            var _local_8:EpicWorkyardVO;
            var _local_9:Vector.<cXML>;
            var _local_10:cXML;
            var _local_11:PositionVO;
            var _local_12:ChainGroupVO;
            var _local_13:Vector.<cXML>;
            var _local_14:cXML;
            var _local_15:ChainVO;
            var _local_2:Vector.<cXML> = _arg_1.CreateChildrenArray();
            for each (_local_3 in _local_2)
            {
                _local_4 = new Vector.<PositionVO>();
                _local_5 = _local_3.GetAttributeString_string(NAME_EPICWORKYARD_SUBBUILDING_POSITIONS);
                _local_6 = _local_5.split(",");
                for each (_local_7 in _local_6)
                {
                    _local_11 = this.mPositions[_local_7];
                    if (_local_11 == null)
                    {
                        gMisc.Assert(false, (('Not found sub-building position "' + _local_7) + '" while parsing EpicWorkyard in epic_workyard_definitions.xml'));
                    };
                    _local_4.push(_local_11);
                };
                _local_8 = new EpicWorkyardVO(_local_3.GetAttributeString_string(NAME_EPICWORKYARD_BUILDING_ID), (_local_3.GetAttributeFloatingPoint(NAME_EPICWORKYARD_SUBBUILDINGS) as int), _local_4, _local_3.GetAttributeBool(NAME_EPICWORKYARD_AUTOUPGRADE));
                _local_9 = _local_3.CreateChildrenArray();
                for each (_local_10 in _local_9)
                {
                    _local_12 = new ChainGroupVO(_local_10.GetAttributeBool(NAME_EPICWORKYARD_GROUP_CHAIN_SHOW_QUEST_INACTIVE), _local_10.GetAttributeInt(NAME_EPICWORKYARD_GROUP_CHAIN_DISPLAYED_CHAINS), _local_10.GetAttributeString_string(NAME_EPICWORKYARD_CHAIN_SUBBUILDING_ID));
                    _local_13 = _local_10.CreateChildrenArray();
                    for each (_local_14 in _local_13)
                    {
                        _local_15 = new ChainVO(_local_12.getSubbuildingId(), _local_14.GetAttributeInt(NAME_EPICWORKYARD_CHAIN_RANK), _local_14.GetAttributeInt(NAME_EPICWORKYARD_CHAIN_REQUIREMENT_LEVEL), _local_14.GetAttributeString_string(NAME_EPICWORKYARD_CHAIN_REQUIREMENT_QUEST), _local_14.GetAttributeString_string(NAME_EPICWORKYARD_CHAIN_TOOLTIP_LOCA));
                        _local_12.addChain(_local_15);
                        if (!this.mEpicSubBuildings.hasOwnProperty(_local_15.getName()))
                        {
                            this.mEpicSubBuildings[_local_15.getName()] = _local_15;
                        };
                    };
                    _local_12.createRankedChains();
                    _local_8.addChainGroup(_local_12);
                };
                this.mEpicWorkyards[_local_8.getName()] = _local_8;
            };
        }

        private function parseXML(_arg_1:cXML):void
        {
            this.parsePositions(_arg_1.MoveToSubNode(NAME_ELEMENT_POSITIONS));
            this.parseEpicWorkyards(_arg_1.MoveToSubNode(NAME_ELEMENT_EPICWORKYARDS));
        }

        private function parsePositions(_arg_1:cXML):void
        {
            var _local_3:cXML;
            var _local_4:PositionVO;
            var _local_2:Vector.<cXML> = _arg_1.CreateChildrenArray();
            for each (_local_3 in _local_2)
            {
                _local_4 = new PositionVO(_local_3.GetAttributeString_string(NAME_POSITION_NAME), _local_3.GetAttributeFloatingPoint(NAME_POSITION_X), _local_3.GetAttributeFloatingPoint(NAME_POSITION_Y), _local_3.GetAttributeInt(NAME_POSITION_ICON_X), _local_3.GetAttributeInt(NAME_POSITION_ICON_Y));
                this.mPositions[_local_4.getName()] = _local_4;
            };
        }

        public function buildEpicWorkyardsManager():EpicWorkyardsManager
        {
            return (new EpicWorkyardsManager(this.mEpicWorkyards, this.mEpicSubBuildings));
        }


    }
}
