package Enums
{
    public class ADVENT_CALENDAR_DOOR_REWARD_TYPE 
    {

        public static const NORMAL:int = 0;
        public static const HIDDEN:int = 1;
        public static const SHOW_FIRST:int = 2;


        public static function toString(_arg_1:int):String
        {
            switch (_arg_1)
            {
                case NORMAL:
                    return ("normal");
                case HIDDEN:
                    return ("hidden");
                case SHOW_FIRST:
                    return ("showfirst");
                default:
                    return ("normal");
            };
        }

        public static function Parse(_arg_1:String):int
        {
            _arg_1 = _arg_1.toLowerCase();
            if (_arg_1 == toString(NORMAL))
            {
                return (NORMAL);
            };
            if (_arg_1 == toString(HIDDEN))
            {
                return (HIDDEN);
            };
            if (_arg_1 == toString(SHOW_FIRST))
            {
                return (SHOW_FIRST);
            };
            return (-1);
        }


    }
}
