package GUI.Components
{
    import mx.controls.Image;
    import nLib.cSpriteLib;
    import __AS3__.vec.Vector;
    import flash.geom.Point;
    import flash.display.BitmapData;
    import flash.events.Event;
    import GO.cGOSpriteLibContainer;
    import flash.display.Bitmap;
    import __AS3__.vec.*;

    public class BatchedSpriteLibAnimation extends Image 
    {

        private var _spriteLib:cSpriteLib;
        private var _subTypes:Vector.<int>;
        private var _speed:Number;
        private var _points:Vector.<Point>;
        private var _maxOffset:int;
        private var _animationName:String;
        private var _bitmapData:BitmapData;
        private var _maxFrames:int;
        private var _frameOffsets:Vector.<int>;
        private var _frame:int = -1;
        private var _offsetFrames:int;
        private var _numInstances:int;

        public function BatchedSpriteLibAnimation()
        {
            super();
            this.addEventListener(Event.ADDED_TO_STAGE, this.init);
        }

        public function init(_arg_1:Event=null):void
        {
            this._spriteLib = global.effectGroup.GetSpriteLibFromNameGOList(this._animationName);
            this._speed = (this._spriteLib.GetContainer() as cGOSpriteLibContainer).mEffectDefaultAnimSpeed;
            this._bitmapData = new BitmapData(this.width, this.height, true, 0);
            this.source = new Bitmap(this._bitmapData);
        }

        public function get offsetFrames():int
        {
            return (this._offsetFrames);
        }

        public function set animationName(_arg_1:String):void
        {
            this._animationName = _arg_1;
        }

        private function animate(_arg_1:Event):void
        {
            this._spriteLib.Animate(global.ui.mCalculateTicks.mDeltaTicksOne);
            if (this._frame != int(this._spriteLib.GetAnimFrame()))
            {
                this.render();
            };
        }

        private function render():void
        {
            var _local_2:int;
            this._bitmapData.fillRect(this._bitmapData.rect, 0);
            if (this._frame >= ((this._spriteLib.GetNofFrames(0) + this._maxOffset) - 1))
            {
                this.visible = false;
                return;
            };
            var _local_1:int;
            while (_local_1 < this._points.length)
            {
                _local_2 = (this._frame + this._frameOffsets[_local_1]);
                if (((_local_2 >= 0) && (_local_2 <= (this._spriteLib.GetNofFrames(0) - 1))))
                {
                    this._bitmapData.copyPixels(this._spriteLib.GetBitmapFromSubTypeAndFrame(this._subTypes[_local_1], _local_2), this._bitmapData.rect, this._points[_local_1], null, null, true);
                };
                this._frameOffsets[_local_1]++;
                _local_1++;
            };
            this._frame++;
        }

        public function get numInstances():int
        {
            return (this._numInstances);
        }

        public function set numInstances(_arg_1:int):void
        {
            this._numInstances = _arg_1;
        }

        public function get animationName():String
        {
            return (this._animationName);
        }

        public function set offsetFrames(_arg_1:int):void
        {
            this._offsetFrames = _arg_1;
        }

        override public function set visible(_arg_1:Boolean):void
        {
            var _local_2:int;
            var _local_3:int;
            var _local_4:int;
            var _local_5:int;
            var _local_6:int;
            var _local_7:int;
            if (_arg_1)
            {
                this._points = new Vector.<Point>();
                this._frameOffsets = new Vector.<int>();
                this._subTypes = new Vector.<int>();
                _local_2 = 0;
                while (_local_2 < this._numInstances)
                {
                    _local_3 = int(int((Math.random() * this._spriteLib.GetNofSubTypes())));
                    _local_4 = this._spriteLib.GetMaxWidthForSubType(_local_3);
                    _local_5 = this._spriteLib.GetMaxHeightForSubType(_local_3);
                    _local_6 = int(Math.round((Math.random() * ((this.width - _local_4) / _local_4))));
                    _local_7 = int(Math.round((Math.random() * ((this.height - _local_5) / _local_5))));
                    this._points.push(new Point((_local_6 * _local_4), (_local_7 * _local_5)));
                    this._frameOffsets.push(((_local_2 * this._offsetFrames) * -1));
                    this._subTypes.push(_local_3);
                    _local_2++;
                };
                this._maxOffset = ((this._numInstances * this._offsetFrames) - this._offsetFrames);
                this.addEventListener(Event.ENTER_FRAME, this.animate);
                this._spriteLib.SetAnim(this._speed, true);
                this._frame = 0;
                this.render();
            }
            else
            {
                this.removeEventListener(Event.ENTER_FRAME, this.animate);
            };
            super.visible = _arg_1;
        }


    }
}
