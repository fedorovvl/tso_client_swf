package GUI.GAME
{
    import Model.Observer;
    import Tasks.Task;
    import __AS3__.vec.Vector;
    import Interface.cGeneralInterface;
    import GUI.Components.TaskBuildingPanel;
    import Fulfilments.WeeklyRewardDefinition;
    import mx.collections.ArrayCollection;
    import GO.cBuilding;
    import Fulfilments.Category;
    import Enums.COMMAND;
    import flash.events.MouseEvent;
    import Model.Notifiers.TaskManagerChannel;
    import Model.Notifier;
    import mx.events.ListEvent;
    import mx.events.FlexEvent;
    import Communication.VO.EffectVO;
    import Communication.VO.dUniqueID;
    import Tasks.TaskPool;
    import com.bluebyte.tso.util.TimeUtil;
    import GUI.Loca.cLocaManager;
    import Enums.LOCA_GROUP;
    import GUI.Components.Frame;
    import com.bluebyte.tso.quests.view.ui.itemrenderer.QuestRewardItemRenderer;
    import GUI.FloatingItemsManager;
    import Interface.cGameInterface;
    import flash.events.Event;
    import Fulfilments.Trigger.FulfilmentTrigger;
    import Communication.VO.TriggerVO;
    import ServerState.cResources;
    import Utils.TriggerUtils;
    import Tasks.TaskDefinition;

    public class cTaskBuildingPanel extends cBasicInfoPanel implements Observer 
    {

        private var selectedTask:Task;
        private var totalTasksCount:int = 0;
        private var completedTasksCount:int = 0;
        private var tasks:Vector.<Task>;
        private var mGI:cGeneralInterface;
        public var mPanel:TaskBuildingPanel;
        private var weeklyRewards:WeeklyRewardDefinition;
        private var rewards:ArrayCollection = new ArrayCollection();
        private var building:cBuilding;
        private var category:Category;


        private function getNumberOfClaimedTasks():int
        {
            var _local_2:Task;
            var _local_1:int;
            for each (_local_2 in this.tasks)
            {
                if (_local_2.getState() == Task.CLAIMED)
                {
                    _local_1++;
                };
            };
            return (_local_1);
        }

        private function claimReward(_arg_1:MouseEvent):void
        {
            this.mPanel.btnOK.enabled = false;
            this.mGI.mClientMessages.SendMessagetoServer(COMMAND.CLAM_TASK_REWARD, this.mGI.mCurrentViewedZoneID, this.selectedTask.getId());
            this.mPanel.busy = true;
        }

        public function update(_arg_1:Notifier, _arg_2:String, _arg_3:Object):void
        {
            if (_arg_2 == TaskManagerChannel.UPDATED)
            {
                this.selectedTask = null;
            };
            if (((IsVisible()) && (!(this.building == null))))
            {
                this.SetData(this.building);
            };
        }

        private function completeHandler(_arg_1:FlexEvent):void
        {
            this.mPanel.btnClose.addEventListener(MouseEvent.CLICK, this.ClosePanel);
            this.mPanel.taskList.addEventListener(ListEvent.ITEM_CLICK, this.selectTask);
            this.mPanel.pvpTaskBuildingTasksButton.addEventListener(MouseEvent.CLICK, this.pvpTaskBuildingButton);
            this.mPanel.btnOK.addEventListener(MouseEvent.CLICK, this.claimReward);
            this.mPanel.btnPay.addEventListener(MouseEvent.CLICK, this.payToFinish);
            this.mPanel.btnClosePanel.addEventListener(MouseEvent.CLICK, this.ClosePanel);
            this.mGI.channels.TASK_MANAGER.addPropertyObserver(TaskManagerChannel.UPDATED, this);
            this.mGI.channels.TASK_MANAGER.addPropertyObserver(TaskManagerChannel.TASK_FINISHED, this);
        }

        override public function SetData(_arg_1:cBuilding):void
        {
            var _local_3:Number;
            var _local_6:EffectVO;
            var _local_7:dUniqueID;
            if (this.building != _arg_1)
            {
                this.selectedTask = null;
            };
            this.building = _arg_1;
            if (this.mGI.getCurrentTaskManager() == null)
            {
                Hide();
                return;
            };
            this.category = this.mGI.getCurrentTaskManager().getCategoryByName(this.building.GetBuildingName_string());
            if (this.category == null)
            {
                Hide();
                return;
            };
            this.weeklyRewards = TaskPool.getInstance().getWeeklyRewards(this.category.getCategoryDefinition().getId());
            var _local_2:int = this.getNumberOfClaimedTasks();
            _local_3 = (this.mGI.getCurrentTaskManager().getResetTaskTime() - TimeUtil.getServerTime());
            this.mPanel.timeUntilResetLabel.toolTip = cLocaManager.GetInstance().GetText(LOCA_GROUP.TOOLTIP, "timeLeftUntilTaskReset");
            this.mPanel.timeUntilResetLabel.text = cLocaManager.GetInstance().FormatDuration(Math.max(0, _local_3));
            var _local_4:ArrayCollection = new ArrayCollection();
            var _local_5:int;
            if (this.weeklyRewards != null)
            {
                for each (_local_6 in this.weeklyRewards.rewards)
                {
                    _local_6.additionalUniqueIds_vector = new ArrayCollection();
                    _local_6.index = _local_5;
                    _local_7 = new dUniqueID();
                    if ((((this.completedTasksCount >= 3) && (this.completedTasksCount < 6)) && (_local_5 == 0)))
                    {
                        _local_7.uniqueID1 = defines.EFFECT_ENABLED_UID;
                    }
                    else
                    {
                        if ((((this.completedTasksCount >= 6) && (this.completedTasksCount < 9)) && (_local_5 <= 1)))
                        {
                            _local_7.uniqueID1 = defines.EFFECT_ENABLED_UID;
                        }
                        else
                        {
                            if (this.completedTasksCount == 9)
                            {
                                _local_7.uniqueID1 = defines.EFFECT_ENABLED_UID;
                            }
                            else
                            {
                                _local_7.uniqueID1 = defines.EFFECT_DISABLED_UID;
                            };
                        };
                    };
                    if (_local_2 < 3)
                    {
                        _local_7.uniqueID2 = 0;
                    }
                    else
                    {
                        if ((((_local_2 >= 3) && (_local_2 < 6)) && (_local_5 == 0)))
                        {
                            _local_7.uniqueID2 = defines.EFFECT_COMPLETED_UID;
                        }
                        else
                        {
                            if ((((_local_2 >= 6) && (_local_2 < 9)) && (_local_5 <= 1)))
                            {
                                _local_7.uniqueID2 = defines.EFFECT_COMPLETED_UID;
                            }
                            else
                            {
                                if (_local_2 == 9)
                                {
                                    _local_7.uniqueID2 = defines.EFFECT_COMPLETED_UID;
                                }
                                else
                                {
                                    _local_7.uniqueID2 = 0;
                                };
                            };
                        };
                    };
                    _local_6.additionalUniqueIds_vector.addItem(_local_7);
                    _local_4.addItem(_local_6);
                    _local_5++;
                };
            };
            this.mPanel.weeklyRewards.dataProvider = _local_4;
            this.updateProgressBar();
            this.setTasks();
            if (((!(this.selectedTask == null)) && (!(this.selectedTask.getDefinition() == null))))
            {
                this.updateTask(this.selectedTask);
            }
            else
            {
                this.updateTask(this.tasks[0]);
            };
        }

        private function setTasks():void
        {
            var _local_3:Task;
            this.totalTasksCount = 0;
            this.completedTasksCount = 0;
            this.tasks = this.mGI.getCurrentTaskManager().getChildTasks(this.category);
            var _local_1:Array = new Array();
            var _local_2:Boolean;
            for each (_local_3 in this.tasks)
            {
                _local_3.selected = (_local_3 == this.selectedTask);
                _local_2 = ((_local_2) || (_local_3.selected));
                _local_1.push(_local_3);
                this.totalTasksCount++;
                if (_local_3.getFinished())
                {
                    this.completedTasksCount++;
                };
            };
            if (!_local_2)
            {
                this.selectedTask = null;
            };
            this.mPanel.taskList.dataProvider = _local_1;
            this.mPanel.triggerContainer.verticalScrollPosition = 0;
        }

        private function updateProgressBar():void
        {
            this.mPanel.rewardsProgressBar.toolTip = ((this.completedTasksCount.toString() + " / ") + this.totalTasksCount.toString());
            this.mPanel.rewardsProgressBar.value = ((this.completedTasksCount * 1) / (this.totalTasksCount * 1));
        }

        private function selectTask(_arg_1:ListEvent):void
        {
            this.updateTask((_arg_1.itemRenderer.data as Task));
        }

        public function claimTaskRewardsCompletedHandler():void
        {
            var _local_7:Frame;
            this.mPanel.busy = false;
            var _local_1:Array = this.mPanel.rewards.list.getChildren();
            var _local_2:int = this.mPanel.rewards.list.numChildren;
            var _local_3:int;
            while (_local_3 < _local_2)
            {
                _local_7 = (_local_1[_local_3] as QuestRewardItemRenderer).frame;
                if (_local_7 != null)
                {
                    FloatingItemsManager.createJumpFlyDestroy(_local_7, "GAMESTATE_ID_ACTIONBAR.actionBarCenter.btnActionBar04");
                };
                _local_3++;
            };
            this.mPanel.rewards.dataProvider = new ArrayCollection();
            var _local_4:Array = this.mPanel.weeklyRewards.list.getChildren();
            var _local_5:int = this.getNumberOfClaimedTasks();
            var _local_6:Frame;
            if ((_local_5 % 3) == 0)
            {
                _local_6 = (_local_4[((_local_5 / 3) - 1)] as QuestRewardItemRenderer).frame;
                FloatingItemsManager.createJumpFlyDestroy(_local_6, "GAMESTATE_ID_ACTIONBAR.actionBarCenter.btnActionBar04");
            };
            this.updateProgressBar();
        }

        public function setPvpTaskBuildingTasks(_arg_1:Boolean):void
        {
            this.mPanel.pvpTaskBuildingTasksButton.selected = (!(_arg_1));
        }

        public function Init(_arg_1:TaskBuildingPanel):void
        {
            AddBaseElement(_arg_1);
            this.mGI = (global.ui as cGameInterface);
            this.mPanel = _arg_1;
            this.mPanel.addEventListener(FlexEvent.CREATION_COMPLETE, this.completeHandler);
        }

        private function pvpTaskBuildingButton(_arg_1:MouseEvent):void
        {
            globalFlash.gui.mPlayerOptionsPanel.pvpTaskBuildingTasksButtonHandler(_arg_1);
        }

        private function payToFinish(_arg_1:MouseEvent):void
        {
            this.mPanel.btnPay.enabled = false;
            this.mGI.mClientMessages.SendMessagetoServer(COMMAND.PAY_TO_FINISH, this.mGI.mCurrentViewedZoneID, this.selectedTask.getId());
            this.mPanel.busy = true;
        }

        private function ClosePanel(_arg_1:Event):void
        {
            this.Hide();
        }

        public function Refresh():void
        {
            var _local_2:FulfilmentTrigger;
            var _local_1:Boolean = true;
            for each (_local_2 in this.selectedTask.getTriggers())
            {
                if (!_local_2.check())
                {
                    _local_1 = false;
                };
            };
            if (_local_1)
            {
                this.mPanel.btnOK.enabled = true;
            };
            this.updateTask(this.selectedTask);
        }

        private function updateTask(_arg_1:Task):void
        {
            var _local_5:FulfilmentTrigger;
            var _local_6:TriggerVO;
            var _local_7:cResources;
            var _local_8:EffectVO;
            if (this.selectedTask != null)
            {
                this.selectedTask.selected = false;
            };
            this.selectedTask = _arg_1;
            this.setTasks();
            var _local_2:Array = new Array();
            var _local_3:Boolean = true;
            this.mPanel.btnOK.visible = true;
            if (this.selectedTask != null)
            {
                for each (_local_5 in this.selectedTask.getTriggers())
                {
                    _local_2.push(_local_5);
                    _local_6 = _local_5.getDefinition();
                    if (((!(_local_5.getFinished())) && (_local_6.action_string == TriggerUtils.PAY_TO_FINISH_string)))
                    {
                        this.mPanel.btnOK.visible = false;
                        if (global.resourceDefinitions_vector.indexOf(_local_6.item_string) != -1)
                        {
                            _local_7 = this.mGI.mCurrentPlayerZone.GetResources(this.mGI.mCurrentPlayer);
                            if (!_local_7.HasPlayerResource(_local_6.item_string, _local_6.amount))
                            {
                                _local_3 = false;
                            };
                        };
                    }
                    else
                    {
                        if (!_local_5.getFinished())
                        {
                            _local_3 = false;
                        };
                    };
                };
            };
            this.mPanel.btnPay.enabled = _local_3;
            this.mPanel.triggerList.dataProvider = _local_2;
            var _local_4:ArrayCollection = new ArrayCollection();
            if (((!(this.selectedTask == null)) && (!(this.selectedTask.getState() == Task.CLAIMED))))
            {
                for each (_local_8 in (this.selectedTask.getDefinition() as TaskDefinition).reward_vector)
                {
                    _local_4.addItem(_local_8);
                };
            };
            this.mPanel.rewards.dataProvider = _local_4;
            if (this.selectedTask != null)
            {
                this.mPanel.selectedQuestDetails.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.QUEST_START_DESCRIPTIONS, this.selectedTask.getDefinition().getName());
                this.mPanel.taskDetailLabel.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.QUEST_LABELS, this.selectedTask.getDefinition().getName());
                this.mPanel.btnOK.enabled = (this.selectedTask.getState() == Task.FINISHED);
            };
        }


    }
}
