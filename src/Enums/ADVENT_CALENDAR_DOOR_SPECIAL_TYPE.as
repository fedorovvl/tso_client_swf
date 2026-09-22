package Enums
{
    import nLib.gMisc;

    public class ADVENT_CALENDAR_DOOR_SPECIAL_TYPE 
    {

        public static const NORMAL:int = 0;
        public static const FINAL_REWARD:int = 1;
        public static const ALL_PREVIOUS_NEEDED:int = 2;
        public static const NO_PREVIOUS_NEEDED:int = 3;


        public static function Parse(_arg_1:String):int
        {
            _arg_1 = _arg_1.toLowerCase();
            if (_arg_1 == toString(NORMAL))
            {
                return (NORMAL);
            };
            if (_arg_1 == toString(FINAL_REWARD))
            {
                return (FINAL_REWARD);
            };
            if (_arg_1 == toString(ALL_PREVIOUS_NEEDED))
            {
                return (ALL_PREVIOUS_NEEDED);
            };
            if (_arg_1 == toString(NO_PREVIOUS_NEEDED))
            {
                return (NO_PREVIOUS_NEEDED);
            };
            gMisc.Assert(false, (("Could not interpret door type string '" + _arg_1) + "'!"));
            return (-1);
        }

        public static function toString(_arg_1:int):String
        {
            switch (_arg_1)
            {
                case NORMAL:
                    return ("normal");
                case FINAL_REWARD:
                    return ("final_reward");
                case ALL_PREVIOUS_NEEDED:
                    return ("all_previous_needed");
                case NO_PREVIOUS_NEEDED:
                    return ("no_previous_needed");
                default:
                    return ("Unknown: " + _arg_1);
            };
        }


    }
}
