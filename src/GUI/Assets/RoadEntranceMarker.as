package GUI.Assets
{
    import flash.display.BitmapData;
    import flash.display.Shape;
    import flash.geom.Matrix;
    import flash.geom.Point;
    import nLib.cBackbuffer;

    public class RoadEntranceMarker
    {
        private static var connectedArrow:BitmapData;
        private static var disconnectedArrow:BitmapData;
        private static var cachedScale:Number = -1;
        private static var position:Point = new Point();

        public static function Render(x:int, y:int, connected:Boolean, scale:Number):void
        {
            if (connectedArrow == null || cachedScale != scale)
            {
                if (connectedArrow != null)
                {
                    connectedArrow.dispose();
                    disconnectedArrow.dispose();
                }
                connectedArrow = CreateArrow(0x63D77A, scale);
                disconnectedArrow = CreateArrow(0xFFAE42, scale);
                cachedScale = scale;
            }
            var arrow:BitmapData = connected ? connectedArrow : disconnectedArrow;
            position.x = Math.round(x - arrow.width / 2);
            position.y = y - arrow.height + 1;
            cBackbuffer.mBackBuffer.copyPixels(arrow, arrow.rect, position, null, null, true);
        }

        private static function CreateArrow(color:uint, scale:Number):BitmapData
        {
            var shape:Shape = new Shape();
            shape.graphics.lineStyle(1, 0x202A30, 1, true);
            shape.graphics.beginFill(color);
            shape.graphics.moveTo(5, 1);
            shape.graphics.lineTo(11, 1);
            shape.graphics.lineTo(11, 10);
            shape.graphics.lineTo(15, 10);
            shape.graphics.lineTo(8, 19);
            shape.graphics.lineTo(1, 10);
            shape.graphics.lineTo(5, 10);
            shape.graphics.lineTo(5, 1);
            shape.graphics.endFill();
            var width:int = Math.max(1, Math.round(16 * scale));
            var height:int = Math.max(1, Math.round(20 * scale));
            var matrix:Matrix = new Matrix();
            matrix.scale(width / 16, height / 20);
            var bitmap:BitmapData = new BitmapData(width, height, true, 0);
            bitmap.draw(shape, matrix, null, null, null, true);
            return (bitmap);
        }
    }
}
