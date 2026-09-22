package GO
{
    import nLib.cXML;

    public class cWatchData 
    {

        private var yPixelOffset:int;
        private var xPixelOffset:int;

        public function cWatchData(_arg_1:cXML)
        {
            super();
            this.xPixelOffset = int((_arg_1.GetAttributeFloatingPoint("x") * 100));
            this.yPixelOffset = int((_arg_1.GetAttributeFloatingPoint("y") * 100));
        }

        public function getYPixelOffset():int
        {
            return (this.yPixelOffset);
        }

        public function getXPixelOffset():int
        {
            return (this.xPixelOffset);
        }

        public function toString():String
        {
            return (((("<WatchData " + this.xPixelOffset) + "/") + this.yPixelOffset) + " >");
        }


    }
}
