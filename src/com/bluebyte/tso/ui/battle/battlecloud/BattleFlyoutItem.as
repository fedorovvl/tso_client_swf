package com.bluebyte.tso.ui.battle.battlecloud
{
    import mx.containers.HBox;
    import com.bluebyte.tso.util.IPoolable;
    import mx.controls.Image;
    import flash.filters.DropShadowFilter;
    import flash.geom.Point;
    import flash.geom.Matrix;
    import flash.geom.Rectangle;
    import flash.geom.Transform;

    public class BattleFlyoutItem extends HBox implements IPoolable 
    {

        private var img:Image;
        private var dropShowFilter:DropShadowFilter;
        public var initRotation:Number;
        private var dropShadowEnabled:Boolean = false;
        public var t:Number = 0;

        public var origin:Point = new Point();
        public var midPoint:Point = new Point();
        public var target:Point = new Point();

        public function BattleFlyoutItem()
        {
            super();
            includeInLayout = false;
            clipContent = false;
            mouseEnabled = false;
            mouseChildren = false;
            cacheAsBitmap = true;
            this.img = new Image();
            this.img.smoothBitmapContent = true;
            this.img.includeInLayout = false;
            this.img.mouseEnabled = false;
            this.img.mouseChildren = false;
            addChild(this.img);
            this.dropShowFilter = new DropShadowFilter(2, 90, 0, 0.8, 11, 11, 1, 1);
        }

        public function set r(_arg_1:Number):void
        {
            var _local_2:Matrix = this.img.transform.matrix;
            var _local_3:Rectangle = this.img.getBounds(this);
            _local_2.translate(-(_local_3.left + (_local_3.width / 2)), -(_local_3.top + (_local_3.height / 2)));
            _local_2.rotate(((_arg_1 / 180) * Math.PI));
            _local_2.translate((_local_3.left + (_local_3.width / 2)), (_local_3.top + (_local_3.height / 2)));
            this.img.transform.matrix = _local_2;
        }

        public function showShadow():void
        {
            if (this.dropShadowEnabled)
            {
                this.img.filters = [this.dropShowFilter];
            };
        }

        public function reset():void
        {
            this.img.transform = new Transform(this.img);
            this.img.source = null;
            this.img.filters = [];
            x = 0;
            y = 0;
            this.t = 0;
            this.origin = new Point();
            this.midPoint = new Point();
            this.target = new Point();
            this.initRotation = 0;
            alpha = 1;
            this.dropShadowEnabled = false;
        }

        public function init(_arg_1:Object=null):void
        {
            this.img.source = _arg_1["source"];
            x = _arg_1["x"];
            y = _arg_1["y"];
            this.dropShadowEnabled = _arg_1["shadow_enabled"];
            this.dropShowFilter.distance = _arg_1["shadow_distance"];
            this.dropShowFilter.alpha = _arg_1["shadow_alpha"];
            this.dropShowFilter.blurX = _arg_1["shadow_blur"];
            this.dropShowFilter.blurY = _arg_1["shadow_blur"];
            this.dropShowFilter.strength = _arg_1["shadow_strength"];
        }


    }
}
