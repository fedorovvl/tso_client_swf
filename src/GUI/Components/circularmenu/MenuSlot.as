package GUI.Components.circularmenu
{
    import mx.containers.Canvas;
    import flash.display.BitmapData;
    import mx.core.UIComponent;
    import mx.core.ScrollPolicy;
    import flash.events.MouseEvent;
    import flash.events.Event;
    import flash.display.Graphics;
    import flash.display.Bitmap;

    public class MenuSlot extends Canvas 
    {

        private var renderSourceHovered:BitmapData = null;
        public var alphaNotHovered:Number = 1;
        private var _isMouseOver:Boolean = false;
        private var maskSprite:UIComponent = null;
        private var renderSourceNormal:BitmapData = null;
        private var _imageHovered:Object;
        private var _imageNormal:Object;

        public function MenuSlot()
        {
            super();
            mouseFocusEnabled = false;
            mouseEnabled = true;
            verticalScrollPolicy = (horizontalScrollPolicy = ScrollPolicy.OFF);
            addEventListener(MouseEvent.ROLL_OVER, this.rollOverHandler);
            addEventListener(MouseEvent.ROLL_OUT, this.rollOutHandler);
            clipContent = false;
            this.maskSprite = new UIComponent();
            this.maskSprite.mouseEnabled = false;
            addChild(this.maskSprite);
            this.maskSprite.visible = false;
            hitArea = this.maskSprite;
        }

        public function get imageHovered():Object
        {
            return (this._imageHovered);
        }

        public function set imageNormal(_arg_1:Object):void
        {
            if (this._imageNormal === _arg_1)
            {
                return;
            };
            this._imageNormal = _arg_1;
            this.renderSourceNormal = null;
            invalidateProperties();
        }

        public function set imageHovered(_arg_1:Object):void
        {
            if (this._imageHovered === _arg_1)
            {
                return;
            };
            this._imageHovered = _arg_1;
            this.renderSourceHovered = null;
            invalidateProperties();
        }

        [Bindable(event="rollOverChanged")]
        public function get isMouseOver():Boolean
        {
            return (this._isMouseOver);
        }

        private function rollOverHandler(_arg_1:MouseEvent):void
        {
            this._isMouseOver = true;
            invalidateDisplayList();
            dispatchEvent(new Event("rollOverChanged"));
            alpha = 1;
        }

        private function drawHitArea(_arg_1:Graphics, _arg_2:BitmapData, _arg_3:uint=2):void
        {
            var _local_5:uint;
            _arg_1.beginFill(0, 1);
            var _local_4:uint;
            while (_local_4 < _arg_2.width)
            {
                _local_5 = _arg_3;
                while (_local_5 < _arg_2.height)
                {
                    if (_arg_2.getPixel(_local_4, _local_5))
                    {
                        _arg_1.drawRect(_local_4, _local_5, _arg_3, _arg_3);
                    };
                    _local_5 = (_local_5 + _arg_3);
                };
                _local_4 = (_local_4 + _arg_3);
            };
            _arg_1.endFill();
        }

        override protected function measure():void
        {
            super.measure();
            if (this.renderSourceNormal)
            {
                measuredWidth = this.renderSourceNormal.width;
                measuredHeight = this.renderSourceNormal.height;
            }
            else
            {
                measuredWidth = minWidth;
                measuredHeight = minHeight;
            };
        }

        public function get imageNormal():Object
        {
            return (this._imageNormal);
        }

        override protected function commitProperties():void
        {
            super.commitProperties();
            if (((!(this.renderSourceHovered)) && (this.imageHovered)))
            {
                this.renderSourceHovered = this.getBitmapData(this.imageHovered);
                invalidateDisplayList();
            };
            if (((!(this.renderSourceNormal)) && (this.imageNormal)))
            {
                this.renderSourceNormal = this.getBitmapData(this.imageNormal);
                invalidateDisplayList();
                if (this.renderSourceNormal)
                {
                    this.drawHitArea(this.maskSprite.graphics, this.renderSourceNormal);
                };
                alpha = this.alphaNotHovered;
            };
        }

        private function getBitmapData(_arg_1:Object):BitmapData
        {
            var _local_2:Bitmap;
            if (_arg_1)
            {
                _local_2 = new (_arg_1)();
                if (_local_2)
                {
                    return (_local_2.bitmapData);
                };
            };
            return (null);
        }

        override protected function updateDisplayList(_arg_1:Number, _arg_2:Number):void
        {
            var _local_3:BitmapData = ((this.isMouseOver) ? this.renderSourceHovered : this.renderSourceNormal);
            if (!_local_3)
            {
                super.updateDisplayList(_arg_1, _arg_2);
                return;
            };
            var _local_4:Graphics = graphics;
            _local_4.clear();
            _local_4.beginBitmapFill(_local_3);
            _local_4.drawRect(0, 0, _local_3.width, _local_3.height);
            _local_4.endFill();
            super.updateDisplayList(_arg_1, _arg_2);
        }

        private function rollOutHandler(_arg_1:MouseEvent):void
        {
            this._isMouseOver = false;
            invalidateDisplayList();
            dispatchEvent(new Event("rollOverChanged"));
            alpha = this.alphaNotHovered;
        }


    }
}
