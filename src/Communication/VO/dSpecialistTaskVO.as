package Communication.VO
{
    import Enums.SPECIALIST_TASK_TYPES;

    public class dSpecialistTaskVO 
    {

        public var subTaskID:int;
        public var phase:int;
        public var bonusTime:int;
        public var type:int;
        public var collectedTime:int;


        public function toString():String
        {
            var _local_1:* = "<dSpecialistTaskVO ";
            _local_1 = (_local_1 + this.dataString());
            return (_local_1 + " />");
        }

        public function dataString():String
        {
            return ((((((((((((" type='" + this.type) + "' typeString='") + SPECIALIST_TASK_TYPES.toString(this.type)) + "' subTaskID='") + this.subTaskID) + "' phase='") + this.phase) + "' collectedTime='") + this.collectedTime) + "' bonusTime='") + this.bonusTime) + "'");
        }


    }
}
