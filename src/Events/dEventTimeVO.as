package Events
{
    public class dEventTimeVO 
    {

        public var event_name_string:String;
        public var startDate:Number;
        public var stopDate:Number;


        public static function fromEvent(_arg_1:dEventVO):dEventTimeVO
        {
            var _local_2:dEventTimeVO = new (dEventTimeVO)();
            _local_2.event_name_string = _arg_1.event_name_string;
            _local_2.startDate = _arg_1.startDate;
            _local_2.stopDate = _arg_1.stopDate;
            return (_local_2);
        }


    }
}
