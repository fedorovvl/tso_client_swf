package Enums
{
    public class MILITARY_UNIT_ARMORTYPE 
    {

        public static const INVALID:int = -1;
        public static const LIGHT:int = 1;
        public static const MEDIUM:int = 2;
        public static const HEAVY:int = 3;
        public static const TANK:int = 4;


        public static function getAssetName(_arg_1:int):String
        {
            switch (_arg_1)
            {
                case LIGHT:
                    return ("IconCombat3BonusMelee");
                case MEDIUM:
                    return ("IconCombat3BonusRanged");
                case HEAVY:
                    return ("IconCombat3BonusCavalry");
            };
            return ("n/a");
        }

        public static function parse(_arg_1:String):int
        {
            _arg_1 = _arg_1.toLowerCase();
            if (_arg_1 == "light")
            {
                return (LIGHT);
            };
            if (_arg_1 == "medium")
            {
                return (MEDIUM);
            };
            if (_arg_1 == "heavy")
            {
                return (HEAVY);
            };
            if (_arg_1 == "tank")
            {
                return (TANK);
            };
            return (0);
        }

        public static function toString(_arg_1:int):String
        {
            switch (_arg_1)
            {
                case LIGHT:
                    return ("Light");
                case MEDIUM:
                    return ("Medium");
                case HEAVY:
                    return ("Heavy");
                case TANK:
                    return ("Tank");
                default:
                    return ("Unknown: " + _arg_1);
            };
        }


    }
}
