package Utils
{
    public class IntegerUtils 
    {


        public static function addAndCheck(_arg_1:int, _arg_2:int):int
        {
            var _local_3:Number = ((_arg_1 as Number) + _arg_2);
            if (_local_3 > int.MAX_VALUE)
            {
                _local_3 = int.MAX_VALUE;
            };
            return (_local_3 as int);
        }


    }
}
