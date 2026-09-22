package Enums
{
    public class ONE_CLICK_SHOPITEM 
    {

        public static const INSTANT_BUILDING_CONSTRUCTION:int = 8000;
        public static const INSTANT_PROVISIONHOUSE_PRODUCTION:int = 8002;
        public static const INSTANT_BARRACKS_PRODUCTION:int = 8003;
        public static const INSTANT_BUILDING_UPGRADE:int = 8004;
        public static const HALF_SPECIALIST_TIME:int = 8005;
        public static const PAY_FOR_QUEST_FINISH:int = 8006;
        public static const BUY_TEMP_BUILD_QUEUE_SLOT:int = 8007;
        public static const BUY_TRADE_SLOT_FOR_COINS:int = 8008;
        public static const BUY_TRADE_SLOT_FOR_GEMS:int = 8009;
        public static const BUY_TRADE_UNLIMITED_LOTS:int = 8010;
        public static const INSTANT_SKILL_TIMED_PRODUCTION:int = 8011;
        public static const INSTANT_COLLECTION_TIMED_PRODUCTION:int = 8012;
        public static const INSTANT_EXPEDITION_PRODUCTION:int = 8013;
        public static const BUY_PERMANENT_COLONY_SLOT:int = 8014;
        public static const BUY_TEMP_COLONY_SLOT:int = 8015;
        public static const INSTANT_EXPEDITION_UNIT_PRODUCTION:int = 8016;
        public static const INSTANT_ELITE_UNIT_PRODUCTION:int = 8017;
        public static const INSTANT_SIMPLE_TIMED_PRODUCTION:int = 8018;
        public static const INVALID_SHOPITEM:int = 8999;


        public static function toString(_arg_1:int):String
        {
            switch (_arg_1)
            {
                case INSTANT_BUILDING_CONSTRUCTION:
                    return ("INSTANT_BUILDING_CONSTRUCTION");
                case INSTANT_PROVISIONHOUSE_PRODUCTION:
                    return ("INSTANT_PROVISIONHOUSE_PRODUCTION");
                case INSTANT_BARRACKS_PRODUCTION:
                    return ("INSTANT_BARRACKS_PRODUCTION");
                case INSTANT_BUILDING_UPGRADE:
                    return ("INSTANT_BUILDING_UPGRADE");
                case HALF_SPECIALIST_TIME:
                    return ("HALF_SPECIALIST_TIME");
                case PAY_FOR_QUEST_FINISH:
                    return ("PAY_FOR_QUEST_FINISH");
                case BUY_PERMANENT_COLONY_SLOT:
                    return ("BUY_PERMANENT_COLONY_SLOT");
                case BUY_TEMP_BUILD_QUEUE_SLOT:
                    return ("BUY_TEMP_BUILD_QUEUE_SLOT");
                case BUY_TEMP_COLONY_SLOT:
                    return ("BUY_TEMP_COLONY_SLOT");
                case BUY_TRADE_SLOT_FOR_COINS:
                    return ("BUY_TRADE_SLOT_FOR_COINS");
                case BUY_TRADE_SLOT_FOR_GEMS:
                    return ("BUY_TRADE_SLOT_FOR_GEMS");
                case BUY_TRADE_UNLIMITED_LOTS:
                    return ("BUY_TRADE_UNLIMITED_LOTS");
                case INSTANT_SKILL_TIMED_PRODUCTION:
                    return ("INSTANT_SKILL_TIMED_PRODUCTION");
                case INSTANT_COLLECTION_TIMED_PRODUCTION:
                    return ("INSTANT_COLLECTION_TIMED_PRODUCTION");
                case INSTANT_EXPEDITION_PRODUCTION:
                    return ("INSTANT_EXPEDITION_PRODUCTION");
                case INSTANT_ELITE_UNIT_PRODUCTION:
                    return ("INSTANT_ELITE_UNIT_PRODUCTION");
                case INVALID_SHOPITEM:
                    return ("INVALID_SHOPITEM");
                case INSTANT_SIMPLE_TIMED_PRODUCTION:
                    return ("INSTANT_SIMPLE_TIMED_PRODUCTION");
                default:
                    return ("ONE_CLICK_SHOPITEM_" + _arg_1);
            };
        }


    }
}
