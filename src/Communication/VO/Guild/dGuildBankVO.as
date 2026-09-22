package Communication.VO.Guild
{
    import mx.collections.ArrayCollection;

    public class dGuildBankVO 
    {

        public var currUpdateGem:int;
        public var currUpdateCoin:int;

        public var bankTabs:ArrayCollection = new ArrayCollection();
        public var bankHistory:ArrayCollection = new ArrayCollection();


        public function cloneDGuildBankVO():dGuildBankVO
        {
            var _local_2:dGuildBankTabVO;
            var _local_3:dGuildBankTransactionVO;
            var _local_1:dGuildBankVO = new dGuildBankVO();
            if (this.bankTabs != null)
            {
                for each (_local_2 in this.bankTabs)
                {
                    _local_1.bankTabs.addItem(_local_2.cloneDGuildBankTabVO());
                };
            };
            if (this.bankHistory != null)
            {
                for each (_local_3 in this.bankHistory)
                {
                    _local_1.bankHistory.addItem(_local_3.cloneDGuildBankTransactionVO());
                };
            };
            _local_1.currUpdateCoin = this.currUpdateCoin;
            _local_1.currUpdateGem = this.currUpdateGem;
            return (_local_1);
        }

        public function getPayTab():dGuildBankTabVO
        {
            var _local_1:dGuildBankTabVO;
            for each (_local_1 in this.bankTabs)
            {
                if (_local_1.isPaymentTab)
                {
                    return (_local_1);
                };
            };
            return (null);
        }


    }
}
