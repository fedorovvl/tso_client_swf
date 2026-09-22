package com.bluebyte.bluefire.api.model.vo
{
    public class PresenceUpdatedVO 
    {

        private var _online:Boolean;
        private var _name:String;

        public function PresenceUpdatedVO(_arg_1:String, _arg_2:Boolean)
        {
            super();
            this._name = _arg_1;
            this._online = _arg_2;
        }

        public function get online():Boolean
        {
            return (this._online);
        }

        public function set name(_arg_1:String):void
        {
            this._name = _arg_1;
        }

        public function get name():String
        {
            return (this._name);
        }

        public function set online(_arg_1:Boolean):void
        {
            this._online = _arg_1;
        }


    }
}
