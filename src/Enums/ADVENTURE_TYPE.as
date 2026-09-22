package Enums
{
    import nLib.gMisc;

    public class ADVENTURE_TYPE 
    {

        public static const MISSION:int = 0;
        public static const MINI:int = 1;
        public static const COOP:int = 2;
        public static const VENTURE:int = 3;
        public static const SCENARIO:int = 4;
        public static const EXPEDITION:int = 5;


        public static function parse(_arg_1:String):int
        {
            if (_arg_1 == toString(MISSION))
            {
                return (MISSION);
            };
            if (_arg_1 == toString(MINI))
            {
                return (MINI);
            };
            if (_arg_1 == toString(COOP))
            {
                return (COOP);
            };
            if (_arg_1 == toString(SCENARIO))
            {
                return (SCENARIO);
            };
            if (_arg_1 == toString(VENTURE))
            {
                return (VENTURE);
            };
            if (_arg_1 == toString(EXPEDITION))
            {
                return (EXPEDITION);
            };
            gMisc.Assert(false, (("Could not parse AdventureType'" + _arg_1) + "'!"));
            return (-1);
        }

        public static function toString(_arg_1:int):String
        {
            switch (_arg_1)
            {
                case MISSION:
                    return ("Mission");
                case MINI:
                    return ("Mini");
                case COOP:
                    return ("Coop");
                case SCENARIO:
                    return ("Scenario");
                case VENTURE:
                    return ("Venture");
                case EXPEDITION:
                    return ("Expedition");
            };
            return ("Unknown adventure type");
        }


    }
}
