package Communication.VO
{
    public class PvPCommandVO 
    {

        public var id:int;
        public var commandId:int;


        public static function Create(_arg_1:int, _arg_2:int):PvPCommandVO
        {
            var _local_3:PvPCommandVO = new (PvPCommandVO)();
            _local_3.commandId = _arg_1;
            _local_3.id = _arg_2;
            return (_local_3);
        }


        public function IsValid():Boolean
        {
            return (true);
        }

        public function toString():String
        {
            return (("<PvPCommandVO commandId='" + this.commandId) + "' />");
        }


    }
}
