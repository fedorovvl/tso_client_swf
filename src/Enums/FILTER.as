package Enums
{
    public final class FILTER 
    {

        public static const NONE:int = 0;
        public static const SNOW_NO_WATER:int = 1;
        public static const SNOW_LIGHT:int = 2;
        public static const SNOW:int = 3;
        public static const OVEN:int = 4;
        public static const DOOMSDAY:int = 5;
        public static const NIGHT:int = 6;
        public static const DESERT:int = 7;
        public static const TROPICAL:int = 8;
        public static const COLORMOD:int = 9;
        public static const BLACK_AND_WHITE:int = 10;
        public static const SPOOKY:int = 11;
        public static const SNOW_MEDIUM:int = 12;
        public static const TUNDRA:int = 13;
        public static const DARKERSHADOW:int = 14;
        public static const MAGICSEPIA:int = 15;


        public static function toString(_arg_1:int):String
        {
            switch (_arg_1)
            {
                case NONE:
                    return ("none");
                case SNOW_NO_WATER:
                    return ("snownowater");
                case SNOW_LIGHT:
                    return ("snowlight");
                case SNOW:
                    return ("snow");
                case OVEN:
                    return ("oven");
                case DOOMSDAY:
                    return ("doomsday");
                case NIGHT:
                    return ("night");
                case DESERT:
                    return ("desert");
                case TROPICAL:
                    return ("tropical");
                case COLORMOD:
                    return ("colormod");
                case BLACK_AND_WHITE:
                    return ("blackandwhite");
                case SPOOKY:
                    return ("spooky");
                case SNOW_MEDIUM:
                    return ("snow_medium");
                case TUNDRA:
                    return ("tundra");
                case DARKERSHADOW:
                    return ("darkershadow");
                case MAGICSEPIA:
                    return ("magicsepia");
            };
            return (("UNDEFINED(" + _arg_1) + ")");
        }

        public static function toInt(_arg_1:String):int
        {
            if (_arg_1 == "none")
            {
                return (NONE);
            };
            if (_arg_1 == "snownowater")
            {
                return (SNOW_NO_WATER);
            };
            if (_arg_1 == "snowlight")
            {
                return (SNOW_LIGHT);
            };
            if (_arg_1 == "snow")
            {
                return (SNOW);
            };
            if (_arg_1 == "oven")
            {
                return (OVEN);
            };
            if (_arg_1 == "doomsday")
            {
                return (DOOMSDAY);
            };
            if (_arg_1 == "night")
            {
                return (NIGHT);
            };
            if (_arg_1 == "desert")
            {
                return (DESERT);
            };
            if (_arg_1 == "tropical")
            {
                return (TROPICAL);
            };
            if (_arg_1 == "colormod")
            {
                return (COLORMOD);
            };
            if (_arg_1 == "blackandwhite")
            {
                return (BLACK_AND_WHITE);
            };
            if (_arg_1 == "spooky")
            {
                return (SPOOKY);
            };
            if (_arg_1 == "snow_medium")
            {
                return (SNOW_MEDIUM);
            };
            if (_arg_1 == "tundra")
            {
                return (TUNDRA);
            };
            if (_arg_1 == "darkershadow")
            {
                return (DARKERSHADOW);
            };
            if (_arg_1 == "magicsepia")
            {
                return (MAGICSEPIA);
            };
            return (-1);
        }


    }
}
