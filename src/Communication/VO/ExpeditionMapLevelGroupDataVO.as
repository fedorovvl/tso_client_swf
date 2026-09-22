package Communication.VO
{
    import mx.collections.ArrayCollection;

    public class ExpeditionMapLevelGroupDataVO 
    {

        public var levelMax:int;
        public var tacticPointLimit:int;
        public var troopLimit:int;
        public var levelMin:int;
        public var levelGroup:int;
        public var admiralLimit:int;

        public var mapStartCost:ArrayCollection = new ArrayCollection();
        public var resourceReward:ArrayCollection = new ArrayCollection();


        public static function Create(_arg_1:int, _arg_2:int, _arg_3:int, _arg_4:int, _arg_5:int, _arg_6:int):ExpeditionMapLevelGroupDataVO
        {
            var _local_7:ExpeditionMapLevelGroupDataVO = new (ExpeditionMapLevelGroupDataVO)();
            _local_7.levelGroup = _arg_1;
            _local_7.levelMin = _arg_2;
            _local_7.levelMax = _arg_3;
            _local_7.troopLimit = _arg_4;
            _local_7.admiralLimit = _arg_5;
            _local_7.tacticPointLimit = _arg_6;
            return (_local_7);
        }


        public function GetResourceReward(_arg_1:int):ExpeditionMapLevelGroupResourceRewardVO
        {
            var _local_2:ExpeditionMapLevelGroupResourceRewardVO;
            for each (_local_2 in this.resourceReward)
            {
                if (_local_2.id == _arg_1)
                {
                    return (_local_2);
                };
            };
            return (null);
        }

        public function toString():String
        {
            return (((((((((((('<ExpeditionMapLevelGroupDataVO levelGroup="' + this.levelGroup) + '" levelMin="') + this.levelMin) + '" levelMax="') + this.levelMax) + '" troopLimit="') + this.troopLimit) + '" admiralLimit="') + this.admiralLimit) + '" tacticPointLimit="') + this.tacticPointLimit) + '" />');
        }


    }
}
