package Votes
{
    import mx.collections.ArrayCollection;
    import nLib.cXML;
    import ShopSystem.cShopItem;

    public class cVotePoolDefinition 
    {

        public var votesAmount:int;
        public var choicesAmount:int;
        public var name:String;
        public var voteItems:ArrayCollection = new ArrayCollection();
        public var id:int;


        public static function createInstance(_arg_1:String, _arg_2:int, _arg_3:int):cVotePoolDefinition
        {
            var _local_4:cVotePoolDefinition = new (cVotePoolDefinition)();
            _local_4.name = _arg_1;
            _local_4.choicesAmount = _arg_2;
            _local_4.votesAmount = _arg_3;
            return (_local_4);
        }

        public static function createFromXml(_arg_1:cXML):cVotePoolDefinition
        {
            var _local_2:cVotePoolDefinition = new (cVotePoolDefinition)();
            _local_2.id = _arg_1.GetAttributeInt("id");
            _local_2.name = _arg_1.GetAttributeString_string("name");
            _local_2.choicesAmount = _arg_1.GetAttributeInt("choicesAmount");
            _local_2.votesAmount = _arg_1.GetAttributeInt("votesAmount");
            return (_local_2);
        }


        public function toString():String
        {
            var _local_1:String;
            var _local_2:cShopItem;
            _local_1 = (((((((("<VotePoolDefinition id='" + this.id) + "' name='") + this.name) + "' choicesAmount='") + this.choicesAmount) + "' votesAmount='") + this.votesAmount) + "'>\n");
            for each (_local_2 in this.voteItems)
            {
                _local_1 = (_local_1 + (_local_2.toString() + "\n"));
            };
            return (_local_1 + "</VotePoolDefinition>");
        }


    }
}
