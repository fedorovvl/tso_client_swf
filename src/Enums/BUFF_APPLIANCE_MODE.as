package Enums
{
    public class BUFF_APPLIANCE_MODE 
    {

        public static const PLAYER:int = 0;
        public static const FRIEND:int = 1;
        public static const GUILD_MEMBER:int = 2;
        public static const CULTURE_BUILDING:int = 3;
        public static const EXTRA_BUILDING_BUFF:int = 4;
        public static const FRIEND_OR_GUILD_MEMBER_PREMIUM:int = 31;


        public static function parseString(_arg_1:String):int
        {
            if (toString(PLAYER) == _arg_1)
            {
                return (PLAYER);
            };
            if (toString(FRIEND) == _arg_1)
            {
                return (FRIEND);
            };
            if (toString(GUILD_MEMBER) == _arg_1)
            {
                return (GUILD_MEMBER);
            };
            if (toString(FRIEND_OR_GUILD_MEMBER_PREMIUM) == _arg_1)
            {
                return (FRIEND_OR_GUILD_MEMBER_PREMIUM);
            };
            if (toString(CULTURE_BUILDING) == _arg_1)
            {
                return (CULTURE_BUILDING);
            };
            if (toString(EXTRA_BUILDING_BUFF) == _arg_1)
            {
                return (EXTRA_BUILDING_BUFF);
            };
            return (PLAYER);
        }

        public static function toString(_arg_1:int):String
        {
            switch (_arg_1)
            {
                case PLAYER:
                    return ("Player");
                case FRIEND:
                    return ("Friend");
                case GUILD_MEMBER:
                    return ("GuildMember");
                case FRIEND_OR_GUILD_MEMBER_PREMIUM:
                    return ("FriendOrGuildPremium");
                case CULTURE_BUILDING:
                    return ("CultureBuilding");
                case EXTRA_BUILDING_BUFF:
                    return ("BuildingBuff");
                default:
                    return ("Unknown: " + _arg_1);
            };
        }


    }
}
