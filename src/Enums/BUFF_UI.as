package Enums
{
    public class BUFF_UI 
    {

        public static const DEFAULT:int = 0;
        public static const STACK_RESOURCE:int = 1;
        public static const STACK_BATTLEBUFF:int = 2;


        public static function toString(_arg_1:int):String
        {
            switch (_arg_1)
            {
                case STACK_RESOURCE:
                    return ("stack-resource");
                case STACK_BATTLEBUFF:
                    return ("stack-battlebuff");
            };
            return ("default");
        }

        public static function toInt(_arg_1:String):int
        {
            switch (_arg_1)
            {
                case "stack-resource":
                    return (STACK_RESOURCE);
                case "stack-battlebuff":
                    return (STACK_BATTLEBUFF);
            };
            return (0);
        }


    }
}
