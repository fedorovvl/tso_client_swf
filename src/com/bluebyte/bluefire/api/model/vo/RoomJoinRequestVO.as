package com.bluebyte.bluefire.api.model.vo
{
    public class RoomJoinRequestVO 
    {

        private var _useForOnlineStatus:Boolean;
        private var _name:String;

        public function RoomJoinRequestVO(_arg_1:String, _arg_2:Boolean=false)
        {
            super();
            this._name = _arg_1;
            this._useForOnlineStatus = _arg_2;
        }

        public function get useForOnlineStatus():Boolean
        {
            return (this._useForOnlineStatus);
        }

        public function get name():String
        {
            return (this._name);
        }

        public function set name(_arg_1:String):void
        {
            this._name = _arg_1;
        }

        public function set useForOnlineStatus(_arg_1:Boolean):void
        {
            this._useForOnlineStatus = _arg_1;
        }


    }
}
