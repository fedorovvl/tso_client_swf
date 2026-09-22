package com.bluebyte.tso.util
{
    import flash.geom.Rectangle;
    import flash.geom.Point;
    import flash.xml.XMLNode;
    import __AS3__.vec.Vector;

    public class RandomPointZone 
    {

        protected var rects:Array = new Array();


        public function add(_arg_1:int, _arg_2:int, _arg_3:int, _arg_4:int):RandomPointZone
        {
            this.rects.push(new Rectangle(_arg_1, _arg_2, _arg_3, _arg_4));
            return (this);
        }

        public function get bounds():Rectangle
        {
            var _local_2:Rectangle;
            var _local_1:Rectangle;
            for each (_local_2 in this.rects)
            {
                if (_local_1)
                {
                    _local_1 = _local_1.union(_local_2);
                }
                else
                {
                    _local_1 = _local_2;
                };
            };
            return (_local_1);
        }

        public function getRandomPoint():Point
        {
            var _local_1:Rectangle = (this.rects[Math.min((this.rects.length - 1), int((Math.random() * this.rects.length)))] as Rectangle);
            var _local_2:Point = new Point();
            if (_local_1)
            {
                _local_2.x = ((Math.random() * _local_1.width) + _local_1.x);
                _local_2.y = ((Math.random() * _local_1.height) + _local_1.y);
            };
            return (_local_2);
        }

        public function fromXML(_arg_1:Vector.<XMLNode>):void
        {
            var _local_2:XMLNode;
            for each (_local_2 in _arg_1)
            {
                this.add(_local_2.attributes["x"], _local_2.attributes["y"], _local_2.attributes["width"], _local_2.attributes["height"]);
            };
        }


    }
}
