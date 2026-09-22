package nLib
{
    import flash.events.Event;

    public class cEventWithData extends Event 
    {

        public var mType_string:String;
        public var mObject:Object;

        public function cEventWithData(_arg_1:String, _arg_2:String, _arg_3:Object, _arg_4:Boolean, _arg_5:Boolean)
        {
            super(_arg_1, _arg_4, _arg_5);
            this.mType_string = _arg_2;
            this.mObject = _arg_3;
        }

    }
}
