package com.bluebyte.tso.ui.assets
{
    import flash.display.BitmapData;
    import flash.geom.Point;
    import __AS3__.vec.Vector;
    import flash.geom.Rectangle;
    import mx.core.UIComponent;
    import flash.xml.XMLNode;
    import flash.display.Bitmap;
    import nLib.cXML;
    import __AS3__.vec.*;

    public class TexturePackerAsset 
    {

        private var _animation:String;
        private var _height:int = 1;
        private var _width:int = 1;
        private var _timeScale:Number = 0;
        private var failCounter:int = 0;
        private var sheet:BitmapData = null;
        private var minPos:Point;

        private var frames:Vector.<SpriteVO> = new Vector.<SpriteVO>();
        private var rect:Rectangle = new Rectangle();

        public function TexturePackerAsset(_arg_1:String)
        {
            super();
            this._animation = _arg_1;
            this.load();
        }

        public function getTimeScale():Number
        {
            return (this._timeScale);
        }

        public function getWidth():int
        {
            return (this._width);
        }

        private function tryLater():void
        {
            this.failCounter++;
            if (this.failCounter < 1000)
            {
                (global.getApplication() as UIComponent).callLater(this.load);
            };
        }

        public function isReady():Boolean
        {
            return ((this.frames.length > 0) || (this.failCounter >= 1000));
        }

        public function numFrames():int
        {
            return (this.frames.length);
        }

        public function getAnimation():String
        {
            return (this._animation);
        }

        public function render(_arg_1:BitmapData, _arg_2:int, _arg_3:Point):void
        {
            if ((((!(this.isReady())) || (_arg_2 >= this.frames.length)) || (_arg_2 < 0)))
            {
                return;
            };
            this.rect.x = this.frames[_arg_2].offset.x;
            this.rect.y = this.frames[_arg_2].offset.y;
            this.rect.width = this.frames[_arg_2].rect.width;
            this.rect.height = this.frames[_arg_2].rect.height;
            var _local_4:Point = this.frames[_arg_2].offset.add(_arg_3);
            _arg_1.copyPixels(this.sheet, this.frames[_arg_2].rect, _local_4, null, null, true);
        }

        public function getHeight():int
        {
            return (this._height);
        }

        private function load():void
        {
            var _local_4:XMLNode;
            var _local_5:SpriteVO;
            var _local_6:SpriteVO;
            var _local_1:XMLNode = Assets.getInstance().getXML(this._animation);
            if (!_local_1)
            {
                this.tryLater();
                return;
            };
            var _local_2:Bitmap = Assets.getInstance().getUnclonedBitmap(_local_1.attributes["imagePath"]);
            if (!_local_2)
            {
                this.tryLater();
                return;
            };
            this.frames.length = 0;
            var _local_3:Rectangle = new Rectangle();
            for each (_local_4 in cXML.getChildNodes(_local_1, "sprite"))
            {
                _local_6 = new SpriteVO();
                _local_6.rect = new Rectangle(parseInt(_local_4.attributes["x"]), parseInt(_local_4.attributes["y"]), parseInt(_local_4.attributes["w"]), parseInt(_local_4.attributes["h"]));
                if (_local_6.rect.size.length >= 2)
                {
                    _local_6.offset = new Point(parseInt(_local_4.attributes["oX"]), parseInt(_local_4.attributes["oY"]));
                    if (isNaN(_local_6.offset.x))
                    {
                        _local_6.offset.x = 0;
                    };
                    if (isNaN(_local_6.offset.y))
                    {
                        _local_6.offset.y = 0;
                    };
                    this.frames.push(_local_6);
                    _local_3 = _local_3.union(new Rectangle(_local_6.offset.x, _local_6.offset.y, _local_6.rect.width, _local_6.rect.height));
                };
            };
            this.minPos = _local_3.topLeft;
            for each (_local_5 in this.frames)
            {
                _local_5.offset = _local_5.offset.subtract(this.minPos);
            };
            this._width = _local_3.width;
            this._height = _local_3.height;
            this.sheet = _local_2.bitmapData;
            this._timeScale = parseFloat(_local_1.attributes["timeScale"]);
            if (!this._timeScale)
            {
                this._timeScale = 1;
            };
        }

        public function getFrame(_arg_1:int):SpriteVO
        {
            if ((((!(this.isReady())) || (_arg_1 >= this.frames.length)) || (_arg_1 < 0)))
            {
                return (null);
            };
            return (this.frames[_arg_1]);
        }


    }
}
