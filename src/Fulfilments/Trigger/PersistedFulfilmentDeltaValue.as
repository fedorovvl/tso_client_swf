package Fulfilments.Trigger
{
    import Trigger.PersistedTriggerDeltaValue;
    import Utils.Disposable;
    import Communication.VO.Fulfilments.FulfilmentTriggerVO;
    import Enums.DIRTY_INDICATOR;

    public class PersistedFulfilmentDeltaValue implements PersistedTriggerDeltaValue, Disposable 
    {

        public var mDirtyIndicator:int;
        protected var triggerVO:FulfilmentTriggerVO;

        public function PersistedFulfilmentDeltaValue(_arg_1:FulfilmentTriggerVO)
        {
            super();
            this.triggerVO = _arg_1;
        }

        public function persist():void
        {
            if (this.triggerVO.userID < 0)
            {
                return;
            };
            this.mDirtyIndicator = DIRTY_INDICATOR.MODIFIED_BIT;
        }

        public function add(_arg_1:Number):void
        {
            this.triggerVO.value = (this.triggerVO.value + _arg_1);
            this.persist();
        }

        public function readPersistence():void
        {
        }

        public function setFinished():void
        {
            this.triggerVO.finished = 1;
            this.persist();
        }

        public function setValue(_arg_1:Number):void
        {
            this.triggerVO.value = _arg_1;
            this.persist();
        }

        public function getFinished():Boolean
        {
            return (this.triggerVO.finished == 1);
        }

        public function getValue():Number
        {
            return (this.triggerVO.value);
        }

        public function getTriggerVO():FulfilmentTriggerVO
        {
            return (this.triggerVO);
        }

        public function dispose():void
        {
            this.triggerVO = null;
        }


    }
}
