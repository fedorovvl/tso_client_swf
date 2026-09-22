package Communication.VO
{
    public class dTrackedMissionVO 
    {

        public var id1:int;
        public var id2:int;
        public var missionType:int;


        public function init(_arg_1:int, _arg_2:int, _arg_3:int):dTrackedMissionVO
        {
            this.missionType = _arg_1;
            this.id1 = _arg_2;
            this.id2 = _arg_3;
            return (this);
        }


    }
}
