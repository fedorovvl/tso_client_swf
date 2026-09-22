package GUI.achievement.view.detail.mediator
{
    import mx.containers.VBox;
    import GUI.achievement.vo.ShowAchievementNotificationVO;
    import flash.utils.Dictionary;
    import GUI.achievement.view.detail.AchievementDetailView;
    import GUI.achievement.view.detail.CategoryDetailHeaderView;
    import flash.display.DisplayObjectContainer;
    import mx.core.Container;
    import Utils.DictionaryUtils;
    import Achievements.AchievementConsts;
    import flash.events.Event;
    import GUI.helpers.UIComponentHelpers;
    import Achievements.UserAchievement;
    import __AS3__.vec.Vector;
    import Utils.Tree.ITreeNode;
    import Achievements.UserAchievementCategory;
    import GUI.helpers.DynamicArray;
    import org.puremvc.as3.interfaces.INotification;
    import GUI.achievement.vo.AchievementGUIDetailVO;
    import Achievements.AchievementsManager;

    public class AchievementCategory extends AbstractAchievementDetailMediator 
    {

        private const DEFAULT_SUB_VIEWS_COUNT:int = 5;

        private var achievementSubViewParentContainer:VBox;
        private var componentWidth:int;
        private var selectedAchievementVO:ShowAchievementNotificationVO;
        private var achievementsOnPage:int;
        private var triggerPoolDictionary:Dictionary;
        private var subViewsMap:Dictionary;

        public function AchievementCategory(_arg_1:String, _arg_2:CategoryDetailHeaderView, _arg_3:DisplayObjectContainer, _arg_4:Dictionary)
        {
            super(_arg_1, _arg_2, _arg_3);
            this.triggerPoolDictionary = _arg_4;
            this.subViewsMap = new Dictionary();
            this.achievementsOnPage = Math.floor((_arg_3.height / AchievementDetailView.ACHIEVEMENT_VIEW_BACKGROUND_HEIGHT));
        }

        private function setContainerVerticalScrollBarPosition(_arg_1:Number):void
        {
            var _local_2:Container = (listParentContainer as Container);
            _local_2.verticalScrollPosition = _arg_1;
            this.removeCheckComponentComplete();
        }

        override public function setWidth(_arg_1:int, _arg_2:Boolean=true):void
        {
            super.setWidth(_arg_1, _arg_2);
            this.componentWidth = _arg_1;
        }

        override public function show():void
        {
            super.show();
            this.achievementSubViewParentContainer.visible = true;
        }

        override public function hide():void
        {
            super.hide();
            DictionaryUtils.clearDictionary(this.subViewsMap);
            this.achievementSubViewParentContainer.visible = false;
            this.removeCheckComponentComplete();
        }

        override public function listNotificationInterests():Array
        {
            return (super.listNotificationInterests().concat(AchievementConsts.SHOW_ACHIEVEMENT));
        }

        private function handleAchievementSelected(_arg_1:int):void
        {
            if (((!(this.subViewsMap == null)) && (this.subViewsMap[_arg_1] == null)))
            {
                return;
            };
            var _local_2:AchievementDetailView = this.subViewsMap[_arg_1];
            var _local_3:int = currentSubViews.indexOf(_local_2);
            if (_local_3 >= 0)
            {
                this.selectedAchievementVO = new ShowAchievementNotificationVO(_local_3, currentSubViews.length);
                _local_2.forceExpand();
                if (!this.handleCheckComponentComplete(null))
                {
                    this.achievementSubViewParentContainer.addEventListener(Event.ENTER_FRAME, this.handleCheckComponentComplete, false, 0, true);
                };
            };
        }

        override public function dispose():void
        {
            super.dispose();
            if (listParentContainer)
            {
                UIComponentHelpers.removeMouseInteraction(listParentContainer);
                listParentContainer = null;
            };
            if (this.achievementSubViewParentContainer)
            {
                this.removeCheckComponentComplete();
                this.achievementSubViewParentContainer = null;
            };
            this.triggerPoolDictionary = null;
            if (this.subViewsMap != null)
            {
                DictionaryUtils.clearDictionary(this.subViewsMap);
                this.subViewsMap = null;
            };
        }

        override public function setXOffset(_arg_1:int, _arg_2:Boolean=false):void
        {
            super.setXOffset(_arg_1, _arg_2);
            this.achievementSubViewParentContainer.x = _arg_1;
        }

        override protected function updateSubViewDetails(_arg_1:UserAchievementCategory):void
        {
            var _local_3:UserAchievement;
            var _local_4:AchievementDetailView;
            var _local_2:Vector.<ITreeNode> = this.getChildren(_arg_1);
            var _local_5:int;
            var _local_6:int = _local_2.length;
            while (_local_5 < _local_6)
            {
                _local_4 = null;
                _local_3 = (_local_2[_local_5] as UserAchievement);
                if (_local_5 < currentSubViews.length)
                {
                    _local_4 = this.subViewsMap[_local_3.getAchievementId()];
                    if (_local_4 != null)
                    {
                        _local_4.updateDetails(_local_3.getFinished(), _local_3.getPoints(), _local_3.getTriggers());
                    };
                };
                _local_5++;
            };
        }

        override protected function initMembers():void
        {
            super.initMembers();
            subcategoryViews = new DynamicArray(AchievementDetailView, this.DEFAULT_SUB_VIEWS_COUNT);
            this.achievementSubViewParentContainer = new VBox();
            this.achievementSubViewParentContainer.setStyle(UIComponentHelpers.VERTICAL_GAP, 0);
            UIComponentHelpers.removeMouseInteraction(this.achievementSubViewParentContainer);
            listParentContainer.addChild(this.achievementSubViewParentContainer);
        }

        private function removeCheckComponentComplete():void
        {
            this.achievementSubViewParentContainer.removeEventListener(Event.ENTER_FRAME, this.handleCheckComponentComplete);
            this.selectedAchievementVO = null;
        }

        override protected function getChildren(_arg_1:UserAchievementCategory):Vector.<ITreeNode>
        {
            return (_arg_1.getVisibleAchievementChildren());
        }

        private function handleCheckComponentComplete(_arg_1:Event):Boolean
        {
            var _local_2:Number;
            var _local_4:Number;
            var _local_5:Number;
            var _local_6:int;
            var _local_3:Container = (listParentContainer as Container);
            if (((this.selectedAchievementVO.achievementLength <= this.achievementsOnPage) || (this.selectedAchievementVO.achievementIndex < (this.achievementsOnPage / 2))))
            {
                this.setContainerVerticalScrollBarPosition(0);
                return (true);
            };
            if (this.achievementSubViewParentContainer.height > 0)
            {
                _local_4 = (AchievementDetailView.ACHIEVEMENT_VIEW_BACKGROUND_HEIGHT + AchievementDetailView.TRIGGER_BOX_VERTICAL_GAP);
                _local_5 = (currentSubViews[this.selectedAchievementVO.achievementIndex] as AchievementDetailView).getExpandedHeight();
                _local_6 = 0;
                while (_local_6 < currentSubViews.length)
                {
                    if (_local_6 != this.selectedAchievementVO.achievementIndex)
                    {
                        _local_5 = (_local_5 + (currentSubViews[_local_6] as AchievementDetailView).getCollapsedHeight());
                    };
                    _local_6++;
                };
                if (this.selectedAchievementVO.achievementIndex >= (this.selectedAchievementVO.achievementLength - (this.achievementsOnPage / 2)))
                {
                    _local_2 = _local_3.maxVerticalScrollPosition;
                }
                else
                {
                    _local_2 = (((this.selectedAchievementVO.achievementIndex - (this.achievementsOnPage / 2)) + 1) * _local_4);
                };
                if (((_local_5 < this.achievementSubViewParentContainer.height) || (!(_local_3.verticalScrollPosition == _local_2))))
                {
                    _local_3.verticalScrollPosition = _local_2;
                    return (false);
                };
                this.setContainerVerticalScrollBarPosition(_local_2);
                return (true);
            };
            return (false);
        }

        override public function handleNotification(_arg_1:INotification):void
        {
            super.handleNotification(_arg_1);
            var _local_2:Object = _arg_1.getBody();
            var _local_3:String = _arg_1.getName();
            switch (_local_3)
            {
                case AchievementConsts.SHOW_ACHIEVEMENT:
                    this.handleAchievementSelected(int(_arg_1.getType()));
                    return;
            };
        }

        override protected function setSubViewDetails(_arg_1:Vector.<ITreeNode>, _arg_2:Boolean, _arg_3:Boolean, _arg_4:String):void
        {
            var _local_5:UserAchievement;
            var _local_6:AchievementDetailView;
            var _local_7:AchievementGUIDetailVO;
            var _local_8:int;
            var _local_9:int = _arg_1.length;
            removeSubViewsFromScreen();
            currentSubViews = null;
            subcategoryViews.setLength(_local_9);
            currentSubViews = subcategoryViews.getArray();
            this.removeCheckComponentComplete();
            while (_local_8 < _local_9)
            {
                _local_5 = (_arg_1[_local_8] as UserAchievement);
                _local_6 = (currentSubViews[_local_8] as AchievementDetailView);
                this.subViewsMap[_local_5.getAchievementId()] = _local_6;
                _local_6.setTriggerPoolDictionary(this.triggerPoolDictionary);
                _local_6.setWidth(this.componentWidth);
                _local_7 = AchievementsManager.getInstance().getAchievementGUIDetailVO(_local_5.getAchievementVO().getAchievementID());
                _local_6.populateDetails(_local_5.getAchievementVO().getAchievementID(), _local_5.getAchievementVO().getAchievementName(), _local_7, _local_5.getFinished(), _local_5.getPoints(), _local_5.getTriggers(), true, _arg_2, _arg_3, _arg_4);
                _local_6.setParent(this.achievementSubViewParentContainer);
                _local_8++;
            };
        }


    }
}
