package Communication.VO.Achievements
{
    public class AchievementTriggerUIDetailVO 
    {

        private var type:String;
        private var name:String;
        private var progressParameter:String;

        public function AchievementTriggerUIDetailVO(_arg_1:String, _arg_2:String, _arg_3:String)
        {
            super();
            this.name = _arg_1;
            this.type = _arg_2;
            this.progressParameter = _arg_3;
        }

        public function getType():String
        {
            return (this.type);
        }

        public function getName():String
        {
            return (this.name);
        }

        public function getProgress():String
        {
            return (this.progressParameter);
        }


    }
}
