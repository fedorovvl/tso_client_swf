package Communication.VO.Tasks
{
    import mx.collections.ArrayCollection;
    import Communication.VO.dUniqueID;

    public class TaskClaimVO 
    {

        public var taskId:int;
        public var uniqueIDs:ArrayCollection = new ArrayCollection();
        public var weeklyUniqueId:dUniqueID;


    }
}
