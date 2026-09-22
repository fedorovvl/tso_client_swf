package Communication.VO
{
    public class ConditionUpdatedVO 
    {

        public var index:int;
        public var uniqueID:dUniqueID;
        public var amount:Number;


        public static function Init(_arg_1:dUniqueID, _arg_2:int, _arg_3:Number):ConditionUpdatedVO
        {
            var _local_4:ConditionUpdatedVO = new (ConditionUpdatedVO)();
            _local_4.uniqueID = _arg_1;
            _local_4.index = _arg_2;
            _local_4.amount = _arg_3;
            return (_local_4);
        }


    }
}
