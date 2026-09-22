package Communication.VO
{
    public class dAdventureStateChangeVO 
    {

        public var adventureId:int;
        public var startTime:Number;
        public var troopLimit:int;
        public var state:int;
        public var admiralCount:int;


        public static function Create(_arg_1:int, _arg_2:int, _arg_3:Number, _arg_4:int, _arg_5:int):dAdventureStateChangeVO
        {
            var _local_6:dAdventureStateChangeVO = new (dAdventureStateChangeVO)();
            _local_6.adventureId = _arg_1;
            _local_6.state = _arg_2;
            _local_6.startTime = _arg_3;
            _local_6.troopLimit = _arg_4;
            _local_6.admiralCount = _arg_5;
            return (_local_6);
        }


        public function toString():String
        {
            return (((((((((("<dAdventureStateChangeVO adventureId='" + this.adventureId) + "' state='") + this.state) + "' startTime='") + this.startTime) + "' troopLimit='") + this.troopLimit) + "' admiralCount='") + this.admiralCount) + "' />");
        }


    }
}
