package Enums
{
    import Utils.StringUtils;
    import nLib.gMisc;

    public class BUFF_TARGET_TYPE 
    {

        public static const BUILDING:int = 0;
        public static const DEPOSIT:int = 1;
        public static const HOMEZONE:int = 2;
        public static const COMBAT_WIN_CONDITION_BOSS:int = 3;
        public static const COMBAT_WIN_CONDITION_BUILDING:int = 4;
        public static const COMBAT_WIN_CONDITION_SUPPLY:int = 5;
        public static const PRODUCTION:int = 6;
        public static const MILITARY_UNIT:int = 7;


        public static function parse(_arg_1:String):int
        {
            if (StringUtils.equalsIgnoreCase(_arg_1, toString(BUILDING)))
            {
                return (BUILDING);
            };
            if (StringUtils.equalsIgnoreCase(_arg_1, toString(COMBAT_WIN_CONDITION_BOSS)))
            {
                return (COMBAT_WIN_CONDITION_BOSS);
            };
            if (StringUtils.equalsIgnoreCase(_arg_1, toString(COMBAT_WIN_CONDITION_BUILDING)))
            {
                return (COMBAT_WIN_CONDITION_BUILDING);
            };
            if (StringUtils.equalsIgnoreCase(_arg_1, toString(COMBAT_WIN_CONDITION_SUPPLY)))
            {
                return (COMBAT_WIN_CONDITION_SUPPLY);
            };
            if (StringUtils.equalsIgnoreCase(_arg_1, toString(DEPOSIT)))
            {
                return (DEPOSIT);
            };
            if (StringUtils.equalsIgnoreCase(_arg_1, toString(HOMEZONE)))
            {
                return (HOMEZONE);
            };
            if (StringUtils.equalsIgnoreCase(_arg_1, toString(PRODUCTION)))
            {
                return (PRODUCTION);
            };
            if (StringUtils.equalsIgnoreCase(_arg_1, toString(MILITARY_UNIT)))
            {
                return (MILITARY_UNIT);
            };
            gMisc.Assert(false, (("Could not interpret string '" + _arg_1) + "' for buff target type!"));
            return (BUILDING);
        }

        public static function toString(_arg_1:int):String
        {
            switch (_arg_1)
            {
                case BUILDING:
                    return ("Building");
                case COMBAT_WIN_CONDITION_BOSS:
                    return ("CombatWinConditionBoss");
                case COMBAT_WIN_CONDITION_BUILDING:
                    return ("CombatWinConditionBuilding");
                case COMBAT_WIN_CONDITION_SUPPLY:
                    return ("CombatWinConditionSupply");
                case DEPOSIT:
                    return ("Deposit");
                case HOMEZONE:
                    return ("Homezone");
                case PRODUCTION:
                    return ("Production");
                case MILITARY_UNIT:
                    return ("MilitaryUnit");
                default:
                    return ("Unknown: " + _arg_1);
            };
        }


    }
}
