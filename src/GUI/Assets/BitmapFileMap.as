package GUI.Assets
{
    import flash.utils.Dictionary;
    import flash.display.LoaderInfo;
    import flash.events.Event;
    import flash.display.Bitmap;
    import flash.display.Loader;
    import flash.utils.ByteArray;
    import flash.display.BitmapData;

    public class BitmapFileMap extends BinFileMap 
    {

        private var loaders:Dictionary;
        private var total:int;
        private var loaded:int;
        private var id2bitmap:Dictionary;
        private var completeHandlerCall:Function;

        public function BitmapFileMap(_arg_1:BinDataHolderVO=null)
        {
            super(_arg_1);
            this.loaders = new Dictionary();
            this.id2bitmap = new Dictionary();
            this.total = 0;
        }

        private function checkCompletion():void
        {
            if (this.loaded == this.total)
            {
                this.completeHandlerCall();
                this.completeHandlerCall = null;
            };
        }

        protected function completeHandler(_arg_1:Event):void
        {
            var _local_2:LoaderInfo = (_arg_1.target as LoaderInfo);
            _local_2.removeEventListener(Event.COMPLETE, this.completeHandler);
            var _local_3:Number = this.loaders[_local_2];
            this.id2bitmap[_local_3] = this.cloneBitmap((_local_2.content as Bitmap));
            _local_2.bytes.clear();
            _local_2.loader.unloadAndStop();
            delete id2data[_local_3];
            delete this.loaders[_local_2];
            this.loaded++;
            this.checkCompletion();
        }

        public function getBitmap(_arg_1:String):Bitmap
        {
            if (!(_arg_1 in name2id))
            {
                return (null);
            };
            var _local_2:Number = name2id[_arg_1];
            if (!(_local_2 in this.id2bitmap))
            {
                return (null);
            };
            return (this.id2bitmap[_local_2] as Bitmap);
        }

        public function calculateUniqueBitmapMemory(_seen:Dictionary):Number
        {
            var _local_1:Object;
            var _local_2:Bitmap;
            var _local_3:BitmapData;
            var _local_4:Number = 0;
            for each (_local_1 in this.id2bitmap)
            {
                _local_2 = (_local_1 as Bitmap);
                _local_3 = ((_local_2 != null) ? _local_2.bitmapData : null);
                if (((_local_3 != null) && (!(_seen[_local_3]))))
                {
                    _seen[_local_3] = true;
                    _local_4 = (_local_4 + ((_local_3.width * _local_3.height) * 4));
                };
            };
            return (_local_4);
        }

        private function cloneBitmap(_arg_1:Bitmap):Bitmap
        {
            return (new Bitmap(_arg_1.bitmapData.clone(), _arg_1.pixelSnapping, _arg_1.smoothing));
        }

        public function loadBitmaps(_arg_1:BinDataHolderVO, _arg_2:Function):void
        {
            var _local_3:String;
            var _local_4:Number;
            var _local_5:Loader;
            this.load(_arg_1);
            this.completeHandlerCall = _arg_2;
            for (_local_3 in id2data)
            {
                _local_4 = Number(_local_3);
                _local_5 = new Loader();
                this.loaders[_local_5.contentLoaderInfo] = _local_4;
                _local_5.contentLoaderInfo.addEventListener(Event.COMPLETE, this.completeHandler);
                _local_5.loadBytes((id2data[_local_4] as ByteArray));
                this.total++;
            };
            if (this.total == 0)
            {
                (_arg_2());
            };
        }


    }
}
