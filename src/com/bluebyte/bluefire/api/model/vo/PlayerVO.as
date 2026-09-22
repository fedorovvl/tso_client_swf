package com.bluebyte.bluefire.api.model.vo
{
    public class PlayerVO 
    {

        private var _id:int;
        private var _name:String;
        private var _password:String;


        public function get id():int
        {
            return (this._id);
        }

        public function set password(_arg_1:String):void
        {
            this._password = _arg_1;
        }

        public function get password():String
        {
            return (this._password);
        }

        public function get name():String
        {
            return (this._name);
        }

        public function set id(_arg_1:int):void
        {
            this._id = _arg_1;
        }

        public function set name(_arg_1:String):void
        {
            this._name = _arg_1;
        }


    }
}
