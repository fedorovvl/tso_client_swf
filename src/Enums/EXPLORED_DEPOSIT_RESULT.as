package Enums
{
    public class EXPLORED_DEPOSIT_RESULT 
    {

        public static const PENDING:int = 0;
        public static const FOUND:int = 1;
        public static const NO_DEPOSIT_IN_SECTORS:int = 2;
        public static const ALL_DEPOSITS_ACCESSIBLE:int = 3;
        public static const FAIL_OVERRIDE_DEPOSIT_FOUND:int = 4;


        public static function toString(_arg_1:int):String
        {
            switch (_arg_1)
            {
                case PENDING:
                    return ("Pending");
                case FOUND:
                    return ("Found");
                case NO_DEPOSIT_IN_SECTORS:
                    return ("NoDepositInSectors");
                case ALL_DEPOSITS_ACCESSIBLE:
                    return ("AllDepositsAccessible");
                case FAIL_OVERRIDE_DEPOSIT_FOUND:
                    return ("FailOverrideDepositFound");
                default:
                    return ("Unknown: " + _arg_1);
            };
        }


    }
}
