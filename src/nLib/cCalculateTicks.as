package nLib
{
    public class cCalculateTicks 
    {

        private const SCALE_GAME_FRAMERATE:Number = 16;

        public var mDeltaTicksMs:Number;
        private var mLastTicks:Number;
        public var mDeltaTicksOne:Number;


        public function InitFpsCounter():void
        {
            this.mLastTicks = -1;
        }

        public function CalculateDeltaTicks():void
        {
            var _local_2:Number;
            var _local_1:Number = gMisc.GetTimeSinceStartup();
            if (this.mLastTicks != -1)
            {
                _local_2 = (_local_1 - this.mLastTicks);
            }
            else
            {
                _local_2 = 0;
            };
            this.mLastTicks = _local_1;
            _local_2 = Math.min(_local_2, 100);
            this.mDeltaTicksMs = _local_2;
            this.mDeltaTicksOne = ((_local_2 / 1000) * this.SCALE_GAME_FRAMERATE);
        }

        public function GetLastTick():Number
        {
            return (this.mLastTicks);
        }


    }
}
