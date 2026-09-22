package com.bluebyte.bluefire.api.controller
{
    public class TextController 
    {

        public static const UNDEFINED:String = "[undefined text]";
        private static var _instance:TextController;

        private var _textList:Object = new Object();

        public function TextController(_arg_1:SingletonEnforcer)
        {
            super();
            if (_arg_1 == null)
            {
                throw (new Error("TextController is a Sigleton. Use instance to use this class."));
            };
        }

        public static function get instance():TextController
        {
            if (_instance == null)
            {
                _instance = new TextController(new SingletonEnforcer());
            };
            return (_instance);
        }


        private function replaceVariables(_arg_1:String, _arg_2:Array):String
        {
            var _local_4:Array;
            var _local_5:String;
            if (!_arg_2)
            {
                return (_arg_1);
            };
            var _local_3:int;
            while (_local_3 < _arg_2.length)
            {
                _local_4 = _arg_1.match((((("{(" + _local_3) + "|") + _local_3) + ",[A-Z]{1,3})}"));
                if (_local_4)
                {
                    if ((_local_4[1] as String).indexOf(",") > 0)
                    {
                        _local_5 = this.getText(_arg_2[_local_3]);
                    }
                    else
                    {
                        _local_5 = _arg_2[_local_3];
                    };
                    _arg_1 = _arg_1.replace(_local_4[0], _local_5);
                };
                _local_3++;
            };
            return (_arg_1);
        }

        public function getText(_arg_1:String, _arg_2:Array=null):String
        {
            if (!_arg_1)
            {
                throw (new Error(false, "Text identifier must not be null."));
            };
            var _local_3:String = this._textList[_arg_1.toLowerCase()];
            if (((_local_3) && (_local_3.length > 0)))
            {
                return (this.replaceVariables(_local_3, _arg_2));
            };
            trace(((UNDEFINED + " / ") + _arg_1));
            return (UNDEFINED);
        }

        public function registerIdentifier(_arg_1:String, _arg_2:String):void
        {
            if (this._textList.hasOwnProperty(_arg_1.toLowerCase()))
            {
                throw (new Error((("Identifier: " + _arg_1.toLowerCase()) + " already registered!")));
            };
            this._textList[_arg_1.toLowerCase()] = _arg_2;
        }


    }
}//package com.bluebyte.bluefire.api.controller

class SingletonEnforcer 
{

    public function SingletonEnforcer()
    {
        super();
    }

}


