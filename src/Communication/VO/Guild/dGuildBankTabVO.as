package Communication.VO.Guild
{
    import mx.collections.ArrayCollection;
    import Communication.VO.dResourceVO;
    import Communication.VO.dBuffVO;

    public class dGuildBankTabVO 
    {

        public var name:String;
        public var resources_vector:ArrayCollection = new ArrayCollection();
        public var guildBankBuffs:ArrayCollection = new ArrayCollection();
        public var maxResource:int;
        public var currMaxSizeUpdate:int;
        public var guildID:int;
        public var maxBuff:int;
        public var isPaymentTab:Boolean;
        public var id:int;
        public var hasAccess:Boolean;


        public function cloneDGuildBankTabVO():dGuildBankTabVO
        {
            var _local_2:dResourceVO;
            var _local_3:dBuffVO;
            var _local_1:dGuildBankTabVO = new dGuildBankTabVO();
            _local_1.id = this.id;
            _local_1.name = this.name;
            _local_1.maxResource = this.maxResource;
            _local_1.maxBuff = this.maxBuff;
            _local_1.guildID = this.guildID;
            _local_1.currMaxSizeUpdate = this.currMaxSizeUpdate;
            _local_1.isPaymentTab = this.isPaymentTab;
            if (this.resources_vector != null)
            {
                for each (_local_2 in this.resources_vector)
                {
                    _local_1.resources_vector.addItem(_local_2);
                };
            };
            if (this.guildBankBuffs != null)
            {
                for each (_local_3 in this.guildBankBuffs)
                {
                    _local_1.guildBankBuffs.addItem(_local_3);
                };
            };
            return (_local_1);
        }


    }
}
