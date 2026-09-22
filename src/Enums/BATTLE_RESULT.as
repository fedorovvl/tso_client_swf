package Enums
{
    public class BATTLE_RESULT 
    {

        public static const GENERAL_WON_AND_RETURNS:int = 0;
        public static const GENERAL_WON_AND_CONTINUES:int = 1;
        public static const GENERAL_LOST:int = 2;
        public static const GENERAL_WON_AND_BLOCKED:int = 3;


        public static function toString(_arg_1:int):String
        {
            switch (_arg_1)
            {
                case GENERAL_WON_AND_RETURNS:
                    return (AVATAR_MESSAGE_TYPE.GENERAL_WON_AND_RETURNS);
                case GENERAL_WON_AND_CONTINUES:
                    return (AVATAR_MESSAGE_TYPE.GENERAL_WON_AND_CONTINUES);
                case GENERAL_LOST:
                    return (AVATAR_MESSAGE_TYPE.GENERAL_LOST);
                case GENERAL_WON_AND_BLOCKED:
                    return (AVATAR_MESSAGE_TYPE.GENERAL_WON_AND_BLOCKED);
                default:
                    return ("Unknown: " + _arg_1);
            };
        }


    }
}
