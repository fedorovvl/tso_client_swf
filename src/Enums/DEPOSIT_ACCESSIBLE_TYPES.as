package Enums
{
    public class DEPOSIT_ACCESSIBLE_TYPES 
    {

        public static const NOT_ACCESSIBLE:int = 0;
        public static const UNUSED:int = 1;
        public static const ACCESSIBLE:int = 2;


        public static function toString(_arg_1:int):String
        {
            switch (_arg_1)
            {
                case NOT_ACCESSIBLE:
                    return ("Not Accessible");
                case UNUSED:
                    return ("Unsed");
                case ACCESSIBLE:
                    return ("Accessible");
                default:
                    return ("Unknown: " + _arg_1);
            };
        }


    }
}
