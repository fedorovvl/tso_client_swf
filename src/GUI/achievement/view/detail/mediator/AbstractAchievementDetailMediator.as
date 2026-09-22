package GUI.achievement.view.detail.mediator
{
    import org.puremvc.as3.patterns.mediator.Mediator;
    import GUI.achievement.interfaces.IUpdateAchievementView;
    import Utils.Disposable;
    import GUI.achievement.view.detail.CategoryDetailHeaderView;
    import GUI.helpers.DynamicArray;
    import flash.display.DisplayObjectContainer;
    import GUI.achievement.view.detail.AbstractDetailSubView;
    import Achievements.UserAchievementCategory;
    import Achievements.AchievementConsts;
    import org.puremvc.as3.interfaces.INotification;
    import GUI.GAME.achievement.AchievementPanel;
    import __AS3__.vec.Vector;
    import Utils.Tree.ITreeNode;
    import Communication.VO.dPlayerListItemVO;
    import __AS3__.vec.*;

    public class AbstractAchievementDetailMediator extends Mediator implements IUpdateAchievementView, Disposable 
    {

        protected var visible:Boolean;
        protected var headerView:CategoryDetailHeaderView;
        protected var subcategoryViews:DynamicArray;
        protected var categoryID:int;
        protected var itemsOnRow:int;
        private var mediatorCount:int = 0;
        protected var currentSubViews:Array;
        protected var currentPlayerId:int;
        protected var listParentContainer:DisplayObjectContainer;
        protected var xOffset:int;

        public function AbstractAchievementDetailMediator(_arg_1:String, _arg_2:CategoryDetailHeaderView, _arg_3:DisplayObjectContainer)
        {
            super((_arg_1 + this.mediatorCount++));
            this.headerView = _arg_2;
            this.listParentContainer = _arg_3;
            this.initMembers();
        }

        public function hide():void
        {
            this.visible = false;
            this.headerView.hide();
            this.removeSubViewsFromScreen();
            this.categoryID = -1;
            this.currentPlayerId = -1;
        }

        protected function removeSubViewsFromScreen():void
        {
            var _local_2:AbstractDetailSubView;
            if (this.currentSubViews == null)
            {
                return;
            };
            var _local_1:int;
            var _local_3:int = this.currentSubViews.length;
            while (_local_1 < _local_3)
            {
                _local_2 = (this.currentSubViews[_local_1] as AbstractDetailSubView);
                _local_2.setParent(null);
                _local_1++;
            };
        }

        public function update(_arg_1:UserAchievementCategory):void
        {
            if ((((this.visible) && (this.categoryID >= 0)) && (this.currentPlayerId == _arg_1.getPlayerId())))
            {
                this.updateCategoryData(_arg_1);
            };
        }

        override public function handleNotification(_arg_1:INotification):void
        {
            var _local_2:String = _arg_1.getName();
            var _local_3:Object = _arg_1.getBody();
            switch (_local_2)
            {
                case AchievementConsts.USER_ACHIEVEMENT_TREE_UPDATED:
                    this.update((_local_3 as UserAchievementCategory));
                    return;
            };
        }

        public function setWidth(_arg_1:int, _arg_2:Boolean=true):void
        {
            this.headerView.setWidth((_arg_1 + ((_arg_2) ? (AchievementPanel.SCROLL_BAR_OFFSET / 2) : 0)));
        }

        public function dispose():void
        {
            if (this.subcategoryViews)
            {
                this.subcategoryViews.dispose();
                this.subcategoryViews = null;
            };
            this.listParentContainer = null;
            this.headerView = null;
            this.currentSubViews = null;
        }

        protected function setCategoryData(_arg_1:int, _arg_2:UserAchievementCategory, _arg_3:Array, _arg_4:Boolean, _arg_5:Boolean, _arg_6:String):void
        {
            var _local_8:Vector.<ITreeNode>;
            var _local_9:int;
            var _local_7:UserAchievementCategory = _arg_2.getCategory(_arg_1);
            this.categoryID = _arg_1;
            if (_arg_3 != null)
            {
                _local_8 = new Vector.<ITreeNode>();
                for each (_local_9 in _arg_3)
                {
                    _local_8.push(_local_7.getChildById(_local_9));
                };
            }
            else
            {
                _local_8 = this.getChildren(_local_7);
            };
            this.setSubViewDetails(_local_8, _arg_4, _arg_5, _arg_6);
            this.headerView.populateHeaderCategoryDetails(_local_7.getAchievementCategoryVO().getCategoryName(), _local_7.getAchievementCategoryVO().getCategoryID(), _local_7.getFinishedLeaves(), _local_7.getTotalLeaves(), _local_7.getProgress(), _local_7.getHideProgress(), _local_7.getPoints());
        }

        public function setXOffset(_arg_1:int, _arg_2:Boolean=false):void
        {
            this.xOffset = _arg_1;
            this.headerView.setXOffset((_arg_1 + ((_arg_2) ? (AchievementPanel.SCROLL_BAR_OFFSET / 2) : 0)));
        }

        protected function updateSubViewDetails(_arg_1:UserAchievementCategory):void
        {
        }

        protected function getChildren(_arg_1:UserAchievementCategory):Vector.<ITreeNode>
        {
            return (_arg_1.getChildren());
        }

        override public function listNotificationInterests():Array
        {
            return ([AchievementConsts.USER_ACHIEVEMENT_TREE_UPDATED]);
        }

        protected function initMembers():void
        {
            this.categoryID = -1;
            this.visible = false;
            this.xOffset = 0;
        }

        public function updateCategoryData(_arg_1:UserAchievementCategory):void
        {
            var _local_2:UserAchievementCategory = _arg_1.getCategory(this.categoryID);
            this.updateSubViewDetails(_local_2);
            this.headerView.updateHeaderCategoryDetails(_local_2.getFinishedLeaves(), _local_2.getTotalLeaves(), _local_2.getProgress(), _local_2.getPoints());
        }

        public function setCategoryUserData(_arg_1:int, _arg_2:UserAchievementCategory, _arg_3:dPlayerListItemVO, _arg_4:Array, _arg_5:Boolean, _arg_6:Boolean, _arg_7:String):void
        {
            if (_arg_2 != null)
            {
                this.currentPlayerId = _arg_3.id;
                this.setCategoryData(_arg_1, _arg_2, _arg_4, _arg_5, _arg_6, _arg_7);
                this.headerView.populateHeaderUserDetails(_arg_3.username, _arg_3.avatarId);
            };
        }

        public function show():void
        {
            this.visible = true;
            this.headerView.show();
        }

        protected function setSubViewDetails(_arg_1:Vector.<ITreeNode>, _arg_2:Boolean, _arg_3:Boolean, _arg_4:String):void
        {
        }


    }
}
