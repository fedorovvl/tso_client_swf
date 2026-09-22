package GUI.achievement.vo
{
    import Utils.Disposable;

    public class CategoryGUIDetailVO implements Disposable 
    {

        private var headerIcon:String;
        private var subcategoryIcon:String;
        private var listIcon:String;

        public function CategoryGUIDetailVO(_arg_1:String, _arg_2:String, _arg_3:String)
        {
            super();
            this.listIcon = _arg_1;
            this.subcategoryIcon = _arg_2;
            this.headerIcon = _arg_3;
        }

        public function getSubcategoryIcon():String
        {
            return (this.subcategoryIcon);
        }

        public function dispose():void
        {
            this.listIcon = null;
            this.subcategoryIcon = null;
            this.headerIcon = null;
        }

        public function getHeaderIcon():String
        {
            return (this.headerIcon);
        }

        public function getListIcon():String
        {
            return (this.listIcon);
        }


    }
}
