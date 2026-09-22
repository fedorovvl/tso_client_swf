package Enums
{
    public class MILITARY_UNIT_PROPERTY 
    {

        public static const ID:int = 1;
        public static const ATTACK_PRIORITY:int = 2;
        public static const INSTANT_BUILD_COST:int = 3;
        public static const IS_BOSS:int = 4;
        public static const IS_PRODUCIBLE:int = 5;
        public static const IS_SPECIALIST:int = 6;
        public static const PRODUCTION_TIME:int = 7;
        public static const INITIATIVE:int = 8;
        public static const UI_PRIORITY:int = 9;
        public static const DEFENSE_PRIORITY:int = 10;
        public static const UNIT_CATEGORY:int = 11;


        public static function toString(_arg_1:int):String
        {
            switch (_arg_1)
            {
                case ID:
                    return ("Id");
                case ATTACK_PRIORITY:
                    return ("AttackPriority");
                case DEFENSE_PRIORITY:
                    return ("DefensePriority");
                case INITIATIVE:
                    return ("Initiative");
                case INSTANT_BUILD_COST:
                    return ("InstantBuildCost");
                case IS_BOSS:
                    return ("IsBoss");
                case IS_PRODUCIBLE:
                    return ("IsProducible");
                case IS_SPECIALIST:
                    return ("IsSpecialist");
                case PRODUCTION_TIME:
                    return ("ProductionTime");
                case UI_PRIORITY:
                    return ("UIPriority");
                case UNIT_CATEGORY:
                    return ("UnitCategory");
                default:
                    return ("Unknown: " + _arg_1);
            };
        }

        public static function parse(_arg_1:String):int
        {
            _arg_1 = _arg_1.toLowerCase();
            if (_arg_1 == "id")
            {
                return (ID);
            };
            if (((_arg_1 == "attack_priority") || (_arg_1 == "attackpriority")))
            {
                return (ATTACK_PRIORITY);
            };
            if (((_arg_1 == "defense_priority") || (_arg_1 == "defensepriority")))
            {
                return (DEFENSE_PRIORITY);
            };
            if (_arg_1 == "initiative")
            {
                return (INITIATIVE);
            };
            if (((_arg_1 == "instant_build_cost") || (_arg_1 == "instantbuildcost")))
            {
                return (INSTANT_BUILD_COST);
            };
            if (((_arg_1 == "is_bos") || (_arg_1 == "isboss")))
            {
                return (IS_BOSS);
            };
            if (((_arg_1 == "is_producible") || (_arg_1 == "isproducible")))
            {
                return (IS_PRODUCIBLE);
            };
            if (((_arg_1 == "is_specialist") || (_arg_1 == "isspecialist")))
            {
                return (IS_SPECIALIST);
            };
            if (((_arg_1 == "production_time") || (_arg_1 == "productiontime")))
            {
                return (PRODUCTION_TIME);
            };
            if (((_arg_1 == "ui_priority") || (_arg_1 == "uipriority")))
            {
                return (UI_PRIORITY);
            };
            if (((_arg_1 == "unit_category") || (_arg_1 == "unitcategory")))
            {
                return (UNIT_CATEGORY);
            };
            return (0);
        }


    }
}
