package Fulfilments.Trigger
{
    import Trigger.Triggerable;
    import Utils.Disposable;
    import Trigger.Trigger;
    import Trigger.IUpdateTrigger;
    import Interface.cGeneralInterface;
    import Fulfilments.Identity;
    import Communication.VO.Fulfilments.FulfilmentTriggerVO;
    import Communication.VO.TriggerVO;
    import Enums.DIRTY_INDICATOR;
    import Trigger.TriggerFactory;

    public class FulfilmentTrigger implements Triggerable, Disposable, Trigger, IUpdateTrigger 
    {

        private var identityId:int;
        private var generalInterface:cGeneralInterface;
        private var type_string:String;
        private var identity:Identity;
        private var delta:PersistedFulfilmentDeltaValue;
        public var activeTrigger:Trigger;
        private var initData:FulfilmentTriggerVO;
        private var playerId:int;
        private var triggerVO:TriggerVO;
        private var finished:Boolean = false;
        private var innerTriggerMarkedForDisposal:Boolean;
        private var value:int;

        public function FulfilmentTrigger(_arg_1:TriggerVO, _arg_2:cGeneralInterface)
        {
            super();
            this.triggerVO = _arg_1;
            this.generalInterface = _arg_2;
            this.playerId = -1;
            this.identityId = -1;
            this.innerTriggerMarkedForDisposal = false;
        }

        private function getIsTriggerReadyForDispose():Boolean
        {
            if ((((this.finished) && (this.innerTriggerMarkedForDisposal)) && (!(this.activeTrigger == null))))
            {
                return (this.delta.mDirtyIndicator == DIRTY_INDICATOR.CLEAN);
            };
            return (false);
        }

        public function getCurrentAmount():Number
        {
            return (this.value);
        }

        public function check():Boolean
        {
            var _local_1:int = this.value;
            if (this.activeTrigger != null)
            {
                this.value = (this.activeTrigger.getCurrentAmount() as int);
                if (this.value != _local_1)
                {
                    return (this.activeTrigger.check());
                };
            };
            return (false);
        }

        public function getIsRecentlyFinished():Boolean
        {
            return ((!(this.activeTrigger == null)) && (!(this.delta.mDirtyIndicator == DIRTY_INDICATOR.CLEAN)));
        }

        public function init(_arg_1:FulfilmentTriggerVO, _arg_2:TriggerFactory, _arg_3:Identity, _arg_4:Boolean):void
        {
            if (_arg_1 != null)
            {
                this.finished = (_arg_1.finished == 1);
            }
            else
            {
                this.finished = _arg_3.getFinished();
            };
            this.type_string = this.triggerVO.type_string;
            this.identity = _arg_3;
            this.playerId = this.identity.getPlayerId();
            this.identityId = this.identity.getDefinition().getId();
            this.initData = new FulfilmentTriggerVO();
            if (!this.finished)
            {
                if (_arg_1 != null)
                {
                    this.value = (_arg_1.value as int);
                    this.initData = _arg_1.clone();
                }
                else
                {
                    this.value = 0;
                    this.initData.userID = this.identity.getPlayerId();
                    this.initData.ID = this.identity.getDefinition().getId();
                    this.initData.triggerID = this.triggerVO.achievementTriggerId;
                };
                if (_arg_4)
                {
                    this.delta = new PersistedFulfilmentDeltaValue(this.initData);
                    _arg_2.setDeltaValue(this.delta);
                    this.activeTrigger = _arg_2.createTrigger(this.triggerVO, this.identity);
                };
            };
            this.initData = null;
        }

        private function disposeTrigger():void
        {
            if (this.activeTrigger != null)
            {
                this.activeTrigger.dispose();
                this.activeTrigger = null;
            };
        }

        public function dispose():void
        {
            this.innerTriggerMarkedForDisposal = false;
            this.disposeTrigger();
        }

        public function updateValue(_arg_1:int):void
        {
            this.value = _arg_1;
        }

        public function trigger(_arg_1:Trigger):void
        {
            this.finished = true;
            this.identity.updateProgress();
        }

        public function getValue():int
        {
            return (this.value);
        }

        public function isRunning():Boolean
        {
            return (true);
        }

        public function getTriggerId():int
        {
            return (this.triggerVO.triggerIdx);
        }

        public function getPersistedDeltaValue():PersistedFulfilmentDeltaValue
        {
            return (this.delta);
        }

        public function disposeFinishedTrigger():void
        {
            if (this.getIsTriggerReadyForDispose())
            {
                this.innerTriggerMarkedForDisposal = false;
                this.disposeTrigger();
            };
        }

        public function reset():void
        {
        }

        public function getDefinition():TriggerVO
        {
            return (this.triggerVO);
        }

        public function setTriggerable(_arg_1:Triggerable):void
        {
            this.identity = (_arg_1 as Identity);
        }

        public function getFinished():Boolean
        {
            return (this.finished);
        }

        public function triggerUpdated(_arg_1:Trigger):void
        {
            this.identity.triggerUpdated(this);
        }

        public function getTriggerable():Triggerable
        {
            return (this.identity);
        }

        public function getIdentityId():int
        {
            return (this.identityId);
        }

        public function setFinished(_arg_1:Boolean):void
        {
            this.finished = _arg_1;
            if (this.finished)
            {
                if (this.delta != null)
                {
                    this.delta.setFinished();
                };
                this.innerTriggerMarkedForDisposal = true;
            };
        }

        public function isReversible():Boolean
        {
            return (false);
        }


    }
}
