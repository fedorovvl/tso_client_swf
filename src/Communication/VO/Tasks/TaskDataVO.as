package Communication.VO.Tasks
{
    import mx.collections.ArrayCollection;

    public class TaskDataVO 
    {

        public var userID:int = -1;
        public var taskResetTime:Number = 0;

        public var tasksToStart:ArrayCollection = new ArrayCollection();
        public var tasksTriggerValueUpdates:ArrayCollection = new ArrayCollection();
        public var finishedTasksTriggers:ArrayCollection = new ArrayCollection();


        public function isInitialized():Boolean
        {
            return (!(this.userID == -1));
        }


    }
}
