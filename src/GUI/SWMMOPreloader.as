package GUI
{
    import flash.display.Sprite;
    import mx.preloaders.IPreloaderDisplay;
    import flash.events.ProgressEvent;
    import mx.events.FlexEvent;
    import flash.display.Bitmap;
    import flash.events.Event;
	import mx.modules.ModuleBase;

    public class SWMMOPreloader extends Sprite implements IPreloaderDisplay 
    {

		private static var mx_modules_ModuleBase_ref:ModuleBase;

        public static const BACKGROUND_COLOR:uint = 16643050;
        public static const BAR_Y_OFFSET:int = 140;

        [Embed(source="../../assets/SWMMOPreloader/Logo.jpg")]
        public static var Logo:Class;

        [Embed(source="../../assets/SWMMOPreloader/Bar.jpg")]
        public static var Bar:Class;

        private var _stageHeight:int;
        private var _stageWidth:int;
        private var _logo:Sprite;
        private var _progress:Sprite;
        private var _background:Sprite;
        private var _bar:Sprite;
        private var _preloader:Sprite;

        public function SWMMOPreloader()
        {
            super();
            this._background = new Sprite();
            addChild(this._background);
            this._logo = this._fillBitmap(new Logo(), this._logo);
            this._bar = this._fillBitmap(new Bar(), this._bar);
            this._progress = new Sprite();
            this._bar.addChild(this._progress);
        }

        public function get stageWidth():Number
        {
            return (this._stageWidth);
        }

        private function _center(_arg_1:Sprite, _arg_2:int=0):void
        {
            _arg_1.x = int(((this._stageWidth / 2) - (_arg_1.width / 2)));
            _arg_1.y = (int(((this._stageHeight / 2) - (_arg_1.height / 2))) + _arg_2);
        }

        public function get stageHeight():Number
        {
            return (this._stageHeight);
        }

        private function _applyLayout():void
        {
            this._background.graphics.beginFill(BACKGROUND_COLOR);
            this._background.graphics.drawRect(0, 0, this._stageWidth, this._stageHeight);
            this._background.graphics.endFill();
            this._center(this._logo);
            this._center(this._bar, BAR_Y_OFFSET);
        }

        protected function _onProgress(_arg_1:ProgressEvent):void
        {
            this._fillProgress(((_arg_1.bytesLoaded * 100) / _arg_1.bytesTotal));
        }

        public function get backgroundSize():String
        {
            return (null);
        }

        public function get backgroundAlpha():Number
        {
            return (0);
        }

        public function set stageHeight(_arg_1:Number):void
        {
            this._stageHeight = _arg_1;
            this._applyLayout();
        }

        public function get backgroundColor():uint
        {
            return (0);
        }

        public function set backgroundSize(_arg_1:String):void
        {
        }

        public function set stageWidth(_arg_1:Number):void
        {
            this._stageWidth = _arg_1;
            this._applyLayout();
        }

        public function set backgroundAlpha(_arg_1:Number):void
        {
        }

        public function set backgroundImage(_arg_1:Object):void
        {
        }

        public function get backgroundImage():Object
        {
            return (null);
        }

        public function set backgroundColor(_arg_1:uint):void
        {
        }

        public function set preloader(_arg_1:Sprite):void
        {
            this._preloader = _arg_1;
            this._preloader.addEventListener(ProgressEvent.PROGRESS, this._onProgress, false, 0, true);
            this._preloader.addEventListener(FlexEvent.INIT_COMPLETE, this._onInitComplete, false, 0, true);
        }

        private function _fillProgress(_arg_1:int):void
        {
            var _local_2:int = int(Math.max((((_arg_1 * this._bar.width) / 100) - 12), 0));
            this._progress.graphics.clear();
            this._progress.graphics.beginFill(597293);
            this._progress.graphics.drawRect((4 + _local_2), 3, ((this._bar.width - _local_2) - 12), (this._bar.height - 12));
            this._progress.graphics.endFill();
        }

        private function _fillBitmap(_arg_1:Bitmap, _arg_2:Sprite):Sprite
        {
            _arg_2 = new Sprite();
            _arg_2.graphics.beginBitmapFill(_arg_1.bitmapData);
            _arg_2.graphics.drawRect(0, 0, _arg_1.width, _arg_1.height);
            _arg_2.graphics.endFill();
            addChild(_arg_2);
            return (_arg_2);
        }

        protected function _onInitComplete(_arg_1:Event):void
        {
            dispatchEvent(new Event(Event.COMPLETE));
        }

        public function initialize():void
        {
        }


    }
}
