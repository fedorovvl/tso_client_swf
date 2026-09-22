package Communication.VO
{
    public class SpecialistTaskResultTypeVO 
    {

        public var taskType_string:String;
        public var resourceType_string:String = null;
        public var amount:int = 0;

        public function SpecialistTaskResultTypeVO(_arg_1:String, _arg_2:String, _arg_3:int)
        {
            super();
            this.taskType_string = _arg_1;
            this.resourceType_string = _arg_2;
            this.amount = _arg_3;
        }

    }
}
