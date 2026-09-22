package BuffSystem
{
    import Utils.HashMapWrapper;
    import AdventureSystem.cAdventureDefinition;
    import Utils.StringUtils;
    import com.bluebyte.tso.adventure.logic.AdventureManager;

    public class BuffAdventureController 
    {

        private static const buff2adventure:HashMapWrapper = new HashMapWrapper();


        public static function init(_arg_1:Object, _arg_2:Array):void
        {
            var _local_4:cAdventureDefinition;
            var _local_5:cBuffDefinition;
            var _local_6:String;
            var _local_7:String;
            var _local_3:HashMapWrapper = new HashMapWrapper();
            for each (_local_4 in _arg_2)
            {
                if (((_local_4.IsUsingAdventureSpecificBuffs()) && (!(StringUtils.isEmpty(_local_4.GetConnectedBuffGroup())))))
                {
                    if (_local_3.getItem(_local_4.GetConnectedBuffGroup()) != null)
                    {
                        _local_6 = (_local_3.getItem(_local_4.GetConnectedBuffGroup()) as String);
                        _local_3.putItem(_local_4.GetConnectedBuffGroup(), ((_local_6 + ",") + _local_4.GetName()));
                    }
                    else
                    {
                        _local_3.putItem(_local_4.GetConnectedBuffGroup(), _local_4.GetName());
                    };
                };
            };
            for each (_local_5 in _arg_1)
            {
                _local_7 = (_local_3.getItem(_local_5.GetGroup_string()) as String);
                if (_local_7 != null)
                {
                    buff2adventure.putItem(_local_5.GetName_string(), _local_7);
                };
            };
            _local_3.clear();
        }

        public static function isBuffAdventureBuff(_arg_1:String):Boolean
        {
            return (!(StringUtils.isEmpty(getBuffAdventureForBuff_string(_arg_1))));
        }

        public static function getBuffAdventureForBuff_string(_arg_1:String):String
        {
            return (buff2adventure.getItem(_arg_1) as String);
        }

        public static function isActiveBuffAdventureBuffOrNormalBuff(_arg_1:String):Boolean
        {
            var _local_2:String;
            if (buff2adventure.hasKey(_arg_1))
            {
                for each (_local_2 in getBuffAdventureForBuff_string(_arg_1).split(","))
                {
                    if (AdventureManager.getInstance().isAdventureActive(_local_2))
                    {
                        return (true);
                    };
                };
                return (false);
            };
            return (true);
        }


    }
}
