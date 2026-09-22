package Communication.VO
{
    public class dQuestTriggerVO 
    {

        public var status:int;
        public var deltaStart:Number;


        public function toString():String
        {
            return (((("<dQuestTriggerVO status='" + this.status) + "' deltaStart='") + this.deltaStart) + "' />");
        }


    }
}
