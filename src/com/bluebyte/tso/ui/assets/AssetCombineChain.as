package com.bluebyte.tso.ui.assets
{
    import flash.display.Bitmap;
    import flash.geom.Point;

    public final class AssetCombineChain 
    {

        private var name:String;
        private var next:AssetCombineChain;
        private var x:int;
        private var y:int;

        public function AssetCombineChain(_arg_1:String, _arg_2:int=0, _arg_3:int=0)
        {
            super();
            this.name = _arg_1;
            this.x = _arg_2;
            this.y = _arg_3;
        }

        public static function create(_arg_1:String):AssetCombineChain
        {
            return (new AssetCombineChain(_arg_1, 0, 0));
        }


        public function add(_arg_1:String, _arg_2:int=0, _arg_3:int=0):AssetCombineChain
        {
            var _local_4:AssetCombineChain = this;
            while (_local_4.next)
            {
                _local_4 = _local_4.next;
            };
            _local_4.next = new AssetCombineChain(_arg_1, _arg_2, _arg_3);
            return (this);
        }

        public function calculateHashKey():String
        {
            var _local_1:String = this.toString();
            var _local_2:AssetCombineChain = this.next;
            while (_local_2)
            {
                _local_1 = (_local_1 + _local_2.toString());
                _local_2 = _local_2.next;
            };
            return (_local_1);
        }

        internal function renderBitmap():Bitmap
        {
            var _local_1:Bitmap = Assets.getInstance().getBitmap(this.name);
            var _local_2:AssetCombineChain = this.next;
            while (((_local_1) && (_local_2)))
            {
                _local_2.render(_local_1);
                _local_2 = _local_2.next;
            };
            return (_local_1);
        }

        public function toString():String
        {
            return (((((this.name + ",") + this.x) + ",") + this.y) + "|");
        }

        private function render(_arg_1:Bitmap):Bitmap
        {
            var _local_2:Bitmap = Assets.getInstance().getUnclonedBitmap(this.name);
            if (_local_2)
            {
                _arg_1.bitmapData.copyPixels(_local_2.bitmapData, _local_2.bitmapData.rect, new Point(this.x, this.y), null, null, true);
            };
            return (_arg_1);
        }


    }
}
