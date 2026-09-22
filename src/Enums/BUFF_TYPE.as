package Enums
{
    import nLib.gMisc;

    public class BUFF_TYPE 
    {

        public static const TIMED:int = 0;
        public static const ZONE:int = 1;
        public static const INSTANT:int = 2;
        public static const UPGRADE:int = 3;
        public static const TIMED_HIDDEN:int = 4;
        public static const COMBAT_INSTANT:int = 5;
        public static const COMBAT_TIMED:int = 6;
        public static const WAIT_FOR_ACTION:int = 7;
        public static const ZONE_TIMED:int = 8;
        public static const PERMANENT:int = 9;


        public static function toString(_arg_1:int):String
        {
            switch (_arg_1)
            {
                case TIMED:
                    return ("Timed");
                case INSTANT:
                    return ("Instant");
                case UPGRADE:
                    return ("Upgrade");
                case ZONE:
                    return ("Zone");
                case TIMED_HIDDEN:
                    return ("TimedHidden");
                case COMBAT_INSTANT:
                    return ("CombatInstant");
                case COMBAT_TIMED:
                    return ("CombatTimed");
                case WAIT_FOR_ACTION:
                    return ("WaitForAction");
                case ZONE_TIMED:
                    return ("ZoneTimed");
                case PERMANENT:
                    return ("Permanent");
                default:
                    return ("Unknown: " + _arg_1);
            };
        }

        public static function isVisibleBuff(_arg_1:int):Boolean
        {
            switch (_arg_1)
            {
                case TIMED:
                case ZONE:
                case INSTANT:
                case UPGRADE:
                case WAIT_FOR_ACTION:
                case ZONE_TIMED:
                    return (true);
            };
            return (false);
        }

        public static function Parse(_arg_1:String):int
        {
            if (_arg_1 == toString(TIMED))
            {
                return (TIMED);
            };
            if (_arg_1 == toString(INSTANT))
            {
                return (INSTANT);
            };
            if (_arg_1 == toString(UPGRADE))
            {
                return (UPGRADE);
            };
            if (_arg_1 == toString(ZONE))
            {
                return (ZONE);
            };
            if (_arg_1 == toString(TIMED_HIDDEN))
            {
                return (TIMED_HIDDEN);
            };
            if (_arg_1 == toString(COMBAT_INSTANT))
            {
                return (COMBAT_INSTANT);
            };
            if (_arg_1 == toString(COMBAT_TIMED))
            {
                return (COMBAT_TIMED);
            };
            if (_arg_1 == toString(ZONE_TIMED))
            {
                return (ZONE_TIMED);
            };
            if (_arg_1 == toString(WAIT_FOR_ACTION))
            {
                return (WAIT_FOR_ACTION);
            };
            if (_arg_1 == toString(PERMANENT))
            {
                return (PERMANENT);
            };
            gMisc.Assert(false, (("Could not interpret buff string '" + _arg_1) + "'!"));
            return (-1);
        }


    }
}
