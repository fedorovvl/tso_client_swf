package Enums
{
    import Utils.StringUtils;

    public class ADVENTURE_MODE 
    {

        public static const MODE_CLASSIC:int = 0;
        public static const MODE_EXPEDITION:int = 1;
        public static const MODE_EXPEDITION_PVE:int = 2;
        public static const MODE_EXPEDITION_PVP:int = 3;
        public static const MODE_BUFF_ADVENTURE:int = 4;
        public static const MODE_MIXED_ADVENTURE:int = 5;


        public static function toString(_arg_1:int):String
        {
            switch (_arg_1)
            {
                case MODE_CLASSIC:
                    return ("classic");
                case MODE_EXPEDITION:
                    return ("expedition");
                case MODE_EXPEDITION_PVE:
                    return ("pve");
                case MODE_EXPEDITION_PVP:
                    return ("pvp");
                case MODE_BUFF_ADVENTURE:
                    return ("buff");
                case MODE_MIXED_ADVENTURE:
                    return ("mixed");
                default:
                    return ("Unknown: " + _arg_1);
            };
        }

        public static function stringToBitField(_arg_1:String):int
        {
            var _local_3:String;
            var _local_4:int;
            var _local_5:int;
            var _local_2:int;
            if (!StringUtils.isEmpty(_arg_1))
            {
                for each (_local_3 in StringUtils.split(_arg_1, StringUtils.COMMA))
                {
                    _local_4 = ADVENTURE_MODE.fromString(_local_3);
                    if (_local_4 > -1)
                    {
                        _local_5 = (1 << _local_4);
                        _local_2 = (_local_2 | _local_5);
                    };
                };
            }
            else
            {
                _local_2 = -1;
            };
            return (_local_2);
        }

        public static function fromString(_arg_1:String):int
        {
            if ("classic" == _arg_1)
            {
                return (MODE_CLASSIC);
            };
            if ("expedition" == _arg_1)
            {
                return (MODE_EXPEDITION);
            };
            if ("pve" == _arg_1)
            {
                return (MODE_EXPEDITION_PVE);
            };
            if ("pvp" == _arg_1)
            {
                return (MODE_EXPEDITION_PVP);
            };
            if ("buff" == _arg_1)
            {
                return (MODE_BUFF_ADVENTURE);
            };
            if ("mixed" == _arg_1)
            {
                return (MODE_MIXED_ADVENTURE);
            };
            return (-1);
        }


    }
}
