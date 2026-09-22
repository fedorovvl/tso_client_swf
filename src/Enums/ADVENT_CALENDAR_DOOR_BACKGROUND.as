package Enums
{
    import nLib.gMisc;

    public class ADVENT_CALENDAR_DOOR_BACKGROUND 
    {

        public static const NORMAL:int = 0;
        public static const ADVENT:int = 1;
        public static const CHRISTMAS_EVE:int = 2;
        public static const NEW_YEAR:int = 3;
        public static const WM_EVENT_ADVENTURE:int = 4;
        public static const WM_EVENT_BONUS:int = 5;
        public static const PRESENTS:int = 6;


        public static function toString(_arg_1:int):String
        {
            switch (_arg_1)
            {
                case NORMAL:
                    return ("normal");
                case ADVENT:
                    return ("advent");
                case CHRISTMAS_EVE:
                    return ("christmas_eve");
                case NEW_YEAR:
                    return ("new_year");
                case WM_EVENT_ADVENTURE:
                    return ("wm_event_adventure");
                case WM_EVENT_BONUS:
                    return ("wm_event_bonus");
                case PRESENTS:
                    return ("presents");
                default:
                    return ("Unknown: " + _arg_1);
            };
        }

        public static function Parse(_arg_1:String):int
        {
            _arg_1 = _arg_1.toLowerCase();
            if (_arg_1 == toString(NORMAL))
            {
                return (NORMAL);
            };
            if (_arg_1 == toString(ADVENT))
            {
                return (ADVENT);
            };
            if (_arg_1 == toString(CHRISTMAS_EVE))
            {
                return (CHRISTMAS_EVE);
            };
            if (_arg_1 == toString(NEW_YEAR))
            {
                return (NEW_YEAR);
            };
            if (_arg_1 == toString(WM_EVENT_ADVENTURE))
            {
                return (WM_EVENT_ADVENTURE);
            };
            if (_arg_1 == toString(WM_EVENT_BONUS))
            {
                return (WM_EVENT_BONUS);
            };
            if (_arg_1 == toString(PRESENTS))
            {
                return (PRESENTS);
            };
            gMisc.Assert(false, (("Could not interpret background string '" + _arg_1) + "'!"));
            return (-1);
        }


    }
}
