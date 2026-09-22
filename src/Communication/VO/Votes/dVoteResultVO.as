package Communication.VO.Votes
{
    public class dVoteResultVO 
    {

        public var availablePoolID:int;
        public var voteID:int;
        public var batchRoundID:int;
        public var itemID:int;
        public var poolID:int;
        public var percentage:int;


        public static function PercentageDescComparator(_arg_1:dVoteResultVO, _arg_2:dVoteResultVO):int
        {
            if (_arg_2.percentage != _arg_1.percentage)
            {
                return (_arg_2.percentage - _arg_1.percentage);
            };
            return (_arg_1.itemID - _arg_2.itemID);
        }


        public function isEqual(_arg_1:dVoteResultVO):Boolean
        {
            if ((((((((!(_arg_1 == null)) && (this.voteID == _arg_1.voteID)) && (this.availablePoolID == _arg_1.availablePoolID)) && (this.batchRoundID == _arg_1.batchRoundID)) && (this.itemID == _arg_1.itemID)) && (this.percentage == _arg_1.percentage)) && (this.poolID == _arg_1.poolID)))
            {
                return (true);
            };
            return (false);
        }

        public function Clone():dVoteResultVO
        {
            var _local_1:dVoteResultVO = new dVoteResultVO();
            _local_1.voteID = this.voteID;
            _local_1.availablePoolID = this.availablePoolID;
            _local_1.batchRoundID = this.batchRoundID;
            _local_1.itemID = this.itemID;
            _local_1.percentage = this.percentage;
            _local_1.poolID = this.poolID;
            return (_local_1);
        }


    }
}
