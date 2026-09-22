package Communication.VO
{
    import mx.collections.ArrayCollection;

    public class dQuestVO 
    {

        public var questWindowShowState:Boolean = false;
        public var startQuestTime:Number;
        public var questTriggersFinished:ArrayCollection;
        public var activeQuest_string:String;
        public var rewardWindowShowState:Boolean = false;
        public var activeQuestMode:int;


        public function toString():String
        {
            var _local_2:int;
            var _local_1:* = "";
            if (this.questTriggersFinished != null)
            {
                for each (_local_2 in this.questTriggersFinished)
                {
                    if (_local_1 != "")
                    {
                        _local_1 = (_local_1 + ", ");
                    };
                    _local_1 = (_local_1 + _local_2);
                };
            };
            return (((((((((((("<dQuestVO activeQuest='" + this.activeQuest_string) + "' activeQuestMode='") + this.activeQuestMode) + "' startQuestTime='") + this.startQuestTime) + "' questWindowShowState='") + this.questWindowShowState) + "' rewardWindowShowState='") + this.rewardWindowShowState) + "' questTriggersFinished='") + _local_1) + "' />");
        }


    }
}
