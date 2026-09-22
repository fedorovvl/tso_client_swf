package Collections
{
    import Communication.VO.collectibles.SpawnListZoneVO;

    public class CollectionsSpawnZone 
    {

        private var zoneLootTableGroup:CollectionsLootTableGroup;
        private var zone:SpawnListZoneVO;

        public function CollectionsSpawnZone(_arg_1:SpawnListZoneVO, _arg_2:CollectionsLootTableGroup)
        {
            super();
            this.zone = _arg_1;
            this.zoneLootTableGroup = _arg_2;
        }

        public function getZone():SpawnListZoneVO
        {
            return (this.zone);
        }

        public function getLootTableGroup():CollectionsLootTableGroup
        {
            return (this.zoneLootTableGroup);
        }


    }
}
