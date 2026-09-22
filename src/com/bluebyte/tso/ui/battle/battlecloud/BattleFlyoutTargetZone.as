package com.bluebyte.tso.ui.battle.battlecloud
{
    import com.bluebyte.tso.util.RandomPointZone;
    import flash.geom.Rectangle;
    import flash.display.Graphics;

    public class BattleFlyoutTargetZone extends RandomPointZone 
    {

        public var debugRender:Boolean;

        public function BattleFlyoutTargetZone(_arg_1:Boolean=false)
        {
            super();
            this.debugRender = _arg_1;
        }

        public function render(_arg_1:Graphics, _arg_2:uint=0xFF0000):void
        {
            var _local_3:Rectangle;
            if (this.debugRender)
            {
                _arg_1.lineStyle(1, _arg_2);
                for each (_local_3 in rects)
                {
                    _arg_1.drawRect(_local_3.x, _local_3.y, _local_3.width, _local_3.height);
                };
            };
        }


    }
}
