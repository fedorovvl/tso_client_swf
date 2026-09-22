package Enums
{
    public class CURSOR_VALID 
    {

        public static const OK:int = 0;
        public static const BUILDING_PLACED_BUILDING_IS_ALREADY_THERE:int = 1;
        public static const BUILDING_PLACED_BLOCKED_BY_BLOCKING:int = 2;
        public static const SECTOR_BELONGS_TO_BANDITS:int = 3;
        public static const SECTOR_DOES_NOT_BELONG_TO_PLAYER:int = 4;
        public static const MINE_PLACED_NO_DEPOSIT_HERE:int = 5;
        public static const MINE_PLACED_OVER_BUILDING_BUT_IT_IS_NOT_A_DEPLETED_DEPOSIT:int = 6;
        public static const GARISSON_SECTOR_IS_OWNED_BY_BANDITS:int = 7;
        public static const ATTACK_MODE_NO_BUILDING_AT_DESTINATION:int = 8;
        public static const ATTACK_MODE_BUILDING_BELONGS_TO_HOMEZONE_PLAYER:int = 9;
        public static const ATTACK_MODE_BUILDING_IS_NOT_ATTACKABLE:int = 10;
        public static const APPLY_BUFF_BUILDING_IS_INACTIVE:int = 11;
        public static const APPLY_BUFF_NO_BUILDING_AT_POSITION:int = 12;
        public static const APPLY_BUFF_ON_DEPOSIT_NO_DEPOSIT_HERE:int = 13;
        public static const APPLY_BUFF_NOT_ENOUGH_RESOURCES:int = 14;
        public static const ILLEGAL_POS:int = 15;
        public static const PLACE_IS_COVERED_WITH_FOG:int = 16;
        public static const PLACE_IS_BLOCKED_BY_BUILDING:int = 17;
        public static const SECTOR_IS_OWNED_BY_BANDITS:int = 18;
        public static const ATTACK_MODE_ON_ADVENTURE_ZONE_BUT_NOT_PVP:int = 19;
        public static const ATTACK_MODE_BUILDING_BELONGS_TO_CURRENT_PLAYER:int = 20;
        public static const ATTACK_MODE_HIDDEN_CAMP:int = 21;
        public static const APPLY_BUFF_ON_FOREIGN_ZONE_BUILDING_IS_NOT_OF_CORRECT_TYPE:int = 22;
        public static const APPLY_BUFF_ON_GUILD_HOUSE_PLAYER_IS_NOT_IN_GUILD:int = 23;
        public static const APPLY_BUFF_ON_GUILD_HOUSE_MAXIMUM_NUMBER_OF_GUILD_MEMBERS_REACHED:int = 24;
        public static const APPLY_BUFF_MAXIMUM_NUMBER_OF_BUFFS_REACHED_FOR_THIS_BUILDING:int = 25;
        public static const APPLY_BUFF_DEPOSIT_IS_OF_WRONG_TYPE:int = 26;
        public static const APPLY_BUFF_ZONE_IS_NOT_HOMEZONE:int = 27;
        public static const APPLY_BUFF_TEMPORARILY_BLOCKED:int = 28;
        public static const APPLY_BUFF_BANDITS_EMPTY:int = 29;
        public static const APPLY_BUFF_UNIT_NOT_AVAILABLE:int = 30;
        public static const BUILDING_PLACED_PLACE_IS_COVERED_WITH_FOG:int = 31;
        public static const DELETE_BUILDING_RESTRICTED:int = 32;
        public static const MOVE_BUILDING_RESTRICTED:int = 33;
        public static const PLACE_IS_NOT_REACHABLE_BY_PATH_FINDING:int = 34;
        public static const MINE_TYPE_PLACE_IS_BLOCKED:int = 35;
        public static const BUILDING_PLACED_TRY_TO_PLACE_NORMAL_BUILDING_OVER_DEPOSIT:int = 36;
        public static const SET_STREET_STREET_ALREADY_AT_POSITION:int = 37;
        public static const SET_STREET_COVERED_WITH_FOG:int = 38;
        public static const SET_STREET_SECTOR_IS_OWNED_BY_BANDITS:int = 39;
        public static const SET_STREET_SECTOR_IS_NOT_OWNED_BY_PLAYER:int = 40;
        public static const SET_STREET_PLACE_IS_BLOCKED_BY_DEPOSIT:int = 41;
        public static const SET_STREET_PLACE_IS_BLOCKED_BY_BLOCKING:int = 42;
        public static const ATTACK_MODE_PLAYER_ID_OF_BUILDING_IS_ZERO_SNH:int = 43;
        public static const APPLY_BUFF_NO_PLAYER_SNH:int = 44;
        public static const APPLY_BUFF_COULD_NOT_INTERPRET_TYPE_SNH:int = 45;
        public static const APPLY_BUFF_WRONG_ZONE_TYPE:int = 46;
        public static const BUILDING_PLACED_BUILDING_IS_IN_LIST_SNH:int = 47;
        public static const EDITOR_PLACE_ALLOCATED_WITH_BUILDING:int = 48;
        public static const EDITOR_PLACE_ALLOCATED_WITH_STREET:int = 49;
        public static const EDITOR_PLACE_OTHER_BUILDING_IS_TO_NEAR:int = 50;
        public static const CULTURE_BUILDING_ON_COOLDOWN:int = 51;
        public static const APPLY_BUFF_CONDITIONS_NOT_FULFILLED:int = 52;


        public static function toString(_arg_1:int):String
        {
            switch (_arg_1)
            {
                case OK:
                    return ("OK");
                case BUILDING_PLACED_BUILDING_IS_ALREADY_THERE:
                    return ("BUILDING_PLACED_BUILDING_IS_ALREADY_THERE");
                case BUILDING_PLACED_BLOCKED_BY_BLOCKING:
                    return ("BUILDING_PLACED_BLOCKED_BY_BLOCKING");
                case ILLEGAL_POS:
                    return ("ILLEGAL_POS");
                case PLACE_IS_COVERED_WITH_FOG:
                    return ("PLACE_IS_COVERED_WITH_FOG");
                case PLACE_IS_BLOCKED_BY_BUILDING:
                    return ("PLACE_IS_BLOCKED_BY_BUILDING");
                case SECTOR_BELONGS_TO_BANDITS:
                    return ("SECTOR_BELONGS_TO_BANDITS");
                case SECTOR_DOES_NOT_BELONG_TO_PLAYER:
                    return ("SECTOR_DOES_NOT_BELONG_TO_PLAYER");
                case SECTOR_IS_OWNED_BY_BANDITS:
                    return ("SECTOR_IS_OWNED_BY_BANDITS");
                case ATTACK_MODE_NO_BUILDING_AT_DESTINATION:
                    return ("ATTACK_MODE_NO_BUILDING_AT_DESTINATION");
                case ATTACK_MODE_BUILDING_BELONGS_TO_CURRENT_PLAYER:
                    return ("ATTACK_MODE_BUILDING_BELONGS_TO_CURRENT_PLAYER");
                case ATTACK_MODE_BUILDING_BELONGS_TO_HOMEZONE_PLAYER:
                    return ("ATTACK_MODE_BUILDING_BELONGS_TO_HOMEZONE_PLAYER");
                case ATTACK_MODE_BUILDING_IS_NOT_ATTACKABLE:
                    return ("ATTACK_MODE_BUILDING_IS_NOT_ATTACKABLE");
                case ATTACK_MODE_ON_ADVENTURE_ZONE_BUT_NOT_PVP:
                    return ("ATTACK_MODE_ON_ADVENTURE_ZONE_BUT_NOT_PVP");
                case APPLY_BUFF_NO_BUILDING_AT_POSITION:
                    return ("APPLY_BUFF_NO_BUILDING_AT_POSITION");
                case APPLY_BUFF_ON_FOREIGN_ZONE_BUILDING_IS_NOT_OF_CORRECT_TYPE:
                    return ("APPLY_BUFF_ON_FOREIGN_ZONE_BUILDING_IS_NOT_OF_CORRECT_TYPE");
                case APPLY_BUFF_ON_GUILD_HOUSE_PLAYER_IS_NOT_IN_GUILD:
                    return ("APPLY_BUFF_ON_GUILD_HOUSE_PLAYER_IS_NOT_IN_GUILD");
                case APPLY_BUFF_ON_GUILD_HOUSE_MAXIMUM_NUMBER_OF_GUILD_MEMBERS_REACHED:
                    return ("APPLY_BUFF_ON_GUILD_HOUSE_MAXIMUM_NUMBER_OF_GUILD_MEMBERS_REACHED");
                case APPLY_BUFF_BUILDING_IS_INACTIVE:
                    return ("APPLY_BUFF_BUILDING_IS_INACTIVE");
                case APPLY_BUFF_MAXIMUM_NUMBER_OF_BUFFS_REACHED_FOR_THIS_BUILDING:
                    return ("APPLY_BUFF_MAXIMUM_NUMBER_OF_BUFFS_REACHED_FOR_THIS_BUILDING");
                case APPLY_BUFF_ON_DEPOSIT_NO_DEPOSIT_HERE:
                    return ("APPLY_BUFF_ON_DEPOSIT_NO_DEPOSIT_HERE");
                case APPLY_BUFF_DEPOSIT_IS_OF_WRONG_TYPE:
                    return ("APPLY_BUFF_DEPOSIT_IS_OF_WRONG_TYPE");
                case APPLY_BUFF_ZONE_IS_NOT_HOMEZONE:
                    return ("APPLY_BUFF_ZONE_IS_NOT_HOMEZONE");
                case BUILDING_PLACED_PLACE_IS_COVERED_WITH_FOG:
                    return ("BUILDING_PLACED_PLACE_IS_COVERED_WITH_FOG");
                case GARISSON_SECTOR_IS_OWNED_BY_BANDITS:
                    return ("GARISSON_SECTOR_IS_OWNED_BY_BANDITS");
                case DELETE_BUILDING_RESTRICTED:
                    return ("DELETE_BUILDING_RESTRICTED");
                case PLACE_IS_NOT_REACHABLE_BY_PATH_FINDING:
                    return ("PLACE_IS_NOT_REACHABLE_BY_PATH_FINDING");
                case MINE_PLACED_OVER_BUILDING_BUT_IT_IS_NOT_A_DEPLETED_DEPOSIT:
                    return ("MINE_PLACED_OVER_BUILDING_BUT_IT_IS_NOT_A_DEPLETED_DEPOSIT");
                case MINE_PLACED_NO_DEPOSIT_HERE:
                    return ("MINE_PLACED_NO_DEPOSIT_HERE");
                case BUILDING_PLACED_TRY_TO_PLACE_NORMAL_BUILDING_OVER_DEPOSIT:
                    return ("BUILDING_PLACED_TRY_TO_PLACE_NORMAL_BUILDING_OVER_DEPOSIT");
                case SET_STREET_STREET_ALREADY_AT_POSITION:
                    return ("SET_STREET_STREET_ALREADY_AT_POSITION");
                case SET_STREET_COVERED_WITH_FOG:
                    return ("SET_STREET_COVERED_WITH_FOG");
                case SET_STREET_SECTOR_IS_OWNED_BY_BANDITS:
                    return ("SET_STREET_SECTOR_IS_OWNED_BY_BANDITS");
                case SET_STREET_SECTOR_IS_NOT_OWNED_BY_PLAYER:
                    return ("SET_STREET_SECTOR_IS_NOT_OWNED_BY_PLAYER");
                case SET_STREET_PLACE_IS_BLOCKED_BY_DEPOSIT:
                    return ("SET_STREET_PLACE_IS_BLOCKED_BY_DEPOSIT");
                case SET_STREET_PLACE_IS_BLOCKED_BY_BLOCKING:
                    return ("SET_STREET_PLACE_IS_BLOCKED_BY_BLOCKING");
                case ATTACK_MODE_PLAYER_ID_OF_BUILDING_IS_ZERO_SNH:
                    return ("ATTACK_MODE_PLAYER_ID_OF_BUILDING_IS_ZERO_SNH");
                case APPLY_BUFF_NO_PLAYER_SNH:
                    return ("APPLY_BUFF_NO_PLAYER_SNH");
                case APPLY_BUFF_COULD_NOT_INTERPRET_TYPE_SNH:
                    return ("APPLY_BUFF_COULD_NOT_INTERPRET_TYPE_SNH");
                case APPLY_BUFF_WRONG_ZONE_TYPE:
                    return ("APPLY_BUFF_WRONG_ZONE_TYPE");
                case BUILDING_PLACED_BUILDING_IS_IN_LIST_SNH:
                    return ("BUILDING_PLACED_BUILDING_IS_IN_LIST_SNH");
                case MINE_TYPE_PLACE_IS_BLOCKED:
                    return ("MINE_TYPE_PLACE_IS_BLOCKED");
                case EDITOR_PLACE_ALLOCATED_WITH_BUILDING:
                    return ("EDITOR_PLACE_ALLOCATED_WITH_BUILDING");
                case EDITOR_PLACE_ALLOCATED_WITH_STREET:
                    return ("EDITOR_PLACE_ALLOCATED_WITH_STREET");
                case EDITOR_PLACE_OTHER_BUILDING_IS_TO_NEAR:
                    return ("EDITOR_PLACE_OTHER_BUILDING_IS_TO_NEAR");
                case CULTURE_BUILDING_ON_COOLDOWN:
                    return ("CULTURE_BUILDING_ON_COOLDOWN");
                case APPLY_BUFF_CONDITIONS_NOT_FULFILLED:
                    return ("APPLY_BUFF_CONDITIONS_NOT_FULFILLED");
            };
            return ("Unknown: " + _arg_1);
        }


    }
}
