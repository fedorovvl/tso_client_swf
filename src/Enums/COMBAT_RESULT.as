package Enums
{
    public class COMBAT_RESULT 
    {

        public static const ONGOING:int = 1;
        public static const PLAYERWON_RETURN:int = 2;
        public static const PLAYERWON_CONTINUE:int = 3;
        public static const PLAYERLOST:int = 4;
        public static const DRAW:int = 5;


        public static function toString(_arg_1:int):String
        {
            switch (_arg_1)
            {
                case ONGOING:
                    return ("Ongoing");
                case PLAYERWON_CONTINUE:
                    return ("PlayerWonContinue");
                case PLAYERWON_RETURN:
                    return ("PlayerWonReturn");
                case PLAYERLOST:
                    return ("PlayerLost");
                case DRAW:
                    return ("Draw");
                default:
                    return ("Unknown: " + _arg_1);
            };
        }

        public static function parse(_arg_1:String):int
        {
            _arg_1 = _arg_1.toLowerCase();
            if (_arg_1 == "ongoing")
            {
                return (ONGOING);
            };
            if (((_arg_1 == "playerwoncontinue") || (_arg_1 == "playerwon_continue")))
            {
                return (PLAYERWON_CONTINUE);
            };
            if (((_arg_1 == "playerwonreturn") || (_arg_1 == "playerwon_return")))
            {
                return (PLAYERWON_RETURN);
            };
            if (_arg_1 == "playerlost")
            {
                return (PLAYERLOST);
            };
            if (_arg_1 == "draw")
            {
                return (DRAW);
            };
            return (0);
        }


    }
}
