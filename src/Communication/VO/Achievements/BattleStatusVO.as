package Communication.VO.Achievements
{
    public class BattleStatusVO 
    {

        private var targetName:String;
        private var zoneName:String;
        private var casualties:int;

        public function BattleStatusVO(_arg_1:String, _arg_2:String, _arg_3:int)
        {
            super();
            this.zoneName = _arg_1;
            this.targetName = _arg_2;
            this.casualties = _arg_3;
        }

        public function getTargetName():String
        {
            return (this.targetName);
        }

        public function getCasualties():int
        {
            return (this.casualties);
        }

        public function getZoneName():String
        {
            return (this.zoneName);
        }


    }
}
