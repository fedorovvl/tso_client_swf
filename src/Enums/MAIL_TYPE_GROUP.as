package Enums
{
    public class MAIL_TYPE_GROUP 
    {

        public static const MAIL_UNREAD:int = 0;
        public static const MAIL_READ:int = 1;
        public static const NPC:int = 2;
        public static const TRADE:int = 3;
        public static const FRIEND:int = 4;
        public static const GUILD:int = 5;
        public static const LOOT:int = 6;
        public static const ADVENTURE:int = 7;
        public static const GIFT:int = 8;
        public static const BUFF:int = 9;
        public static const BATTLE_REPORT:int = 10;
        public static const HARD_CURRENCY:int = 11;


        public static function getMailGroup(_arg_1:int, _arg_2:Boolean):int
        {
            switch (_arg_1)
            {
                case MAIL_TYPE.MAIL:
                case MAIL_TYPE.LOCA_MAIL:
                    if (_arg_2)
                    {
                        return (MAIL_READ);
                    };
                    return (MAIL_UNREAD);
                case MAIL_TYPE.NPC_MAIL:
                case MAIL_TYPE.NPC_MAIL_LOOT:
                    return (NPC);
                case MAIL_TYPE.TRADE:
                case MAIL_TYPE.TRADE_ACCEPTED:
                case MAIL_TYPE.TRADE_DECLINED:
                    return (TRADE);
                case MAIL_TYPE.FRIEND_REQUEST:
                case MAIL_TYPE.FRIEND_INVITATION_CONFIRMED:
                    return (FRIEND);
                case MAIL_TYPE.GUILD_INVITE:
                case MAIL_TYPE.GUILD_INVITE_DECLINE:
                case MAIL_TYPE.GUILD_INVITE_FULL:
                case MAIL_TYPE.GUILD_KICK:
                case MAIL_TYPE.GUILD_SUCCESSION_REQUEST:
                case MAIL_TYPE.GUILD_SUCCESSION_DECLINED:
                case MAIL_TYPE.GUILD_SUCCESSION_EXPIRED:
                case MAIL_TYPE.GUILD_LEADER_CHANGED:
                case MAIL_TYPE.GUILD_NEW_LEADER:
                case MAIL_TYPE.GUILD_OLD_LEADER:
                case MAIL_TYPE.GUILD_SUCCESSION_DUE_TO_INACTIVE:
                case MAIL_TYPE.GUILD_APPLY:
                case MAIL_TYPE.GUILD_APPLY_ACCEPTED:
                case MAIL_TYPE.GUILD_APPLY_DECLINED:
                    return (GUILD);
                case MAIL_TYPE.TREASURE_LOOT:
                case MAIL_TYPE.TREASURE_LOOT_SKILLED:
                case MAIL_TYPE.TREASURE_LOOT_TRAVELLINGERUDITE:
                case MAIL_TYPE.TREASURE_LOOT_BEANACOLOADA:
                case MAIL_TYPE.COOPERATION_REWARD:
                case MAIL_TYPE.BANDITS_LOOT:
                case MAIL_TYPE.QUEST_LOOT:
                case MAIL_TYPE.LOCA_LOOT_MAIL:
                case MAIL_TYPE.COLLECTIBLE_REWARDS:
                case MAIL_TYPE.EVENT_LOOT_REWARDS_CURRENT_USER:
                case MAIL_TYPE.EVENT_LOOT_REWARDS_FRIEND_USER:
                    return (LOOT);
                case MAIL_TYPE.GIFT:
                case MAIL_TYPE.BUFF:
                    return (GIFT);
                case MAIL_TYPE.BUFFED_BUILDING:
                case MAIL_TYPE.BUFFED_DEPOSIT:
                case MAIL_TYPE.EVENT_MONSTER_HIT_BY_FRIEND:
                    return (BUFF);
                case MAIL_TYPE.BATTLE_REPORT:
                case MAIL_TYPE.BATTLE_REPORT_INTERCEPTED:
                case MAIL_TYPE.PVP_COMBAT_REPORT_ATTACKER_WON:
                case MAIL_TYPE.PVP_COMBAT_REPORT_ATTACKER_LOST:
                case MAIL_TYPE.PVP_COMBAT_REPORT_DEFENDER_WON:
                case MAIL_TYPE.PVP_COMBAT_REPORT_DEFENDER_LOST:
                    return (BATTLE_REPORT);
                case MAIL_TYPE.HARD_CURRENCY_PURCHASED:
                case MAIL_TYPE.HARD_CURRENCY_REMOVED:
                case MAIL_TYPE.INVITED_FRIEND_PURCHASED:
                    return (HARD_CURRENCY);
                case MAIL_TYPE.ADVENTURE_WON_LOOT:
                case MAIL_TYPE.EXPEDITION_WON_LOOT:
                case MAIL_TYPE.EXPEDITION_LOST_LOOT:
                case MAIL_TYPE.ADVENTURE_LOST_LOOT:
                case MAIL_TYPE.INVITE_TO_ADVENTURE:
                case MAIL_TYPE.FIND_ADVENTURE_LOOT_POSITIVE:
                case MAIL_TYPE.FIND_ADVENTURE_LOOT_POSITIVE_SKILLED:
                case MAIL_TYPE.FIND_ADVENTURE_LOOT_NEGATIVE:
                case MAIL_TYPE.FIND_ADVENTURE_LOOT_MAP_FRAGMENT:
                case MAIL_TYPE.FIND_ADVENTURE_LOOT_MAP_FRAGMENT_SKILLED:
                case MAIL_TYPE.FIND_EXPEDITION_LOOT_POSITIVE:
                case MAIL_TYPE.FIND_EXPEDITION_LOOT_NEGATIVE:
                case MAIL_TYPE.ADVENTURE_LOCKED_COMPENSATION:
                case MAIL_TYPE.EXPEDITION_LOCKED_COMPENSATION:
                case MAIL_TYPE.ADVENTURE_FAILED_CANCELLED:
                case MAIL_TYPE.ADVENTURE_LEAVE_NOTIFICATION:
                case MAIL_TYPE.ADVENTURE_CANCEL_INVITATION:
                    return (ADVENTURE);
                default:
                    return (0);
            };
        }


    }
}
