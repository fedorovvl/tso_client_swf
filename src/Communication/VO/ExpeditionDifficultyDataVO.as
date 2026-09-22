package Communication.VO
{
    public class ExpeditionDifficultyDataVO 
    {

        public var rewardAmountAdjustment:Number = 0;
        public var victoryBuff:String = null;
        public var difficulty:int = 0;


        public static function Create(_arg_1:int, _arg_2:String, _arg_3:Number):ExpeditionDifficultyDataVO
        {
            var _local_4:ExpeditionDifficultyDataVO = new (ExpeditionDifficultyDataVO)();
            _local_4.difficulty = _arg_1;
            _local_4.victoryBuff = _arg_2;
            _local_4.rewardAmountAdjustment = _arg_3;
            return (_local_4);
        }


        public function GetRewardAmountAdjustmentPercent():Number
        {
            return (this.rewardAmountAdjustment);
        }

        public function toString():String
        {
            return (((('<ExpeditionDifficultyDataVO difficulty="' + this.difficulty) + '" victoryBuff="') + this.victoryBuff) + '" />');
        }


    }
}
