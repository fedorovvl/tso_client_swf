package Communication.VO.Guild
{
    public class dGuildBankTransactionVO 
    {

        public var player:String;
        public var transactionType:int;
        public var amount:int;
        public var time:Number;
        public var guildID:int;
        public var tabName:String;
        public var tabID:int;
        public var targetTabName:String;
        public var groupType:int;
        public var description:String;
        public var targetTabID:int;


        public function cloneDGuildBankTransactionVO():dGuildBankTransactionVO
        {
            var _local_1:dGuildBankTransactionVO = new dGuildBankTransactionVO();
            _local_1.tabID = this.tabID;
            _local_1.description = this.description;
            _local_1.time = this.time;
            _local_1.player = this.player;
            _local_1.amount = this.amount;
            _local_1.transactionType = this.transactionType;
            _local_1.groupType = this.groupType;
            _local_1.tabName = this.tabName;
            _local_1.targetTabID = this.targetTabID;
            _local_1.targetTabName = this.targetTabName;
            return (_local_1);
        }


    }
}
