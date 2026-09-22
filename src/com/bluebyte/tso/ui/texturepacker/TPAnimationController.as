package com.bluebyte.tso.ui.texturepacker
{
    import Utils.Disposable;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    import com.bluebyte.tso.ui.assets.TexturePackerAsset;
    import flash.display.BitmapData;
    import com.bluebyte.tso.ui.assets.Assets;
    import com.bluebyte.tso.ui.assets.SpriteVO;

    public class TPAnimationController implements Disposable 
    {

        private var _loop:Boolean = false;
        private var _animation:String;
        private var invalidated:Boolean = false;
        private var _pendingAnimation:String = null;
        public var offset:Point = new Point();
        public var playStartedCallback:Function = null;
        public var loopFinishedCallback:Function = null;
        private var _isPlaying:Boolean = false;
        public var bounds:Rectangle = new Rectangle();
        private var _repeat:int = 1;
        private var time:Number;
        public var finishedCallback:Function = null;
        private var _autoPlay:Boolean = false;
        private var i:int;
        private var asset:TexturePackerAsset;
        private var loopsLeft:int = 1;


        public function stop():void
        {
            this.i = (this.time = 0);
            if (this.isPlaying())
            {
                if (this.finishedCallback != null)
                {
                    this.finishedCallback();
                };
            };
            this._isPlaying = false;
        }

        public function get animation():String
        {
            return ((this._pendingAnimation) ? this._pendingAnimation : this._animation);
        }

        public function set animation(_arg_1:String):void
        {
            this._pendingAnimation = _arg_1;
            this.invalidated = true;
        }

        public function set autoPlay(_arg_1:Boolean):void
        {
            this._autoPlay = _arg_1;
            this.invalidated = true;
        }

        public function getWidth():int
        {
            return ((this.isReady()) ? this.bounds.width : 0);
        }

        public function render(_arg_1:BitmapData):void
        {
            if (((this.asset) && (this.asset.isReady())))
            {
                this.asset.render(_arg_1, this.i, this.offset);
            };
        }

        public function get repeat():int
        {
            return (this._repeat);
        }

        public function getHeight():int
        {
            return ((this.isReady()) ? this.bounds.height : 0);
        }

        public function dispose():void
        {
            this.stop();
            this.playStartedCallback = null;
            this.loopFinishedCallback = null;
            this.finishedCallback = null;
            this.asset = null;
        }

        public function isReady():Boolean
        {
            return ((!(this.isInvalidated())) && (this.asset.isReady()));
        }

        public function get loop():Boolean
        {
            return (this._repeat <= 0);
        }

        public function get frames():int
        {
            if (((this.asset) && (this.asset.isReady())))
            {
                return (this.asset.numFrames());
            };
            return (0);
        }

        public function get autoPlay():Boolean
        {
            return (this._autoPlay);
        }

        public function play():void
        {
            if (this._isPlaying)
            {
                return;
            };
            this.i = (this.time = 0);
            this.loopsLeft = this.repeat;
            if ((((!(this.asset == null)) && (this.asset.isReady())) && (this.asset.numFrames() > 0)))
            {
                this._isPlaying = true;
                if (this.playStartedCallback != null)
                {
                    this.playStartedCallback();
                };
            };
        }

        public function set repeat(_arg_1:int):void
        {
            this._repeat = _arg_1;
            this.invalidated = true;
        }

        public function isPlaying():Boolean
        {
            return (this._isPlaying);
        }

        public function set loop(_arg_1:Boolean):void
        {
            this._repeat = ((_arg_1) ? 0 : 1);
            this.invalidated = true;
        }

        public function commitProperties():void
        {
            if (!this.invalidated)
            {
                return;
            };
            this.invalidated = false;
            if (this._pendingAnimation)
            {
                this.asset = Assets.getInstance().getAnimation(this._pendingAnimation);
                if (this.asset.isReady())
                {
                    this.stop();
                    this._animation = this._pendingAnimation;
                    this._pendingAnimation = null;
                    this.measure();
                }
                else
                {
                    this.invalidated = true;
                };
            };
            if (((!(this._isPlaying)) && (this._autoPlay)))
            {
                this.play();
            };
        }

        public function renderDebug(_arg_1:BitmapData):void
        {
        }

        protected function measure():void
        {
            this.bounds.width = this.asset.getWidth();
            this.bounds.height = this.asset.getHeight();
        }

        public function process():Boolean
        {
            if (!this.isPlaying())
            {
                return (false);
            };
            this.time = (this.time + this.asset.getTimeScale());
            if (this.i == int(this.time))
            {
                return (false);
            };
            this.i = int(this.time);
            if (this.i >= this.asset.numFrames())
            {
                this.i = (this.time = 0);
                if (!this.loop)
                {
                    this.loopsLeft--;
                    if (this.loopsLeft > 0)
                    {
                        this.i = (this.time = 0);
                    }
                    else
                    {
                        this.stop();
                        return (false);
                    };
                }
                else
                {
                    if (this.loopFinishedCallback != null)
                    {
                        this.loopFinishedCallback();
                    };
                };
            };
            return (true);
        }

        public function getCurrentFrame():SpriteVO
        {
            return (this.asset.getFrame(this.i));
        }

        public function isInvalidated():Boolean
        {
            return (this.invalidated);
        }


    }
}
