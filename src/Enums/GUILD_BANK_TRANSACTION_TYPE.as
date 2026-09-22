package Enums
{
    public final class GUILD_BANK_TRANSACTION_TYPE 
    {

        public static const DONATE:int = 0;
        public static const WITHDRAW:int = 1;
        public static const TRANSFER:int = 2;
        public static const BUY_TAB:int = 3;
        public static const ENLARGE:int = 4;


        public static function toString(_arg_1:int):String
        {
            switch (_arg_1)
            {
                case DONATE:
                    return ("GuildBankDonateHistory");
                case WITHDRAW:
                    return ("GuildBankWithdrawHistory");
                case TRANSFER:
                    return ("GuildBankTransferHistory");
                case BUY_TAB:
                    return ("GuildBankBuyTabHistory");
                case ENLARGE:
                    return ("GuildBankEnlargeHistory");
                default:
                    return ("Unknown: " + _arg_1);
            };
        }


    }
}
