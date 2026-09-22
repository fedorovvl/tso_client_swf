package Communication.VO
{
    import Communication.VO.Votes.dPlayerVoteItemVO;
    import mx.collections.ArrayCollection;

    public class dPlayerVotePoolVO 
    {

        public var availablePoolID:int;
        public var name:String;
        public var playerVoteItemVO:dPlayerVoteItemVO;
        public var poolID:int;

        public var voteItems:ArrayCollection = new ArrayCollection();
        public var votes:ArrayCollection = new ArrayCollection();


    }
}
