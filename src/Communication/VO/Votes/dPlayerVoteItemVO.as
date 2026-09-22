package Communication.VO.Votes
{
    public class dPlayerVoteItemVO 
    {

        public var availablePoolId:int;
        public var itemId:int;
        public var batchRoundId:int;


        public static function Create(_arg_1:int, _arg_2:int, _arg_3:int):dPlayerVoteItemVO
        {
            var _local_4:dPlayerVoteItemVO = new (dPlayerVoteItemVO)();
            _local_4.itemId = _arg_1;
            _local_4.availablePoolId = _arg_2;
            _local_4.batchRoundId = _arg_3;
            return (_local_4);
        }


    }
}
