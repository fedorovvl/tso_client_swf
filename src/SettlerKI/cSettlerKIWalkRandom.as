package SettlerKI
{
    import GO.cSettler;

    public class cSettlerKIWalkRandom extends cSettlerKI 
    {

        private var mDirectionAngle:Number;

        public function cSettlerKIWalkRandom(_arg_1:cSettler)
        {
            super(_arg_1);
            this.mDirectionAngle = Math.random();
        }

        override public function Compute():void
        {
            var _local_1:Number;
            mSettler.Animate();
            mNewDirection = (mNewDirection - 0.1);
            if (mNewDirection < 0)
            {
                mNewDirection = 10.25;
                _local_1 = Math.random();
                if (_local_1 > 0.666)
                {
                    this.mDirectionAngle = gCalculations.AddAngle(this.mDirectionAngle, (0.125 / 4));
                }
                else
                {
                    if (_local_1 > 0.333)
                    {
                        this.mDirectionAngle = gCalculations.AddAngle(this.mDirectionAngle, (-0.125 / 4));
                    };
                };
                mDirection = gCalculations.TransFormPoint(this.mDirectionAngle, 1);
            };
            super.BounceBackFromBoarder();
            super.SetSubTypeFromDirection();
        }


    }
}
