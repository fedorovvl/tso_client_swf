package GO
{
    import nLib.cXML;

    public class cBlockingData 
    {

        public static const BLOCK_TYPE_ALLOW_ALL:int = 0;
        public static const BLOCK_TYPE_ALLOW_NOTHING:int = 1;
        public static const BLOCK_TYPE_ALLOW_STREETS:int = 2;
        public static const BLOCK_TYPE_ALLOW_WATERBUILD:int = 3;
        public static const BLOCK_TYPE_ALLOW_SAFE:int = 4;
        public static const BLOCK_TYPE_ALLOW_MOVE:int = 5;

        private var yPixelOffset:int;
        private var xPixelOffset:int;
        private var blockingType:int;

        public function cBlockingData(_arg_1:cXML)
        {
            super();
            this.xPixelOffset = int((_arg_1.GetAttributeFloatingPoint("x") * 100));
            this.yPixelOffset = int((_arg_1.GetAttributeFloatingPoint("y") * 100));
            this.blockingType = _arg_1.GetAttributeInt("blockingType");
        }

        public static function isFullyBlocked(_arg_1:int):Boolean
        {
            return ((_arg_1 == BLOCK_TYPE_ALLOW_NOTHING) || (_arg_1 == BLOCK_TYPE_ALLOW_SAFE));
        }


        public function getBlockingType():int
        {
            return (this.blockingType);
        }

        public function getXPixelOffset():int
        {
            return (this.xPixelOffset);
        }

        public function getYPixelOffset():int
        {
            return (this.yPixelOffset);
        }


    }
}
