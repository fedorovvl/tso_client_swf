package Communication.VO
{
    public class dLeaveAdventureVO 
    {

        public var playerID:int;
        public var timestamp:int;


        public static function CreateLeaveAdventureVO(_arg_1:int, _arg_2:int):dLeaveAdventureVO
        {
            var _local_3:dLeaveAdventureVO = new (dLeaveAdventureVO)();
            _local_3.playerID = _arg_1;
            _local_3.timestamp = _arg_2;
            return (_local_3);
        }


    }
}
