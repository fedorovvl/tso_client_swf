package Enums
{
    import Utils.StringUtils;
    import nLib.gMisc;

    public class CAMP_TYPE 
    {

        public static const BOSS_EXIT:int = 1;
        public static const BOSS_FINAL:int = 2;
        public static const CAV_CAMP:int = 3;
        public static const MELEE_CAMP:int = 4;
        public static const MIXED_CAMP:int = 5;
        public static const RANGED_CAMP:int = 6;
        public static const DEFENSE_SLOT:int = 0xFF;


        public static function Parse(_arg_1:String):int
        {
            if (StringUtils.equalsIgnoreCase(_arg_1, toString(BOSS_EXIT)))
            {
                return (BOSS_EXIT);
            };
            if (StringUtils.equalsIgnoreCase(_arg_1, toString(BOSS_FINAL)))
            {
                return (BOSS_FINAL);
            };
            if (StringUtils.equalsIgnoreCase(_arg_1, toString(CAV_CAMP)))
            {
                return (CAV_CAMP);
            };
            if (StringUtils.equalsIgnoreCase(_arg_1, toString(DEFENSE_SLOT)))
            {
                return (DEFENSE_SLOT);
            };
            if (StringUtils.equalsIgnoreCase(_arg_1, toString(MELEE_CAMP)))
            {
                return (MELEE_CAMP);
            };
            if (StringUtils.equalsIgnoreCase(_arg_1, toString(MIXED_CAMP)))
            {
                return (MIXED_CAMP);
            };
            if (StringUtils.equalsIgnoreCase(_arg_1, toString(RANGED_CAMP)))
            {
                return (RANGED_CAMP);
            };
            gMisc.Assert(false, (("Could not interpret win condition type '" + _arg_1) + "'!"));
            return (-1);
        }

        public static function toString(_arg_1:int):String
        {
            switch (_arg_1)
            {
                case BOSS_EXIT:
                    return ("BossExit");
                case BOSS_FINAL:
                    return ("BossFinal");
                case CAV_CAMP:
                    return ("CavCamp");
                case DEFENSE_SLOT:
                    return ("DefenseSlot");
                case MELEE_CAMP:
                    return ("MeleeCamp");
                case MIXED_CAMP:
                    return ("MixedCamp");
                case RANGED_CAMP:
                    return ("RangedCamp");
                default:
                    return ("Unknown: " + _arg_1);
            };
        }


    }
}
