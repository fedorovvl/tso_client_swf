package Communication.VO.collectibles
{
    import Collections.CollectionsLootTableGroup;
    import __AS3__.vec.Vector;

    public class SpawnListVO 
    {

        private var lootTableGroup:CollectionsLootTableGroup;
        private var name:String;
        private var spawnListZones:Vector.<SpawnListZoneVO>;

        public function SpawnListVO(_arg_1:String, _arg_2:Vector.<SpawnListZoneVO>, _arg_3:CollectionsLootTableGroup)
        {
            super();
            this.name = _arg_1;
            this.spawnListZones = _arg_2;
            this.lootTableGroup = _arg_3;
        }

        public function getName():String
        {
            return (this.name);
        }

        public function getListZones():Vector.<SpawnListZoneVO>
        {
            return (this.spawnListZones);
        }

        public function getLootTableGroup():CollectionsLootTableGroup
        {
            return (this.lootTableGroup);
        }


    }
}
