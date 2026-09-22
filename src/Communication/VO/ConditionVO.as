package Communication.VO
{
    public class ConditionVO 
    {

        public var amount:Number;
        public var completed:Boolean = false;
        public var uniqueID:dUniqueID;
        public var index:int;
        [Transient]
        public var trigger:TriggerVO;


        public function Init(_arg_1:TriggerVO, _arg_2:int):ConditionVO
        {
            var _local_3:ConditionVO = new ConditionVO();
            _local_3.index = _arg_1.triggerIdx;
            _local_3.trigger = _arg_1;
            _local_3.amount = _arg_2;
            return (_local_3);
        }


    }
}
