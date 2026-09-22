package Communication.VO.collectibles
{
    import __AS3__.vec.Vector;
    import __AS3__.vec.*;

    public class CollectionResourceDefinitionVO 
    {

        private var requiredPlayerLevelMax:int;
        private var name:String;
        private var requiredPlayerLevelMin:int;
        private var rarity:int;
        private var buildings:Vector.<CollectionResourceDefinitionBuildingVO>;

        public function CollectionResourceDefinitionVO(_arg_1:String, _arg_2:Vector.<CollectionResourceDefinitionBuildingVO>, _arg_3:int, _arg_4:int, _arg_5:int)
        {
            super();
            this.name = _arg_1;
            this.buildings = _arg_2;
            this.rarity = _arg_3;
            this.requiredPlayerLevelMin = _arg_4;
            this.requiredPlayerLevelMax = _arg_5;
        }

        public function getName():String
        {
            return (this.name);
        }

        public function getRequiredPlayerLevelMin():int
        {
            return (this.requiredPlayerLevelMin);
        }

        public function getRequiredPlayerLevelMax():int
        {
            return (this.requiredPlayerLevelMax);
        }

        public function getRarity():int
        {
            return (this.rarity);
        }

        public function getBuildings():Vector.<CollectionResourceDefinitionBuildingVO>
        {
            return (this.buildings);
        }

        public function getBuildingsForLootTableGroup(_arg_1:String):Vector.<CollectionResourceDefinitionBuildingVO>
        {
            var _local_3:CollectionResourceDefinitionBuildingVO;
            var _local_2:Vector.<CollectionResourceDefinitionBuildingVO> = new Vector.<CollectionResourceDefinitionBuildingVO>();
            for each (_local_3 in this.buildings)
            {
                if (_local_3.getHasAssociatedLootTable(_arg_1))
                {
                    _local_2.push(_local_3);
                };
            };
            return (_local_2);
        }


    }
}
