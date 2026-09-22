package Enums
{
    public final class COMMAND 
    {

        public static const SET_BUILDING_OFFSETS:int = 32;
        public static const ADD_HARD_CURRENCY:int = 33;
        public static const SET_BUILDING_IN_GAME:int = 50;
        public static const SET_BUILDING_BY_BUFF:int = 51;
        public static const SET_BUILDING_PICKUP:int = 52;
        public static const SELECT_BUILDING:int = 55;
        public static const UPGRADE_BUILDING:int = 60;
        public static const APPLY_BUFF:int = 61;
        public static const APPLY_LOOTTABLE_BUFF:int = 62;
        public static const APPLY_BUFF_LIST:int = 63;
        public static const DESTRUCT_BUILDING:int = 65;
        public static const DESTRUCT_MOUNTAIN:int = 67;
        public static const BUILD_WAY:int = 70;
        public static const BUILD_WAY_SECONDARY:int = 75;
        public static const ERASE_WAY:int = 80;
        public static const GET_COMBAT_PREVIEW:int = 84;
        public static const ATTACK_BUILDING:int = 85;
        public static const MOVE_GARISSON:int = 86;
        public static const BUY_SPECIALIST:int = 90;
        public static const START_TIMED_PRODUCTION:int = 91;
        public static const INVITE_TO_ADVENTURE:int = 92;
        public static const ACCEPT_ADVENTURE_INVITATION:int = 93;
        public static const DECLINE_ADVENTURE_INVITATION:int = 94;
        public static const SET_TASK:int = 95;
        public static const START_TRAVEL_TO_ZONE:int = 96;
        public static const EXTERNAL_MESSAGE_TRAVEL_TO_ZONE:int = 97;
        public static const QUEST_TRIGGER:int = 100;
        public static const QUEST_APPLY_REWARD_EFFECTS:int = 101;
        public static const QUEST_PAY_FOR_QUEST_FINISH:int = 102;
        public static const GET_DEBUG_ZONE:int = 105;
        public static const STOP_PRODUCTION:int = 107;
        public static const BUILDQUEUE_MOVE_UP:int = 115;
        public static const BUILDQUEUE_MOVE_DOWN:int = 116;
        public static const BUILDQUEUE_REMOVE:int = 117;
        public static const GAMETICK_REFRESH_COMMAND:int = 120;
        public static const BUY_SHOP_ITEM:int = 130;
        public static const BUY_ONE_CLICK_SHOP_ITEM:int = 66;
        public static const CREATE_DEPOSIT_LOCAL:int = 131;
        public static const REFRESH_STATUS_IDS:int = 132;
        public static const CANCEL_ADVENTURE:int = 133;
        public static const APPLY_CASUALTIES:int = 134;
        public static const CHANGE_TRACKED_MISSION_LIST:int = 135;
        public static const REMOVE_BUFF:int = 136;
        public static const MOVE_BUILDING:int = 137;
        public static const SELECT_BUILDING_TO_MOVE:int = 138;
        public static const DELETE_BUILDING:int = 139;
        public static const SET_ADVENTURE_STATUS:int = 140;
        public static const DELIVER_PRODUCTION:int = 141;
        public static const ADVENTURE_INVITATION_EXPIRED:int = 142;
        public static const BUY_SHOP_ITEM_MOBILE:int = 143;
        public static const SAVE_PLAYER_SETTINGS:int = 144;
        public static const COMBAT_UNIT_SWITCH:int = 145;
        public static const COMBAT_GET_STATS:int = 146;
        public static const COLONY_ASSIGN:int = 147;
        public static const COLONY_REMOVE:int = 148;
        public static const GET_PVP_COLONIES:int = 149;
        public static const START_CONQUERING_PVP_COLONY:int = 150;
        public static const CANCEL_PVP_COLONY:int = 151;
        public static const COMBAT3_PRE_ATTACK:int = 154;
        public static const COMBAT3_CHOOSE_UNIT:int = 155;
        public static const COLONY_GET_DEFENSE_MODE_STATS:int = 157;
        public static const COLONY_START_DEFENSE_MODE:int = 158;
        public static const CANCEL_LOCKED_ADVENTURE:int = 159;
        public static const DEPOSIT_FOUND:int = 160;
        public static const CLAM_TASK_REWARD:int = 161;
        public static const PAY_TO_FINISH:int = 162;
        public static const CHEAT_FINISH_TASK:int = 163;
        public static const CHEAT_RESET_TASKS:int = 164;
        public static const KILL_EVENT_MONSTER:int = 165;
        public static const BUFF_ADVENTURE_CLEANUP:int = 166;
        public static const MOVE_COLLECTIBLE_BUILDING:int = 167;
        public static const CANCEL_ADVENTURE_INVITATION:int = 168;
        public static const LEAVE_ADVENTURE:int = 169;
        public static const INIT_SERVER:int = 1000;
        public static const GET_ZONE:int = 1001;
        public static const GET_ZONE_ON_LOGIN:int = 1002;
        public static const GET_UPDATES:int = 1004;
        public static const INIT_CLIENT_DONE:int = 1005;
        public static const SESSION_AUTH:int = 1008;
        public static const INIT_CHAT:int = 1009;
        public static const STORE_ZONE_TO_XML:int = 1011;
        public static const SPEEDMODE:int = 1013;
        public static const GET_FRIEND_LIST:int = 1014;
        public static const SEARCH_PLAYER_LIST:int = 1015;
        public static const SEARCH_RECIEPIENT_LIST:int = 1016;
        public static const ADD_FRIEND:int = 1017;
        public static const REMOVE_FRIEND:int = 1018;
        public static const SEND_MAIL:int = 1023;
        public static const PRODUCTION_MOVE_UP:int = 1025;
        public static const PRODUCTION_MOVE_DOWN:int = 1026;
        public static const PRODUCTION_REMOVE:int = 1027;
        public static const PRODUCTION_MOVE_TOP:int = 0x0404;
        public static const PRODUCTION_MOVE_BOTTOM:int = 1029;
        public static const PRODUCTION_CANCEL_ALL_WAITING:int = 1030;
        public static const RAISE_ARMY:int = 1031;
        public static const RESOURCES_CHEAT:int = 1032;
        public static const RETREAT:int = 1033;
        public static const MAX_UNITS_CHEAT:int = 1034;
        public static const ARMY_CHEAT:int = 1035;
        public static const GET_ZONE_ON_THE_FLY:int = 1037;
        public static const SPOOLTIME:int = 1040;
        public static const ACCEPT_FRIEND_REQUEST:int = 1041;
        public static const DECLINE_FRIEND_REQUEST:int = 1042;
        public static const ACCEPT_LOOT:int = 1043;
        public static const SET_CITY_LEVEL:int = 1044;
        public static const GET_ZONE_FROM_CLIENT:int = 1045;
        public static const GET_ASCIIZONE:int = 1046;
        public static const GRAB_FOREIGN_ZONE:int = 1047;
        public static const CHECK_TRADES:int = 1048;
        public static const INITIATE_TRADE:int = 1049;
        public static const ACCEPT_TRADE_MAIL:int = 1050;
        public static const ACCEPT_TRADE_MARKET:int = 1051;
        public static const ACCEPT_TRADE_GTC:int = 1052;
        public static const DECLINE_TRADE:int = 1053;
        public static const COMPLETE_TRADE_MAIL:int = 1054;
        public static const COMPLETE_TRADE_MARKET:int = 1055;
        public static const DELETE_TRADE_BY_USER:int = 1056;
        public static const DELETE_TRADE_BY_TIMEOUT:int = 1057;
        public static const DELETE_TRADES_BY_DEMOLITION:int = 1058;
        public static const REMOVE_TRADE:int = 1059;
        public static const DELETE_TRADE_GTC:int = 1060;
        public static const TRADE_GET_UPDATES:int = 1061;
        public static const TRADE_GET_USER_TRADES:int = 1062;
        public static const GET_TRADE_HISTORY:int = 1063;
        public static const ENABLE_PLAYER_LOGGING:int = 1064;
        public static const SET_FAKE_DATE:int = 1160;
        public static const GOD_MODE_CHEAT:int = 1161;
        public static const MARK_MAIL_AS_READ:int = 1164;
        public static const APPLY_EFFECT:int = 1165;
        public static const INPUT_ACTION:int = 1166;
        public static const SET_HIDE_HELP:int = 1167;
        public static const HELP_SHOWN:int = 1168;
        public static const RESET_HELP:int = 1169;
        public static const SET_SKILLPOINTS:int = 1170;
        public static const RESET_SKILLPOINTS:int = 1171;
        public static const MODIFIER_EFFECT:int = 1172;
        public static const CHANGE_SPECIALIST_NAME:int = 1173;
        public static const PREMIUM_EXPIRE_NOTIFIED:int = 1174;
        public static const GET_INBOX_HEADERS:int = 1175;
        public static const GET_OUTBOX_HEADERS:int = 1176;
        public static const GET_INBOX_BODY:int = 1177;
        public static const GET_OUTBOX_BODY:int = 1178;
        public static const DELETE_INBOX_MAIL:int = 1179;
        public static const DELETE_OUTBOX_MAIL:int = 1180;
        public static const MARK_MAILS:int = 1181;
        public static const BLOCK_SENDER:int = 1182;
        public static const UNBLOCK_SENDER:int = 1183;
        public static const GET_BLOCK_LIST:int = 1184;
        public static const CLAIM_LOOT:int = 1185;
        public static const RECREATE_EMPTY_DEPOSIT:int = 1186;
        public static const SPAWN_PICKUPS_CHEAT:int = 1188;
        public static const UPDATE_PICKUP_DATA:int = 1189;
        public static const FORCE_COMPLETE_ACHIEVEMENT:int = 1190;
        public static const FORCE_COMPLETE_ACHIEVEMENT_TRIGGER:int = 1191;
        public static const GET_COMPARED_USER_ACHIEVEMENTS:int = 1192;
        public static const SET_PVP_MODIFIER:int = 1195;
        public static const SET_PVP_LEVEL:int = 1196;
        public static const ADD_PVP_XP:int = 1200;
        public static const CLAIM_PVP_LEVEL_REWARDS:int = 1198;
        public static const UPDATE_PVP_MODIFIER:int = 1199;
        public static const DISMISS_MAILS:int = 1201;
        public static const TEST_PATH:int = 2090;
        public static const TEST_WAYPOINT:int = 2091;
        public static const ADD_WAY_NE:int = 2092;
        public static const ADD_WAY_SE:int = 2093;
        public static const ADD_WAY_SW:int = 2094;
        public static const ADD_WAY_NW:int = 2095;
        public static const UNDEFINED:int = 3000;
        public static const GUILD_GET:int = 4000;
        public static const GUILD_GET_HEADERS:int = 4001;
        public static const GUILD_FOUND:int = 4002;
        public static const GUILD_FOUND_VALIDATE_NAME:int = 4003;
        public static const GUILD_FOUND_VALIDATE_TAG:int = 4004;
        public static const GUILD_EDIT_VALUE:int = 4005;
        public static const GUILD_INVITE:int = 4006;
        public static const GUILD_JOIN_REQUEST:int = 4007;
        public static const GUILD_LEAVE:int = 4008;
        public static const GUILD_KICK:int = 4009;
        public static const GUILD_INVITE_ACCEPT:int = 4010;
        public static const GUILD_INVITE_DECLINE:int = 4011;
        public static const GUILD_GET_OWN:int = 4014;
        public static const GUILD_SEND_MAIL:int = 4015;
        public static const GUILD_STEP_DOWN:int = 4016;
        public static const GUILD_APPLY:int = 4019;
        public static const GUILD_APPLY_ACCEPT:int = 4020;
        public static const GUILD_APPLY_DECLINE:int = 4021;
        public static const GUILD_SUCCESSION_ACCEPT:int = 4017;
        public static const GUILD_SUCCESSION_DECLINE:int = 4018;
        public static const GUILD_DONATE_RESOURCE:int = 4022;
        public static const EVENT_DONATE_RESOURCE:int = 4023;
        public static const GUILD_GET_BANK:int = 4024;
        public static const GUILD_BANK_TRANSFER:int = 4025;
        public static const GUILD_BANK_WITHDRAW:int = 4026;
        public static const GUILD_RANK_GET:int = 4027;
        public static const GUILD_BANK_BUY_TAB:int = 4028;
        public static const GUILD_BANK_ENLARGE:int = 4029;
        public static const GUILD_BANK_TAB_RENAME:int = 4030;
        public static const PING_ZONE:int = 5000;
        public static const REMOVE_TEMP_BUILD_SLOT:int = 6000;
        public static const VISIT_FRIEND_ZONE:int = 7816;
        public static const DELAY_EVENT_1:int = 9001;
        public static const DELAY_EVENT_2:int = 9002;
        public static const PENDING_DATABASE_INC:int = 9003;
        public static const PENDING_DATABASE_DEC:int = 9004;
        public static const FORCE_GUILD_STEPDOWN_CHK:int = 9005;
        public static const TEST_LOOTTABLE:int = 9006;
        public static const DEBUG_ADD_QUEST_REWARD:int = 9007;
        public static const DEBUG_CRASH_ZONE:int = 9008;
        public static const LOGGER_SEND_UNCAUGHT_EXCEPTION:int = 9010;
        public static const LOGGER_SEND_CLIENT_LOG:int = 9011;
        public static const CREATE_COLLECTION:int = 10000;
        public static const BUY_COLLECTION:int = 10001;
        public static const EPIC_WORKYARD_CREATE_PRODUCTION_CHAIN:int = 20000;
        public static const EPIC_WORKYARD_DESTROY_PRODUCTION_CHAIN:int = 20001;
        public static const EPIC_WORKYARD_CHANGE_PRODUCTION_CHAIN:int = 20002;
        public static const REVEAL_FRIEND_COLLECTIBLE_BUILDING_BUFF:int = 10002;
        public static const BUFF_APPLY_ENVIRONMENT_BUFF:int = 10004;
        public static const ZONE_BUFF_REMOVE:int = 10005;
        public static const ITEM_REGISTRY_REGISTER:int = 10006;
        public static const OPEN_ADVENT_CALENDAR_DOOR:int = 11000;
        public static const OPEN_ADVENT_CALENDAR_DOOR_WITH_GEMS:int = 11001;
        public static const SELECT_ADVENT_CALENDAR_DOOR_REWARD:int = 11002;
        public static const CHECK_AVATAR_NAME:int = 11010;
        public static const UPDATE_PLAYER_INFO:int = 11011;
        public static const UPDATE_PLAYER_INFO_AND_USERNAME:int = 11012;
        public static const VOTES_SEND_PLAYER_VOTE:int = 11020;
        public static const VOTES_DELETE_PLAYER_VOTE_WITH_GEMS:int = 11021;
        public static const VOTES_SET_SEEN_BATCH_VOTE:int = 11022;
        public static const CLIENT_UI_TRACK:int = 11500;
        public static const ADD_FRIENDSHIP_TIME_CHEAT:int = 11100;
        public static const EXPIRE_MAIL_CHEAT:int = 11101;
        public static const START_EVENT:int = 12000;
        public static const STOP_EVENT:int = 12001;
        public static const CLEANUP_EVENT:int = 12002;
        public static const SET_BUILDING_IN_DEFENSE_MODE:int = 12101;
        public static const SET_BUILDING_IN_DEFENSE_MODE_BY_BUFF:int = 12102;
        public static const COLONY_REQUEST_YIELD:int = 12011;
        public static const ADD_BLOCKING_PATH_PREVIEW:int = 12050;
        public static const ADD_BLOCKING_PATH_PREVIEW_START:int = 12051;
        public static const ADD_BLOCKING_PATH_PREVIEW_TARGET:int = 12052;
        public static const DELETE_BLOCKING_PATH_PREVIEW:int = 12053;
        public static const MOVE_BLOCKING_PATH_PREVIEW_START:int = 12054;
        public static const MOVE_BLOCKING_PATH_PREVIEW_TARGET:int = 12055;
        public static const ADD_PICKUP:int = 13001;
        public static const EXECUTE_PICKUP:int = 13002;
        public static const RESET_CULTURE_BUILDING_COOLDOWN_WITH_GEMS:int = 13003;
        public static const NOTIFY_GENERAL_SKILL_STAR_COINS_PICKED_UP:int = 1300;
        public static const CONTENT_GENERATOR_ROLL:int = 14000;
        public static const CONTENT_GENERATOR_COMPLETE_COLLECTION:int = 14001;
        public static const CHEAT_CONTENT_GENERATOR_ROLL:int = 14002;
        public static const CHEAT_CONTENT_GENERATOR_COLLECTION_PART:int = 14003;
        public static const CHEAT_DESTROY_CAMP:int = 14004;
        public static const CHEAT_GET_GENERIC_VALUES:int = 14005;
        public static const CHEAT_SET_GENERIC_VALUE:int = 14006;
        public static const CHEAT_APPLY_EFFECT:int = 14007;


        public static function GetString(_arg_1:int):String
        {
            switch (_arg_1)
            {
                case RESET_CULTURE_BUILDING_COOLDOWN_WITH_GEMS:
                    return ("RESET_CULTURE_BUILDING_COOLDOWN_WITH_GEMS");
                case SET_BUILDING_OFFSETS:
                    return ("SET_BUILDING_OFFSETS");
                case ADD_HARD_CURRENCY:
                    return ("ADD_HARD_CURRENCY");
                case SET_BUILDING_IN_GAME:
                    return ("SET_BUILDING_IN_GAME");
                case SET_BUILDING_IN_DEFENSE_MODE:
                    return ("SET_BUILDING_IN_DEFENSE_MODE");
                case SET_BUILDING_IN_DEFENSE_MODE_BY_BUFF:
                    return ("SET_BUILDING_IN_DEFENSE_MODE_BY_BUFF");
                case SET_BUILDING_BY_BUFF:
                    return ("SET_BUILDING_INSTANTLY");
                case SET_BUILDING_PICKUP:
                    return ("SET_BUILDING_PICKUP");
                case SELECT_BUILDING:
                    return ("SELECT_BUILDING");
                case UPGRADE_BUILDING:
                    return ("UPGRADE_BUILDING");
                case APPLY_BUFF:
                    return ("APPLY_BUFF");
                case APPLY_LOOTTABLE_BUFF:
                    return ("APPLY_LOOTTABLE_BUFF");
                case DESTRUCT_BUILDING:
                    return ("DESTRUCT_BUILDING");
                case DESTRUCT_MOUNTAIN:
                    return ("DESTRUCT_MOUNTAIN");
                case BUILD_WAY:
                    return ("BUILD_WAY");
                case BUILD_WAY_SECONDARY:
                    return ("BUILD_WAY_SECONDARY");
                case ERASE_WAY:
                    return ("ERASE_WAY");
                case GET_COMBAT_PREVIEW:
                    return ("GET_COMBAT_PREVIEW");
                case ATTACK_BUILDING:
                    return ("ATTACK_BUILDING");
                case MOVE_GARISSON:
                    return ("MOVE_GARISSON");
                case BUY_SPECIALIST:
                    return ("BUY_SPECIALIST");
                case SET_TASK:
                    return ("SET_TASK");
                case START_TRAVEL_TO_ZONE:
                    return ("START_TRAVEL_TO_ZONE");
                case EXTERNAL_MESSAGE_TRAVEL_TO_ZONE:
                    return ("EXTERNAL_MESSAGE_TRAVEL_TO_ZONE");
                case QUEST_TRIGGER:
                    return ("QUEST_TRIGGER");
                case QUEST_APPLY_REWARD_EFFECTS:
                    return ("QUEST_APPLY_REWARD_EFFECTS");
                case QUEST_PAY_FOR_QUEST_FINISH:
                    return ("QUEST_PAY_FOR_QUEST_FINISH");
                case GET_DEBUG_ZONE:
                    return ("GET_DEBUG_ZONE");
                case STOP_PRODUCTION:
                    return ("REFRESH_ZONE");
                case BUILDQUEUE_MOVE_UP:
                    return ("BUILDQUEUE_MOVE_UP");
                case BUILDQUEUE_MOVE_DOWN:
                    return ("BUILDQUEUE_MOVE_DOWN");
                case BUILDQUEUE_REMOVE:
                    return ("BUILDQUEUE_REMOVE");
                case GAMETICK_REFRESH_COMMAND:
                    return ("GAMETICK_REFRESH_COMMAND");
                case BUY_SHOP_ITEM:
                    return ("BUY_SHOP_ITEM");
                case BUY_SHOP_ITEM_MOBILE:
                    return ("BUY_SHOP_ITEM_MOBILE");
                case BUY_ONE_CLICK_SHOP_ITEM:
                    return ("BUY_ONE_CLICK_SHOP_ITEM");
                case CREATE_DEPOSIT_LOCAL:
                    return ("CREATE_DEPOSIT_LOCAL");
                case REFRESH_STATUS_IDS:
                    return ("REFRESH_STATUS_IDS");
                case CANCEL_ADVENTURE:
                    return ("CANCEL_ADVENTURE");
                case APPLY_CASUALTIES:
                    return ("APPLY_CASUALTIES");
                case CHANGE_TRACKED_MISSION_LIST:
                    return ("CHANGE_TRACKED_MISSION_LIST");
                case REMOVE_BUFF:
                    return ("REMOVE_BUFF");
                case MOVE_BUILDING:
                    return ("MOVE_BUILDING");
                case SELECT_BUILDING_TO_MOVE:
                    return ("SELECT_BUILDING_TO_MOVE");
                case DELETE_BUILDING:
                    return ("DELETE_BUILDING");
                case SET_SKILLPOINTS:
                    return ("SET_SKILLPOINTS");
                case RESET_SKILLPOINTS:
                    return ("RESET_SKILLPOINTS");
                case SET_ADVENTURE_STATUS:
                    return ("SET_ADVENTURE_STATUS");
                case DELIVER_PRODUCTION:
                    return ("DELIVER_PRODUCTION");
                case TEST_PATH:
                    return ("TEST_PATH");
                case TEST_WAYPOINT:
                    return ("TEST_WAYPOINT");
                case ADD_WAY_NE:
                    return ("ADD_WAY_NE");
                case ADD_WAY_SE:
                    return ("ADD_WAY_SE");
                case ADD_WAY_SW:
                    return ("ADD_WAY_SW");
                case ADD_WAY_NW:
                    return ("ADD_WAY_NW");
                case COMBAT_UNIT_SWITCH:
                    return ("COMBAT_UNIT_SWITCH");
                case COMBAT_GET_STATS:
                    return ("COMBAT_GET_STATS");
                case COLONY_ASSIGN:
                    return ("COLONY_ASSIGN");
                case COLONY_REMOVE:
                    return ("COLONY_REMOVE");
                case GET_PVP_COLONIES:
                    return ("GET_PVP_COLONIES");
                case START_CONQUERING_PVP_COLONY:
                    return ("START_CONQUERING_PVP_COLONY");
                case CANCEL_PVP_COLONY:
                    return ("CANCEL_PVP_COLONY");
                case COMBAT3_PRE_ATTACK:
                    return ("COMBAT3_PRE_ATTACK");
                case COMBAT3_CHOOSE_UNIT:
                    return ("COMBAT3_CHOOSE_UNIT");
                case INIT_SERVER:
                    return ("INIT_SERVER");
                case GET_ZONE:
                    return ("GET_ZONE");
                case GET_ZONE_ON_LOGIN:
                    return ("GET_ZONE_ON_LOGIN");
                case GET_UPDATES:
                    return ("GET_UPDATES");
                case INIT_CLIENT_DONE:
                    return ("INIT_CLIENT_DONE");
                case SESSION_AUTH:
                    return ("SESSION_AUTH");
                case INIT_CHAT:
                    return ("INIT_CHAT");
                case STORE_ZONE_TO_XML:
                    return ("STORE_ZONE_TO_XML");
                case GET_FRIEND_LIST:
                    return ("GET_FRIEND_LIST");
                case SEARCH_PLAYER_LIST:
                    return ("SEARCH_PLAYER_LIST");
                case SEARCH_RECIEPIENT_LIST:
                    return ("SEARCH_RECIEPIENT_LIST");
                case ADD_FRIEND:
                    return ("ADD_FRIEND");
                case REMOVE_FRIEND:
                    return ("REMOVE_FRIEND");
                case GUILD_GET:
                    return ("GUILD_GET");
                case GUILD_GET_HEADERS:
                    return ("GUILD_GET_HEADERS");
                case GUILD_FOUND:
                    return ("GUILD_FOUND");
                case GUILD_FOUND_VALIDATE_NAME:
                    return ("GUILD_FOUND_VALIDATE_NAME");
                case GUILD_FOUND_VALIDATE_TAG:
                    return ("GUILD_FOUND_VALIDATE_TAG");
                case GUILD_EDIT_VALUE:
                    return ("GUILD_EDIT_VALUE");
                case GUILD_INVITE:
                    return ("GUILD_INVITE");
                case GUILD_JOIN_REQUEST:
                    return ("GUILD_JOIN_REQUEST");
                case GUILD_LEAVE:
                    return ("GUILD_LEAVE");
                case GUILD_KICK:
                    return ("GUILD_KICK");
                case GUILD_INVITE_ACCEPT:
                    return ("GUILD_INVITE_ACCEPT");
                case GUILD_INVITE_DECLINE:
                    return ("GUILD_INVITE_DECLINE");
                case GUILD_GET_OWN:
                    return ("GUILD_GET_OWN");
                case GUILD_SEND_MAIL:
                    return ("GUILD_SEND_MAIL");
                case GUILD_STEP_DOWN:
                    return ("GUILD_STEP_DOWN");
                case GUILD_APPLY:
                    return ("GUILD_APPLY");
                case GUILD_APPLY_ACCEPT:
                    return ("GUILD_APPLY_ACCEPT");
                case GUILD_APPLY_DECLINE:
                    return ("GUILD_APPLY_DECLINE");
                case GUILD_SUCCESSION_ACCEPT:
                    return ("GUILD_SUCCESSION_ACCEPT");
                case GUILD_SUCCESSION_DECLINE:
                    return ("GUILD_SUCCESSION_DECLINE");
                case GUILD_DONATE_RESOURCE:
                    return ("GUILD_DONATE_RESOURCE");
                case EVENT_DONATE_RESOURCE:
                    return ("EVENT_DONATE_RESOURCE");
                case GUILD_GET_BANK:
                    return ("GUILD_GET_BANK");
                case GUILD_BANK_TRANSFER:
                    return ("GUILD_BANK_TRANSFER");
                case GUILD_BANK_WITHDRAW:
                    return ("GUILD_BANK_WITHDRAW");
                case GUILD_RANK_GET:
                    return ("GUILD_RANK_GET");
                case GUILD_BANK_BUY_TAB:
                    return ("GUILD_BANK_BUY_TAB");
                case GUILD_BANK_ENLARGE:
                    return ("GUILD_BANK_ENLARGE");
                case GUILD_BANK_TAB_RENAME:
                    return ("GUILD_BANK_TAB_RENAME");
                case PING_ZONE:
                    return ("PING_ZONE");
                case REMOVE_TEMP_BUILD_SLOT:
                    return ("REMOVE_TEMP_BUILD_SLOT");
                case VISIT_FRIEND_ZONE:
                    return ("VISIT_FRIEND_ZONE");
                case SPEEDMODE:
                    return ("SPEEDMODE");
                case PRODUCTION_MOVE_UP:
                    return ("PRODUCTION_MOVE_UP");
                case PRODUCTION_MOVE_DOWN:
                    return ("PRODUCTION_MOVE_DOWN");
                case PRODUCTION_REMOVE:
                    return ("PRODUCTION_REMOVE");
                case START_TIMED_PRODUCTION:
                    return ("START_TIMED_PRODUCTION");
                case INVITE_TO_ADVENTURE:
                    return ("INVITE_TO_ADVENTURE");
                case ACCEPT_ADVENTURE_INVITATION:
                    return ("ACCEPT_ADVENTURE_INVITATION");
                case DECLINE_ADVENTURE_INVITATION:
                    return ("DECLINE_ADVENTURE_INVITATION");
                case CHECK_TRADES:
                    return ("CHECK_TRADES");
                case INITIATE_TRADE:
                    return ("INITIATE_TRADE");
                case ACCEPT_TRADE_MAIL:
                    return ("ACCEPT_TRADE_MAIL");
                case ACCEPT_TRADE_MARKET:
                    return ("ACCEPT_TRADE_MARKET");
                case ACCEPT_TRADE_GTC:
                    return ("ACCEPT_TRADE_GTC");
                case DECLINE_TRADE:
                    return ("DECLINE_TRADE");
                case COMPLETE_TRADE_MAIL:
                    return ("COMPLETE_TRADE_MAIL");
                case COMPLETE_TRADE_MARKET:
                    return ("COMPLETE_TRADE_MARKET");
                case DELETE_TRADE_BY_USER:
                    return ("DELETE_TRADE_BY_USER");
                case DELETE_TRADE_BY_TIMEOUT:
                    return ("DELETE_TRADE_BY_TIMEOUT");
                case DELETE_TRADES_BY_DEMOLITION:
                    return ("DELETE_TRADES_BY_DEMOLITION");
                case DELETE_TRADE_GTC:
                    return ("DELETE_TRADE_GTC");
                case REMOVE_TRADE:
                    return ("REMOVE_TRADE");
                case TRADE_GET_UPDATES:
                    return ("TRADE_GET_UPDATES");
                case TRADE_GET_USER_TRADES:
                    return ("TRADE_GET_USER_TRADES");
                case GET_TRADE_HISTORY:
                    return ("GET_TRADE_HISTORY");
                case RAISE_ARMY:
                    return ("RAISE_ARMY");
                case RESOURCES_CHEAT:
                    return ("RESOURCES_CHEAT");
                case RETREAT:
                    return ("RETREAT");
                case MAX_UNITS_CHEAT:
                    return ("MAX_UNITS_CHEAT");
                case GET_ZONE_ON_THE_FLY:
                    return ("GET_ZONE_ON_THE_FLY");
                case ACCEPT_FRIEND_REQUEST:
                    return ("ACCEPT_FRIEND_REQUEST");
                case DECLINE_FRIEND_REQUEST:
                    return ("DECLINE_FRIEND_REQUEST");
                case ACCEPT_LOOT:
                    return ("ACCEPT_LOOT");
                case CLAIM_LOOT:
                    return ("CLAIM_LOOT");
                case SET_CITY_LEVEL:
                    return ("SET_CITY_LEVEL");
                case GET_ZONE_FROM_CLIENT:
                    return ("GET_ZONE_FROM_CLIENT");
                case GRAB_FOREIGN_ZONE:
                    return ("GRAB_FOREIGN_ZONE");
                case SET_FAKE_DATE:
                    return ("SET_FAKE_DATE");
                case GOD_MODE_CHEAT:
                    return ("GOD_MODE_CHEAT");
                case MARK_MAIL_AS_READ:
                    return ("MARK_MAIL_AS_READ");
                case APPLY_EFFECT:
                    return ("APPLY_EFFECT");
                case MODIFIER_EFFECT:
                    return ("MODIFIER_EFFECT");
                case CHANGE_SPECIALIST_NAME:
                    return ("CHANGE_SPECIALIST_NAME");
                case PREMIUM_EXPIRE_NOTIFIED:
                    return ("PREMIUM_EXPIRE_NOTIFIED");
                case SPAWN_PICKUPS_CHEAT:
                    return ("SPAWN_PICKUPS_CHEAT");
                case UPDATE_PICKUP_DATA:
                    return ("UPDATE_PICKUP_DATA");
                case INPUT_ACTION:
                    return ("INPUT_ACTION");
                case SET_HIDE_HELP:
                    return ("SET_HIDE_HELP");
                case HELP_SHOWN:
                    return ("HELP_SHOWN");
                case RESET_HELP:
                    return ("RESET_HELP");
                case ENABLE_PLAYER_LOGGING:
                    return ("ENABLE_PLAYER_LOGGING");
                case UNDEFINED:
                    return ("UNDEFINED");
                case GET_INBOX_HEADERS:
                    return ("GET_INBOX_MAIL_HEADERS");
                case GET_OUTBOX_HEADERS:
                    return ("GET_OUTBOX_MAIL_HEADERS");
                case GET_INBOX_BODY:
                    return ("GET_INBOX_BODY");
                case GET_OUTBOX_BODY:
                    return ("GET_OUTBOX_BODY");
                case DELETE_INBOX_MAIL:
                    return ("DELETE_INBOX_MAIL");
                case DELETE_OUTBOX_MAIL:
                    return ("DELETE_OUTBOX_MAIL");
                case DISMISS_MAILS:
                    return ("DISMISS_MAILS");
                case SEND_MAIL:
                    return ("SEND_MAIL");
                case MARK_MAILS:
                    return ("MARK_MAILS");
                case BLOCK_SENDER:
                    return ("BLOCK_SENDER");
                case UNBLOCK_SENDER:
                    return ("UNBLOCK_SENDER");
                case GET_BLOCK_LIST:
                    return ("GET_BLOCK_LIST");
                case RECREATE_EMPTY_DEPOSIT:
                    return ("RECREATE_EMPTY_DEPOSIT");
                case SPOOLTIME:
                    return ("SPOOLTIME");
                case DELAY_EVENT_1:
                    return ("DELAY_EVENT_1");
                case DELAY_EVENT_2:
                    return ("DELAY_EVENT_2");
                case PENDING_DATABASE_INC:
                    return ("PENDING_DATABASE_INC");
                case PENDING_DATABASE_DEC:
                    return ("PENDING_DATABASE_DEC");
                case FORCE_GUILD_STEPDOWN_CHK:
                    return ("FORCE_GUILD_STEPDOWN_CHK");
                case DEBUG_ADD_QUEST_REWARD:
                    return ("DEBUG_ADD_QUEST_REWARD");
                case LOGGER_SEND_UNCAUGHT_EXCEPTION:
                    return ("LOGGER_SEND_UNCAUGHT_EXCEPTION");
                case LOGGER_SEND_CLIENT_LOG:
                    return ("LOGGER_SEND_CLIENT_LOG");
                case CREATE_COLLECTION:
                    return ("CREATE_COLLECTION");
                case BUY_COLLECTION:
                    return ("BUY_COLLECTION");
                case REVEAL_FRIEND_COLLECTIBLE_BUILDING_BUFF:
                    return ("REVEAL_FRIEND_COLLECTIBLE_BUILDING_BUFF");
                case OPEN_ADVENT_CALENDAR_DOOR:
                    return ("OPEN_ADVENT_CALENDAR_DOOR");
                case OPEN_ADVENT_CALENDAR_DOOR_WITH_GEMS:
                    return ("OPEN_ADVENT_CALENDAR_DOOR_WITH_GEMS");
                case SELECT_ADVENT_CALENDAR_DOOR_REWARD:
                    return ("SELECT_ADVENT_CALENDAR_DOOR_REWARD");
                case EPIC_WORKYARD_CREATE_PRODUCTION_CHAIN:
                    return ("EPIC_WORKYARD_CREATE_PRODUCTION_CHAIN");
                case EPIC_WORKYARD_DESTROY_PRODUCTION_CHAIN:
                    return ("EPIC_WORKYARD_DESTROY_PRODUCTION_CHAIN");
                case EPIC_WORKYARD_CHANGE_PRODUCTION_CHAIN:
                    return ("EPIC_WORKYARD_CHANGE_PRODUCTION_CHAIN");
                case FORCE_COMPLETE_ACHIEVEMENT:
                    return ("FORCE_COMPLETE_ACHIEVEMENT");
                case FORCE_COMPLETE_ACHIEVEMENT_TRIGGER:
                    return ("FORCE_COMPLETE_ACHIEVEMENT_TRIGGER");
                case GET_COMPARED_USER_ACHIEVEMENTS:
                    return ("GET_COMPARED_USER_ACHIEVEMENTS");
                case SET_PVP_MODIFIER:
                    return ("SET_PVP_MODIFIER");
                case TEST_LOOTTABLE:
                    return ("TEST_LOOTTABLE");
                case CHECK_AVATAR_NAME:
                    return ("CHECK_AVATAR_NAME");
                case UPDATE_PLAYER_INFO:
                    return ("UPDATE_PLAYER_INFO");
                case UPDATE_PLAYER_INFO_AND_USERNAME:
                    return ("UPDATE_PLAYER_INFO_AND_USERNAME");
                case ADD_FRIENDSHIP_TIME_CHEAT:
                    return ("ADD_FRIENDSHIP_TIME_CHEAT");
                case EXPIRE_MAIL_CHEAT:
                    return ("EXPIRE_MAIL_CHEAT");
                case START_EVENT:
                    return ("START_EVENT");
                case STOP_EVENT:
                    return ("STOP_EVENT");
                case CLEANUP_EVENT:
                    return ("CLEANUP_EVENT");
                case EXECUTE_PICKUP:
                    return ("EXECUTE_PICKUP");
                case SET_PVP_LEVEL:
                    return ("SET_PVP_LEVEL");
                case ADD_PVP_XP:
                    return ("ADD_PVP_XP");
                case ZONE_BUFF_REMOVE:
                    return ("ZONE_BUFF_REMOVE");
                case CLAM_TASK_REWARD:
                    return ("CLAM_TASK_REWARD");
                case PAY_TO_FINISH:
                    return ("PAY_TO_FINISH");
                case CONTENT_GENERATOR_ROLL:
                    return ("CONTENT_GENERATOR_ROLL");
                case CONTENT_GENERATOR_COMPLETE_COLLECTION:
                    return ("CONTENT_GENERATOR_COMPLETE_COLLECTION");
                case CHEAT_CONTENT_GENERATOR_ROLL:
                    return ("CHEAT_CONTENT_GENERATOR_ROLL");
                case CHEAT_CONTENT_GENERATOR_COLLECTION_PART:
                    return ("CHEAT_CONTENT_GENERATOR_COLLECTION_PART");
                case CHEAT_DESTROY_CAMP:
                    return ("CHEAT_DESTROY_CAMP");
            };
            return ("UNDEFINED_" + _arg_1);
        }


    }
}
