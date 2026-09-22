package nLib
{
    import flash.geom.Matrix;
    import flash.utils.Dictionary;
    import com.bluebyte.tso.ui.components.MapTextField;
    import flash.geom.Point;
    import flash.display.BitmapData;

    public class MapTextRenderer 
    {

        public static var DEFAULT_FONT_NAME:String = "sans-serif";

        private var matrix:Matrix;
        private var cache:Dictionary;
        private var textField:MapTextField;
        private var point:Point;
        private var cacheCounter:uint = 0;

        public function MapTextRenderer(_arg_1:int=13, _arg_2:uint=0xFFFFFF, _arg_3:int=0, _arg_4:String=null)
        {
            super();
            this.textField = new MapTextField(((_arg_4) ? _arg_4 : DEFAULT_FONT_NAME), _arg_1, _arg_2, _arg_3);
            this.cache = new Dictionary();
            this.point = new Point();
            this.matrix = new Matrix();
        }

        private function getCachedString(_arg_1:String):BitmapData
        {
            var _local_2:BitmapData = this.cache[_arg_1];
            if (!_local_2)
            {
                this.cacheCounter++;
                if (this.cacheCounter > 5000)
                {
                    this.cache = new Dictionary();
                    this.cacheCounter = 0;
                };
                this.textField.text = _arg_1;
                _local_2 = new BitmapData((this.textField.measuredWidth + 2), (this.textField.measuredHeight + 2), true, 0);
                this.matrix.tx = 1;
                this.matrix.ty = 1;
                _local_2.draw(this.textField, this.matrix);
                this.cache[_arg_1] = _local_2;
            };
            return (_local_2);
        }

        public function render(_arg_1:String, _arg_2:BitmapData, _arg_3:int, _arg_4:int, _arg_5:Boolean=false, _arg_6:int=-1):void
        {
            var _local_7:BitmapData = this.getCachedString(_arg_1);
            this.point.x = _arg_3;
            this.point.y = (_arg_4 + 4);
            if (_arg_5)
            {
                this.point.x = (this.point.x - (_local_7.width / 2));
                this.point.y = (this.point.y - (_local_7.height / 2));
            };
            if (_arg_6 > -1)
            {
                _local_7 = _local_7.clone();
                _local_7.fillRect(_local_7.rect, _arg_6);
            };
            _arg_2.copyPixels(_local_7, _local_7.rect, this.point, null, null, true);
        }


    }
}
