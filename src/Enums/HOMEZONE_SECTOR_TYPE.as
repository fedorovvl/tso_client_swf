package Enums
{
    public class HOMEZONE_SECTOR_TYPE 
    {

        public static const MAIN_ISLAND:int = 0;
        public static const NEW_ISLANDS:int = 1;
        public static const ALL:int = 3;


        public static function parse(_arg_1:String):int
        {
            switch (_arg_1)
            {
                case "MainIsland":
                    return (0);
                case "NewIslands":
                    return (1);
                case "All":
                    return (2);
                default:
                    return (-1);
            };
        }

        public static function toString(_arg_1:int):String
        {
            switch (_arg_1)
            {
                case MAIN_ISLAND:
                    return ("MainIsland");
                case NEW_ISLANDS:
                    return ("NewIslands");
                case ALL:
                    return ("All");
                default:
                    return ("Undefined");
            };
        }


    }
}
