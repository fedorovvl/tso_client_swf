package com.bluebyte.tso.util
{
    public class RandomItemUtil 
    {


        public static function getNext(_arg_1:*):IRandomItem
        {
            var _local_4:Number;
            var _local_2:Number = 0;
            var _local_3:IRandomItem;
            for each (_local_3 in _arg_1)
            {
                _local_2 = (_local_2 + _local_3.getChance());
            };
            _local_4 = (Math.random() * _local_2);
            for each (_local_3 in _arg_1)
            {
                if (_local_4 <= _local_3.getChance())
                {
                    return (_local_3);
                };
                _local_4 = (_local_4 - _local_3.getChance());
            };
            return (_local_3);
        }

        public static function getNextEqual(_arg_1:*):Object
        {
            var _local_4:Number;
            var _local_5:Number;
            var _local_2:Object;
            var _local_3:int;
            for each (_local_2 in _arg_1)
            {
                _local_3++;
            };
            _local_4 = (1 / _local_3);
            _local_5 = Math.random();
            for each (_local_2 in _arg_1)
            {
                if (_local_5 <= _local_4)
                {
                    return (_local_2);
                };
                _local_5 = (_local_5 - _local_4);
            };
            return (_local_2);
        }


    }
}
