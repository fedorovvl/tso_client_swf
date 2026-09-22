package nLib
{
    import flash.display.BitmapData;
    import flash.geom.Rectangle;
    import flash.geom.Point;

    public class cBackbufferSegmentCache 
    {

        private var redrawRequired:Boolean = true;
        internal var bitmapData:BitmapData;
        private var wasDrawnTo:Boolean = false;

        public function cBackbufferSegmentCache(_arg_1:int, _arg_2:int, _arg_3:Boolean)
        {
            super();
            this.bitmapData = new BitmapData(_arg_1, _arg_2, _arg_3);
            this.bitmapData.fillRect(this.bitmapData.rect, defines.DEFAULT_BACKGROUND_CLEAR_COLOR);
            this.setRequiresRedraw();
        }

        public function copyPixels(_arg_1:BitmapData, _arg_2:Rectangle, _arg_3:Point, _arg_4:BitmapData=null, _arg_5:Point=null, _arg_6:Boolean=false):void
        {
            if (this.redrawRequired)
            {
                this.bitmapData.copyPixels(_arg_1, _arg_2, _arg_3, _arg_4, _arg_5, _arg_6);
                this.wasDrawnTo = true;
            };
        }

        public function setRequiresRedraw():void
        {
            this.redrawRequired = true;
        }

        public function clear():void
        {
            this.bitmapData.fillRect(this.bitmapData.rect, defines.DEFAULT_BACKGROUND_CLEAR_COLOR);
            this.setRequiresRedraw();
            this.wasDrawnTo = false;
        }

        public function isRequiringRedraw():Boolean
        {
            return (this.redrawRequired);
        }

        public function redrawn():void
        {
            this.redrawRequired = false;
        }

        public function isContainsData():Boolean
        {
            return (this.wasDrawnTo);
        }


    }
}
