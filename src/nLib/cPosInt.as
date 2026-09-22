package nLib
{
    public class cPosInt 
    {

        public var x:int;
        public var y:int;

        public function cPosInt(_arg_1:int=0, _arg_2:int=0)
        {
            super();
            this.x = _arg_1;
            this.y = _arg_2;
        }

        public function Set(_arg_1:cPosInt):cPosInt
        {
            this.x = _arg_1.x;
            this.y = _arg_1.y;
            return (this);
        }

        public function multiply(_arg_1:Number):cPosInt
        {
            this.x = (this.x * _arg_1);
            this.y = (this.y * _arg_1);
            return (this);
        }

        public function toString():String
        {
            return ((this.x + "/") + this.y);
        }

        public function clone():cPosInt
        {
            return (new cPosInt(this.x, this.y));
        }

        public function add(_arg_1:cPosInt):cPosInt
        {
            this.x = (this.x + _arg_1.x);
            this.y = (this.y + _arg_1.y);
            return (this);
        }


    }
}
