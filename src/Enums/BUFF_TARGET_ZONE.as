package Enums
{
    import nLib.gMisc;

    public class BUFF_TARGET_ZONE 
    {

        public static const HOME:int = (1 << 0);
        public static const FRIEND:int = (1 << 1);
        public static const ADVENTURE:int = (1 << 2);
        public static const EXPEDITION:int = (1 << 3);
        public static const DEFENSE_MODE:int = (1 << 4);


        public static function toString(_arg_1:int):String
        {
            var _local_2:* = "";
            if ((_arg_1 & HOME) > 0)
            {
                _local_2 = (_local_2 + "Home");
            };
            if ((_arg_1 & FRIEND) > 0)
            {
                _local_2 = (_local_2 + (((_local_2.length > 0) ? "," : "") + "Friend"));
            };
            if ((_arg_1 & ADVENTURE) > 0)
            {
                _local_2 = (_local_2 + (((_local_2.length > 0) ? "," : "") + "Adventure"));
            };
            if ((_arg_1 & EXPEDITION) > 0)
            {
                _local_2 = (_local_2 + (((_local_2.length > 0) ? "," : "") + "Expedition"));
            };
            if ((_arg_1 & DEFENSE_MODE) > 0)
            {
                _local_2 = (_local_2 + (((_local_2.length > 0) ? "," : "") + "DefenseMode"));
            };
            return (_local_2);
        }

        public static function parse(_arg_1:String):int
        {
            var _local_4:String;
            if (_arg_1.length == 0)
            {
                return (0);
            };
            var _local_2:int;
            var _local_3:Array = _arg_1.split(",");
            for each (_local_4 in _local_3)
            {
                if (_local_4 == "Home")
                {
                    _local_2 = (_local_2 | HOME);
                }
                else
                {
                    if (_local_4 == "Friend")
                    {
                        _local_2 = (_local_2 | FRIEND);
                    }
                    else
                    {
                        if (_local_4 == "Adventure")
                        {
                            _local_2 = (_local_2 | ADVENTURE);
                        }
                        else
                        {
                            if (_local_4 == "Expedition")
                            {
                                _local_2 = (_local_2 | EXPEDITION);
                            }
                            else
                            {
                                if (_local_4 == "DefenseMode")
                                {
                                    _local_2 = (_local_2 | DEFENSE_MODE);
                                }
                                else
                                {
                                    gMisc.Assert(false, (("Could not interpret target zone string '" + _local_4) + "'!"));
                                };
                            };
                        };
                    };
                };
            };
            return (_local_2);
        }


    }
}
