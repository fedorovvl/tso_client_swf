package Enums
{
    import Utils.StringUtils;
    import nLib.gMisc;

    public class BUFF_PARAMETER_NAME 
    {

        public static const BASE_DAMAGE_MODIFIER_ATTACKER:int = 1;
        public static const BASE_DAMAGE_MODIFIER_DEFENDER:int = 2;
        public static const TIME_STACKING:int = 3;
        public static const DAMAGE:int = 4;
        public static const WIN_CONDITION_TARGET:int = 5;


        public static function toString(_arg_1:int):String
        {
            switch (_arg_1)
            {
                case BASE_DAMAGE_MODIFIER_ATTACKER:
                    return ("BaseDamageModifierAttacker");
                case BASE_DAMAGE_MODIFIER_DEFENDER:
                    return ("BaseDamageModifierDefender");
                case DAMAGE:
                    return ("Damage");
                case TIME_STACKING:
                    return ("TimeStacking");
                case WIN_CONDITION_TARGET:
                    return ("WinConditionTarget");
                default:
                    return ("Unknown: " + _arg_1);
            };
        }

        public static function Parse(_arg_1:String):int
        {
            if (StringUtils.equalsIgnoreCase(_arg_1, toString(BASE_DAMAGE_MODIFIER_ATTACKER)))
            {
                return (BASE_DAMAGE_MODIFIER_ATTACKER);
            };
            if (StringUtils.equalsIgnoreCase(_arg_1, toString(BASE_DAMAGE_MODIFIER_DEFENDER)))
            {
                return (BASE_DAMAGE_MODIFIER_DEFENDER);
            };
            if (StringUtils.equalsIgnoreCase(_arg_1, toString(DAMAGE)))
            {
                return (DAMAGE);
            };
            if (StringUtils.equalsIgnoreCase(_arg_1, toString(TIME_STACKING)))
            {
                return (TIME_STACKING);
            };
            if (StringUtils.equalsIgnoreCase(_arg_1, toString(WIN_CONDITION_TARGET)))
            {
                return (WIN_CONDITION_TARGET);
            };
            gMisc.Assert(false, (("Could not interpret buff parameter '" + _arg_1) + "'!"));
            return (-1);
        }


    }
}
