package org.bytearray.display
{
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.geom.Matrix;
    import flash.geom.Rectangle;

    public class ScaleBitmap extends Bitmap
    {
        protected var _scale9Grid:Rectangle = null;
        protected var _originalBitmap:BitmapData;

        public function ScaleBitmap(bitmapData:BitmapData = null, pixelSnapping:String = "auto", smoothing:Boolean = false)
        {
            super(bitmapData, pixelSnapping, smoothing);
            this._originalBitmap = bitmapData.clone();
        }

        public function getOriginalBitmapData():BitmapData
        {
            return this._originalBitmap;
        }

        private function validGrid(grid:Rectangle):Boolean
        {
            return grid.right <= this._originalBitmap.width && grid.bottom <= this._originalBitmap.height;
        }

        public function setSize(w:Number, h:Number):void
        {
            if (this._scale9Grid == null)
            {
                super.width = w;
                super.height = h;
            }
            else
            {
                w = Math.max(w, this._originalBitmap.width - this._scale9Grid.width);
                h = Math.max(h, this._originalBitmap.height - this._scale9Grid.height);
                this.resizeBitmap(w, h);
            }
        }

        private function assignBitmapData(newBitmap:BitmapData):void
        {
            super.bitmapData.dispose();
            super.bitmapData = newBitmap;
        }

        override public function set scale9Grid(grid:Rectangle):void
        {
            var currentWidth:Number = NaN;
            var currentHeight:Number = NaN;
            if (this._scale9Grid == null && grid != null || this._scale9Grid != null && !this._scale9Grid.equals(grid))
            {
                if (grid == null)
                {
                    currentWidth = width;
                    currentHeight = height;
                    this._scale9Grid = null;
                    this.assignBitmapData(this._originalBitmap.clone());
                    this.setSize(currentWidth, currentHeight);
                }
                else
                {
                    if (!this.validGrid(grid))
                    {
                        throw new Error("#001 - The _scale9Grid does not match the original BitmapData");
                    }
                    this._scale9Grid = grid.clone();
                    this.resizeBitmap(width, height);
                    scaleX = 1;
                    scaleY = 1;
                }
            }
        }

        override public function set width(w:Number):void
        {
            if (w != width)
            {
                this.setSize(w, height);
            }
        }

        override public function set height(h:Number):void
        {
            if (h != height)
            {
                this.setSize(width, h);
            }
        }

        override public function set bitmapData(data:BitmapData):void
        {
            this._originalBitmap = data.clone();
            if (this._scale9Grid != null)
            {
                if (!this.validGrid(this._scale9Grid))
                {
                    this._scale9Grid = null;
                }
                this.setSize(data.width, data.height);
            }
            else
            {
                this.assignBitmapData(this._originalBitmap.clone());
            }
        }

        override public function get scale9Grid():Rectangle
        {
            return this._scale9Grid;
        }

        protected function resizeBitmap(w:Number, h:Number):void
        {
            var srcRect:Rectangle = null;
            var destRect:Rectangle = null;
            var row:int = 0;
            var resized:BitmapData = new BitmapData(w, h, true, 0);
            var srcRows:Array = [0, this._scale9Grid.top, this._scale9Grid.bottom, this._originalBitmap.height];
            var srcCols:Array = [0, this._scale9Grid.left, this._scale9Grid.right, this._originalBitmap.width];
            var destRows:Array = [0, this._scale9Grid.top, h - (this._originalBitmap.height - this._scale9Grid.bottom), h];
            var destCols:Array = [0, this._scale9Grid.left, w - (this._originalBitmap.width - this._scale9Grid.right), w];
            var matrix:Matrix = new Matrix();
            var col:int = 0;
            while (col < 3)
            {
                row = 0;
                while (row < 3)
                {
                    srcRect = new Rectangle(srcCols[col], srcRows[row], srcCols[col + 1] - srcCols[col], srcRows[row + 1] - srcRows[row]);
                    destRect = new Rectangle(destCols[col], destRows[row], destCols[col + 1] - destCols[col], destRows[row + 1] - destRows[row]);
                    matrix.identity();
                    matrix.a = destRect.width / srcRect.width;
                    matrix.d = destRect.height / srcRect.height;
                    matrix.tx = destRect.x - srcRect.x * matrix.a;
                    matrix.ty = destRect.y - srcRect.y * matrix.d;
                    resized.draw(this._originalBitmap, matrix, null, null, destRect, smoothing);
                    row++;
                }
                col++;
            }
            this.assignBitmapData(resized);
        }
    }
}
