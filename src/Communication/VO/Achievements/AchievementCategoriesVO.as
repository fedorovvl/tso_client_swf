package Communication.VO.Achievements
{
    import Utils.Disposable;

    public class AchievementCategoriesVO implements Disposable 
    {

        private var categoryParentID:int = 0;
        private var categoryName:String;
        private var categoryHideProgress:Boolean = false;
        private var categoryUseParentOnFacebookPost:Boolean = false;
        private var categoryID:int;
        private var categoryIgnoreProgress:Boolean = false;

        public function AchievementCategoriesVO(_arg_1:int, _arg_2:String, _arg_3:int, _arg_4:Boolean, _arg_5:Boolean, _arg_6:Boolean)
        {
            super();
            this.categoryID = _arg_1;
            this.categoryName = _arg_2;
            this.categoryParentID = _arg_3;
            this.categoryIgnoreProgress = _arg_4;
            this.categoryHideProgress = _arg_5;
            this.categoryUseParentOnFacebookPost = _arg_6;
        }

        public function getCategoryParentID():int
        {
            return (this.categoryParentID);
        }

        public function getCategoryIgnoreProgress():Boolean
        {
            return (this.categoryIgnoreProgress);
        }

        public function getCategoryHideProgress():Boolean
        {
            return (this.categoryHideProgress);
        }

        public function dispose():void
        {
            this.categoryName = null;
        }

        public function getCategoryID():int
        {
            return (this.categoryID);
        }

        public function getCategoryUseParentOnFacebookPost():Boolean
        {
            return (this.categoryUseParentOnFacebookPost);
        }

        public function getCategoryName():String
        {
            return (this.categoryName);
        }


    }
}
