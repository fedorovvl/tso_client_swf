package com.bluebyte.tso.ui.assets.renderer
{
    import com.bluebyte.tso.ui.assets.CustomBitmapRenderer;
    import flash.display.Bitmap;
    import mx.containers.Canvas;
    import com.bluebyte.tso.ui.assets.Assets;
    import flash.geom.Matrix;
    import flash.display.Graphics;
    import flash.display.GradientType;
    import flash.display.BitmapData;
    import flash.geom.Point;

    public class CampHealthbarRenderer implements CustomBitmapRenderer 
    {

        public static var NAME:String = "campHealthBar";

        private const empty_color:uint = 14692123;
        private const full_color:uint = 9959170;

        private var source:Bitmap;
        private var drawCanvas:Canvas = new Canvas();

        public function CampHealthbarRenderer(_arg_1:Assets)
        {
            super();
            this.source = _arg_1.getBitmap("CampHealthBar");
        }

        public function render(_arg_1:Object):BitmapData
        {
            var _local_2:int = int(_arg_1);
            var _local_3:uint = uint(this.interpolateColor(this.full_color, this.empty_color, (_local_2 / 100)));
            var _local_4:Matrix = new Matrix();
            _local_4.createGradientBox(this.source.width, this.source.height, (Math.PI / 2), 0, 1);
            var _local_5:Graphics = this.drawCanvas.graphics;
            _local_5.clear();
            _local_5.beginGradientFill(GradientType.LINEAR, [_local_3, _local_3], [1, 0], [64, 0xFF], _local_4);
            _local_5.drawRect(6, 5, Math.min(99, _local_2), 19);
            _local_5.endFill();
            var _local_6:BitmapData = new BitmapData(this.source.width, this.source.height, true, 0);
            _local_6.copyPixels(this.source.bitmapData, this.source.bitmapData.rect, new Point());
            _local_6.draw(this.drawCanvas);
            return (_local_6);
        }

        private function interpolateColor(_arg_1:uint, _arg_2:uint, _arg_3:Number):uint
        {
            var _local_4:Number = (1 - _arg_3);
            var _local_5:uint = ((_arg_2 >> 16) & 0xFF);
            var _local_6:uint = ((_arg_2 >> 8) & 0xFF);
            var _local_7:uint = (_arg_2 & 0xFF);
            var _local_8:uint = ((_arg_1 >> 16) & 0xFF);
            var _local_9:uint = ((_arg_1 >> 8) & 0xFF);
            var _local_10:uint = (_arg_1 & 0xFF);
            var _local_11:uint = ((_local_5 * _local_4) + (_local_8 * _arg_3));
            var _local_12:uint = ((_local_6 * _local_4) + (_local_9 * _arg_3));
            var _local_13:uint = ((_local_7 * _local_4) + (_local_10 * _arg_3));
            return (((_local_11 << 16) | (_local_12 << 8)) | _local_13);
        }


    }
}
