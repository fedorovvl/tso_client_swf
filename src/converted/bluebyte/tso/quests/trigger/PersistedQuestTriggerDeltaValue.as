package converted.bluebyte.tso.quests.trigger
{
    import Trigger.PersistedTriggerDeltaValue;
    import Utils.Disposable;
    import converted.bluebyte.tso.quests.logic.QuestManagerStatic;
    import Communication.VO.dQuestElementVO;

    public class PersistedQuestTriggerDeltaValue implements PersistedTriggerDeltaValue, Disposable 
    {

        protected var state:int = QuestManagerStatic.QUEST_TRIGGER_STATUS_RUNNING;
        protected var deltaValue:Number = 0;
        protected var triggerIdx:int = -1;
        protected var questElement:dQuestElementVO;

        public function PersistedQuestTriggerDeltaValue(_arg_1:dQuestElementVO, _arg_2:int)
        {
            super();
            this.questElement = _arg_1;
            this.triggerIdx = _arg_2;
            this.readPersistence();
        }

        protected function getDeltaStart():Number
        {
            if (((this.questElement == null) || (this.triggerIdx < 0)))
            {
                return (0);
            };
            return (this.questElement.GetDeltaStart(this.triggerIdx));
        }

        public function setState(_arg_1:int):void
        {
            this.state = _arg_1;
            this.persist();
        }

        public function setWon():void
        {
            this.setState(QuestManagerStatic.QUEST_TRIGGER_STATUS_WON);
        }

        public function persist():void
        {
        }

        public function dispose():void
        {
            this.questElement = null;
        }

        public function add(_arg_1:Number):void
        {
            this.deltaValue = (this.deltaValue + _arg_1);
            this.persist();
        }

        public function readPersistence():void
        {
            if (((this.questElement == null) || (this.triggerIdx < 0)))
            {
                return;
            };
            this.state = this.questElement.GetTriggerStatus(this.triggerIdx);
            this.setValue(this.getDeltaStart());
        }

        public function setValue(_arg_1:Number):void
        {
            this.deltaValue = _arg_1;
            this.persist();
        }

        public function isRunning():Boolean
        {
            return (this.state == QuestManagerStatic.QUEST_TRIGGER_STATUS_RUNNING);
        }

        public function getValue():Number
        {
            return (this.deltaValue);
        }

        public function setRunning():void
        {
            this.setState(QuestManagerStatic.QUEST_TRIGGER_STATUS_RUNNING);
        }

        public function setFailed():void
        {
            this.setState(QuestManagerStatic.QUEST_TRIGGER_STATUS_FAILED);
        }


    }
}
