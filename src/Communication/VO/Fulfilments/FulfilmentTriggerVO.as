package Communication.VO.Fulfilments
{
    public class FulfilmentTriggerVO 
    {

        public static var INVALID_TRIGGER_UNIQUE_ID:int = -1;

        public var userID:int;
        public var value:Number;
        public var finished:int;
        public var triggerID:int;
        public var ID:int;


        public function clone():FulfilmentTriggerVO
        {
            var _local_1:FulfilmentTriggerVO = new FulfilmentTriggerVO();
            _local_1.userID = this.userID;
            _local_1.ID = this.ID;
            _local_1.triggerID = this.triggerID;
            _local_1.finished = this.finished;
            _local_1.value = this.value;
            return (this);
        }


    }
}
