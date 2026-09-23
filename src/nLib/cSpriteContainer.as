package nLib
{
    import flash.display.DisplayObject;
    import flash.display.BitmapData;
    import flash.display.Loader;
    import flash.net.URLRequest;
    import flash.net.registerClassAlias;
    import GUI.Assets.BinDataHolderVO;
    import GUI.Assets.NamedDataBinVO;
    import GUI.Assets.NameToNamedDataVO;
    import flash.events.Event;
    import GUI.Assets.gAssetManager;
    import flash.display.LoaderInfo;
    import flash.display.Bitmap;

    public class cSpriteContainer 
    {

        private var mPNGLoadedCallback:Function;
        public var mCurrentScaleFactor:Number = -1;
        public var mOriginalGraphicsImage:DisplayObject;
        public var mScaledGraphics:BitmapData;
        public var mFilename_string:String = null;
        public var mLoadingFinished:Boolean;
        public var mExternalData:Object;
        private var mImageLoader:Loader;
        private var mRequest:URLRequest;
        public var mOriginalGraphicsImageBitmapData:BitmapData;
        public var mOriginalScaleFactor:Number = 1000;
        private var mRequestFailCounter:int = 0;

        public function cSpriteContainer(_arg_1:String=null, _arg_2:Function=null, _arg_3:int=1000):void
        {
            super();
            registerClassAlias(BinDataHolderVO.JAVA_NAME, BinDataHolderVO);
            registerClassAlias(NamedDataBinVO.JAVA_NAME, NamedDataBinVO);
            registerClassAlias(NameToNamedDataVO.JAVA_NAME, NameToNamedDataVO);
            if (_arg_1 == null)
            {
                return;
            };
            if (_arg_2 == null)
            {
                _arg_2 = this.dummyFinished;
            };
            this.mOriginalScaleFactor = _arg_3;
            this.LoadGfx(_arg_1, _arg_2);
        }

        protected function binaryLoadCompleteHandler(_arg_1:Event):void
        {
            var _local_2:TSOURLLoader = (_arg_1.target as TSOURLLoader);
            _local_2.removeEventListener(Event.COMPLETE, this.binaryLoadCompleteHandler);
            this.mImageLoader.loadBytes(_local_2.data);
            _local_2.dispose();
            _local_2 = null;
        }

        public function LoadGfx(_arg_1:String, _arg_2:Function):void
        {
            gAssetManager.CheckGraphicsFileNameExtension(_arg_1);
            this.mLoadingFinished = false;
            this.mFilename_string = _arg_1;
            this.mImageLoader = new Loader();
            this.mImageLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, this.CompleteHandlerLoadPNG);
            this.mPNGLoadedCallback = _arg_2;
            var _local_3:TSOURLLoader = new TSOURLLoader();
            _local_3.addEventListener(Event.COMPLETE, this.binaryLoadCompleteHandler, false, 0, true);
            _local_3.loadFile(_arg_1);
        }

        public function dispose():void
        {
            this.mExternalData = null;
            this.mOriginalGraphicsImage = null;
            this.mOriginalGraphicsImageBitmapData = null;
            this.mScaledGraphics = null;
            this.mPNGLoadedCallback = null;
            this.mImageLoader = null;
            this.mRequest = null;
        }

        private function CompleteHandlerLoadPNG(_arg_1:Event):void
        {
            var _local_2:LoaderInfo = this.mImageLoader.contentLoaderInfo;
            global.getApplication().mMemoryMonitor.RegisterLoadedGraphic(_local_2.bytesTotal);
            this.mOriginalGraphicsImage = this.mImageLoader.content;
            this.mOriginalGraphicsImageBitmapData = Bitmap(this.mImageLoader.content).bitmapData;
            this.mImageLoader = null;
            this.mLoadingFinished = true;
            this.mPNGLoadedCallback();
        }

        private function dummyFinished(_arg_1:Event):void
        {
        }


    }
}
