package Enums
{
    public class MILITARY_UNIT_CATEGORY 
    {

        public static const COMBAT_DEFENSE:int = 1;
        public static const EXPEDITION:int = 2;


        public static function toString(_arg_1:int):String
        {
            switch (_arg_1)
            {
                case COMBAT_DEFENSE:
                    return ("CombatDefense");
                case EXPEDITION:
                    return ("Expedition");
                default:
                    return ("Unknown Unit Category " + _arg_1);
            };
        }


    }
}
