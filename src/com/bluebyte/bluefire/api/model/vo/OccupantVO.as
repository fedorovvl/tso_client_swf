package com.bluebyte.bluefire.api.model.vo
{
    public class OccupantVO 
    {

        private var _clickable:Boolean;
        private var _name:String;
        private var _id:int;


        public function get clickable():Boolean
        {
            return (this._clickable);
        }

        public function set clickable(_arg_1:Boolean):void
        {
            this._clickable = _arg_1;
        }

        public function get name():String
        {
            return (this._name);
        }

        public function set name(_arg_1:String):void
        {
            this._name = _arg_1;
        }

        public function get id():int
        {
            return (this._id);
        }

        public function set id(_arg_1:int):void
        {
            this._id = _arg_1;
        }


    }
}
