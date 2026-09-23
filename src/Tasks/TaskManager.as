package Tasks
{
    import Fulfilments.FulfilmentsManager;
    import Trigger.Triggerable;
    import Interface.cGeneralInterface;
    import Trigger.Trigger;
    import __AS3__.vec.Vector;
    import Interface.cGameInterface;
    import Fulfilments.FulfilmentPool;
    import mx.collections.ArrayCollection;
    import Fulfilments.CategoryDefinition;
    import Utils.Tree.ITreeNode;
    import Fulfilments.Category;
    import Fulfilments.WeeklyRewardDefinition;
    import Fulfilments.IIdentityTreeNode;
    import Fulfilments.Identity;
    import Communication.VO.Fulfilments.IdentityVO;
    import Fulfilments.Trigger.FulfilmentTrigger;
    import Communication.VO.Tasks.TaskDataVO;
    import Communication.VO.Fulfilments.FulfilmentTriggerFinishedUpdateVO;
    import Communication.VO.Fulfilments.FulfilmentTriggerValueUpdateVO;
    import Communication.VO.EffectVO;
    import Enums.AVATAR_MESSAGE_TYPE;
    import Communication.VO.Tasks.TaskClaimVO;
    import Communication.VO.TriggerVO;
    import Enums.TRIGGER_ACTION;
    import Trigger.TriggerFactory;
    import Fulfilments.IdentityDefinition;
    import Communication.VO.Fulfilments.FulfilmentTriggerVO;
    import Utils.HashMapWrapper;
    import __AS3__.vec.*;

    public class TaskManager extends FulfilmentsManager implements Triggerable 
    {

        public static const TASK_TREE_UPDATED:String = "taskTreeUpdated";

        private var resetTaskTime:Number;
        private var gi:cGeneralInterface;
        private var resetTrigger:Trigger;
        private var taskBuildingsOnMap_vector:Vector.<String> = new Vector.<String>();
        private var resetTasks:Boolean = false;

        public function TaskManager(_arg_1:cGeneralInterface, _arg_2:FulfilmentPool, _arg_3:int, _arg_4:ArrayCollection, _arg_5:ArrayCollection, _arg_6:ArrayCollection, _arg_7:Vector.<String>, _arg_8:Boolean)
        {
            super();
            this.gi = _arg_1;
            this.resetTasks = _arg_8;
            this.taskBuildingsOnMap_vector = _arg_7;
            build((_arg_1 as cGameInterface), _arg_2, _arg_3, _arg_4, _arg_5, _arg_6);
        }

        override protected function isCategoryAllowed(_arg_1:CategoryDefinition):Boolean
        {
            var _local_2:String;
            for each (_local_2 in this.taskBuildingsOnMap_vector)
            {
                if (_local_2 == _arg_1.getName())
                {
                    return (true);
                };
            };
            return (false);
        }

        public function setResetTasks(_arg_1:Boolean):void
        {
            this.resetTasks = _arg_1;
        }

        public function getChildTasks(_arg_1:Category):Vector.<Task>
        {
            var _local_3:ITreeNode;
            var _local_2:Vector.<Task> = new Vector.<Task>();
            for each (_local_3 in _arg_1.getChildren())
            {
                if ((_local_3 is Task))
                {
                    _local_2.push((_local_3 as Task));
                }
                else
                {
                    if ((_local_3 is Category))
                    {
                        _local_2 = _local_2.concat(this.getChildTasks((_local_3 as Category)));
                    };
                };
            };
            return (_local_2);
        }

        public function getCategoryWithWeeklyReward(_arg_1:IIdentityTreeNode):Category
        {
            var _local_3:WeeklyRewardDefinition;
            var _local_2:Category = (_arg_1.getParent() as Category);
            if (_local_2.getCategoryDefinition().getId() != 0)
            {
                _local_3 = TaskPool.getInstance().getWeeklyRewards(_local_2.getCategoryDefinition().getId());
                if (_local_3 != null)
                {
                    return (_local_2);
                };
                return (this.getCategoryWithWeeklyReward(_local_2));
            };
            return (null);
        }

        public function getTaskTriggerUpdates():TaskDataVO
        {
            var _local_2:Identity;
            var _local_3:IdentityVO;
            var _local_4:FulfilmentTrigger;
            var _local_1:TaskDataVO = new TaskDataVO();
            _local_1.userID = this.gi.mHomePlayer.getPlayerID();
            for each (_local_2 in getIdentities().valueSet())
            {
                _local_3 = new IdentityVO();
                _local_3.ID = _local_2.getId();
                _local_3.categoryID = _local_2.getCategoryID();
                _local_3.finished = (_local_2 as Task).getState();
                _local_3.tracked = _local_2.isTracked;
                _local_1.tasksToStart.addItem(_local_3);
                for each (_local_4 in _local_2.getTriggers())
                {
                    if (_local_4.getFinished())
                    {
                        _local_1.finishedTasksTriggers.addItem(new FulfilmentTriggerFinishedUpdateVO().init(_local_4.getIdentityId(), _local_4.getTriggerId()));
                    }
                    else
                    {
                        if (_local_1.tasksTriggerValueUpdates != null)
                        {
                            _local_1.tasksTriggerValueUpdates.addItem(new FulfilmentTriggerValueUpdateVO().init(_local_4.getIdentityId(), _local_4.getTriggerId(), _local_4.getValue()));
                        };
                    };
                };
            };
            return (_local_1);
        }

        public function hasTasksBeenReset():Boolean
        {
            return (this.resetTasks);
        }

        override public function allUpdatesHandled():void
        {
            super.allUpdatesHandled();
        }

        public function rewardTask(_arg_1:cGameInterface, _arg_2:TaskClaimVO):void
        {
            var _local_10:Task;
            var _local_11:EffectVO;
            var _local_12:WeeklyRewardDefinition;
            var _local_13:EffectVO;
            var _local_3:int = _arg_2.taskId;
            var _local_4:Task = (getIdentityByID(_local_3) as Task);
            if (_local_4 == null)
            {
                return;
            };
            var _local_5:TaskDefinition = (_local_4.getDefinition() as TaskDefinition);
            var _local_6:int;
            while (_local_6 < _local_5.reward_vector.length)
            {
                _local_11 = _local_5.reward_vector[_local_6].clone();
                _local_11.uniqueID = _arg_2.uniqueIDs[_local_6];
                _arg_1.effectFactory.createEffect(_local_11).apply();
                _local_6++;
            };
            _local_4.mDirtyIndicator.strongModified();
            _local_4.setState(Task.CLAIMED);
            var _local_7:Category = this.getCategoryWithWeeklyReward(_local_4);
            var _local_8:Vector.<Task> = this.getChildTasks(_local_7);
            var _local_9:int;
            for each (_local_10 in _local_8)
            {
                if (_local_10.getState() == Task.CLAIMED)
                {
                    _local_9++;
                };
            };
            if ((_local_9 % 3) == 0)
            {
                _local_12 = TaskPool.getInstance().getWeeklyRewards(_local_7.getCategoryDefinition().getId());
                _local_13 = _local_12.rewards[((_local_9 / 3) - 1)].clone();
                _local_13.uniqueID = _arg_2.weeklyUniqueId;
                _arg_1.effectFactory.createEffect(_local_13).apply();
                globalFlash.gui.mAvatarMessageList.AddMessage(AVATAR_MESSAGE_TYPE.WEEKLY_TASK_GAINED);
            };
        }

        public function reset():void
        {
        }

        override public function dispose():void
        {
            if (this.resetTrigger != null)
            {
                this.resetTrigger.dispose();
                this.resetTrigger = null;
            }
            super.dispose();
            this.gi = null;
        }

        public function setResetTaskTime(_arg_1:Number):void
        {
            var _local_2:TriggerVO;
            this.resetTaskTime = _arg_1;
            if (this.resetTrigger != null)
            {
                this.resetTrigger.dispose();
            };
            if (_arg_1 > 0)
            {
                _local_2 = new TriggerVO();
                _local_2.action_string = TRIGGER_ACTION.ACTION_ON_DATE;
                _local_2.dateInMiliseconds = this.resetTaskTime;
                this.resetTrigger = new TriggerFactory(this.gi).createTrigger(_local_2, this);
            };
        }

        override public function buildIdentities(_arg_1:cGameInterface, _arg_2:FulfilmentPool, _arg_3:HashMapWrapper, _arg_4:ArrayCollection, _arg_5:ArrayCollection, _arg_6:int, _arg_7:ArrayCollection):HashMapWrapper
        {
            var _local_8:IdentityDefinition;
            var _local_9:Task;
            var _local_13:IdentityVO;
            var _local_14:FulfilmentTriggerVO;
            var _local_15:HashMapWrapper;
            var _local_16:TriggerFactory;
            var _local_17:IdentityVO;
            var _local_18:Boolean;
            var _local_10:HashMapWrapper = new HashMapWrapper();
            var _local_11:Vector.<IdentityDefinition> = _arg_2.getIdentities_vector();
            var _local_12:HashMapWrapper = new HashMapWrapper();
            for each (_local_13 in _arg_4)
            {
                _local_12.putItem(_local_13.ID, _local_13);
            };
            _local_15 = new HashMapWrapper();
            for each (_local_14 in _arg_5)
            {
                _local_15.putItem(((_local_14.ID + "_") + _local_14.triggerID), _local_14);
            };
            _local_16 = new TriggerFactory(_arg_1);
            for each (_local_8 in _local_11)
            {
                _local_17 = (_local_12.getItem(_local_8.getId()) as IdentityVO);
                if (((!(_local_17 == null)) && (_arg_3.hasKey(_local_17.categoryID))))
                {
                    _local_18 = true;
                    _local_9 = new Task(_local_8, _arg_6, _arg_1);
                    _local_9.setFinished((_local_17.finished >= BOOL_TRUE_INT));
                    _local_9.setState(_local_17.finished);
                    _local_9.isTracked = _local_17.tracked;
                    if (_local_9.getFinished())
                    {
                        _local_9.setVisible(true);
                    };
                    if (_local_8.getDisabled())
                    {
                        if (!_local_9.getFinished())
                        {
                            _local_9.setVisible(false);
                        };
                        _local_18 = false;
                    };
                    _local_9.setTriggers(buildTriggers(_arg_1, _local_9, _local_15, _arg_6, _local_18, _local_16));
                    _local_10.putItem(_local_8.getId(), _local_9);
                };
            };
            return (_local_10);
        }

        public function getResetTaskTime():Number
        {
            return (this.resetTaskTime);
        }

        public function getTaskBuildingsOnMap_vector():Vector.<String>
        {
            return (this.taskBuildingsOnMap_vector);
        }

        public function trigger(_arg_1:Trigger):void
        {
            this.resetTrigger.dispose();
            this.resetTrigger = null;
        }


    }
}
