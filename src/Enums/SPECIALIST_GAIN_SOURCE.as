package Enums
{
    public class SPECIALIST_GAIN_SOURCE 
    {

        public static const TAVERN:int = 0;
        public static const SHOP:int = 1;
        public static const OTHERS:int = 2;


        public static function GetString(_arg_1:int):String
        {
            switch (_arg_1)
            {
                case TAVERN:
                    return ("TAVERN");
                case SHOP:
                    return ("SHOP");
                case OTHERS:
                    return ("OTHERS");
            };
            return ("UNDEFINED_" + _arg_1);
        }


    }
}
