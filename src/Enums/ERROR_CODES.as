package Enums
{
    public class ERROR_CODES 
    {

        public static const NO_ERROR:int = 0;
        public static const BUILD_QUEUE_FULL:int = 2;
        public static const INVALID_BUILD_POS:int = 3;
        public static const MAX_NUMBER_OF_BUILDINGS_REACHED:int = 4;
        public static const COULD_NOT_BUILD_UNKNOWN_REASON:int = 5;
        public static const BUILDING_TO_ATTACK_IS_NULL:int = 6;
        public static const COULD_NOT_FIND_BUILDING:int = 7;
        public static const COULD_NOT_AFFORD_SPECIALIST:int = 8;
        public static const BUILDING_IS_ON_FOG:int = 9;
        public static const PLAYER_IS_NOT_SECTOR_OWNER:int = 10;
        public static const PLACE_IS_NOT_REACHABLE:int = 11;
        public static const COULD_NOT_FIND_MAIL_IN_DB:int = 12;
        public static const MAX_AMOUNT_OF_SPECIALIST_TYPE_REACHED:int = 13;
        public static const MAX_AMOUNT_OF_SHOP_ITEM_REACHED:int = 14;
        public static const COULD_NOT_FIND_SPECIALIST:int = 15;
        public static const SPECIALIST_ALREADY_HAS_TASK:int = 16;
        public static const MAIL_WAS_DELETED:int = 17;
        public static const MALFORMED_ID:int = 18;
        public static const UNKNOWN_BUFF_TYPE:int = 19;
        public static const SECTOR_IS_OWNED_BY_BANDITS:int = 20;
        public static const CANNOT_TEAR_DOWN_INITIAL_BUILDING:int = 21;
        public static const CANNOT_TEAR_DOWN_GARRISON:int = 22;
        public static const NO_ARMY_HOLDER_DEFINED:int = 23;
        public static const UNKNOWN_UNIT_TYPE:int = 24;
        public static const BUFF_IS_NOT_PRODUCABLE:int = 25;
        public static const UNIT_IS_NOT_RECRUITABLE:int = 26;
        public static const UNKNOWN_PRODUCTION_TYPE:int = 27;
        public static const PLAYER_LEVEL_TOO_LOW:int = 28;
        public static const UNKNOWN_SHOP_ITEM_CONTENT:int = 29;
        public static const MINE_TYPE_BUILDING_IS_NOT_PLACED_ON_DEPOSIT:int = 30;
        public static const UNKNOWN_DEPOSIT:int = 31;
        public static const SPECIALIST_HAS_NO_GARRISON:int = 32;
        public static const SPECIALIST_HAS_NO_UNITS:int = 33;
        public static const BUILDING_BELONGS_TO_PLAYER:int = 34;
        public static const CANNOT_INITIATE_TRADE_ON_FOREIGN_ZONE:int = 35;
        public static const CANNOT_TRADE_SAME_RESOURCE:int = 36;
        public static const CANNOT_ACCEPT_LOOT_ON_FOREIGN_ZONE:int = 37;
        public static const CANNOT_RAISE_ARMY_WITHOUT_MAYORHOUSE:int = 38;
        public static const PRODUCTION_AMOUNT_TOO_HIGH:int = 39;
        public static const TRY_TO_BUILD_ON_DEPOSIT:int = 40;
        public static const TRY_TO_GIFT_NON_GIFTABLE_SHOP_ITEM:int = 41;
        public static const TRY_TO_SEARCH_DEPOSIT_WITHOUT_LEVEL:int = 42;
        public static const ZONE_IS_NO_ADVENTURE:int = 43;
        public static const TRADE_WITH_ILLEGAL_RESOURCES:int = 44;
        public static const FOREIGN_ZONE:int = 45;
        public static const QUEUING_NOT_ALLOWED:int = 46;
        public static const CANNOT_TEAR_DOWN_BUILDING_KNOCKDOWN_DISALLOWED:int = 47;
        public static const NO_BUILDING_AT_POSITION:int = 60;
        public static const BUILDING_NOT_MOVEABLE:int = 61;
        public static const BUILDING_ALREADY_MOVING:int = 62;
        public static const BUILDING_ALREADY_DESTRUCTED:int = 63;
        public static const SHOP_ITEM_NOT_FOUND:int = 90;
        public static const ACCEPT_TRADE_MAIL_ALREADY_DELETED:int = 91;
        public static const COULD_NOT_FIND_TRADE_IN_DB:int = 92;
        public static const TRADE_ALREADY_ACCEPTED:int = 93;
        public static const UNKNOWN_TRADE_TYPE:int = 94;
        public static const CANNOT_ACCEPT_TRADE_INSUFFICIENT_RESOURCES:int = 95;
        public static const CANNOT_ACCEPT_TRADE_BUFF_NOT_AVAILABLE:int = 96;
        public static const OTHER_TRADE_ERROR:int = 97;
        public static const SPECIALIST_TRANSPORTER_NO_FIGHT:int = 98;
        public static const BLACKLIST_MATCH:int = 98;
        public static const ACCEPT_ADVENTURE_IS_NOT_ACTIVE:int = 99;
        public static const ADVENTURE_MAXIMUM_CONCURRENT_REACHED:int = 100;
        public static const ADVENTURE_PLAYER_LEVEL_IS_NOT_HIGH_ENOUGH:int = 101;
        public static const BUILDING_IS_NOT_ATTACKABLE:int = 102;
        public static const SEND_MAIL_BLOCKED:int = 103;
        public static const COLONY_IS_UNDER_ATTACK:int = 105;
        public static const CANNOT_ASSIGN_COLONY:int = 106;
        public static const COLONY_ATTACK_TOO_LATE:int = 107;
        public static const PLAYER_TRIED_TO_CLAIM_WRONG_PVP_LEVEL_REWARD:int = 108;
        public static const ADVENTURE_START_CONDITIONS_NOT_MET:int = 109;
        public static const TRYING_TO_BUY_ITEM_REACHED_PER_EVENT:int = 110;
        public static const EVENT_NOT_ACTIVE:int = 111;
        public static const PLAYER_TRIED_TO_BUY_ITEM_OVER_COMP_LIMIT:int = 113;
        public static const TRYING_TO_BUY_ITEM_ON_COOLDOWN:int = 111;
        public static const REQUIREMENTS_NOT_MET:int = 112;
        public static const GENERAL_ERROR:int = 500;
        public static const ILLEGAL_CLASS:int = 510;
        public static const INVALID_GRID_POS:int = 520;
        public static const PLACE_IS_BLOCKED:int = 530;
        public static const MINE_TYPE_PLACE_IS_BLOCKED:int = 531;
        public static const PLACE_IS_BLOCKED_BY_BUILDING:int = 533;
        public static const PLACE_IS_BLOCKED_BY_BUILDING_IN_LIST:int = 534;
        public static const PLACE_IS_BLOCKED_BY_BLOCKING_SYSTEM:int = 535;
        public static const DB_ERROR:int = 540;
        public static const ILLEGAL_VALUE:int = 550;
        public static const QUEST_TRIGGER_ERROR:int = 551;
        public static const INAPPROPRIATE_LANGUAGE:int = 552;
        public static const SERVER_ERROR_CODES:int = 1000;
        public static const SERVER_ZONE_INIT_FAILED:int = 1001;
        public static const SERVER_ZONE_CRASHED:int = 1002;
        public static const SERVER_SHUTDOWN:int = 1003;
        public static const SERVER_PLAYER_TRIES_TO_CHEAT:int = 1004;
        public static const SERVER_NO_VALID_SESSION:int = 1005;
        public static const SERVER_ZONE_BANNED:int = 1006;
        public static const SERVER_VALIDATOR_ERROR_NULL_VALUE_EXCEPTION:int = 1007;
        public static const SERVER_VALIDATOR_ERROR_RANGE_EXCEPTION:int = 1008;
        public static const SERVER_VALIDATOR_ERROR_WRONG_INSTANCE_EXCEPTION:int = 1009;
        public static const SERVER_OVERSTRAINED:int = 1010;
        public static const SERVER_ZONE_SUPPORT_LOCK:int = 1011;
        public static const NEWER_SESSION_DETECTED:int = 1012;
        public static const SERVER_CLIENT_VERSION_MISMATCH:int = 1013;
        public static const SERVER_CLIENT_SETTINGS_DEFINED_MISMATCH:int = 1016;
        public static const SERVER_FRIEND_ZONE_CRASHED:int = 1017;
        public static const GUILD_FOUND_NAME_EXISTS:int = -1000;
        public static const GUILD_FOUND_TAG_EXISTS:int = -1001;
        public static const GUILD_HASGUILD:int = -1002;
        public static const GUILD_NO_GUILD:int = -1003;
        public static const GUILD_EDIT_NOT_ALLOWED:int = -1004;
        public static const GUILD_FULL:int = -1005;
        public static const GUILD_JOIN_COOLDOWN:int = -1006;
        public static const GUILD_FOUND_NO_GUILDHOUSE:int = -1007;
        public static const GUILD_DISBANDED:int = -1008;
        public static const GUILD_SUCCESSION_ERROR:int = -1009;
        public static const GUILD_ALREADY_APPLIED_ERROR:int = -1010;
        public static const GUILD_ALREADY_IN_GUILD:int = -1011;
        public static const GUILD_APPLICANTS_HAS_GUILD:int = -1012;
        public static const GUILD_APPLICANT_COOLDOWN:int = -1013;
        public static const GUILD_APPLY_GUILD_FULL:int = -1014;
        public static const GUILD_RANK_TAB_NO_SELECTED:int = -1500;
        public static const GUILD_BANK_ERROR:int = -1501;
        public static const GUILD_TAB_NAME_INVALID:int = -1502;
        public static const GUILD_BANK_DAILY_LIMIT_ERROR:int = -1503;
        public static const GUILD_BANK_PAY_PERMISSION_ERROR:int = -1504;
        public static const GUILD_BANK_WITHDRAW_PERMISSION_ERROR:int = -1505;
        public static const GUILD_BANK_TRANSFER_ERROR:int = -1506;
        public static const GET_COMBAT_STATS_NOT_FOUND:int = -2000;
        public static const BB_AUTH_FAILED:String = "BigBrother.AuthFailed";
        public static const BB_SERVICE_FAILED:String = "BigBrother.ServiceFailed";
        public static const BB_FILE_NOT_FOUND:String = "BigBrother.FileNotFound";
        public static const BB_SERVERS_FULL:String = "BigBrother.ServerFull";


        public static function toString(_arg_1:int):String
        {
            switch (_arg_1)
            {
                case NO_ERROR:
                    return ("No Error");
                case BUILD_QUEUE_FULL:
                    return ("Build queue is full");
                case INVALID_BUILD_POS:
                    return ("Invalid build position");
                case MAX_NUMBER_OF_BUILDINGS_REACHED:
                    return ("Max number of buildings reached");
                case COULD_NOT_BUILD_UNKNOWN_REASON:
                    return ("Could not build - unknown reason");
                case BUILDING_TO_ATTACK_IS_NULL:
                    return ("Building to attack is null");
                case COULD_NOT_FIND_BUILDING:
                    return ("Could not find building");
                case COULD_NOT_AFFORD_SPECIALIST:
                    return ("Could not afford specialist");
                case BUILDING_IS_ON_FOG:
                    return ("Building should be build on fog of war");
                case PLAYER_IS_NOT_SECTOR_OWNER:
                    return ("Player does not own sector");
                case PLACE_IS_NOT_REACHABLE:
                    return ("Place is not reachable");
                case COULD_NOT_FIND_MAIL_IN_DB:
                    return ("Could not find mail in database");
                case MAX_AMOUNT_OF_SPECIALIST_TYPE_REACHED:
                    return ("MaxAmountOfSpecialistTypeReached");
                case MAX_AMOUNT_OF_SHOP_ITEM_REACHED:
                    return ("MaxAmountOfShopItemReached");
                case COULD_NOT_FIND_SPECIALIST:
                    return ("CouldNotFindSpecialist");
                case SPECIALIST_ALREADY_HAS_TASK:
                    return ("SpecialistAlreadyHasTask");
                case MAIL_WAS_DELETED:
                    return ("MailWasDeleted");
                case MALFORMED_ID:
                    return ("MalformedId");
                case UNKNOWN_BUFF_TYPE:
                    return ("UnknownBuffType");
                case SECTOR_IS_OWNED_BY_BANDITS:
                    return ("Sector is owned by bandits");
                case CANNOT_TEAR_DOWN_INITIAL_BUILDING:
                    return ("CannotTearDownInitialBuilding");
                case CANNOT_TEAR_DOWN_GARRISON:
                    return ("CannotTearDownGarrison");
                case NO_ARMY_HOLDER_DEFINED:
                    return ("NoArmyHolderDefined");
                case UNKNOWN_UNIT_TYPE:
                    return ("UnknownUnitType");
                case BUFF_IS_NOT_PRODUCABLE:
                    return ("BuffIsNotProducable");
                case UNIT_IS_NOT_RECRUITABLE:
                    return ("UnitIsNotRecruitable");
                case UNKNOWN_PRODUCTION_TYPE:
                    return ("UnknownProductionType");
                case PLAYER_LEVEL_TOO_LOW:
                    return ("PlayerLevelTooLow");
                case UNKNOWN_SHOP_ITEM_CONTENT:
                    return ("UnknownShopItemContent");
                case MINE_TYPE_BUILDING_IS_NOT_PLACED_ON_DEPOSIT:
                    return ("Building is not placed on deposit but should");
                case UNKNOWN_DEPOSIT:
                    return ("UnknownDeposit");
                case SPECIALIST_HAS_NO_GARRISON:
                    return ("SpecialistHasNoGarrison");
                case SPECIALIST_HAS_NO_UNITS:
                    return ("SpecialistHasNoUnits");
                case BUILDING_BELONGS_TO_PLAYER:
                    return ("BuildingBelongsToPlayer");
                case CANNOT_INITIATE_TRADE_ON_FOREIGN_ZONE:
                    return ("InitiateTradeOnForeignZone");
                case CANNOT_TRADE_SAME_RESOURCE:
                    return ("CannotTradeSameResource");
                case CANNOT_ACCEPT_LOOT_ON_FOREIGN_ZONE:
                    return ("CannotAccepLootOnForeignZone");
                case CANNOT_RAISE_ARMY_WITHOUT_MAYORHOUSE:
                    return ("CannotRaiseArmyWithoutMayorhouse");
                case PRODUCTION_AMOUNT_TOO_HIGH:
                    return ("ProductionAmountTooHigh");
                case TRY_TO_BUILD_ON_DEPOSIT:
                    return ("Try to build on deposit");
                case TRY_TO_GIFT_NON_GIFTABLE_SHOP_ITEM:
                    return ("TryToGiftNonGiftableShopItem");
                case TRY_TO_SEARCH_DEPOSIT_WITHOUT_LEVEL:
                    return ("TryToSearchDepositWithoutLevel");
                case ZONE_IS_NO_ADVENTURE:
                    return ("ZoneIsNoAdventure");
                case TRADE_WITH_ILLEGAL_RESOURCES:
                    return ("Trading untradeable resources");
                case FOREIGN_ZONE:
                    return ("Forbidden command on foreign zone");
                case QUEUING_NOT_ALLOWED:
                    return ("Queuing isn't allowed");
                case NO_BUILDING_AT_POSITION:
                    return ("No Building at Position");
                case SHOP_ITEM_NOT_FOUND:
                    return ("Shop Item not found");
                case COULD_NOT_FIND_TRADE_IN_DB:
                    return ("Could not find trade in database");
                case TRADE_ALREADY_ACCEPTED:
                    return ("Trade is already accepted.");
                case UNKNOWN_TRADE_TYPE:
                    return ("Trade type is unknown.");
                case REQUIREMENTS_NOT_MET:
                    return ("Requirements not met.");
                case INAPPROPRIATE_LANGUAGE:
                    return ("InappropriateLanguage");
                case CANNOT_TEAR_DOWN_BUILDING_KNOCKDOWN_DISALLOWED:
                    return ("Building not allowed to knock down!");
                case GENERAL_ERROR:
                    return ("General error");
                case ILLEGAL_CLASS:
                    return ("Illegal class");
                case INVALID_GRID_POS:
                    return ("Grid Position is invalid");
                case MINE_TYPE_PLACE_IS_BLOCKED:
                case PLACE_IS_BLOCKED_BY_BUILDING:
                    return ("Building place is blocked");
                case DB_ERROR:
                    return ("Database error");
                case ILLEGAL_VALUE:
                    return ("Illegal Value");
                case NEWER_SESSION_DETECTED:
                    return ("NewerSessionDetected");
                case GUILD_EDIT_NOT_ALLOWED:
                    return ("GuildEditNotAllowed");
                case GUILD_HASGUILD:
                    return ("GuildHasGuild");
                case GUILD_FOUND_NAME_EXISTS:
                    return ("GuildFoundNameExists");
                case GUILD_FOUND_TAG_EXISTS:
                    return ("GuildFoundTagExists");
                case GUILD_FULL:
                    return ("GuildFull");
                case GUILD_JOIN_COOLDOWN:
                    return ("GuildJoinCooldown");
                case GUILD_NO_GUILD:
                    return ("GuildNoGuild");
                case GUILD_FOUND_NO_GUILDHOUSE:
                    return ("GuildFoundNoGuildHouse");
                case GUILD_DISBANDED:
                    return ("GuildDisbanded");
                case GUILD_SUCCESSION_ERROR:
                    return ("GuildSuccessionError");
                case GUILD_ALREADY_APPLIED_ERROR:
                    return ("GuildAlreadyApplied");
                case GUILD_ALREADY_IN_GUILD:
                    return ("GuildAlreadyInGuild");
                case GUILD_APPLICANTS_HAS_GUILD:
                    return ("GuildApplicantHasGuild");
                case GUILD_APPLICANT_COOLDOWN:
                    return ("GuildApplicantCooldown");
                case GUILD_APPLY_GUILD_FULL:
                    return ("GuildApplyGuildFull");
                case GUILD_RANK_TAB_NO_SELECTED:
                    return ("GuildRankTabNoSelectError");
                case GUILD_BANK_ERROR:
                    return ("GuildBankError");
                case GUILD_TAB_NAME_INVALID:
                    return ("GuildTabInvalidName");
                case GUILD_BANK_DAILY_LIMIT_ERROR:
                    return ("GuildDailyLimitError");
                case GUILD_BANK_PAY_PERMISSION_ERROR:
                    return ("GuildPayPermissionError");
                case GUILD_BANK_WITHDRAW_PERMISSION_ERROR:
                    return ("GuildWithdrawPermissionError");
                case GUILD_BANK_TRANSFER_ERROR:
                    return ("GuildTransferPermissionError");
                case GET_COMBAT_STATS_NOT_FOUND:
                    return ("GetCombatStatsNotFound");
                case SEND_MAIL_BLOCKED:
                    return ("SendMailBlocked");
                case COLONY_IS_UNDER_ATTACK:
                    return ("ColonyIsUnderAttack");
                case CANNOT_ASSIGN_COLONY:
                    return ("CannotAssignColony");
                case COLONY_ATTACK_TOO_LATE:
                    return ("ColonyAttackTooLate");
                case PLAYER_TRIED_TO_CLAIM_WRONG_PVP_LEVEL_REWARD:
                    return ("PlayerTriedToClaimWrongPvPLevelReward");
                case PLAYER_TRIED_TO_BUY_ITEM_OVER_COMP_LIMIT:
                    return ("PlayerTriedToExceedComprehensiveLimitation");
                case SERVER_FRIEND_ZONE_CRASHED:
                    return ("FriendZoneCrashed");
                case SERVER_ZONE_INIT_FAILED:
                    return ("ZoneInitFailed");
                case SERVER_ZONE_CRASHED:
                    return ("ZoneCrashed");
                case SERVER_OVERSTRAINED:
                    return ("ServerOverstrained");
                default:
                    return ("UNKNOWN_ERROR_CODE_" + _arg_1);
            };
        }


    }
}
