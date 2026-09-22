package Communication.VO
{
    public class ConditionFinishedVO 
    {

        public var index:int;
        public var grid:int;


        public static function Init(_arg_1:int, _arg_2:int):ConditionFinishedVO
        {
            var _local_3:ConditionFinishedVO = new (ConditionFinishedVO)();
            _local_3.grid = _arg_1;
            _local_3.index = _arg_2;
            return (_local_3);
        }


    }
}
