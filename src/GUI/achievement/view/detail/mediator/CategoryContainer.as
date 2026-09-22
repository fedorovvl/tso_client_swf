package GUI.achievement.view.detail.mediator
{
    import GUI.achievement.view.detail.CategoryDetailHeaderView;
    import flash.display.DisplayObjectContainer;
    import GUI.achievement.view.detail.SubcategoryDetailView;
    import Achievements.UserAchievementCategory;
    import __AS3__.vec.Vector;
    import Utils.Tree.ITreeNode;
    import GUI.helpers.DynamicArray;
    import GUI.achievement.view.detail.*;

    public class CategoryContainer extends AbstractAchievementDetailMediator 
    {

        private const DEFAULT_SUBCATEGORIES_COUNT:int = 10;
        private const DEFAULT_ITEMS_ON_ROW:int = 2;

        public function CategoryContainer(_arg_1:String, _arg_2:CategoryDetailHeaderView, _arg_3:DisplayObjectContainer)
        {
            super(_arg_1, _arg_2, _arg_3);
        }

        override public function setWidth(_arg_1:int, _arg_2:Boolean=true):void
        {
            super.setWidth(_arg_1, _arg_2);
            itemsOnRow = Math.floor((_arg_1 / SubcategoryDetailView.VIEW_COMPONENT_WIDTH));
        }

        override protected function updateSubViewDetails(_arg_1:UserAchievementCategory):void
        {
            var _local_3:UserAchievementCategory;
            var _local_4:SubcategoryDetailView;
            var _local_2:Vector.<ITreeNode> = _arg_1.getChildren();
            var _local_5:int;
            var _local_6:int = _local_2.length;
            while (_local_5 < _local_6)
            {
                _local_3 = (_local_2[_local_5] as UserAchievementCategory);
                _local_4 = (currentSubViews[_local_5] as SubcategoryDetailView);
                _local_4.updateDetails(_local_3.getFinishedLeaves(), _local_3.getTotalLeaves(), _local_3.getProgress(), _local_3.getPoints());
                _local_5++;
            };
        }

        override protected function initMembers():void
        {
            super.initMembers();
            subcategoryViews = new DynamicArray(SubcategoryDetailView, this.DEFAULT_SUBCATEGORIES_COUNT);
            itemsOnRow = this.DEFAULT_ITEMS_ON_ROW;
        }

        override protected function setSubViewDetails(_arg_1:Vector.<ITreeNode>, _arg_2:Boolean, _arg_3:Boolean, _arg_4:String):void
        {
            var _local_5:UserAchievementCategory;
            var _local_6:SubcategoryDetailView;
            var _local_9:int;
            var _local_10:int;
            var _local_11:int;
            var _local_12:int;
            var _local_7:int;
            var _local_8:int = _arg_1.length;
            var _local_13:int;
            removeSubViewsFromScreen();
            currentSubViews = null;
            subcategoryViews.setLength(_local_8);
            currentSubViews = subcategoryViews.getArray();
            while (_local_7 < _local_8)
            {
                _local_5 = (_arg_1[_local_7] as UserAchievementCategory);
                _local_6 = (currentSubViews[_local_7] as SubcategoryDetailView);
                if (_local_5.isVisible())
                {
                    _local_6.populateDetails(_local_5.getAchievementCategoryVO().getCategoryName(), _local_5.getFinishedLeaves(), _local_5.getTotalLeaves(), _local_5.getProgress(), _local_5.getPoints(), _local_5.getAchievementCategoryVO().getCategoryID(), _local_5.hasSubcategories(), _local_5.getHideProgress());
                    _local_6.setParent(listParentContainer);
                    _local_12 = int(Math.floor((_local_13 / itemsOnRow)));
                    _local_11 = (_local_13 % itemsOnRow);
                    _local_9 = (xOffset + (_local_11 * SubcategoryDetailView.VIEW_COMPONENT_WIDTH));
                    _local_10 = (_local_12 * SubcategoryDetailView.VIEW_COMPONENT_HEIGHT);
                    _local_6.setCoordinates(_local_9, _local_10);
                    _local_13++;
                };
                _local_7++;
            };
        }


    }
}
