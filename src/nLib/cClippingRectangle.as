package nLib
{
    public class cClippingRectangle 
    {

        public var minX:int;
        public var minY:int;
        public var maxX:int;
        public var maxY:int;


        public function toPixel():cClippingRectangle
        {
            this.minX = (this.minX * global.streetGridX);
            this.minY = (this.minY * global.streetGridYHalf);
            this.maxX = (this.maxX * global.streetGridX);
            this.maxY = (this.maxY * global.streetGridYHalf);
            return (this);
        }

        public function expandMinMax(_arg_1:int, _arg_2:int, _arg_3:int, _arg_4:int):cClippingRectangle
        {
            this.minX = (this.minX + _arg_1);
            this.minY = (this.minY + _arg_2);
            this.maxX = (this.maxX + _arg_3);
            this.maxY = (this.maxY + _arg_4);
            return (this);
        }

        public function expand(_arg_1:int):cClippingRectangle
        {
            this.minX = (this.minX - _arg_1);
            this.minY = (this.minY - _arg_1);
            this.maxX = (this.maxX + _arg_1);
            this.maxY = (this.maxY + _arg_1);
            return (this);
        }

        public function copy(_arg_1:cClippingRectangle):cClippingRectangle
        {
            this.minX = _arg_1.minX;
            this.minY = _arg_1.minY;
            this.maxX = _arg_1.maxX;
            this.maxY = _arg_1.maxY;
            return (this);
        }

        public function contains(_arg_1:int, _arg_2:int):Boolean
        {
            return ((((_arg_1 >= this.minX) && (_arg_1 <= this.maxX)) && (_arg_2 >= this.minY)) && (_arg_2 <= this.maxY));
        }


    }
}
