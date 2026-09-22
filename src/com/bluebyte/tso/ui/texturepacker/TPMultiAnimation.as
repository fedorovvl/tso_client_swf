package com.bluebyte.tso.ui.texturepacker
{
    import mx.core.UIComponent;
    import Utils.Disposable;
    import Model.Observer;
    import flash.display.BitmapData;
    import __AS3__.vec.Vector;
    import Model.Notifiers.TickChannel;
    import Model.Notifier;
    import flash.geom.Rectangle;
    import flash.display.Bitmap;
    import __AS3__.vec.*;

    public class TPMultiAnimation extends UIComponent implements Disposable, Observer 
    {

        private var bmp:BitmapData;
        private var controllers:Vector.<TPAnimationController> = new Vector.<TPAnimationController>();

        public function TPMultiAnimation()
        {
            super();
            this.includeInLayout = false;
            this.mouseEnabled = false;
            this.mouseChildren = false;
            this.cacheAsBitmap = false;
        }

        public function stop():void
        {
            global.ui.channels.TICK.removePropertyObserver(TickChannel.RENDER_TICK, this);
        }

        public function update(_arg_1:Notifier, _arg_2:String, _arg_3:Object):void
        {
            var _local_4:TPAnimationController;
            this.bmp.lock();
            this.bmp.fillRect(this.bmp.rect, 0);
            for each (_local_4 in this.controllers)
            {
                if (_local_4.process())
                {
                    _local_4.render(this.bmp);
                };
                _local_4.renderDebug(this.bmp);
            };
            this.bmp.unlock();
        }

        override protected function commitProperties():void
        {
            var _local_4:TPAnimationController;
            super.commitProperties();
            var _local_1:int;
            var _local_2:Boolean;
            var _local_3:Rectangle = new Rectangle();
            for each (_local_4 in this.controllers)
            {
                if (_local_4.isInvalidated())
                {
                    _local_4.commitProperties();
                    if (!_local_4.isReady()) continue;
                    _local_2 = true;
                };
                _local_1++;
                _local_3 = _local_3.union(_local_4.bounds);
            };
            if (_local_1 < this.controllers.length)
            {
                callLater(invalidateProperties);
            }
            else
            {
                if (_local_2)
                {
                    this.bmp = new BitmapData(_local_3.width, _local_3.height, true, 0);
                    measuredWidth = (width = this.bmp.width);
                    measuredHeight = (height = this.bmp.height);
                    if (numChildren > 0)
                    {
                        removeChildAt(0);
                    };
                    addChild(new Bitmap(this.bmp));
                    this.start();
                };
            };
        }

        public function start():void
        {
            global.ui.channels.TICK.addPropertyObserver(TickChannel.RENDER_TICK, this);
        }

        public function addController(_arg_1:TPAnimationController):TPAnimationController
        {
            this.controllers.push(_arg_1);
            invalidateProperties();
            return (_arg_1);
        }

        public function dispose():void
        {
            var _local_1:TPAnimationController;
            this.stop();
            for each (_local_1 in this.controllers)
            {
                _local_1.dispose();
            };
            this.controllers.length = 0;
            if (numChildren > 0)
            {
                removeChildAt(0);
            };
            this.bmp = null;
            invalidateProperties();
        }


    }
}
