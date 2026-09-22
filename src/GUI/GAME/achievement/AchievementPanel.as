package GUI.GAME.achievement
{
    import GUI.GAME.cBasicPanel;
    import org.puremvc.as3.interfaces.IMediator;
    import Utils.Disposable;
    import GUI.Components.AchievementPanelViewComponent;
    import Achievements.UserAchievementCategory;
    import GUI.achievement.view.list.AchievementCategoryList;
    import GUI.achievement.view.detail.mediator.CategoryContainer;
    import GUI.ApplicationFacade;
    import GUI.achievement.view.detail.CategoryDetailHeaderView;
    import Communication.VO.dPlayerListItemVO;
    import GUI.achievement.view.AchievementPanelView;
    import __AS3__.vec.Vector;
    import GUI.achievement.interfaces.IUpdateAchievementView;
    import Interface.cGameInterface;
    import flash.utils.Dictionary;
    import GUI.achievement.view.detail.mediator.AchievementCategory;
    import Achievements.AchievementConsts;
    import GUI.helpers.ObjectPool;
    import GUI.achievement.view.detail.AchievementCheckBoxTriggerView;
    import GUI.achievement.view.detail.AchievementProgressTriggerView;
    import Utils.DictionaryUtils;
    import Achievements.IAchievementTreeNode;
    import org.puremvc.as3.interfaces.INotification;
    import __AS3__.vec.*;

    public class AchievementPanel extends cBasicPanel implements IMediator, Disposable 
    {

        public static const SCROLL_BAR_OFFSET:int = 20;

        private const DEFAULT_OBJECT_COUNT:int = 5;

        private var panel:AchievementPanelViewComponent;
        private var userTree:UserAchievementCategory;
        private var achievementCategoryList:AchievementCategoryList;
        private var currentSelectedCategoryId:int;
        private var userCategoryContainerSubMediator:CategoryContainer;
        private var facade:ApplicationFacade;
        private var comparedUserDetailHeaderView:CategoryDetailHeaderView;
        private var userItemVO:dPlayerListItemVO;
        private var comparedUserItemVO:dPlayerListItemVO;
        private var comparedUserTree:UserAchievementCategory;
        private var panelView:AchievementPanelView;
        private var allViews:Vector.<IUpdateAchievementView>;
        private var detailViewMode:String;
        private var comparedUserCategoryContainerSubMediator:CategoryContainer;
        private var currentDetailViews:Array;
        private var gameInterface:cGameInterface;
        private var views:Dictionary;
        private var detailViewType:String;
        private var userAchievementCategorySubMediator:AchievementCategory;
        private var triggerComponentObjectPools:Dictionary;
        private var comparedUserAchievementCategorySubMediator:AchievementCategory;
        private var userDetailHeaderView:CategoryDetailHeaderView;


        private function handleCategorySelected(_arg_1:int, _arg_2:String):void
        {
            if (_arg_1 == this.currentSelectedCategoryId)
            {
                return;
            };
            this.currentSelectedCategoryId = _arg_1;
            this.setMode(this.detailViewMode, _arg_2);
            this.showCurrentViews();
        }

        private function setDetailViewData():void
        {
            if (((this.userItemVO.username == null) || (this.userItemVO.username == "")))
            {
                this.userItemVO.username = this.gameInterface.mCurrentPlayer.GetPlayerName_string();
                this.userItemVO.avatarId = this.gameInterface.mCurrentPlayer.GetAvatarId();
            };
            switch (this.detailViewType)
            {
                case AchievementConsts.DETAIL_VIEW_TYPE_CATEGORY_CONTAINER:
                    this.setCategoryContainerDetails();
                    break;
                case AchievementConsts.DETAIL_VIEW_TYPE_ACHIEVEMENT_CATEGORY:
                    this.setAchievementCategoryDetails();
                    break;
            };
            if (((this.panel) && (this.panel.detailViewContentContainer)))
            {
                this.panel.detailViewContentContainer.verticalScrollPosition = 0;
            };
        }

        public function getMediatorName():String
        {
            return (AchievementConsts.ACHIEVEMENT_PANEL_MEDIATOR_NAME);
        }

        public function init(_arg_1:cGameInterface, _arg_2:AchievementPanelViewComponent):void
        {
            this.gameInterface = _arg_1;
            this.panel = _arg_2;
            this.userItemVO = this.gameInterface.mCurrentPlayer.GetPlayerListItem();
            this.currentSelectedCategoryId = -1;
            this.createTriggerObjectPools();
            globalFlash.gui.windowController.addWindow(_arg_2);
            AddBaseElement(_arg_2);
            this.facade = ApplicationFacade.getInstance();
            this.facade.registerMediator(this);
        }

        private function createTriggerObjectPools():void
        {
            this.triggerComponentObjectPools = new Dictionary();
            this.triggerComponentObjectPools[AchievementConsts.TRIGGER_TYPE_CHECKBOX] = new ObjectPool(AchievementCheckBoxTriggerView, this.DEFAULT_OBJECT_COUNT);
            this.triggerComponentObjectPools[AchievementConsts.TRIGGER_TYPE_PROGRESS] = new ObjectPool(AchievementProgressTriggerView, this.DEFAULT_OBJECT_COUNT);
        }

        override public function dispose():void
        {
            var _local_1:String;
            var _local_2:ObjectPool;
            this.facade.removeMediator(this.getMediatorName());
            DictionaryUtils.clearDictionary(this.views);
            if (this.triggerComponentObjectPools != null)
            {
                for (_local_1 in this.triggerComponentObjectPools)
                {
                    _local_2 = this.triggerComponentObjectPools[_local_1];
                    _local_2.dispose();
                    delete this.triggerComponentObjectPools[_local_1];
                };
                this.triggerComponentObjectPools = null;
            };
            this.userTree = null;
            this.comparedUserTree = null;
            this.panel = null;
            this.facade = null;
            this.gameInterface = null;
            this.detailViewMode = null;
            this.detailViewType = null;
            this.currentDetailViews = null;
            this.allViews = null;
            this.userItemVO = null;
            this.comparedUserItemVO = null;
            super.dispose();
        }

        public function onRegister():void
        {
            this.panelView = new AchievementPanelView(this.panel);
            this.achievementCategoryList = new AchievementCategoryList(this.panel.listViewComponent, this.panel.btnTitle);
            this.facade.registerMediator(this.achievementCategoryList);
            this.userDetailHeaderView = new CategoryDetailHeaderView(this.panel.detailViewHeaderContainer);
            this.comparedUserDetailHeaderView = new CategoryDetailHeaderView(this.panel.detailViewHeaderContainer);
            this.userCategoryContainerSubMediator = new CategoryContainer(AchievementConsts.ACHIEVEMENT_PANEL_CATEGORY_CONTAINER_MEDIATOR_NAME, this.userDetailHeaderView, this.panel.detailViewContentContainer);
            this.facade.registerMediator(this.userCategoryContainerSubMediator);
            this.userAchievementCategorySubMediator = new AchievementCategory(AchievementConsts.ACHIEVEMENT_PANEL_ACHIEVEMENT_CATEGORY_MEDIATOR_NAME, this.userDetailHeaderView, this.panel.detailViewContentContainer, this.triggerComponentObjectPools);
            this.facade.registerMediator(this.userAchievementCategorySubMediator);
            this.comparedUserCategoryContainerSubMediator = new CategoryContainer(AchievementConsts.ACHIEVEMENT_PANEL_CATEGORY_CONTAINER_MEDIATOR_NAME, this.comparedUserDetailHeaderView, this.panel.detailViewContentContainer);
            this.facade.registerMediator(this.comparedUserCategoryContainerSubMediator);
            this.comparedUserAchievementCategorySubMediator = new AchievementCategory(AchievementConsts.ACHIEVEMENT_PANEL_ACHIEVEMENT_CATEGORY_MEDIATOR_NAME, this.comparedUserDetailHeaderView, this.panel.detailViewContentContainer, this.triggerComponentObjectPools);
            this.facade.registerMediator(this.comparedUserAchievementCategorySubMediator);
            this.views = new Dictionary();
            this.views[((AchievementConsts.NORMAL_MODE + "_") + AchievementConsts.DETAIL_VIEW_TYPE_CATEGORY_CONTAINER)] = [this.userCategoryContainerSubMediator];
            this.views[((AchievementConsts.NORMAL_MODE + "_") + AchievementConsts.DETAIL_VIEW_TYPE_ACHIEVEMENT_CATEGORY)] = [this.userAchievementCategorySubMediator];
            this.views[((AchievementConsts.COMPARE_MODE + "_") + AchievementConsts.DETAIL_VIEW_TYPE_CATEGORY_CONTAINER)] = [this.userCategoryContainerSubMediator, this.comparedUserCategoryContainerSubMediator];
            this.views[((AchievementConsts.COMPARE_MODE + "_") + AchievementConsts.DETAIL_VIEW_TYPE_ACHIEVEMENT_CATEGORY)] = [this.userAchievementCategorySubMediator, this.comparedUserAchievementCategorySubMediator];
            this.allViews = new Vector.<IUpdateAchievementView>();
            this.allViews.push(this.userCategoryContainerSubMediator, this.userAchievementCategorySubMediator, this.comparedUserCategoryContainerSubMediator, this.comparedUserAchievementCategorySubMediator);
        }

        override public function Show():void
        {
            this.panelView.show();
            this.achievementCategoryList.show();
            this.showCurrentViews();
            super.Show();
        }

        public function setViewComponent(_arg_1:Object):void
        {
            this.panel = (_arg_1 as AchievementPanelViewComponent);
        }

        private function setCategoryContainerDetails():void
        {
            switch (this.detailViewMode)
            {
                case AchievementConsts.NORMAL_MODE:
                    this.userCategoryContainerSubMediator.setXOffset(0);
                    this.userCategoryContainerSubMediator.setWidth((this.panel.detailsContainer.width - SCROLL_BAR_OFFSET));
                    this.userCategoryContainerSubMediator.setCategoryUserData(this.currentSelectedCategoryId, this.userTree, this.userItemVO, null, true, true, this.detailViewMode);
                    return;
                case AchievementConsts.COMPARE_MODE:
                    this.userCategoryContainerSubMediator.setXOffset(0);
                    this.userCategoryContainerSubMediator.setWidth(((this.panel.detailsContainer.width - SCROLL_BAR_OFFSET) / 2));
                    this.userCategoryContainerSubMediator.setCategoryUserData(this.currentSelectedCategoryId, this.userTree, this.userItemVO, null, false, true, this.detailViewMode);
                    this.comparedUserCategoryContainerSubMediator.setXOffset(((this.panel.detailsContainer.width - SCROLL_BAR_OFFSET) / 2), true);
                    this.comparedUserCategoryContainerSubMediator.setWidth(((this.panel.detailsContainer.width - SCROLL_BAR_OFFSET) / 2), false);
                    this.comparedUserCategoryContainerSubMediator.setCategoryUserData(this.currentSelectedCategoryId, this.comparedUserTree, this.comparedUserItemVO, null, false, false, this.detailViewMode);
                    return;
            };
        }

        private function showCurrentViews():void
        {
            var _local_1:IUpdateAchievementView;
            for each (_local_1 in this.allViews)
            {
                if (this.currentDetailViews.indexOf(_local_1) < 0)
                {
                    _local_1.hide();
                };
            };
            for each (_local_1 in this.currentDetailViews)
            {
                _local_1.show();
            };
        }

        private function handleShowHidePanel(_arg_1:String, _arg_2:IAchievementTreeNode):void
        {
            if (((IsVisible()) && (_arg_1 == null)))
            {
                this.Hide();
            }
            else
            {
                if (_arg_1 == null)
                {
                    _arg_1 = AchievementConsts.NORMAL_MODE;
                };
                this.comparedUserTree = (_arg_2 as UserAchievementCategory);
                if (this.currentSelectedCategoryId < 0)
                {
                    this.currentSelectedCategoryId = 0;
                };
                this.achievementCategoryList.forceCategorySelected(this.currentSelectedCategoryId);
                if (((_arg_1 == AchievementConsts.COMPARE_MODE) && (_arg_2 == null)))
                {
                    this.showHourglassAnimation(true);
                }
                else
                {
                    this.showHourglassAnimation(false);
                };
                this.setMode(_arg_1, this.computeViewType());
                this.Show();
            };
        }

        private function showHourglassAnimation(_arg_1:Boolean):void
        {
            this.panel.hourglassAnimLayer.visible = _arg_1;
            this.panel.hourglassAnim.visible = _arg_1;
            this.panel.detailViewHeaderContainer.visible = (!(_arg_1));
            this.panel.detailViewContentContainer.visible = (!(_arg_1));
        }

        public function handleNotification(_arg_1:INotification):void
        {
            var _local_2:Object = _arg_1.getBody();
            var _local_3:String = _arg_1.getName();
            var _local_4:String = _arg_1.getType();
            switch (_local_3)
            {
                case AchievementConsts.SHOW_HIDE_ACHIEVEMENT_PANEL:
                    if (!this.userTree)
                    {
                        _local_2 = this.gameInterface.getCurrentUserAchievementManager().getTree();
                        this.handleUpdateTreeView((_local_2 as UserAchievementCategory));
                        this.achievementCategoryList.handleInitializeList((_local_2 as UserAchievementCategory));
                    };
                    this.handleShowHidePanel(_local_4, (_local_2 as IAchievementTreeNode));
                    return;
                case AchievementConsts.USER_ACHIEVEMENT_TREE_UPDATED:
                    this.handleUpdateTreeView((_local_2 as UserAchievementCategory));
                    return;
                case AchievementConsts.CATEGORY_CONTAINER_SELECTED:
                    this.handleCategorySelected(int(_local_2), AchievementConsts.DETAIL_VIEW_TYPE_CATEGORY_CONTAINER);
                    return;
                case AchievementConsts.ACHIEVEMENT_CATEGORY_SELECTED:
                    this.handleCategorySelected(int(_local_2), AchievementConsts.DETAIL_VIEW_TYPE_ACHIEVEMENT_CATEGORY);
                    return;
                case AchievementConsts.COMPARED_TREE_RECEIVED:
                    this.handleComparedTreeReceived((_local_2 as UserAchievementCategory));
                    return;
                case AchievementConsts.SHOW_ACHIEVEMENT:
                    this.handleShowHidePanel(AchievementConsts.NORMAL_MODE, null);
                    this.handleCategorySelected(int(_local_2), AchievementConsts.DETAIL_VIEW_TYPE_ACHIEVEMENT_CATEGORY);
                    return;
                case AchievementConsts.EVENT_CHANGED:
                    this.handleCheckVisibleCategorySelected();
                    return;
            };
        }

        private function handleComparedTreeReceived(_arg_1:UserAchievementCategory):void
        {
            if (((!(_arg_1 == null)) && (IsVisible())))
            {
                this.comparedUserTree = _arg_1;
                this.setMode(this.detailViewMode, this.computeViewType());
                this.showHourglassAnimation(false);
            };
        }

        public function setComparedUserItemVO(_arg_1:dPlayerListItemVO):void
        {
            this.comparedUserItemVO = _arg_1;
        }

        private function setAchievementCategoryDetails():void
        {
            var _local_1:Array;
            var _local_2:Array;
            switch (this.detailViewMode)
            {
                case AchievementConsts.NORMAL_MODE:
                    this.userAchievementCategorySubMediator.setXOffset(0);
                    this.userAchievementCategorySubMediator.setWidth((this.panel.detailsContainer.width - SCROLL_BAR_OFFSET));
                    _local_1 = this.sortDictionaryKeys(this.userTree.getCategory(this.currentSelectedCategoryId).getAchievementStatusHashMap(true));
                    this.userAchievementCategorySubMediator.setCategoryUserData(this.currentSelectedCategoryId, this.userTree, this.userItemVO, _local_1, true, true, this.detailViewMode);
                    return;
                case AchievementConsts.COMPARE_MODE:
                    _local_2 = this.computeSortedAchievementIDList();
                    this.userAchievementCategorySubMediator.setXOffset(0);
                    this.userAchievementCategorySubMediator.setWidth(((this.panel.detailsContainer.width - SCROLL_BAR_OFFSET) / 2));
                    this.userAchievementCategorySubMediator.setCategoryUserData(this.currentSelectedCategoryId, this.userTree, this.userItemVO, _local_2, false, true, this.detailViewMode);
                    this.comparedUserAchievementCategorySubMediator.setXOffset(((this.panel.detailsContainer.width - SCROLL_BAR_OFFSET) / 2), true);
                    this.comparedUserAchievementCategorySubMediator.setWidth(((this.panel.detailsContainer.width - SCROLL_BAR_OFFSET) / 2), false);
                    this.comparedUserAchievementCategorySubMediator.setCategoryUserData(this.currentSelectedCategoryId, this.comparedUserTree, this.comparedUserItemVO, _local_2, false, false, this.detailViewMode);
                    return;
            };
        }

        private function handleUpdateTreeView(_arg_1:UserAchievementCategory):void
        {
            this.userTree = _arg_1;
        }

        public function onRemove():void
        {
            if (this.achievementCategoryList)
            {
                this.facade.removeMediator(this.achievementCategoryList.getMediatorName());
                this.achievementCategoryList.dispose();
                this.achievementCategoryList = null;
            };
            if (this.panelView)
            {
                this.panelView.dispose();
                this.panelView = null;
            };
            if (this.userDetailHeaderView)
            {
                this.userDetailHeaderView.dispose();
                this.userDetailHeaderView = null;
            };
            if (this.userCategoryContainerSubMediator != null)
            {
                this.facade.removeMediator(this.userCategoryContainerSubMediator.getMediatorName());
                this.userCategoryContainerSubMediator.dispose();
                this.userCategoryContainerSubMediator = null;
            };
            if (this.userAchievementCategorySubMediator != null)
            {
                this.facade.removeMediator(this.userAchievementCategorySubMediator.getMediatorName());
                this.userAchievementCategorySubMediator.dispose();
                this.userAchievementCategorySubMediator = null;
            };
            if (this.comparedUserCategoryContainerSubMediator != null)
            {
                this.facade.removeMediator(this.comparedUserCategoryContainerSubMediator.getMediatorName());
                this.comparedUserCategoryContainerSubMediator.dispose();
                this.comparedUserCategoryContainerSubMediator = null;
            };
            if (this.comparedUserAchievementCategorySubMediator != null)
            {
                this.facade.removeMediator(this.comparedUserAchievementCategorySubMediator.getMediatorName());
                this.comparedUserAchievementCategorySubMediator.dispose();
                this.comparedUserAchievementCategorySubMediator = null;
            };
        }

        public function getViewComponent():Object
        {
            return (this.panel);
        }

        private function setMode(_arg_1:String, _arg_2:String):void
        {
            this.detailViewMode = _arg_1;
            this.detailViewType = _arg_2;
            this.currentDetailViews = this.views[((this.detailViewMode + "_") + this.detailViewType)];
            this.setDetailViewData();
        }

        private function computeViewType():String
        {
            if (!this.userTree)
            {
                return (AchievementConsts.DETAIL_VIEW_TYPE_CATEGORY_CONTAINER);
            };
            var _local_1:UserAchievementCategory = this.userTree.getCategory(this.currentSelectedCategoryId);
            return ((_local_1.hasSubcategories()) ? AchievementConsts.DETAIL_VIEW_TYPE_CATEGORY_CONTAINER : AchievementConsts.DETAIL_VIEW_TYPE_ACHIEVEMENT_CATEGORY);
        }

        public function sortDictionaryKeys(_arg_1:Dictionary):Array
        {
            var _local_3:Object;
            var _local_2:Array = new Array();
            for (_local_3 in _arg_1)
            {
                _local_2.push(_local_3);
            };
            _local_2.sort(Array.NUMERIC);
            return (_local_2);
        }

        override public function Hide():void
        {
            var _local_1:IUpdateAchievementView;
            this.panelView.hide();
            this.achievementCategoryList.hide();
            for each (_local_1 in this.currentDetailViews)
            {
                _local_1.hide();
            };
            this.currentDetailViews = null;
            super.Hide();
        }

        private function handleCheckVisibleCategorySelected():void
        {
            var _local_1:UserAchievementCategory = this.userTree.getCategory(this.currentSelectedCategoryId);
            if (((!(_local_1 == null)) || ((!(_local_1 == null)) && (!(_local_1.isVisible())))))
            {
                this.handleCategorySelected(0, AchievementConsts.DETAIL_VIEW_TYPE_CATEGORY_CONTAINER);
            };
        }

        private function computeSortedAchievementIDList():Array
        {
            var _local_8:String;
            if (((this.userTree == null) || (this.comparedUserTree == null)))
            {
                return (null);
            };
            var _local_1:Array = [];
            var _local_2:Dictionary = this.userTree.getCategory(this.currentSelectedCategoryId).getAchievementStatusHashMap(true);
            var _local_3:Dictionary = this.comparedUserTree.getCategory(this.currentSelectedCategoryId).getAchievementStatusHashMap(false);
            var _local_4:Array = [];
            var _local_5:Array = [];
            var _local_6:Array = [];
            var _local_7:Array = [];
            for (_local_8 in _local_2)
            {
                if (((_local_2[_local_8] == true) && (_local_3[_local_8] == true)))
                {
                    _local_4.push(parseInt(_local_8));
                }
                else
                {
                    if (((_local_2[_local_8] == true) && (_local_3[_local_8] == false)))
                    {
                        _local_5.push(parseInt(_local_8));
                    }
                    else
                    {
                        if (((_local_2[_local_8] == false) && (_local_3[_local_8] == true)))
                        {
                            _local_6.push(parseInt(_local_8));
                        }
                        else
                        {
                            _local_7.push(parseInt(_local_8));
                        };
                    };
                };
            };
            _local_1 = _local_1.concat.apply(this, _local_4);
            _local_1 = _local_1.concat.apply(this, _local_5);
            _local_1 = _local_1.concat.apply(this, _local_6);
            return (_local_1.concat.apply(this, _local_7));
        }

        public function listNotificationInterests():Array
        {
            return ([AchievementConsts.SHOW_HIDE_ACHIEVEMENT_PANEL, AchievementConsts.USER_ACHIEVEMENT_TREE_UPDATED, AchievementConsts.CATEGORY_CONTAINER_SELECTED, AchievementConsts.ACHIEVEMENT_CATEGORY_SELECTED, AchievementConsts.SHOW_ACHIEVEMENT, AchievementConsts.COMPARED_TREE_RECEIVED, AchievementConsts.EVENT_CHANGED]);
        }


    }
}
