package Enums
{
    public class MILLITARY_UNIT_SKILLS 
    {

        public static const BONUS_DAMAGE_BUILDINGS:int = 0;
        public static const BONUS_DAMAGE_UNITS:int = 1;
        public static const ATTACK_WEAKEST_TARGET:int = 2;
        public static const SPLASH_DAMAGE:int = 3;
        public static const BONUS_AC_IN_TOWER:int = 4;
        public static const FIRST_STRIKE:int = 5;
        public static const LAST_STRIKE:int = 6;
        public static const IGNORE_TOWER_AC_BONUS:int = 7;
        public static const IS_SPECIALIST:int = 8;


        public static function toString(_arg_1:int):String
        {
            switch (_arg_1)
            {
                case BONUS_DAMAGE_BUILDINGS:
                    return ("BonusDamageBuildings");
                case BONUS_DAMAGE_UNITS:
                    return ("BonusDamageUnits");
                case ATTACK_WEAKEST_TARGET:
                    return ("AttackWeakestTarget");
                case SPLASH_DAMAGE:
                    return ("SplashDamage");
                case BONUS_AC_IN_TOWER:
                    return ("BonusAcInTower");
                case FIRST_STRIKE:
                    return ("FirstStrike");
                case LAST_STRIKE:
                    return ("LastStrike");
                case IGNORE_TOWER_AC_BONUS:
                    return ("IgnoreTowerACBonus");
                case IS_SPECIALIST:
                    return ("IsSpecialist");
                default:
                    return ("Unknown: " + _arg_1);
            };
        }


    }
}
