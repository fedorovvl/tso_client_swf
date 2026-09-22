package Communication.VO.collectibles
{
    import __AS3__.vec.Vector;
    import nLib.gMisc;
    import __AS3__.vec.*;

    public class PickupVO 
    {

        private var resourceName:String;
        private var chance:int;
        private var max:int;
        private var min:int;
        private var buildingNamesLength:int;
        private var buildingNames:Vector.<String>;

        public function PickupVO(_arg_1:Vector.<CollectionResourceDefinitionBuildingVO>, _arg_2:String, _arg_3:int, _arg_4:int, _arg_5:int)
        {
            super();
            this.parseBuildingNames(_arg_1);
            this.resourceName = _arg_2;
            this.min = _arg_3;
            this.max = _arg_4;
            this.chance = _arg_5;
        }

        private function parseBuildingNames(_arg_1:Vector.<CollectionResourceDefinitionBuildingVO>):void
        {
            var _local_2:CollectionResourceDefinitionBuildingVO;
            this.buildingNames = new Vector.<String>();
            for each (_local_2 in _arg_1)
            {
                this.buildingNames.push(_local_2.getName());
            };
            this.buildingNamesLength = this.buildingNames.length;
        }

        public function getMaxAmount():int
        {
            return (this.max);
        }

        public function getChance():int
        {
            return (this.chance);
        }

        public function getMinAmount():int
        {
            return (this.min);
        }

        public function hasBuildingName(_arg_1:String):Boolean
        {
            var _local_2:String;
            for each (_local_2 in this.buildingNames)
            {
                if (_arg_1 == _local_2)
                {
                    return (true);
                };
            };
            return (false);
        }

        public function getResourceName():String
        {
            return (this.resourceName);
        }

        public function getRandomBuildingName():String
        {
            if (this.buildingNamesLength > 1)
            {
                return (this.buildingNames[gMisc.GetRandomValueMinMaxInt(0, (this.buildingNamesLength - 1))]);
            };
            return (this.buildingNames[0]);
        }


    }
}
