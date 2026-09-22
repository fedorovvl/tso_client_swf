package Enums
{
    public class ADVENTURE_INVITATION_STATUS 
    {

        public static const PENDING:int = 0;
        public static const ACCEPTED:int = 1;
        public static const DECLINED:int = 2;
        public static const LEFT:int = 3;
        public static const CANCELLED:int = 4;


        public static function toString(_arg_1:int):String
        {
            switch (_arg_1)
            {
                case PENDING:
                    return ("Pending");
                case ACCEPTED:
                    return ("Accepted");
                case DECLINED:
                    return ("Declined");
                case LEFT:
                    return ("Left");
                case CANCELLED:
                    return ("Cancelled");
                default:
                    return ("Unknown: " + _arg_1);
            };
        }

        public static function IsActiveInvitation(_arg_1:int):Boolean
        {
            return ((_arg_1 == PENDING) || (_arg_1 == ACCEPTED));
        }


    }
}
