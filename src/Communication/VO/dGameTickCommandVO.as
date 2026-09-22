package Communication.VO
{
    import Enums.COMMAND;

    public class dGameTickCommandVO extends dBaseVO 
    {

        public var data:Object;
        public var mode:int;
        public var playerID:int;
        public var time:Number;


        public function toDebugString(_arg_1:Number):String
        {
            var _local_2:* = "<dGameTickCommandVO ";
            var _local_3:Number = this.time;
            if (_arg_1 > 0)
            {
                _local_2 = (_local_2 + (("delta='" + (_local_3 - _arg_1)) + "' "));
            };
            _local_2 = (_local_2 + ((((("time='" + _local_3) + "' mode='") + this.mode) + "' modeString='") + COMMAND.GetString(this.mode)));
            if (this.data != null)
            {
                _local_2 = (_local_2 + ("' data='" + this.data));
            };
            return (_local_2 + "' />");
        }

        public function toString():String
        {
            return (this.toDebugString(0));
        }


    }
}
