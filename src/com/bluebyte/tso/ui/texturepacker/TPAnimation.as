package com.bluebyte.tso.ui.texturepacker
{
    import mx.core.UIComponent;
    import Utils.Disposable;
    import Model.Observer;
    import flash.display.BitmapData;
    import Model.Notifier;
    import Model.Notifiers.TickChannel;
    import flash.geom.Matrix;
    import flash.display.Bitmap;

    public class TPAnimation extends UIComponent implements Disposable, Observer 
    {

        private var bmp:BitmapData;
        private var controller:TPAnimationController = new TPAnimationController();

        public function TPAnimation()
        {
            super();
            this.controller.finishedCallback = this.finished;
            this.controller.loopFinishedCallback = this.loopFinished;
            this.controller.playStartedCallback = this.playStarted;
            this.includeInLayout = false;
            this.mouseEnabled = false;
            this.mouseChildren = false;
            this.cacheAsBitmap = false;
        }

        public function stop():void
        {
            this.controller.stop();
        }

        public function get autoPlay():Boolean
        {
            return (this.controller.autoPlay);
        }

        public function get loop():Boolean
        {
            return (this.controller.loop);
        }

        public function set autoPlay(_arg_1:Boolean):void
        {
            this.controller.autoPlay = _arg_1;
        }

        public function set loop(_arg_1:Boolean):void
        {
            this.controller.loop = _arg_1;
        }

        public function update(_arg_1:Notifier, _arg_2:String, _arg_3:Object):void
        {
            this.bmp.lock();
            this.bmp.fillRect(this.bmp.rect, 0);
            if (this.controller.process())
            {
                this.controller.render(this.bmp);
            };
            this.bmp.unlock();
        }

        public function get animation():String
        {
            return (this.controller.animation);
        }

        public function get frames():int
        {
            return (this.controller.frames);
        }

        public function set animation(_arg_1:String):void
        {
            this.controller.animation = _arg_1;
        }

        public function isPlaying():Boolean
        {
            return (this.controller.isPlaying());
        }

        protected function finished():void
        {
            global.ui.channels.TICK.removePropertyObserver(TickChannel.RENDER_TICK, this);
            this.bmp.fillRect(this.bmp.rect, 0);
            dispatchEvent(new TPAnimationEvent(TPAnimationEvent.STOPPED));
        }

        public function play():void
        {
            this.controller.play();
        }

        public function set repeat(_arg_1:int):void
        {
            this.controller.repeat = this.repeat;
        }

        override protected function commitProperties():void
        {
            var _local_1:Matrix;
            super.commitProperties();
            if (this.controller.isInvalidated())
            {
                this.controller.commitProperties();
                if ((((this.controller.isReady()) && (!(this.controller.getWidth() == measuredWidth))) && (!(this.controller.getHeight() == measuredHeight))))
                {
                    this.bmp = new BitmapData(this.controller.getWidth(), this.controller.getHeight(), true, 0);
                    measuredWidth = (width = this.bmp.width);
                    measuredHeight = (height = this.bmp.height);
                    _local_1 = new Matrix();
                    _local_1.translate((-(measuredWidth) / 2), (-(measuredHeight) / 2));
                    _local_1.concat(this.transform.matrix);
                    this.transform.matrix = _local_1;
                    if (numChildren > 0)
                    {
                        removeChildAt(0);
                    };
                    addChild(new Bitmap(this.bmp));
                };
            };
        }

        protected function playStarted():void
        {
            global.ui.channels.TICK.addPropertyObserver(TickChannel.RENDER_TICK, this);
            dispatchEvent(new TPAnimationEvent(TPAnimationEvent.STARTED));
        }

        public function get repeat():int
        {
            return (this.controller.repeat);
        }

        protected function loopFinished():void
        {
            dispatchEvent(new TPAnimationEvent(TPAnimationEvent.LOOP_FINISHED));
        }

        public function dispose():void
        {
            this.controller.dispose();
            this.bmp = null;
        }


    }
}
