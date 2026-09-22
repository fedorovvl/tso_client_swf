package Communication.VO.collectibles
{
    import __AS3__.vec.Vector;

    public class LootTableVO 
    {

        private var name:String;
        private var rarity:int;
        private var requiresEventName:String;
        private var totalChance:int;
        private var pickupsVector:Vector.<PickupVO>;

        public function LootTableVO(_arg_1:String, _arg_2:int, _arg_3:String, _arg_4:Vector.<PickupVO>)
        {
            var _local_5:PickupVO;
            super();
            this.name = _arg_1;
            this.rarity = _arg_2;
            this.requiresEventName = _arg_3;
            this.pickupsVector = _arg_4;
            this.totalChance = 0;
            for each (_local_5 in _arg_4)
            {
                this.totalChance = (this.totalChance + _local_5.getChance());
            };
        }

        public function getName():String
        {
            return (this.name);
        }

        public function getTotalChance():int
        {
            return (this.totalChance);
        }

        public function getPickups():Vector.<PickupVO>
        {
            return (this.pickupsVector);
        }

        public function getRarity():int
        {
            return (this.rarity);
        }

        public function getRequiresEventName():String
        {
            if (this.requiresEventName.length > 0)
            {
                return (this.requiresEventName);
            };
            return (null);
        }


    }
}
