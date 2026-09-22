package Utils
{
    import flash.utils.Dictionary;

    public class DictionaryUtils 
    {

        public function DictionaryUtils()
        {
            super();
            throw (new Error("Do not instanciate this class!"));
        }

        public static function fromObject(_arg_1:Object):Dictionary
        {
            var _local_3:Object;
            if (_arg_1 == null)
            {
                return (null);
            };
            var _local_2:Dictionary = new Dictionary();
            for (_local_3 in _arg_1)
            {
                _local_2[_local_3] = _arg_1[_local_3];
            };
            return (_local_2);
        }

        public static function countDictionaryKeys(_arg_1:Dictionary):int
        {
            var _local_3:*;
            var _local_2:int;
            for (_local_3 in _arg_1)
            {
                _local_2++;
            };
            return (_local_2);
        }

        public static function clearDictionary(_arg_1:Dictionary):void
        {
            var _local_3:*;
            var _local_2:int;
            for (_local_3 in _arg_1)
            {
                delete _arg_1[_local_3];
            };
        }

        public static function fromCommaSeparatedList(_arg_1:String):HashSetWrapper
        {
            var _local_3:String;
            var _local_2:HashSetWrapper = new HashSetWrapper();
            for each (_local_3 in StringUtils.split(_arg_1, ","))
            {
                _local_2.add(_local_3);
            };
            return (_local_2);
        }


    }
}
