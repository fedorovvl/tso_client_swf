package Enums
{
    import Utils.HashMapWrapper;
    import nLib.gMisc;

    public class PICKUP_PROVIDER_TYPE 
    {

        public static const SUPPORT:int = 0;
        public static const PVP_COLONY:int = 1;
        public static const BUFF_ADVENTURE:int = 2;
        public static const GENERAL_SKILL:int = 3;
        public static const GIVE_COLLECTIBLE_EFFECT:int = 4;
        public static const map:HashMapWrapper = new HashMapWrapper();

        {
            map.putItem(SUPPORT, "support");
            map.putItem(PVP_COLONY, "pvp_colony");
            map.putItem(BUFF_ADVENTURE, "buff_adventure");
            map.putItem(GENERAL_SKILL, "general_skill");
            map.putItem(GIVE_COLLECTIBLE_EFFECT, "give_collectible_effect");
        }


        public static function toString(_arg_1:int):String
        {
            if (!map.hasKey(_arg_1))
            {
                return ("Unknown: " + _arg_1);
            };
            return (map.getItem(_arg_1) as String);
        }

        public static function parse(_arg_1:String):int
        {
            var _local_2:int;
            for each (_local_2 in map.keySet())
            {
                if (map.getItem(_local_2) == _arg_1)
                {
                    return (_local_2);
                };
            };
            gMisc.Assert(false, (("Could not interpret pickup provider type '" + _arg_1) + "'!"));
            return (-1);
        }


    }
}
