package GUI.Components
{
    import mx.controls.Image;
    import nLib.cSpriteLib;
    import flash.geom.Point;
    import flash.display.BitmapData;
    import flash.events.Event;
    import GO.cGOSpriteLibContainer;
    import flash.display.Bitmap;

    public class SpriteLibAnimation extends Image 
    {

        private var _spriteLib:cSpriteLib;
        private var _loop:Boolean = false;
        private var _speed:Number;
        private var _frame:int = -1;
        private var _point:Point = new Point(0, 0);
        private var _animationName:String;
        private var _bitmapData:BitmapData;

        public function SpriteLibAnimation()
        {
            super();
            this.addEventListener(Event.ADDED_TO_STAGE, this.init);
        }

        public function get loop():Boolean
        {
            return (this._loop);
        }

        public function getBitmap():BitmapData
        {
            return (this._bitmapData);
        }

        private function render():void
        {
            this._frame = this._spriteLib.GetAnimFrame();
            if (this._frame >= (this._spriteLib.GetNofFrames(0) - 1))
            {
                if (!this._loop)
                {
                    this.visible = false;
                };
            };
            this._bitmapData.fillRect(this._bitmapData.rect, 0);
            var _local_1:BitmapData = this._spriteLib.GetBitmapFromSubTypeAndFrame(0, this._frame);
            if (_local_1 != null)
            {
                this._bitmapData.copyPixels(_local_1, this._bitmapData.rect, this._point, null, null, false);
            };
        }

        override public function set visible(_arg_1:Boolean):void
        {
            if (_arg_1)
            {
                this.addEventListener(Event.ENTER_FRAME, this.animate);
                this._spriteLib.SetAnim(this._speed, this._loop);
                this._frame = 0;
                this.render();
            }
            else
            {
                this.removeEventListener(Event.ENTER_FRAME, this.animate);
            };
            super.visible = _arg_1;
        }

        public function set loop(_arg_1:Boolean):void
        {
            this._loop = _arg_1;
        }

        public function init(_arg_1:Event=null):void
        {
            this._spriteLib = global.effectGroup.GetSpriteLibFromNameGOList(this._animationName);
            this._speed = (this._spriteLib.GetContainer() as cGOSpriteLibContainer).mEffectDefaultAnimSpeed;
            this._bitmapData = new BitmapData(Math.max(1, this.width), Math.max(1, this.height), true, 0);
            this.source = new Bitmap(this._bitmapData);
        }

        public function get animationName():String
        {
            return (this._animationName);
        }

        private function animate(_arg_1:Event):void
        {
            this._spriteLib.Animate(global.ui.mCalculateTicks.mDeltaTicksOne);
            if (this._frame != int(this._spriteLib.GetAnimFrame()))
            {
                this.render();
            };
        }

        public function set animationName(_arg_1:String):void
        {
            this._animationName = _arg_1;
        }


    }
}
