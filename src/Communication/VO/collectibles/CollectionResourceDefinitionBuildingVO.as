package Communication.VO.collectibles
{
    import Collections.CollectionsConsts;

    public class CollectionResourceDefinitionBuildingVO 
    {

        private var type:String;
        private var name:String;
        private var associatedLootTables:Array;
        private var locaExtension:String;

        public function CollectionResourceDefinitionBuildingVO(_arg_1:String, _arg_2:String, _arg_3:Array, _arg_4:String)
        {
            super();
            this.name = _arg_1;
            this.type = _arg_2;
            this.associatedLootTables = _arg_3;
            this.locaExtension = _arg_4;
        }

        public function getName():String
        {
            return (this.name);
        }

        public function getLocaExtension_string():String
        {
            return (this.locaExtension);
        }

        public function getType():String
        {
            return (this.type);
        }

        public function getAssociatedLootTables():Array
        {
            return (this.associatedLootTables);
        }

        public function getHasAssociatedLootTable(_arg_1:String):Boolean
        {
            var _local_2:String;
            for each (_local_2 in this.associatedLootTables)
            {
                if (((_local_2 == _arg_1) || (_local_2 == CollectionsConsts.COLLECTIBLE_LOOT_TABLE_ALL)))
                {
                    return (true);
                };
            };
            return (false);
        }


    }
}
