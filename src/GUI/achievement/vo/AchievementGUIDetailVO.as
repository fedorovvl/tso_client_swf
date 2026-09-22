package GUI.achievement.vo
{
    public class AchievementGUIDetailVO 
    {

        private var smallIcon:String;
        private var smallIconRightOffset:int;
        private var icon:String;
        private var smallIconBottomOffset:int;

        public function AchievementGUIDetailVO(_arg_1:String, _arg_2:String, _arg_3:int, _arg_4:int)
        {
            super();
            this.icon = _arg_1;
            this.smallIcon = _arg_2;
            this.smallIconRightOffset = _arg_3;
            this.smallIconBottomOffset = _arg_4;
        }

        public function getSmallIcon():String
        {
            return (this.smallIcon);
        }

        public function getIconBottomOffset():int
        {
            return (this.smallIconBottomOffset);
        }

        public function getIcon():String
        {
            return (this.icon);
        }

        public function getIconRightOffset():int
        {
            return (this.smallIconRightOffset);
        }


    }
}
