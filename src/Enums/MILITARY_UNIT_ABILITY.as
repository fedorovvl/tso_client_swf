package Enums
{
    public class MILITARY_UNIT_ABILITY 
    {

        public static const DAMAGE_BONUS_PERCENT_LIGHT_ARMOR:int = 1;
        public static const DAMAGE_BONUS_PERCENT_MEDIUM_ARMOR:int = 2;
        public static const DAMAGE_BONUS_PERCENT_HEAVY_ARMOR:int = 3;
        public static const DAMAGE_BONUS_PERCENT_TANK_ARMOR:int = 5;


        public static function parse(_arg_1:String):int
        {
            _arg_1 = _arg_1.toLowerCase();
            if (((_arg_1 == "damage_bonus_percent_light_armor") || (_arg_1 == "damagebonuspercentlightarmor")))
            {
                return (DAMAGE_BONUS_PERCENT_LIGHT_ARMOR);
            };
            if (((_arg_1 == "damage_bonus_percent_medium_armor") || (_arg_1 == "damagebonuspercentmediumarmor")))
            {
                return (DAMAGE_BONUS_PERCENT_MEDIUM_ARMOR);
            };
            if (((_arg_1 == "damage_bonus_percent_heavy_armor") || (_arg_1 == "damagebonuspercentheavyarmor")))
            {
                return (DAMAGE_BONUS_PERCENT_HEAVY_ARMOR);
            };
            if (((_arg_1 == "damage_bonus_percent_tank_armor") || (_arg_1 == "damagebonuspercenttankarmor")))
            {
                return (DAMAGE_BONUS_PERCENT_TANK_ARMOR);
            };
            return (0);
        }

        public static function toString(_arg_1:int):String
        {
            switch (_arg_1)
            {
                case DAMAGE_BONUS_PERCENT_LIGHT_ARMOR:
                    return ("DamageBonusPercentLightArmor");
                case DAMAGE_BONUS_PERCENT_MEDIUM_ARMOR:
                    return ("DamageBonusPercentMediumArmor");
                case DAMAGE_BONUS_PERCENT_HEAVY_ARMOR:
                    return ("DamageBonusPercentHeavyArmor");
                case DAMAGE_BONUS_PERCENT_TANK_ARMOR:
                    return ("DamageBonusPercentTankArmor");
                default:
                    return ("Unknown: " + _arg_1);
            };
        }


    }
}
