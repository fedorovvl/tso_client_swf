package com.bluebyte.tso.particle
{
    import mx.containers.Canvas;
    import __AS3__.vec.Vector;
    import GUI.Components.SpriteLibAnimation;
    import flash.display.BitmapData;
    import flash.geom.Point;
    import nLib.cSpriteLib;
    import flash.events.Event;
    import mx.events.ResizeEvent;
    import GO.cGOSpriteLibContainer;
    import flash.utils.getTimer;
    import __AS3__.vec.*;

    public class ParticlePlane extends Canvas 
    {

        private var assets:Vector.<SpriteLibAnimation>;
        private var bmp:BitmapData = null;
        private var numParticles:int = 0;
        private var assetsToUse:Array;
        private var active:Vector.<Particle> = new Vector.<Particle>();
        private var point:Point = new Point();
        private var time:int = 0;
        private var sprites:Vector.<cSpriteLib>;
        private var sinList:Vector.<int> = new Vector.<int>();
        private var assetsLoaded:Boolean;

        public function ParticlePlane()
        {
            super();
            mouseEnabled = false;
            mouseChildren = false;
            focusEnabled = false;
            mouseFocusEnabled = false;
            addEventListener(Event.ENTER_FRAME, this.enterFrameHandler);
            addEventListener(ResizeEvent.RESIZE, this.resizeHandler);
            var _local_1:Number = 1;
            while (_local_1 <= 0x0200)
            {
                this.sinList.push((Math.sin(_local_1) * 100));
                _local_1 = (_local_1 + 0.1);
            };
        }

        public function stop():void
        {
            this.numParticles = 0;
            if (((this.sprites) && (this.active.length == 0)))
            {
                this.onParticleEnd();
            };
        }

        private function onParticleEnd():void
        {
            this.bmp = null;
            this.sprites.length = 0;
            this.assetsLoaded = false;
        }

        protected function randomizeParticle(_arg_1:Particle):void
        {
            _arg_1.set((((Math.random() * this.width) * 1.5) - (this.width / 2)), ((-(Math.random()) * this.height) / 2), ((Math.random() * 50) + 50), int(((Math.random() * 50) + 50)), int((Math.random() * this.sinList.length)));
        }

        public function start(_arg_1:Array):void
        {
            if (this.numParticles == 0)
            {
                this.assetsToUse = _arg_1;
                this.assetsLoaded = this.tryLoadAssets();
                this.bmp = new BitmapData(this.width, this.height, true, 0xFFFFFF);
                this.numParticles = 100;
            };
        }

        private function tryLoadAssets():Boolean
        {
            var _local_1:String;
            var _local_2:String;
            var _local_3:int;
            var _local_4:cSpriteLib;
            var _local_5:Number;
            for each (_local_1 in this.assetsToUse)
            {
                if (!global.effectGroup.IsSpriteInGroup(_local_1))
                {
                    return (false);
                };
            };
            this.sprites = new Vector.<cSpriteLib>();
            for each (_local_2 in this.assetsToUse)
            {
                _local_3 = 0;
                while (_local_3 < 10)
                {
                    _local_4 = global.effectGroup.GetSpriteLibFromNameGOList(_local_2);
                    _local_5 = (_local_4.GetContainer() as cGOSpriteLibContainer).mEffectDefaultAnimSpeed;
                    _local_4.SetAnim(_local_5, true);
                    _local_4.SetRandomSubType();
                    _local_4.SetRandomAnimFrame();
                    this.sprites.push(_local_4);
                    _local_3++;
                };
            };
            return (true);
        }

        protected function updateParticles():void
        {
            var _local_2:cSpriteLib;
            var _local_3:Particle;
            var _local_4:int;
            var _local_5:int;
            var _local_6:int;
            var _local_7:Particle;
            if (!cSettingsManager.getInstance().showBuffAnimations)
            {
                return;
            };
            if (!this.assetsLoaded)
            {
                this.assetsLoaded = this.tryLoadAssets();
                if (!this.assetsLoaded)
                {
                    return;
                };
            };
            var _local_1:int;
            while (_local_1 < Math.min(10, (this.numParticles - this.active.length)))
            {
                _local_3 = new Particle(this.sprites[int((Math.random() * this.sprites.length))]);
                this.randomizeParticle(_local_3);
                this.active.push(_local_3);
                _local_1++;
            };
            for each (_local_2 in this.sprites)
            {
                _local_2.Animate(global.ui.mCalculateTicks.mDeltaTicksOne);
            };
            if (this.time < getTimer())
            {
                this.bmp.lock();
                this.bmp.fillRect(this.bmp.rect, 0xFFFFFF);
                _local_4 = height;
                _local_5 = width;
                _local_6 = 0;
                while (_local_6 < this.active.length)
                {
                    _local_7 = this.active[_local_6];
                    _local_7.index++;
                    if (_local_7.index == this.sinList.length)
                    {
                        _local_7.index = 0;
                    };
                    _local_7.position.x = (_local_7.position.x + (((2 * _local_7.speed) / 100) * global.ui.mCalculateTicks.mDeltaTicksOne));
                    _local_7.position.y = (_local_7.position.y + (((5 * _local_7.speed) / 100) * global.ui.mCalculateTicks.mDeltaTicksOne));
                    if (((_local_7.position.y > _local_4) || (_local_7.position.x > _local_5)))
                    {
                        if (this.active.length > this.numParticles)
                        {
                            this.active.splice(_local_6, 1);
                            _local_7.asset = null;
                        }
                        else
                        {
                            this.randomizeParticle(_local_7);
                        };
                    }
                    else
                    {
                        if (_local_7.asset)
                        {
                            this.point.x = (_local_7.position.x + (this.sinList[_local_7.index] / 10));
                            this.point.y = _local_7.position.y;
                            this.bmp.copyPixels(_local_7.asset.GetBitmap(), _local_7.asset.GetBitmap().rect, this.point, null, null, true);
                        };
                    };
                    _local_6++;
                };
                this.bmp.unlock();
                this.time = (getTimer() + 10);
                if (((this.active.length == 0) && (this.numParticles)))
                {
                    this.onParticleEnd();
                };
            };
        }

        protected function enterFrameHandler(_arg_1:Event):void
        {
            if (((this.bmp) && (visible)))
            {
                this.updateParticles();
                if (this.bmp)
                {
                    this.graphics.clear();
                    if (cSettingsManager.getInstance().showBuffAnimations)
                    {
                        this.graphics.beginBitmapFill(this.bmp, null, false, false);
                        this.graphics.drawRect(0, 0, this.bmp.width, this.bmp.height);
                        this.graphics.endFill();
                    };
                };
            };
        }

        protected function resizeHandler(_arg_1:ResizeEvent):void
        {
            if (this.bmp)
            {
                this.bmp = new BitmapData(this.width, this.height, true, 0xFFFFFF);
            };
        }


    }
}
