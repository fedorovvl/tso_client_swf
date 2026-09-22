package com.bluebyte.tso.ui.util
{
    import flash.utils.Dictionary;
    import flash.events.KeyboardEvent;
    import flash.display.Stage;

    public class KeyState 
    {

        private static var inst:KeyState;

        private var keyState:Dictionary = new Dictionary();

        public function KeyState()
        {
            super();
            if (inst)
            {
                throw (new Error("Tried to instanciate KeyState() twice!"));
            };
        }

        public static function isDown(_arg_1:int):Boolean
        {
            return (getInstance().keyState[_arg_1] === true);
        }

        public static function isUp(_arg_1:int):Boolean
        {
            return (!(isDown(_arg_1)));
        }

        public static function attach(_arg_1:Stage):void
        {
            _arg_1.addEventListener(KeyboardEvent.KEY_DOWN, getInstance().keyDownHandler);
            _arg_1.addEventListener(KeyboardEvent.KEY_UP, getInstance().keyUpHandler);
        }

        private static function getInstance():KeyState
        {
            if (!inst)
            {
                inst = new (KeyState)();
            };
            return (inst);
        }


        private function keyUpHandler(_arg_1:KeyboardEvent):void
        {
            this.keyState[_arg_1.keyCode] = false;
        }

        private function keyDownHandler(_arg_1:KeyboardEvent):void
        {
            this.keyState[_arg_1.keyCode] = true;
        }


    }
}
