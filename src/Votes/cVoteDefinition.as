package Votes
{
    import mx.collections.ArrayCollection;
    import nLib.cXML;

    public class cVoteDefinition 
    {

        public var name:String;
        public var votePools:ArrayCollection = new ArrayCollection();
        public var altShopGroup:String;
        public var durationInDays:int;
        public var costGems:int;


        public static function createFromXml(_arg_1:cXML):cVoteDefinition
        {
            var _local_3:cXML;
            var _local_2:cVoteDefinition = new (cVoteDefinition)();
            _local_2.name = _arg_1.GetAttributeString_string("name");
            _local_2.durationInDays = _arg_1.GetAttributeInt("durationInDays");
            _local_2.costGems = _arg_1.GetAttributeInt("costGems");
            _local_2.altShopGroup = _arg_1.GetAttributeString_string("altShopGroup");
            for each (_local_3 in _arg_1.CreateChildrenArray())
            {
                _local_2.votePools.addItem(cVotePoolDefinition.createFromXml(_local_3));
            };
            return (_local_2);
        }


        public function toString():String
        {
            var _local_1:String;
            var _local_2:cVotePoolDefinition;
            _local_1 = ((((((((("<VoteDefinition " + "' name='") + this.name) + "' durationInDays='") + this.durationInDays) + "' costGems='") + this.costGems) + "' altShopGroup='") + this.altShopGroup) + "' >\n");
            for each (_local_2 in this.votePools)
            {
                _local_1 = (_local_1 + (_local_2.toString() + "\n"));
            };
            return (_local_1 + "</VoteDefinition>");
        }

        public function GetVoteDefinitionByName(_arg_1:String):cVotePoolDefinition
        {
            var _local_2:cVotePoolDefinition;
            for each (_local_2 in this.votePools)
            {
                if (_arg_1 == _local_2.name)
                {
                    return (_local_2);
                };
            };
            return (null);
        }


    }
}
