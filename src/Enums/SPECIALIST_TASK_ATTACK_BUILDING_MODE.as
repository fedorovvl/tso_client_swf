package Enums
{
    public class SPECIALIST_TASK_ATTACK_BUILDING_MODE 
    {

        public static const BUILDING_ONLY:int = 0;
        public static const CLEAR_SECTOR:int = 1;


        public static function toString(_arg_1:int):String
        {
            switch (_arg_1)
            {
                case BUILDING_ONLY:
                    return ("BuildingOnly");
                case CLEAR_SECTOR:
                    return ("ClearSector");
                default:
                    return ("Unknown: " + _arg_1);
            };
        }


    }
}
