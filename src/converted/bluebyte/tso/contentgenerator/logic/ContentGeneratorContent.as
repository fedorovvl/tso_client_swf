package converted.bluebyte.tso.contentgenerator.logic
{
    import __AS3__.vec.Vector;
    import ServerState.dResource;
    import LootTableSystem.cLootTable;
    import Communication.VO.EffectVO;
    import LootTableSystem.cLootTableItemContent;
    import Communication.VO.ContentGenerator.ContentGeneratorContentVO;
    import nLib.cXML;
    import mx.collections.ArrayCollection;
    import __AS3__.vec.*;

    public class ContentGeneratorContent 
    {

        private var icon:String;
        private var name:String;
        private var costs:Vector.<dResource>;
        private var requiresEvent:String;
        private var sortIndex:int;
        public var selected:Boolean;
        private var partName:String;
        private var id:int;
        private var playerLevel:int;
        private var rewards:cLootTable;
        private var partAmount:int;
        private var content:cLootTable;

        public function ContentGeneratorContent(_arg_1:int, _arg_2:String, _arg_3:int, _arg_4:String, _arg_5:int, _arg_6:int, _arg_7:String, _arg_8:cLootTable, _arg_9:Vector.<dResource>, _arg_10:cLootTable, _arg_11:String)
        {
            super();
            this.id = _arg_1;
            this.name = _arg_2;
            this.sortIndex = _arg_3;
            this.partName = _arg_4;
            this.partAmount = _arg_5;
            this.playerLevel = _arg_6;
            this.icon = _arg_7;
            this.content = _arg_8;
            this.costs = _arg_9;
            this.rewards = _arg_10;
            this.requiresEvent = _arg_11;
        }

        public static function createContentFromVO(_arg_1:ContentGeneratorContentVO):ContentGeneratorContent
        {
            var _local_5:EffectVO;
            var _local_6:dResource;
            var _local_7:EffectVO;
            var _local_2:cLootTable = new cLootTable("", "", 0, 0, 0, 0);
            var _local_3:Vector.<dResource> = new Vector.<dResource>();
            var _local_4:cLootTable = new cLootTable("", "", 0, 0, 0, 0);
            for each (_local_5 in _arg_1.loottableItems)
            {
                _local_2.mItemContents_vector.push(cLootTableItemContent.CreateLootTableItemContentFromEffectVO(_local_5));
            };
            for each (_local_6 in _arg_1.costs)
            {
                _local_3.push(_local_6);
            };
            for each (_local_7 in _arg_1.rewards)
            {
                _local_4.mItemContents_vector.push(cLootTableItemContent.CreateLootTableItemContentFromEffectVO(_local_7));
            };
            return (new ContentGeneratorContent(_arg_1.id, _arg_1.name, _arg_1.sortIndex, _arg_1.partName, _arg_1.partAmount, _arg_1.playerLevel, _arg_1.icon, _local_2, _local_3, _local_4, _arg_1.requiresEvent));
        }

        public static function parseXML(_arg_1:cXML):ContentGeneratorContent
        {
            var _local_2:int = _arg_1.GetAttributeInt("id");
            var _local_3:String = _arg_1.GetAttributeString_string("name");
            var _local_4:int = _arg_1.GetAttributeInt("sortIndex");
            var _local_5:String = _arg_1.GetAttributeString_string("partName");
            var _local_6:int = _arg_1.GetAttributeInt("partAmount");
            var _local_7:int = _arg_1.GetAttributeInt("playerLevel");
            var _local_8:String = _arg_1.GetAttributeString_string("icon");
            var _local_9:String = _arg_1.GetAttributeString_string("requiresEvent");
            var _local_10:cLootTable = cLootTable.CreateLootTableFromXml(_arg_1.MoveToSubNode("Content"));
            var _local_11:Vector.<dResource> = gParse.ParseCosts(_arg_1.MoveToSubNode("Costs"));
            var _local_12:cLootTable = cLootTable.CreateLootTableFromXml(_arg_1.MoveToSubNode("Rewards"));
            _local_12.SetChanceItemsAmount(1);
            return (new ContentGeneratorContent(_local_2, _local_3, _local_4, _local_5, _local_6, _local_7, _local_8, _local_10, _local_11, _local_12, _local_9));
        }


        public function getContent():cLootTable
        {
            return (this.content);
        }

        public function getCosts():Vector.<dResource>
        {
            return (this.costs);
        }

        public function getId():int
        {
            return (this.id);
        }

        public function getName():String
        {
            return (this.name);
        }

        public function getVOFromContent():ContentGeneratorContentVO
        {
            var _local_4:cLootTableItemContent;
            var _local_5:dResource;
            var _local_6:cLootTableItemContent;
            var _local_7:ContentGeneratorContentVO;
            var _local_1:ArrayCollection = new ArrayCollection();
            var _local_2:ArrayCollection = new ArrayCollection();
            var _local_3:ArrayCollection = new ArrayCollection();
            for each (_local_4 in this.content.mItemContents_vector)
            {
                _local_1.addItem(_local_4.GetEffectVOFromLootTableItemContent());
            };
            for each (_local_5 in this.costs)
            {
                _local_2.addItem(_local_5.clone());
            };
            for each (_local_6 in this.rewards.mItemContents_vector)
            {
                _local_3.addItem(_local_6.GetEffectVOFromLootTableItemContent());
            };
            _local_7 = new ContentGeneratorContentVO();
            _local_7.Init(this.id, this.name, this.sortIndex, this.partName, this.partAmount, this.playerLevel, this.icon, _local_1, _local_2, _local_3, this.requiresEvent);
            return (_local_7);
        }

        public function getPartAmount():int
        {
            return (this.partAmount);
        }

        public function getSortIndex():int
        {
            return (this.sortIndex);
        }

        public function getPartName():String
        {
            return (this.partName);
        }

        public function getPlayerLevel():int
        {
            return (this.playerLevel);
        }

        public function getRewards():cLootTable
        {
            return (this.rewards);
        }

        public function getIcon():String
        {
            return (this.icon);
        }

        public function GetIsEnabled():Boolean
        {
            var _local_1:Boolean = (((this.getRequiresEvent() == null) || (this.getRequiresEvent() == "")) || (global.ui.mEventManager.isEventStarted(this.getRequiresEvent())));
            var _local_2:* = (this.getPlayerLevel() <= global.ui.mCurrentPlayer.GetPlayerLevel());
            return ((_local_1) && (_local_2));
        }

        public function getRequiresEvent():String
        {
            return (this.requiresEvent);
        }

        public function toString():String
        {
            return (this.name);
        }


    }
}
