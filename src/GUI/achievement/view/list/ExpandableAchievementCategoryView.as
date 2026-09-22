package GUI.achievement.view.list
{
    import flash.events.EventDispatcher;
    import Utils.Disposable;
    import GUI.achievement.interfaces.IAchievementView;
    import __AS3__.vec.Vector;
    import flash.display.DisplayObjectContainer;
    import GUI.Components.achievement.list.ExpandableAchievementCategoryViewComponent;
    import GUI.Assets.gAssetManager;
    import GUI.helpers.UIComponentHelpers;
    import flash.events.MouseEvent;
    import mx.events.EffectEvent;
    import flash.events.Event;
    import Achievements.AchievementConsts;
    import GUI.ApplicationFacade;
    import Achievements.IAchievementTreeNode;
    import Utils.Tree.ITreeNode;
    import Achievements.UserAchievementCategory;
    import mx.effects.Sequence;
    import Achievements.AchievementsManager;
    import GUI.achievement.vo.CategoryGUIDetailVO;
    import GUI.Loca.cLocaManager;
    import Enums.LOCA_GROUP;
    import Communication.VO.Achievements.AchievementCategoriesVO;
    import __AS3__.vec.*;

    public class ExpandableAchievementCategoryView extends EventDispatcher implements Disposable, IAchievementView 
    {

        private const MAIN_BUTTON_LEFT_OFFSET:int = 0;
        private const RESIZE_EXPAND:String = "ResizeExpand";
        private const EXPAND_BTN_STATE_COLLAPSED_ICON_NAME:String = "ArrowSmallSUp";
        private const MAIN_BUTTON_LEFT_RANK_OFFSET:int = 22;
        private const EXPAND_BTN_STATE_EXPANDED_ICON_NAME:String = "ArrowSmallNUp";
        private const BUTTON_RANK_STYLES:Object = {
            "1":{
                "normal":"ButtonNormal",
                "hover":"ButtonNormal",
                "selected":"ButtonHighlight",
                "labelLeft":45,
                "iconLeft":16
            },
            "2":{
                "normal":"QuestItemBgHead",
                "hover":"QuestItemBgHead",
                "selected":"QuestItemBgHeadSelected",
                "labelLeft":60,
                "iconLeft":26
            },
            "3":{
                "normal":"QuestItemBgNormal",
                "hover":"QuestItemBgNormal",
                "selected":"QuestItemBgSelected",
                "labelLeft":38,
                "iconLeft":4
            }
        };
        private const RESIZE_COLLAPSE:String = "ResizeCollapse";

        private var currentHeight:Number;
        private var mainCategoryName:String;
        private var subViews:Vector.<ExpandableAchievementCategoryView>;
        private var expanding:Boolean;
        private var mainCategoryRank:int;
        private var mainCategoryID:int;
        private var expanded:Boolean;
        private var expandedHeight:Number;
        private var parentViewComponent:DisplayObjectContainer;
        private var collapsedHeight:Number;
        public var viewComponent:ExpandableAchievementCategoryViewComponent;
        private var expandable:Boolean;

        public function ExpandableAchievementCategoryView(_arg_1:DisplayObjectContainer)
        {
            super();
            this.parentViewComponent = _arg_1;
            this.viewComponent = new ExpandableAchievementCategoryViewComponent();
            this.parentViewComponent.addChild(this.viewComponent);
            this.expandable = false;
            this.expanding = false;
            this.expanded = false;
        }

        public function handleCategorySelected(_arg_1:int):void
        {
            var _local_2:ExpandableAchievementCategoryView;
            this.viewComponent.btnItem.selected = (_arg_1 == this.mainCategoryID);
            for each (_local_2 in this.subViews)
            {
                _local_2.handleCategorySelected(_arg_1);
                if (((_local_2.mainCategoryID == _arg_1) && (!(this.expanded))))
                {
                    this.handleCollapseButtonClick(null);
                };
            };
        }

        public function show():void
        {
            var _local_1:ExpandableAchievementCategoryView;
            this.addListeners();
            for each (_local_1 in this.subViews)
            {
                _local_1.show();
            };
        }

        private function setExpandedState(_arg_1:Boolean):void
        {
            if (!_arg_1)
            {
                this.calculateExpandedHeight();
            };
            this.currentHeight = ((this.expanded) ? this.expandedHeight : this.collapsedHeight);
            this.viewComponent.btnExpand.iconImage = gAssetManager.GetBitmap(((this.expanded) ? this.EXPAND_BTN_STATE_EXPANDED_ICON_NAME : this.EXPAND_BTN_STATE_COLLAPSED_ICON_NAME));
            if (_arg_1)
            {
                this.viewComponent.height = this.currentHeight;
                this.viewComponent.list.visible = this.expanded;
                this.viewComponent.list.alpha = ((this.expanded) ? 1 : 0);
            };
        }

        private function removeListeners():void
        {
            UIComponentHelpers.removeMouseInteraction(this.viewComponent);
            this.viewComponent.btnItem.removeEventListener(MouseEvent.CLICK, this.handleMainButtonClick);
            this.viewComponent.btnExpand.removeEventListener(MouseEvent.CLICK, this.handleCollapseButtonClick);
            this.viewComponent.expand.removeEventListener(EffectEvent.EFFECT_START, this.handleExpandCollapseResizeStart);
            this.viewComponent.collapseResize.removeEventListener(EffectEvent.EFFECT_START, this.handleExpandCollapseResizeStart);
            this.viewComponent.resize.removeEventListener(EffectEvent.EFFECT_START, this.handleExpandCollapseResizeStart);
            this.viewComponent.expand.removeEventListener(EffectEvent.EFFECT_END, this.handleExpandCollapseResizeEnd);
            this.viewComponent.collapse.removeEventListener(EffectEvent.EFFECT_END, this.handleExpandCollapseResizeEnd);
            this.viewComponent.list.removeEventListener(this.RESIZE_EXPAND, this.handleChildResize);
            this.viewComponent.list.removeEventListener(this.RESIZE_COLLAPSE, this.handleChildResize);
        }

        public function getHeight():Number
        {
            return (this.currentHeight);
        }

        private function addListeners():void
        {
            UIComponentHelpers.enableMouseInteractionForList(this.viewComponent.btnItem, this.viewComponent.btnExpand);
            this.viewComponent.btnItem.addEventListener(MouseEvent.CLICK, this.handleMainButtonClick, false, 0, true);
            this.viewComponent.btnExpand.addEventListener(MouseEvent.CLICK, this.handleCollapseButtonClick, false, 0, true);
            this.viewComponent.expand.addEventListener(EffectEvent.EFFECT_START, this.handleExpandCollapseResizeStart, false, 0, true);
            this.viewComponent.collapseResize.addEventListener(EffectEvent.EFFECT_START, this.handleExpandCollapseResizeStart, false, 0, true);
            this.viewComponent.resize.addEventListener(EffectEvent.EFFECT_START, this.handleExpandCollapseResizeStart, false, 0, true);
            this.viewComponent.expand.addEventListener(EffectEvent.EFFECT_END, this.handleExpandCollapseResizeEnd, false, 0, true);
            this.viewComponent.collapse.addEventListener(EffectEvent.EFFECT_END, this.handleExpandCollapseResizeEnd, false, 0, true);
            this.viewComponent.list.addEventListener(this.RESIZE_EXPAND, this.handleChildResize, false, 0, true);
            this.viewComponent.list.addEventListener(this.RESIZE_COLLAPSE, this.handleChildResize, false, 0, true);
        }

        private function initSequences():void
        {
            this.calculateExpandedHeight();
            this.viewComponent.expandResize.heightTo = this.expandedHeight;
            this.collapsedHeight = this.viewComponent.collapseResize.heightTo;
            this.currentHeight = ((this.expanded) ? this.expandedHeight : this.collapsedHeight);
        }

        private function handleExpandCollapseResizeEnd(_arg_1:EffectEvent):void
        {
            this.expanding = false;
            this.viewComponent.list.visible = this.expanded;
            this.viewComponent.btnExpand.addEventListener(MouseEvent.CLICK, this.handleCollapseButtonClick, false, 0, true);
        }

        private function handleChildResize(_arg_1:Event):void
        {
            this.calculateExpandedHeight();
            this.currentHeight = this.expandedHeight;
            if (_arg_1.type == this.RESIZE_COLLAPSE)
            {
                this.viewComponent.resize.startDelay = 300;
            }
            else
            {
                this.viewComponent.resize.startDelay = 0;
            };
            this.viewComponent.resize.play();
            this.parentViewComponent.dispatchEvent(_arg_1);
        }

        public function dispose():void
        {
            this.parentViewComponent.removeChild(this.viewComponent);
            this.viewComponent = null;
            this.parentViewComponent = null;
            this.mainCategoryName = null;
            this.subViews = null;
        }

        public function hide():void
        {
            var _local_1:ExpandableAchievementCategoryView;
            this.expanding = false;
            if (this.viewComponent.expand.isPlaying)
            {
                this.viewComponent.expand.stop();
            };
            if (this.viewComponent.collapse.isPlaying)
            {
                this.viewComponent.collapse.stop();
            };
            this.viewComponent.list.alpha = ((this.expanded) ? 1 : 0);
            this.removeListeners();
            for each (_local_1 in this.subViews)
            {
                _local_1.hide();
            };
        }

        private function setExpandButtonState():void
        {
            if (((this.expandable) && (this.mainCategoryRank > 1)))
            {
                this.viewComponent.btnExpand.iconImage = gAssetManager.GetBitmap(((this.expanded) ? this.EXPAND_BTN_STATE_EXPANDED_ICON_NAME : this.EXPAND_BTN_STATE_COLLAPSED_ICON_NAME));
                this.viewComponent.btnExpand.visible = true;
                this.viewComponent.btnExpand.enabled = true;
            }
            else
            {
                this.viewComponent.btnExpand.visible = false;
                this.viewComponent.btnExpand.enabled = false;
            };
        }

        private function handleMainButtonClick(_arg_1:MouseEvent):void
        {
            var _local_2:String = (((this.expandable) || (this.mainCategoryRank == 1)) ? AchievementConsts.CATEGORY_CONTAINER_SELECTED : AchievementConsts.ACHIEVEMENT_CATEGORY_SELECTED);
            ApplicationFacade.getInstance().sendNotification(_local_2, this.mainCategoryID);
        }

        private function createSubcategories(_arg_1:UserAchievementCategory):void
        {
            var _local_2:IAchievementTreeNode;
            var _local_3:ExpandableAchievementCategoryView;
            var _local_4:Vector.<ITreeNode> = _arg_1.getChildren();
            this.subViews = new Vector.<ExpandableAchievementCategoryView>();
            var _local_5:int;
            var _local_6:int = _local_4.length;
            while (_local_5 < _local_6)
            {
                _local_2 = (_local_4[_local_5] as IAchievementTreeNode);
                if (((!(_local_2.isLeaf())) && (_local_2.isVisible())))
                {
                    _local_3 = new ExpandableAchievementCategoryView(this.viewComponent.list);
                    _local_3.populate((_local_2 as UserAchievementCategory));
                    this.subViews.push(_local_3);
                    this.expandable = true;
                };
                _local_5++;
            };
        }

        private function calculateExpandedHeight():void
        {
            var _local_3:ExpandableAchievementCategoryView;
            var _local_1:int = UIComponentHelpers.getStyleAsInt(this.viewComponent.list, UIComponentHelpers.VERTICAL_GAP);
            var _local_2:int = this.viewComponent.btnItem.height;
            for each (_local_3 in this.subViews)
            {
                _local_2 = (_local_2 + (_local_3.getHeight() + _local_1));
            };
            _local_2 = (_local_2 - _local_1);
            this.expandedHeight = _local_2;
            this.viewComponent.resize.heightTo = this.expandedHeight;
            this.viewComponent.expandResize.heightTo = this.expandedHeight;
        }

        private function handleCollapseButtonClick(_arg_1:MouseEvent):void
        {
            if (this.expanding)
            {
                return;
            };
            this.expanding = true;
            this.expanded = (!(this.expanded));
            this.setExpandedState(false);
            this.viewComponent.btnExpand.removeEventListener(MouseEvent.CLICK, this.handleCollapseButtonClick);
            var _local_2:Sequence = ((this.expanded) ? this.viewComponent.expand : this.viewComponent.collapse);
            _local_2.play();
            this.parentViewComponent.dispatchEvent(new Event(((this.expanded) ? this.RESIZE_EXPAND : this.RESIZE_COLLAPSE)));
        }

        private function populateMainButton():void
        {
            var _local_1:Object = this.getButtonStyle();
            var _local_2:CategoryGUIDetailVO = AchievementsManager.getInstance().getCategoryGUIDetailVO(this.mainCategoryID);
            var _local_3:String = ((_local_2 != null) ? _local_2.getListIcon() : null);
            this.viewComponent.btnItem.labelText = cLocaManager.GetInstance().GetText(LOCA_GROUP.ACHIEVEMENT_LABELS, this.mainCategoryName);
            this.viewComponent.btnItem.normalStyle = _local_1.normal;
            this.viewComponent.btnItem.hoverStyle = _local_1.hover;
            this.viewComponent.btnItem.selectedStyle = _local_1.selected;
            this.viewComponent.btnItem.labelLeft = _local_1.labelLeft;
            this.viewComponent.btnItem.iconLeft = _local_1.iconLeft;
            if (((!(_local_3 == null)) && (_local_3.length > 0)))
            {
                this.viewComponent.btnItem.buttonIcon.source = gAssetManager.GetAchievementUrl(_local_3);
                this.viewComponent.btnItem.buttonIcon.visible = true;
            };
            this.viewComponent.itemCanvas.setStyle(UIComponentHelpers.LEFT, (this.MAIN_BUTTON_LEFT_OFFSET + (this.MAIN_BUTTON_LEFT_RANK_OFFSET * Math.max(0, (this.mainCategoryRank - 2)))));
            this.viewComponent.sidebarArrow.visible = (this.mainCategoryRank > 2);
            this.viewComponent.sidebarArrow.setStyle(UIComponentHelpers.LEFT, ((this.MAIN_BUTTON_LEFT_OFFSET + (this.MAIN_BUTTON_LEFT_RANK_OFFSET * Math.max(0, (this.mainCategoryRank - 2)))) - 15));
            this.setExpandButtonState();
        }

        private function handleExpandCollapseResizeStart(_arg_1:EffectEvent):void
        {
            this.viewComponent.list.visible = this.expanded;
            ApplicationFacade.getInstance().sendNotification(AchievementConsts.UPDATE_LIST_HEIGHT, this.currentHeight);
        }

        private function getButtonStyle():Object
        {
            if (this.mainCategoryRank == 1)
            {
                return (this.BUTTON_RANK_STYLES[1]);
            };
            if (this.expandable)
            {
                return (this.BUTTON_RANK_STYLES[2]);
            };
            return (this.BUTTON_RANK_STYLES[3]);
        }

        public function populate(_arg_1:UserAchievementCategory):void
        {
            var _local_2:AchievementCategoriesVO = _arg_1.getAchievementCategoryVO();
            this.mainCategoryName = _local_2.getCategoryName();
            this.mainCategoryID = _local_2.getCategoryID();
            this.mainCategoryRank = _arg_1.getRank();
            this.createSubcategories(_arg_1);
            this.populateMainButton();
            this.initSequences();
            if (this.mainCategoryRank == 1)
            {
                this.expandable = false;
                this.expanded = true;
            };
            this.setExpandedState(true);
        }


    }
}
