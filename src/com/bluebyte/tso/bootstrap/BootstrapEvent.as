package com.bluebyte.tso.bootstrap
{
    import flash.events.Event;

    public class BootstrapEvent extends Event 
    {

        public static const PROGRESS:String = "progressStep";
        public static const NEXT:String = "nextStep";
        public static const COMPLETE:String = "complete";

        public var step:BootstrapStep;

        public function BootstrapEvent(_arg_1:String, _arg_2:BootstrapStep)
        {
            super(_arg_1);
            this.step = _arg_2;
        }

        override public function clone():Event
        {
            return (new BootstrapEvent(type, this.step));
        }


    }
}
