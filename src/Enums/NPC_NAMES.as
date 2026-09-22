package Enums
{
    public class NPC_NAMES 
    {

        public static const WITHOUT_NAME:int = 0;
        public static const ANONYMOUS:int = 1;
        public static const SIR_OLIVER:int = 2;
        public static const LORD_SARDIN:int = 3;
        public static const SERAPHINA:int = 4;
        public static const HENRY:int = 5;
        public static const THE_KING:int = 6;
        public static const THEODOR:int = 7;
        public static const CRISIS_INFO:int = 8;
        public static const MIN_NPC_ID:int = WITHOUT_NAME;//0
        public static const MAX_NPC_ID:int = CRISIS_INFO;//8


        public static function isNPC(_arg_1:int):Boolean
        {
            return ((_arg_1 <= MAX_NPC_ID) && (_arg_1 >= MIN_NPC_ID));
        }

        public static function toString(_arg_1:int):String
        {
            switch (_arg_1)
            {
                case WITHOUT_NAME:
                    return ("WithoutName");
                case ANONYMOUS:
                    return ("Anonymous");
                case SIR_OLIVER:
                    return ("SirOliver");
                case LORD_SARDIN:
                    return ("LordSardin");
                case SERAPHINA:
                    return ("Seraphina");
                case HENRY:
                    return ("Henry");
                case THE_KING:
                    return ("TheKing");
                case THEODOR:
                    return ("Theodor");
                case CRISIS_INFO:
                    return ("CrisisInfo");
                default:
                    return ("Unknown: " + _arg_1);
            };
        }

        public static function parse(_arg_1:String):int
        {
            if (_arg_1 == "WithoutName")
            {
                return (WITHOUT_NAME);
            };
            if (_arg_1 == "Anonymous")
            {
                return (ANONYMOUS);
            };
            if (_arg_1 == "SirOliver")
            {
                return (SIR_OLIVER);
            };
            if (_arg_1 == "LordSardin")
            {
                return (LORD_SARDIN);
            };
            if (_arg_1 == "Seraphina")
            {
                return (SERAPHINA);
            };
            if (_arg_1 == "Henry")
            {
                return (HENRY);
            };
            if (_arg_1 == "TheKing")
            {
                return (THE_KING);
            };
            if (_arg_1 == "Theodor")
            {
                return (THEODOR);
            };
            if (_arg_1 == "CrisisInfo")
            {
                return (CRISIS_INFO);
            };
            return (WITHOUT_NAME);
        }


    }
}
