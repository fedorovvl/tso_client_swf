package Enums
{
    import nLib.gMisc;

    public class COMBAT_MODIFIER_ATTRIBUTE 
    {

        public static const MAX_ATTACK_DAMAGE:int = 0;
        public static const MIN_ATTACK_DAMAGE:int = 1;
        public static const ACCURACY:int = 2;
        public static const TOTAL_DAMAGE:int = 3;
        public static const LOSE_FLANKING:int = 4;
        public static const ADD_FLANKING:int = 5;
        public static const ADD_SPLASH:int = 6;
        public static const UNIT_HP:int = 7;
        public static const DOUBLE_ATTACK:int = 8;
        public static const TOTAL_DAMAGE_ON_HOMEZONE:int = 9;
        public static const STAR_COINS_FOR_XP:int = 10;
        public static const RECOVER_LOST_TROOPS:int = 11;
        public static const HIRED_MILITARY_FOR_XP:int = 12;
        public static const BATTLE_FRENZY:int = 13;
        public static const MIN_ATTACK_DAMAGE_HOMEZONE:int = 14;
        public static const MAX_ATTACK_DAMAGE_HOMEZONE:int = 15;
        public static const COMBAT_XP:int = 16;
        public static const INSTANT_RECOVER:int = 17;


        public static function toString(_arg_1:int):String
        {
            switch (_arg_1)
            {
                case MAX_ATTACK_DAMAGE:
                    return ("MaxAttackDamage");
                case MIN_ATTACK_DAMAGE:
                    return ("MinAttackDamage");
                case ACCURACY:
                    return ("Accuracy");
                case TOTAL_DAMAGE:
                    return ("TotalDamage");
                case LOSE_FLANKING:
                    return ("LoseSkill_Flanking");
                case ADD_FLANKING:
                    return ("GainSkill_Flanking");
                case ADD_SPLASH:
                    return ("GainSkill_Splash");
                case UNIT_HP:
                    return ("UnitHP");
                case DOUBLE_ATTACK:
                    return ("DoubleAttack");
                case TOTAL_DAMAGE_ON_HOMEZONE:
                    return ("TotalDamageOnHomeZone");
                case STAR_COINS_FOR_XP:
                    return ("StarCoinsForXP");
                case RECOVER_LOST_TROOPS:
                    return ("RecoverLostTroops");
                case HIRED_MILITARY_FOR_XP:
                    return ("HiredMilitaryForXP");
                case BATTLE_FRENZY:
                    return ("BattleFrenzy");
                case MIN_ATTACK_DAMAGE_HOMEZONE:
                    return ("MinAttackDamageOnHomeZone");
                case MAX_ATTACK_DAMAGE_HOMEZONE:
                    return ("MaxAttackDamageOnHomeZone");
                case COMBAT_XP:
                    return ("CombatXP");
                case INSTANT_RECOVER:
                    return ("InstantRecover");
            };
            return ("Unknown Combat Modifier : " + _arg_1);
        }

        public static function Parse(_arg_1:String):int
        {
            if (_arg_1 == toString(MAX_ATTACK_DAMAGE))
            {
                return (MAX_ATTACK_DAMAGE);
            };
            if (_arg_1 == toString(MIN_ATTACK_DAMAGE))
            {
                return (MIN_ATTACK_DAMAGE);
            };
            if (_arg_1 == toString(ACCURACY))
            {
                return (ACCURACY);
            };
            if (_arg_1 == toString(TOTAL_DAMAGE))
            {
                return (TOTAL_DAMAGE);
            };
            if (_arg_1 == toString(LOSE_FLANKING))
            {
                return (LOSE_FLANKING);
            };
            if (_arg_1 == toString(ADD_FLANKING))
            {
                return (ADD_FLANKING);
            };
            if (_arg_1 == toString(ADD_SPLASH))
            {
                return (ADD_SPLASH);
            };
            if (_arg_1 == toString(UNIT_HP))
            {
                return (UNIT_HP);
            };
            if (_arg_1 == toString(DOUBLE_ATTACK))
            {
                return (DOUBLE_ATTACK);
            };
            if (_arg_1 == toString(TOTAL_DAMAGE_ON_HOMEZONE))
            {
                return (TOTAL_DAMAGE_ON_HOMEZONE);
            };
            if (_arg_1 == toString(STAR_COINS_FOR_XP))
            {
                return (STAR_COINS_FOR_XP);
            };
            if (_arg_1 == toString(RECOVER_LOST_TROOPS))
            {
                return (RECOVER_LOST_TROOPS);
            };
            if (_arg_1 == toString(HIRED_MILITARY_FOR_XP))
            {
                return (HIRED_MILITARY_FOR_XP);
            };
            if (_arg_1 == toString(BATTLE_FRENZY))
            {
                return (BATTLE_FRENZY);
            };
            if (_arg_1 == toString(MIN_ATTACK_DAMAGE_HOMEZONE))
            {
                return (MIN_ATTACK_DAMAGE_HOMEZONE);
            };
            if (_arg_1 == toString(MAX_ATTACK_DAMAGE_HOMEZONE))
            {
                return (MAX_ATTACK_DAMAGE_HOMEZONE);
            };
            if (_arg_1 == toString(COMBAT_XP))
            {
                return (COMBAT_XP);
            };
            if (_arg_1 == toString(INSTANT_RECOVER))
            {
                return (INSTANT_RECOVER);
            };
            gMisc.Assert(false, (("Could not interpret combat modifier attribute string '" + _arg_1) + "'!"));
            return (-1);
        }


    }
}
