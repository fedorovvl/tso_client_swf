package com.bluebyte.bluefire.api.event
{
    import flash.events.Event;

    public class RoomManagerEvent extends Event 
    {

        public static const ALL_ROOMS_JOINED:String = "AllRoomsJoined";

        public var data:*;

        public function RoomManagerEvent(_arg_1:String, _arg_2:Boolean=false, _arg_3:Boolean=false)
        {
            super(_arg_1, _arg_2, _arg_3);
        }

        override public function clone():Event
        {
            var _local_1:RoomManagerEvent = new RoomManagerEvent(this.type, this.bubbles, this.cancelable);
            _local_1.data = this.data;
            return (_local_1);
        }


    }
}
