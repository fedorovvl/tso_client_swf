package Achievements
{
    import Trigger.Triggerable;
    import Utils.Disposable;
    import Communication.VO.TriggerVO;
    import Interface.cGeneralInterface;
    import Achievements.trigger.AchievementTrigger;
    import Communication.VO.Achievements.UserAchievementTriggerVO;
    import Enums.DIRTY_INDICATOR;
    import Achievements.trigger.AchievementTriggerFactory;
    import Trigger.Trigger;
    import Achievements.trigger.PersistedAchievementTriggerDeltaValue;

    public class UserAchievementTriggerWrapper implements Triggerable, Disposable 
    {

        private var triggerVO:TriggerVO;
        private var achievementId:int;
        private var progress:Number = 0;
        private var generalInterface:cGeneralInterface;
        private var type_string:String;
        private var activeTrigger:AchievementTrigger;
        private var playerId:int;
        private var userAchievement:UserAchievement;
        private var maxValue:int;
        private var initData:UserAchievementTriggerVO;
        private var innerTriggerMarkedForDisposal:Boolean;
        private var value:int;
        private var finished:Boolean = false;

        public function UserAchievementTriggerWrapper(_arg_1:TriggerVO, _arg_2:cGeneralInterface)
        {
            super();
            this.triggerVO = _arg_1;
            this.generalInterface = _arg_2;
            this.playerId = -1;
            this.achievementId = -1;
            this.innerTriggerMarkedForDisposal = false;
        }

        private function getIsTriggerReadyForDispose():Boolean
        {
            if ((((this.finished) && (this.innerTriggerMarkedForDisposal)) && (!(this.activeTrigger == null))))
            {
                if (this.activeTrigger.getDelta() != null)
                {
                    return (this.activeTrigger.getDelta().mDirtyIndicator == DIRTY_INDICATOR.CLEAN);
                };
                return (this.activeTrigger.getDirtyIndicator() == DIRTY_INDICATOR.CLEAN);
            };
            return (false);
        }

        public function getAchievementId():int
        {
            return (this.achievementId);
        }

        public function getAchievementTriggerVO():TriggerVO
        {
            return (this.triggerVO);
        }

        public function init(_arg_1:UserAchievementTriggerVO, _arg_2:AchievementTriggerFactory, _arg_3:UserAchievement, _arg_4:Boolean):void
        {
            if (_arg_1 != null)
            {
                this.finished = (_arg_1.finished == 1);
            }
            else
            {
                this.finished = _arg_3.getFinished();
            };
            this.type_string = UserAchievementTriggerHelper.getTriggerType(this.triggerVO);
            this.userAchievement = _arg_3;
            this.playerId = this.userAchievement.getPlayerId();
            this.achievementId = this.userAchievement.getAchievementVO().getAchievementID();
            this.initData = new UserAchievementTriggerVO();
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
                    this.initData.userID = this.userAchievement.getPlayerId();
                    this.initData.achievementID = this.userAchievement.getAchievementVO().getAchievementID();
                    this.initData.triggerID = this.triggerVO.achievementTriggerId;
                };
                if (((!(this.type_string == null)) && (this.type_string == AchievementConsts.TRIGGER_TYPE_PROGRESS)))
                {
                    this.maxValue = UserAchievementTriggerHelper.getTriggerMaxValue(this.triggerVO);
                    this.progress = UserAchievementTriggerHelper.getTriggerProgress(this.triggerVO, this.value);
                };
                if (_arg_4)
                {
                    this.activeTrigger = (_arg_2.createTriggerWithInitData(this.triggerVO, this.userAchievement, this.initData) as AchievementTrigger);
                };
            }
            else
            {
                this.progress = 1;
            };
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
            this.disposeTrigger();
            this.generalInterface = null;
            this.triggerVO = null;
            this.userAchievement = null;
            this.initData = null;
        }

        public function getProgress():Number
        {
            return (this.progress);
        }

        public function deactivateTrigger():void
        {
            this.disposeTrigger();
        }

        public function updateValue(_arg_1:int):void
        {
            this.value = _arg_1;
            if (this.type_string == AchievementConsts.TRIGGER_TYPE_PROGRESS)
            {
                this.progress = UserAchievementTriggerHelper.getTriggerProgress(this.triggerVO, this.value);
            };
        }

        public function getType():String
        {
            return (this.type_string);
        }

        public function trigger(_arg_1:Trigger):void
        {
            this.finished = true;
            this.userAchievement.updateProgress();
        }

        public function getValue():int
        {
            return (this.value);
        }

        public function getTriggerId():int
        {
            return (this.triggerVO.triggerIdx);
        }

        public function activateTrigger(_arg_1:AchievementTriggerFactory):void
        {
            if (this.activeTrigger == null)
            {
                this.activeTrigger = (_arg_1.createTriggerWithInitData(this.triggerVO, this.userAchievement, this.initData) as AchievementTrigger);
                this.activeTrigger.check();
            };
        }

        public function disposeFinishedTrigger():void
        {
            if (this.getIsTriggerReadyForDispose())
            {
                this.innerTriggerMarkedForDisposal = false;
                this.disposeTrigger();
            };
        }

        public function checkForUpdate():void
        {
            var _local_1:int = this.value;
            if (this.activeTrigger != null)
            {
                this.value = (this.activeTrigger.getCurrentAmount() as int);
                if (this.value != _local_1)
                {
                };
                this.activeTrigger.check();
            };
        }

        public function getPersistedDeltaValue():PersistedAchievementTriggerDeltaValue
        {
            if (this.activeTrigger != null)
            {
                return (this.activeTrigger.getDelta());
            };
            return (null);
        }

        public function reset():void
        {
        }

        public function getPlayerId():int
        {
            return (this.playerId);
        }

        public function getInitData():UserAchievementTriggerVO
        {
            return (this.initData);
        }

        public function handleValueUpdated():void
        {
            if (this.activeTrigger != null)
            {
                this.value = (this.activeTrigger.getCurrentAmount() as int);
            };
        }

        public function getMaxValue():int
        {
            return (this.maxValue);
        }

        public function getFinished():Boolean
        {
            return (this.finished);
        }

        public function setFinished(_arg_1:Boolean):void
        {
            this.finished = _arg_1;
            if (this.finished)
            {
                this.innerTriggerMarkedForDisposal = true;
            };
        }

        public function getIsRecentlyFinished():Boolean
        {
            return ((!(this.activeTrigger == null)) && (!(this.activeTrigger.getDirtyIndicator() == DIRTY_INDICATOR.CLEAN)));
        }

        public function toString():String
        {
            return (((((((((((((((('<TriggerVO name="' + this.triggerVO.action_string) + ' item="') + this.triggerVO.item_string) + ' id="') + this.triggerVO.achievementTriggerId) + ' min="') + this.triggerVO.min) + ' max="') + this.triggerVO.max) + ' target="') + this.triggerVO.target_string) + ' locaExt="') + this.triggerVO.loca_string) + ' idx="') + this.triggerVO.triggerIdx) + "/>");
        }

        public function getAchievementTrigger():AchievementTrigger
        {
            return (this.activeTrigger);
        }


    }
}
