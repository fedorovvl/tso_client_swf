package Enums
{
    public final class GUILD_LOG_IDENTIFIER 
    {

        public static const MEMBER_INVITE:int = 0;
        public static const MEMBER_KICK:int = 1;
        public static const MEMBER_JOIN:int = 2;
        public static const MEMBER_LEAVE:int = 3;
        public static const MEMBER_RANK_PROMOTE:int = 4;
        public static const MEMBER_RANK_DEGRADE:int = 5;
        public static const MAX_SIZE_INCREASE:int = 6;
        public static const BANNER_CHANGE:int = 7;
        public static const DESCRIPTION_CHANGE:int = 8;
        public static const RANK_NAME_CHANGE:int = 9;
        public static const MOTD_CHANGE:int = 10;
        public static const MEMBER_SUCCESSOR_ORDER_CHANGE:int = 11;
        public static const LEADER_STEP_DOWN:int = 12;
        public static const LEADER_INACTIVE_REPLACEMENT:int = 13;
        public static const MEMBER_APPLY:int = 14;
        public static const KICK_MEMBER_PERMISSION:int = 15;
        public static const GUILD_MAIL_PERMISSION:int = 16;
        public static const NOTE_PERMISSION:int = 17;
        public static const INVITE_PERMISSION:int = 18;
        public static const BANNER_PERMISSION:int = 19;


        public static function toString(_arg_1:int):String
        {
            switch (_arg_1)
            {
                case MEMBER_INVITE:
                    return ("MemberInvite");
                case MEMBER_KICK:
                    return ("MemberKick");
                case MEMBER_JOIN:
                    return ("MemberJoin");
                case MEMBER_LEAVE:
                    return ("MemberLeave");
                case MEMBER_RANK_PROMOTE:
                    return ("MemberRankPromote");
                case MEMBER_RANK_DEGRADE:
                    return ("MemberRankDegrade");
                case MAX_SIZE_INCREASE:
                    return ("MaxSizeIncrease");
                case BANNER_CHANGE:
                    return ("BannerChange");
                case DESCRIPTION_CHANGE:
                    return ("DescriptionChange");
                case RANK_NAME_CHANGE:
                    return ("RankNameChange");
                case MOTD_CHANGE:
                    return ("MOTDChange");
                case MEMBER_SUCCESSOR_ORDER_CHANGE:
                    return ("MemberSuccessorOrderChange");
                case LEADER_STEP_DOWN:
                    return ("LeaderStepDown");
                case LEADER_INACTIVE_REPLACEMENT:
                    return ("LeaderInactiveReplacement");
                case MEMBER_APPLY:
                    return ("MemberApply");
                case KICK_MEMBER_PERMISSION:
                    return ("KickMemberPermission");
                case GUILD_MAIL_PERMISSION:
                    return ("GuildMailPermission");
                case NOTE_PERMISSION:
                    return ("NotePermission");
                case INVITE_PERMISSION:
                    return ("InvitePermission");
                case BANNER_PERMISSION:
                    return ("BannerPermission");
                default:
                    return ("Unknown: " + _arg_1);
            };
        }


    }
}
