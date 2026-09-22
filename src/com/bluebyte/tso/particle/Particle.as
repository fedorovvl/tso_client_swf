package com.bluebyte.tso.particle
{
    import nLib.cSpriteLib;
    import flash.geom.Point;

    public class Particle 
    {

        public var asset:cSpriteLib;
        public var index:int;
        public var speed:int = 100;
        public var position:Point = new Point();
        public var scale:int = 100;

        public function Particle(_arg_1:cSpriteLib)
        {
            super();
            this.asset = _arg_1;
        }

        public function set(_arg_1:int, _arg_2:int, _arg_3:int, _arg_4:int, _arg_5:int=0):void
        {
            this.position.x = (_arg_1 - this.asset.GetWidth());
            this.position.y = (_arg_2 - this.asset.GetHeight());
            this.speed = _arg_3;
            this.scale = _arg_4;
            this.index = _arg_5;
        }


    }
}
