package Enums
{
    public class GUI_END 
    {

        public static const LEFT:int = 0;
        public static const RIGHT:int = 1;
        public static const NONE:int = 2;
        public static const BOTH:int = 3;


        public static function toString(_arg_1:int):String
        {
            switch (_arg_1)
            {
                case GUI_END.LEFT:
                    return ("LEFT");
                case GUI_END.RIGHT:
                    return ("RIGHT");
                case GUI_END.NONE:
                    return ("NONE");
                case GUI_END.BOTH:
                    return ("BOTH");
                default:
                    return ("UNKNOWN");
            };
        }


    }
}
