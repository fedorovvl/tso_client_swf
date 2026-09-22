package com.bluebyte.bluefire.api.model.vo
{
    public class RoomPresenceUpdatedVO extends PresenceUpdatedVO 
    {

        private var _room:String;

        public function RoomPresenceUpdatedVO(_arg_1:String, _arg_2:String, _arg_3:Boolean)
        {
            super(_arg_1, _arg_3);
            this._room = _arg_2;
        }

        public function get room():String
        {
            return (this._room);
        }

        public function set room(_arg_1:String):void
        {
            this._room = _arg_1;
        }


    }
}
