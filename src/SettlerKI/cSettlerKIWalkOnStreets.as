package SettlerKI
{
    import __AS3__.vec.Vector;
    import nLib.cPosInt;
    import GO.cSettler;
    import mx.core.*;
    import flash.geom.*;
    import GO.*;
    import __AS3__.vec.*;
    import nLib.*;
    import Map.*;

    public class cSettlerKIWalkOnStreets extends cSettlerKI 
    {

        private static var m4DirectionPrefereLastDirectionsFirst_list:Vector.<int> = Vector.<int>([0, 1, 3, 2, 1, 2, 0, 3, 2, 3, 1, 0, 3, 0, 2, 1, 0, 3, 1, 2, 1, 0, 2, 3, 2, 1, 3, 0, 3, 2, 0, 1, 3, 1, 0, 2, 0, 2, 1, 3, 1, 3, 2, 0, 2, 0, 3, 1, 3, 0, 1, 2, 0, 1, 2, 3, 1, 2, 3, 0, 2, 3, 0, 1, 1, 3, 0, 2, 2, 0, 1, 3, 3, 1, 2, 0, 0, 2, 3, 1, 1, 0, 3, 2, 2, 1, 0, 3, 3, 2, 1, 0, 0, 3, 2, 1]);

        private var mTempIntPoint:cPosInt = new cPosInt();
        private var mLastDirection:int;

        public function cSettlerKIWalkOnStreets(_arg_1:cSettler)
        {
            super(_arg_1);
            this.mLastDirection = 0;
        }

        override public function Compute():void
        {
        }


    }
}
