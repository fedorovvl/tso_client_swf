package Communication.VO.Votes
{
    import Communication.VO.dPlayerVotePoolVO;

    public class dPlayerVoteVO 
    {

        public var playerVotePoolVO:dPlayerVotePoolVO;
        public var batchStartTime:Number;
        public var endTime:Number;
        public var name:String;
        public var round:int;
        public var batchRoundID:int;
        public var definitionID:int;
        public var pools:Object = {};
        public var seen:Boolean;
        public var playerID:int;


    }
}
