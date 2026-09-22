package Enums
{
    public class ADVENTURE_THEME 
    {

        public static const CLASSICAL:int = 1;
        public static const FAIRYTALE:int = 2;
        public static const MYTH:int = 3;
        public static const EASTER:int = 4;
        public static const SOCCER:int = 5;
        public static const HALLOWEEN:int = 6;
        public static const CHRISTMAS:int = 7;
        public static const APOCALYPSE:int = 8;
        public static const RETRO:int = 9;


        public static function toString(_arg_1:int):String
        {
            switch (_arg_1)
            {
                case CLASSICAL:
                    return ("Classical");
                case FAIRYTALE:
                    return ("Fairytale");
                case MYTH:
                    return ("Myth");
                case EASTER:
                    return ("Easter");
                case SOCCER:
                    return ("Soccer");
                case HALLOWEEN:
                    return ("Halloween");
                case CHRISTMAS:
                    return ("Christmas");
                case APOCALYPSE:
                    return ("Apocalypse");
                case RETRO:
                    return ("Retro");
            };
            return ("Unknown adventure theme");
        }

        public static function parse(_arg_1:String):int
        {
            if (_arg_1 == toString(CLASSICAL))
            {
                return (CLASSICAL);
            };
            if (_arg_1 == toString(FAIRYTALE))
            {
                return (FAIRYTALE);
            };
            if (_arg_1 == toString(MYTH))
            {
                return (MYTH);
            };
            if (_arg_1 == toString(EASTER))
            {
                return (EASTER);
            };
            if (_arg_1 == toString(SOCCER))
            {
                return (SOCCER);
            };
            if (_arg_1 == toString(HALLOWEEN))
            {
                return (HALLOWEEN);
            };
            if (_arg_1 == toString(CHRISTMAS))
            {
                return (CHRISTMAS);
            };
            if (_arg_1 == toString(APOCALYPSE))
            {
                return (APOCALYPSE);
            };
            if (_arg_1 == toString(RETRO))
            {
                return (RETRO);
            };
            return (CLASSICAL);
        }


    }
}
