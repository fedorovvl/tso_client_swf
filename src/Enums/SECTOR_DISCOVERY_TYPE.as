package Enums
{
    public class SECTOR_DISCOVERY_TYPE 
    {

        public static const UNEXPLORED:int = 0;
        public static const RESERVED:int = 1;
        public static const EXPLORED:int = 2;
        public static const ACTIVATED_BY_BUFF:int = 3;


        public static function toString(_arg_1:int):String
        {
            switch (_arg_1)
            {
                case UNEXPLORED:
                    return ("Unexplored");
                case RESERVED:
                    return ("Reserved");
                case EXPLORED:
                    return ("Explored");
                case ACTIVATED_BY_BUFF:
                    return ("ActivatedByBuff");
                default:
                    return ("Unknown: " + _arg_1);
            };
        }

        public static function isExplored(_arg_1:int):Boolean
        {
            return (_arg_1 >= EXPLORED);
        }


    }
}
