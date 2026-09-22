package GUI
{
    import flash.events.Event;

    public class DataEvent extends Event 
    {

        public var data:Object;

        public function DataEvent(_arg_1:String, _arg_2:Object, _arg_3:Boolean=false, _arg_4:Boolean=false)
        {
            super(_arg_1, _arg_3, _arg_4);
            this.data = _arg_2;
        }

    }
}
