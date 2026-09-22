package Utils
{
    import mx.utils.StringUtil;

    public class StringUtils 
    {

        public static const COMMA:String = ",";
        public static const ELLIPSIS:String = "...";


        public static function GetHashCode(_arg_1:String):int
        {
            var _local_4:int;
            var _local_2:int;
            var _local_3:int = _arg_1.length;
            if (_local_3 > 0)
            {
                _local_4 = 0;
                while (_local_4 < _local_3)
                {
                    _local_2 = ((31 * _local_2) + _arg_1.charCodeAt(_local_4));
                    _local_4++;
                };
            };
            return (_local_2);
        }

        public static function equalsIgnoreCase(_arg_1:String, _arg_2:String):Boolean
        {
            return (_arg_1.toLowerCase() == _arg_2.toLowerCase());
        }

        public static function isEmpty(_arg_1:String):Boolean
        {
            return (isNullOrEmpty(_arg_1));
        }

        public static function splitToHashSet(_arg_1:String, _arg_2:String, _arg_3:Boolean):HashSetWrapper
        {
            var _local_5:String;
            var _local_4:HashSetWrapper = new HashSetWrapper();
            for each (_local_5 in _arg_1.split(_arg_2))
            {
                _local_4.add(((_arg_3) ? StringUtil.trim(_local_5) : _local_5));
            };
            return (_local_4);
        }

        public static function startsWithMultiple(_arg_1:String, ... _args):Boolean
        {
            var _local_3:String;
            var _local_4:Boolean;
            if (((_args == null) || (_arg_1 == null)))
            {
                return (false);
            };
            for each (_local_3 in _args)
            {
                _local_4 = (_local_3 == _arg_1.substr(0, _args.length));
                if (_local_4)
                {
                    return (true);
                };
            };
            return (false);
        }

        public static function zeroPad(_arg_1:int, _arg_2:int):String
        {
            var _local_3:String = _arg_1.toString();
            while (_local_3.length < _arg_2)
            {
                _local_3 = ("0" + _local_3);
            };
            return (_local_3);
        }

        public static function equalsCase(_arg_1:String, _arg_2:String):Boolean
        {
            return (_arg_1 == _arg_2);
        }

        public static function truncateText(_arg_1:String, _arg_2:int):String
        {
            return (_arg_1.substr(0, _arg_2) + ELLIPSIS);
        }

        public static function ToInt(_arg_1:String):int
        {
            if (_arg_1 == null)
            {
                return (0);
            };
            return (parseInt(_arg_1));
        }

        public static function startsWith(_arg_1:String, _arg_2:String):Boolean
        {
            if (((_arg_2 == null) || (_arg_1 == null)))
            {
                return (false);
            };
            return (_arg_2 == _arg_1.substr(0, _arg_2.length));
        }

        public static function SubString(_arg_1:String, _arg_2:int, _arg_3:int):String
        {
            if (_arg_1 == null)
            {
                return (null);
            };
            return (_arg_1.substr(_arg_2, _arg_3));
        }

        public static function isNullOrEmpty(_arg_1:String):Boolean
        {
            return ((_arg_1 == null) || (_arg_1.length == 0));
        }

        public static function split(_arg_1:String, _arg_2:String):Array
        {
            var _local_3:Array = _arg_1.split(_arg_2);
            if (((_local_3.length == 1) && (_local_3[0].length == 0)))
            {
                _local_3 = [];
            };
            return (_local_3);
        }

        public static function contains(_arg_1:String, _arg_2:String):Boolean
        {
            return (_arg_2.indexOf(_arg_1) > -1);
        }


    }
}
