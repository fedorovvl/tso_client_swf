package Communication.VO.Guild
{
    import Communication.VO.dPlayerListItemVO;
    import mx.collections.ArrayCollection;

    public class dGuildPlayerListItemVO extends dPlayerListItemVO 
    {

        [Transient]
        public var questsStatus:int;
        public var rankID:int;
        public var officerNote:String;
        public var quest:dGuildQuestVO;
        public var adventures:ArrayCollection;
        public var onlineLast24:Boolean;
        public var dbSuccessorOrder:int;
        public var successorOrder:int;
        public var isLookingForHelp:Boolean;
        public var note:String;
        public var lastUserAction:Number;


    }
}
