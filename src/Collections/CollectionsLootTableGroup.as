package Collections
{
    import __AS3__.vec.Vector;
    import Communication.VO.collectibles.LootTableVO;
    import Communication.VO.collectibles.PickupVO;
    import Interface.cGameInterface;
    import __AS3__.vec.*;

    public class CollectionsLootTableGroup 
    {

        private var lootTables:Vector.<LootTableVO>;

        public function CollectionsLootTableGroup()
        {
            super();
            this.lootTables = new Vector.<LootTableVO>();
        }

        public function getPickups(_arg_1:Vector.<int>, _arg_2:cGameInterface):Vector.<PickupVO>
        {
            return (new Vector.<PickupVO>());
        }

        public function addCollectionsLootTable(_arg_1:LootTableVO):void
        {
            this.lootTables.push(_arg_1);
        }

        public function getLootTables():Vector.<LootTableVO>
        {
            return (this.lootTables);
        }

        private function getLootTablesForRarity(_arg_1:int, _arg_2:cGameInterface):Vector.<LootTableVO>
        {
            var _local_4:LootTableVO;
            var _local_3:Vector.<LootTableVO> = new Vector.<LootTableVO>();
            for each (_local_4 in this.lootTables)
            {
                if (_local_4.getRarity() == _arg_1)
                {
                    if (_local_4.getRequiresEventName() != null)
                    {
                        if (_arg_2.mEventManager.isEventStarted(_local_4.getRequiresEventName()))
                        {
                            _local_3.push(_local_4);
                        };
                    }
                    else
                    {
                        _local_3.push(_local_4);
                    };
                };
            };
            return (_local_3);
        }


    }
}
