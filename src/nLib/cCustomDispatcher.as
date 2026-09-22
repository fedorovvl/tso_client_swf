package nLib
{
    import flash.events.EventDispatcher;
    import flash.events.Event;

    public class cCustomDispatcher extends EventDispatcher 
    {

        public static var mAction_string:String = "action";


        public function doActionWithData(_arg_1:String, _arg_2:Object):void
        {
            dispatchEvent(new cEventWithData(cCustomDispatcher.mAction_string, _arg_1, _arg_2, false, false));
        }

        public function doAction():void
        {
            dispatchEvent(new Event(cCustomDispatcher.mAction_string));
        }


    }
}
