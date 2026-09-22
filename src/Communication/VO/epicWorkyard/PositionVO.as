package Communication.VO.epicWorkyard
{
    public class PositionVO 
    {

        private var mX:Number;
        private var mY:Number;
        private var mIconX:int;
        private var mIconY:int;
        private var mName:String;

        public function PositionVO(_arg_1:String, _arg_2:Number, _arg_3:Number, _arg_4:int, _arg_5:int)
        {
            super();
            this.mName = _arg_1;
            this.mX = _arg_2;
            this.mY = _arg_3;
            this.mIconX = _arg_4;
            this.mIconY = _arg_5;
        }

        public function getName():String
        {
            return (this.mName);
        }

        public function getX():Number
        {
            return (this.mX);
        }

        public function getY():Number
        {
            return (this.mY);
        }

        public function getIconX():int
        {
            return (this.mIconX);
        }

        public function getIconY():int
        {
            return (this.mIconY);
        }


    }
}
