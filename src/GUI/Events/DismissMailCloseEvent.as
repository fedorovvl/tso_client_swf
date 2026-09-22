package GUI.Events
{
    import mx.events.CloseEvent;
    import flash.events.Event;

    public class DismissMailCloseEvent extends CloseEvent 
    {

        public static const DISMISS:String = "dismiss";

        public var toStorage:Boolean;

        public function DismissMailCloseEvent(_arg_1:String, _arg_2:int=-1, _arg_3:Boolean=false)
        {
            super(_arg_1, false, false, _arg_2);
            this.toStorage = _arg_3;
        }

        override public function clone():Event
        {
            return (new DismissMailCloseEvent(type, detail, this.toStorage));
        }


    }
}
