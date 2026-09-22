package Enums
{
    import nLib.gMisc;

    public class ITEM_CONTENT_TYPE 
    {

        public static const BUFF:int = 0;
        public static const RESOURCE:int = 1;
        public static const MILITARY_UNIT:int = 2;
        public static const BUILDING:int = 3;
        public static const SPECIALIST:int = 4;
        public static const ADVENTURE:int = 5;
        public static const NOTHING:int = 6;
        public static const XP:int = 7;
        public static const LOOT:int = 8;
        public static const PVP_XP:int = 9;
        public static const COLLECTION_PART:int = 10;


        public static function toString(_arg_1:int):String
        {
            switch (_arg_1)
            {
                case BUFF:
                    return ("Buff");
                case RESOURCE:
                    return ("Resource");
                case MILITARY_UNIT:
                    return ("MilitaryUnit");
                case BUILDING:
                    return ("Building");
                case SPECIALIST:
                    return ("Specialist");
                case ADVENTURE:
                    return ("Adventure");
                case NOTHING:
                    return ("Nothing");
                case XP:
                    return ("XP");
                case LOOT:
                    return ("Loot");
                case PVP_XP:
                    return ("PvPXP");
                case COLLECTION_PART:
                    return ("CollectionPart");
                default:
                    return ("Unknown: " + _arg_1);
            };
        }

        public static function parse(_arg_1:String):int
        {
            if (_arg_1 == toString(BUFF))
            {
                return (BUFF);
            };
            if (_arg_1 == toString(RESOURCE))
            {
                return (RESOURCE);
            };
            if (_arg_1 == toString(MILITARY_UNIT))
            {
                return (MILITARY_UNIT);
            };
            if (_arg_1 == toString(BUILDING))
            {
                return (BUILDING);
            };
            if (_arg_1 == toString(SPECIALIST))
            {
                return (SPECIALIST);
            };
            if (_arg_1 == toString(ADVENTURE))
            {
                return (ADVENTURE);
            };
            if (_arg_1 == toString(NOTHING))
            {
                return (NOTHING);
            };
            if (_arg_1 == toString(XP))
            {
                return (XP);
            };
            if (_arg_1 == toString(LOOT))
            {
                return (LOOT);
            };
            if (_arg_1 == toString(PVP_XP))
            {
                return (PVP_XP);
            };
            if (_arg_1 == toString(COLLECTION_PART))
            {
                return (COLLECTION_PART);
            };
            gMisc.Assert(false, (("Could not interpret item content string '" + _arg_1) + "'!"));
            return (-1);
        }


    }
}
