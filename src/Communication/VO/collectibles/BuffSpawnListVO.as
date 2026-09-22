package Communication.VO.collectibles
{
    import Collections.CollectionsLootTableGroup;
    import __AS3__.vec.Vector;

    public class BuffSpawnListVO 
    {

        private var buffLootTables:CollectionsLootTableGroup;
        private var pickupCount:Vector.<int>;

        public function BuffSpawnListVO(_arg_1:CollectionsLootTableGroup, _arg_2:Vector.<int>)
        {
            super();
            this.buffLootTables = _arg_1;
            this.pickupCount = _arg_2;
        }

        public function getBuffLootTables():CollectionsLootTableGroup
        {
            return (this.buffLootTables);
        }

        public function getPickupCount():Vector.<int>
        {
            return (this.pickupCount);
        }


    }
}
