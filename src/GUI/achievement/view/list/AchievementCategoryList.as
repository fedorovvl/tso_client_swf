package GUI.achievement.view.list
{
    import org.puremvc.as3.patterns.mediator.Mediator;
    import Utils.Disposable;
    import GUI.achievement.interfaces.IAchievementView;
    import GUI.Components.SpecialButton;
    import __AS3__.vec.Vector;
    import Achievements.UserAchievementCategory;
    import GUI.Components.achievement.list.AchievementCategoryListViewComponent;
    import Achievements.AchievementConsts;
    import flash.events.MouseEvent;
    import GUI.Components.achievement.list.ExpandableAchievementCategoryViewComponent;
    import GUI.Components.GroupList;
    import flash.display.Sprite;
    import mx.core.Container;
    import mx.events.EffectEvent;
    import org.puremvc.as3.interfaces.INotification;
    import GUI.helpers.UIComponentHelpers;
    import GUI.Loca.cLocaManager;
    import Enums.LOCA_GROUP;
    import Utils.Tree.ITreeNode;
    import __AS3__.vec.*;

    public class AchievementCategoryList extends Mediator implements Disposable, IAchievementView 
    {

        private var overviewButton:SpecialButton;
        private var initialized:Boolean;
        private var mainCategoryViews:Vector.<ExpandableAchievementCategoryView>;
        private var treeRoot:UserAchievementCategory;
        private var isVisible:Boolean;
        private var listComponent:AchievementCategoryListViewComponent;

        public function AchievementCategoryList(_arg_1:AchievementCategoryListViewComponent, _arg_2:SpecialButton)
        {
            super(AchievementConsts.ACHIEVEMENT_PANEL_CATEGORY_LIST_MEDIATOR_NAME);
            this.listComponent = _arg_1;
            this.overviewButton = _arg_2;
            this.initialized = false;
        }

        private function handleCategorySelected(_arg_1:int):void
        {
            var _local_2:ExpandableAchievementCategoryView;
            if ((((!(this.overviewButton)) || (!(this.treeRoot))) || (!(this.mainCategoryViews))))
            {
                return;
            };
            this.overviewButton.selected = (_arg_1 == this.treeRoot.getAchievementCategoryVO().getCategoryID());
            for each (_local_2 in this.mainCategoryViews)
            {
                _local_2.handleCategorySelected(_arg_1);
            };
        }

        public function hide():void
        {
            var _local_1:ExpandableAchievementCategoryView;
            for each (_local_1 in this.mainCategoryViews)
            {
                _local_1.hide();
            };
            this.removeListeners();
            this.isVisible = false;
        }

        public function forceCategorySelected(_arg_1:int):void
        {
            this.handleCategorySelected(_arg_1);
        }

        private function handleRootClick(_arg_1:MouseEvent):void
        {
            this.overviewButton.selected = true;
            sendNotification(AchievementConsts.CATEGORY_CONTAINER_SELECTED, this.treeRoot.getAchievementCategoryVO().getCategoryID());
        }

        public function show():void
        {
            var _local_1:ExpandableAchievementCategoryView;
            for each (_local_1 in this.mainCategoryViews)
            {
                _local_1.show();
            };
            this.listComponent.details.height = this.computeListHeight();
            this.addListeners();
            this.isVisible = true;
        }

        protected function handleExpandStart(_arg_1:EffectEvent):void
        {
            if ((_arg_1.target as ExpandableAchievementCategoryViewComponent).expand.isPlaying)
            {
                GroupList.scrollToItemInList((_arg_1.target as Sprite), (this.listComponent.parent as Container));
            };
        }

        override public function handleNotification(_arg_1:INotification):void
        {
            switch (_arg_1.getName())
            {
                case AchievementConsts.CATEGORY_CONTAINER_SELECTED:
                case AchievementConsts.ACHIEVEMENT_CATEGORY_SELECTED:
                    this.handleCategorySelected(int(_arg_1.getBody()));
                    return;
                case AchievementConsts.USER_ACHIEVEMENT_TREE_UPDATED:
                    this.handleInitializeList((_arg_1.getBody() as UserAchievementCategory));
                    return;
                case AchievementConsts.UPDATE_LIST_HEIGHT:
                    this.handleUpdateListHeight();
                    return;
                case AchievementConsts.EVENT_CHANGED:
                    this.clearListView();
                    this.initialized = false;
                    if (_arg_1.getBody() != null)
                    {
                        this.handleInitializeList((_arg_1.getBody() as UserAchievementCategory));
                    };
                    if (this.isVisible)
                    {
                        this.show();
                    };
                    return;
            };
        }

        private function handleUpdateListHeight():void
        {
            this.listComponent.detailsResize.heightTo = this.computeListHeight();
            if (this.listComponent.detailsResize.isPlaying)
            {
                this.listComponent.detailsResize.stop();
            };
            this.listComponent.detailsResize.play();
        }

        private function removeListeners():void
        {
            UIComponentHelpers.removeMouseInteraction(this.listComponent);
            this.overviewButton.removeEventListener(MouseEvent.CLICK, this.handleRootClick);
        }

        private function addListeners():void
        {
            UIComponentHelpers.enableMouseInteractionForList(this.overviewButton);
            this.overviewButton.addEventListener(MouseEvent.CLICK, this.handleRootClick, false, 0, true);
        }

        public function handleInitializeList(_arg_1:UserAchievementCategory):void
        {
            this.treeRoot = _arg_1;
            if (!this.initialized)
            {
                this.initialized = true;
                this.buildListView();
            };
        }

        public function dispose():void
        {
            this.clearListView();
            this.removeListeners();
            this.overviewButton = null;
            this.listComponent = null;
            this.treeRoot = null;
        }

        private function buildListView():void
        {
            var _local_1:UserAchievementCategory;
            var _local_2:ExpandableAchievementCategoryView;
            this.overviewButton.labelText = cLocaManager.GetInstance().GetText(LOCA_GROUP.ACHIEVEMENT_LABELS, this.treeRoot.getAchievementCategoryVO().getCategoryName());
            this.mainCategoryViews = new Vector.<ExpandableAchievementCategoryView>();
            var _local_3:int;
            var _local_4:Vector.<ITreeNode> = this.treeRoot.getChildren();
            var _local_5:int = _local_4.length;
            while (_local_3 < _local_5)
            {
                _local_1 = (_local_4[_local_3] as UserAchievementCategory);
                if (_local_1.isVisible())
                {
                    _local_2 = new ExpandableAchievementCategoryView(this.listComponent.list);
                    _local_2.populate(_local_1);
                    _local_2.viewComponent.addEventListener(EffectEvent.EFFECT_START, this.handleExpandStart);
                    this.mainCategoryViews.push(_local_2);
                };
                _local_3++;
            };
            this.handleUpdateListHeight();
            UIComponentHelpers.removeMouseInteraction(this.listComponent);
        }

        private function clearListView():void
        {
            var _local_1:ExpandableAchievementCategoryView;
            if (this.mainCategoryViews != null)
            {
                while (this.mainCategoryViews.length > 0)
                {
                    _local_1 = this.mainCategoryViews.pop();
                    _local_1.dispose();
                    _local_1 = null;
                };
                this.mainCategoryViews = null;
            };
        }

        override public function listNotificationInterests():Array
        {
            return ([AchievementConsts.CATEGORY_CONTAINER_SELECTED, AchievementConsts.ACHIEVEMENT_CATEGORY_SELECTED, AchievementConsts.USER_ACHIEVEMENT_TREE_UPDATED, AchievementConsts.UPDATE_LIST_HEIGHT, AchievementConsts.EVENT_CHANGED]);
        }

        private function computeListHeight():Number
        {
            var _local_2:ExpandableAchievementCategoryView;
            var _local_1:Number = 0;
            var _local_3:int = UIComponentHelpers.getStyleAsInt(this.listComponent.list, UIComponentHelpers.VERTICAL_GAP);
            for each (_local_2 in this.mainCategoryViews)
            {
                _local_1 = (_local_1 + (_local_2.getHeight() + _local_3));
            };
            _local_1 = (_local_1 + UIComponentHelpers.getStyleAsInt(this.listComponent.list, UIComponentHelpers.TOP));
            return (_local_1 + UIComponentHelpers.getStyleAsInt(this.listComponent.list, UIComponentHelpers.BOTTOM));
        }


    }
}
