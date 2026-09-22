package Enums
{
    import Utils.HashMapWrapper;

    public class TIMED_PRODUCTION_TYPE 
    {

        public static const MILITARY_UNIT:int = 0;
        public static const BUFF:int = 1;
        public static const SKILL:int = 2;
        public static const EFFECT:int = 3;
        public static const COLLECTIONS:int = 4;
        public static const RARE_BUFFS:int = 5;
        public static const COMBAT_THREE_WEAPONS:int = 6;
        public static const COMBAT_THREE_UNITS:int = 7;
        public static const ELITE_UNITS:int = 8;
        public static const COMBAT_THREE_WEAPONS_2:int = 11;
        public static const TYPE_HARDCODED:int = 10000;
        public static const TYPE_CULTUREBUILDING:int = 20000;
        public static const TYPE_SIMPLEPRODUCTION:int = 30000;
        public static const TYPE_TIMEDPRODUCTION:int = 40000;
        public static var DEFAULT_TYPE_string:String = typeIntToStr(TYPE_HARDCODED);
        private static var mapIdToType:HashMapWrapper = new HashMapWrapper();


        public static function isHardcoded(_arg_1:int):Boolean
        {
            return ((mapIdToType.getItem(_arg_1) == null) || (mapIdToType.getItem(_arg_1) == TYPE_HARDCODED));
        }

        public static function isMilitaryProductionType(_arg_1:int):Boolean
        {
            switch (_arg_1)
            {
                case MILITARY_UNIT:
                case ELITE_UNITS:
                case COMBAT_THREE_UNITS:
                case COMBAT_THREE_WEAPONS:
                case COMBAT_THREE_WEAPONS_2:
                    return (true);
            };
            return (false);
        }

        public static function fromString(_arg_1:String):int
        {
            switch (_arg_1)
            {
                case "MilitaryUnit":
                    return (MILITARY_UNIT);
                case "Buff":
                    return (BUFF);
                case "Skill":
                    return (SKILL);
                case "Effect":
                    return (EFFECT);
                case "Collections":
                    return (COLLECTIONS);
                case "RareBuff":
                    return (RARE_BUFFS);
                case "CombatThreeWeapons":
                    return (COMBAT_THREE_WEAPONS);
                case "CombatThreeUnits":
                    return (COMBAT_THREE_UNITS);
                case "EliteUnits":
                    return (ELITE_UNITS);
                default:
                    return (typeStrToInt(_arg_1));
            };
        }

        public static function isSimpleProduction(_arg_1:int):Boolean
        {
            return ((!(mapIdToType.getItem(_arg_1) == null)) && (mapIdToType.getItem(_arg_1) == TYPE_SIMPLEPRODUCTION));
        }

        private static function typeIntToStr(_arg_1:int):String
        {
            switch (_arg_1)
            {
                case TYPE_CULTUREBUILDING:
                    return ("culturebuilding");
                case TYPE_SIMPLEPRODUCTION:
                    return ("simpleproduction");
                case TYPE_TIMEDPRODUCTION:
                    return ("timedproduction");
                case TYPE_HARDCODED:
                    return ("hardcoded");
            };
            return ("Unknown: " + _arg_1);
        }

        private static function typeStrToInt(_arg_1:String):int
        {
            switch (_arg_1)
            {
                case "culturebuilding":
                    return (TYPE_CULTUREBUILDING);
                case "simpleproduction":
                    return (TYPE_SIMPLEPRODUCTION);
                case "timedproduction":
                    return (TYPE_TIMEDPRODUCTION);
                case "hardcoded":
                    return (TYPE_HARDCODED);
            };
            return (-1);
        }

        public static function isTimedProduction(_arg_1:int):Boolean
        {
            return ((mapIdToType.getItem(_arg_1) == null) || (mapIdToType.getItem(_arg_1) == TYPE_TIMEDPRODUCTION));
        }

        public static function toString(_arg_1:int):String
        {
            switch (_arg_1)
            {
                case MILITARY_UNIT:
                    return ("MilitaryUnit");
                case BUFF:
                    return ("StandardBuff");
                case SKILL:
                    return ("Skill");
                case EFFECT:
                    return ("Effect");
                case COLLECTIONS:
                    return ("Collections");
                case RARE_BUFFS:
                    return ("RareBuff");
                case COMBAT_THREE_WEAPONS:
                case COMBAT_THREE_WEAPONS_2:
                    return ("CombatThreeWeapons");
                case COMBAT_THREE_UNITS:
                    return ("CombatThreeUnits");
                case ELITE_UNITS:
                    return ("EliteUnits");
                default:
                    if (mapIdToType.getItem(_arg_1) == null)
                    {
                        return (typeIntToStr(TYPE_HARDCODED));
                    };
                    return (typeIntToStr((mapIdToType.getItem(_arg_1) as int)));
            };
        }

        public static function isCultureBuilding(_arg_1:int):Boolean
        {
            return ((!(mapIdToType.getItem(_arg_1) == null)) && (mapIdToType.getItem(_arg_1) == TYPE_CULTUREBUILDING));
        }

        public static function add(_arg_1:int, _arg_2:String):void
        {
            var _local_3:int = typeStrToInt(_arg_2);
            mapIdToType.putItem(_arg_1, ((_local_3 == -1) ? TYPE_HARDCODED : _local_3));
        }


    }
}
