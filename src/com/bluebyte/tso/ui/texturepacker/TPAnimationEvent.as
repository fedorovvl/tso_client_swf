package com.bluebyte.tso.ui.texturepacker
{
    import flash.events.Event;

    public class TPAnimationEvent extends Event 
    {

        public static const STARTED:String = "started";
        public static const STOPPED:String = "stopped";
        public static const LOOP_FINISHED:String = "loopFinished";

        public function TPAnimationEvent(_arg_1:String)
        {
            super(_arg_1);
        }

        override public function clone():Event
        {
            return (new TPAnimationEvent(this.type));
        }


    }
}
