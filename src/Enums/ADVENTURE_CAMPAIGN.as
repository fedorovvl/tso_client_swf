package Enums
{
    import nLib.gMisc;

    public class ADVENTURE_CAMPAIGN 
    {

        public static const NONE:int = 0;
        public static const THE_LITTLE_TAILOR:int = 1;
        public static const ARABIAN_NIGHTS:int = 2;
        public static const THE_EVIL_QUEEN:int = 3;
        public static const SOCCER_TOURNAMENT:int = 4;
        public static const THE_MOUNTAIN_CLAN:int = 5;


        public static function parse(_arg_1:String):int
        {
            if (_arg_1 == toString(THE_LITTLE_TAILOR))
            {
                return (THE_LITTLE_TAILOR);
            };
            if (_arg_1 == toString(ARABIAN_NIGHTS))
            {
                return (ARABIAN_NIGHTS);
            };
            if (_arg_1 == toString(THE_EVIL_QUEEN))
            {
                return (THE_EVIL_QUEEN);
            };
            if (_arg_1 == toString(SOCCER_TOURNAMENT))
            {
                return (SOCCER_TOURNAMENT);
            };
            if (_arg_1 == toString(THE_MOUNTAIN_CLAN))
            {
                return (THE_MOUNTAIN_CLAN);
            };
            if (((_arg_1 == toString(NONE)) || (_arg_1.length < 1)))
            {
                return (NONE);
            };
            gMisc.Assert(false, (("Could not parse AdventureCampaign'" + _arg_1) + "'!"));
            return (-1);
        }

        public static function toString(_arg_1:int):String
        {
            switch (_arg_1)
            {
                case THE_LITTLE_TAILOR:
                    return ("TheLittleTailor");
                case ARABIAN_NIGHTS:
                    return ("ArabianNights");
                case THE_EVIL_QUEEN:
                    return ("TheEvilQueen");
                case SOCCER_TOURNAMENT:
                    return ("SoccerTournament");
                case THE_MOUNTAIN_CLAN:
                    return ("TheMountainClan");
                case NONE:
                    return ("None");
            };
            return ("Unknown adventure campaign");
        }


    }
}
