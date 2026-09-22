package nLib
{
    import flash.display.BitmapData;

    public class cBackbufferSegment 
    {

        private static var nextId:uint = 0;

        private var lastIndex:int = -1;
        internal var background:cBackbufferSegmentCache = null;
        private var index:int;
        internal var id:uint = 0;
        internal var fog:cBackbufferSegmentCache = null;

        public function cBackbufferSegment(_arg_1:int, _arg_2:int, _arg_3:Boolean)
        {
            super();
            this.id = nextId++;
            this.fog = new cBackbufferSegmentCache(_arg_1, _arg_2, true);
            this.background = new cBackbufferSegmentCache(_arg_1, _arg_2, _arg_3);
            this.free();
        }

        public static function getIndex(_arg_1:int, _arg_2:int):int
        {
            return (_arg_1 + (_arg_2 << 10));
        }


        public function reuse(_arg_1:int):void
        {
            this.setIndex(_arg_1);
            this.fog.clear();
            this.background.clear();
        }

        public function getBitmap(_arg_1:int):BitmapData
        {
            return ((_arg_1 == cBackbuffer.REDIRECT_TARGET_BACKGROUND) ? this.background.bitmapData : this.fog.bitmapData);
        }

        public function isUsed():Boolean
        {
            return (this.index > -1);
        }

        public function free():void
        {
            this.setIndex(-1);
        }

        public function getYP():int
        {
            return (((this.index >> 10) & 0x03FF) * this.fog.bitmapData.height);
        }

        public function setIndex(_arg_1:int):void
        {
            if (this.index > -1)
            {
                this.lastIndex = this.index;
            };
            this.index = _arg_1;
        }

        public function getIndex():int
        {
            return (this.index);
        }

        public function getXP():int
        {
            return ((this.index & 0x03FF) * this.fog.bitmapData.width);
        }

        public function shouldBeDrawn(_arg_1:int):Boolean
        {
            return ((_arg_1 == cBackbuffer.REDIRECT_TARGET_BACKGROUND) ? this.background.isContainsData() : this.fog.isContainsData());
        }


    }
}
