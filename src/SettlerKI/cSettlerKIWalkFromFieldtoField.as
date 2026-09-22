package SettlerKI
{
    import flash.geom.Point;
    import __AS3__.vec.Vector;
    import GO.cSettler;
    import GO.cBuilding;
    import nLib.cPosInt;
    import Map.AdditionalDataTSO;
    import GO.cBlockingData;
    import nLib.gMisc;
    import __AS3__.vec.*;

    public class cSettlerKIWalkFromFieldtoField extends cSettlerKI 
    {

        private var mGridPos:int;
        private var mPos:Point = new Point();
        private var mWait:Number;
        private var mRandomWalkPositions_vector:Vector.<Point> = null;
        private var mDead:Boolean;
        private var mLastWait:Boolean;

        public function cSettlerKIWalkFromFieldtoField(_arg_1:cSettler)
        {
            super(_arg_1);
            this.mWait = 1;
            this.mDead = false;
            this.mRandomWalkPositions_vector = new Vector.<Point>();
            var _local_2:Number = (global.streetGridXHalf / 3);
            var _local_3:Number = (global.streetGridYHalf / 3);
            var _local_4:Number = (global.streetGridXHalf / 4);
            var _local_5:Number = (global.streetGridYHalf / 4);
            this.mRandomWalkPositions_vector.push(new Point(0, 0));
            this.mRandomWalkPositions_vector.push(new Point(-(_local_2), 0));
            this.mRandomWalkPositions_vector.push(new Point(_local_2, 0));
            this.mRandomWalkPositions_vector.push(new Point(0, -(_local_3)));
            this.mRandomWalkPositions_vector.push(new Point(0, _local_3));
            this.mRandomWalkPositions_vector.push(new Point(_local_4, -(_local_3)));
            this.mRandomWalkPositions_vector.push(new Point(_local_4, _local_3));
            this.mRandomWalkPositions_vector.push(new Point(-(_local_4), -(_local_3)));
            this.mRandomWalkPositions_vector.push(new Point(-(_local_4), _local_3));
            this.mRandomWalkPositions_vector.push(new Point(_local_2, -(_local_5)));
            this.mRandomWalkPositions_vector.push(new Point(_local_2, _local_5));
            this.mRandomWalkPositions_vector.push(new Point(-(_local_2), -(_local_5)));
            this.mRandomWalkPositions_vector.push(new Point(-(_local_2), _local_5));
        }

        override public function BuildingWasPlaced(_arg_1:cBuilding, _arg_2:int):void
        {
            if (_arg_2 == this.mGridPos)
            {
                this.mWait = 0;
                if (!this.SelectRandomNeighbourField(this.mPos.x, this.mPos.y, (SPEED * 2)))
                {
                    DeactivateKI();
                };
                return;
            };
        }

        override public function Init():void
        {
            this.mPos.x = mSettler.GetX();
            this.mPos.y = mSettler.GetY();
            this.mGridPos = gCalculations.ConvertPixelPosToStreetGridPos(mSettler.mGeneralInterface.mCurrentPlayerZone, int(this.mPos.x), int(this.mPos.y));
        }

        private function CreateDestinationPos(_arg_1:Number, _arg_2:Number, _arg_3:Number):void
        {
            var _local_4:Number;
            var _local_5:Number;
            _local_4 = (_arg_1 - this.mPos.x);
            _local_5 = (_arg_2 - this.mPos.y);
            mNewDirection = Math.sqrt(((_local_4 * _local_4) + (_local_5 * _local_5)));
            mDirection.x = (_local_4 / mNewDirection);
            mDirection.y = (_local_5 / mNewDirection);
            mDirection.x = (mDirection.x * _arg_3);
            mDirection.y = (mDirection.y * _arg_3);
        }

        private function SelectRandomNeighbourField(_arg_1:Number, _arg_2:Number, _arg_3:Number):Boolean
        {
            var _local_4:int;
            var _local_5:int;
            var _local_6:int;
            var _local_7:int;
            var _local_8:int;
            var _local_10:cPosInt;
            var _local_11:int;
            var _local_12:int;
            mNewDirection = 0;
            var _local_9:int = -1;
            _local_5 = 0;
            while (_local_5 < 2)
            {
                _local_6 = 0;
                _local_4 = 0;
                while (_local_4 < 8)
                {
                    _local_10 = (gCalculations.m8DirectionTableStreetGrid_vector[_local_4] as cPosInt);
                    _local_7 = (_arg_1 + _local_10.x);
                    _local_8 = (_arg_2 + _local_10.y);
                    _local_11 = gCalculations.ConvertPixelPosToStreetGridPos(mSettler.mGeneralInterface.mCurrentPlayerZone, _local_7, _local_8);
                    if (_local_11 != defines.ILLEGAL_INT_POS)
                    {
                        if (!mSettler.mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.IsBlockedAllowedNothingOrFog(_local_11))
                        {
                            _local_12 = mSettler.mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.mAdditionalData.get(_local_11, AdditionalDataTSO.Blocked);
                            if (_local_12 != cBlockingData.BLOCK_TYPE_ALLOW_MOVE)
                            {
                                if (_local_9 == _local_6)
                                {
                                    this.mGridPos = _local_11;
                                    this.CreateDestinationPos(_local_7, _local_8, _arg_3);
                                    return (true);
                                };
                                _local_6++;
                            };
                        };
                    };
                    _local_4++;
                };
                _local_9 = gMisc.GetRandomMinMaxInt(0, (_local_6 - 1));
                _local_5++;
            };
            return (false);
        }

        override public function Compute():void
        {
            var _local_1:int;
            var _local_5:Point;
            var _local_9:int;
            var _local_10:int;
            var _local_11:int;
            if (this.mDead)
            {
                return;
            };
            if (mSettler.mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.mAdditionalData2.get(this.mGridPos, AdditionalDataTSO.Fog) != 0)
            {
                mVisible = false;
                return;
            };
            mVisible = true;
            var _local_2:Number = 0;
            var _local_3:Number = 0;
            var _local_4:Number = 0;
            var _local_6:Boolean;
            if (this.mWait > 0)
            {
                this.mWait = (this.mWait - mSettler.mGeneralInterface.mCalculateTicks.mDeltaTicksMs);
                if (this.mWait <= 0)
                {
                    this.mWait = 0;
                    _local_6 = true;
                    this.mLastWait = true;
                };
            }
            else
            {
                _local_3 = (mDirection.x * mSettler.mGeneralInterface.mCalculateTicks.mDeltaTicksOne);
                _local_4 = (mDirection.y * mSettler.mGeneralInterface.mCalculateTicks.mDeltaTicksOne);
                _local_2 = Math.sqrt(((_local_3 * _local_3) + (_local_4 * _local_4)));
                mNewDirection = (mNewDirection - _local_2);
                if (mNewDirection <= 0)
                {
                    _local_6 = true;
                    this.mLastWait = false;
                };
            };
            if (((_local_2 > 0) || (mSettler.GetGOContainer().mSubtypeCalculatedNof > 8)))
            {
                if ((((_local_2 == 0) && (mSettler.GetGOContainer().mSubtypeCalculatedNof > 8)) && (mSettler.GetSubType() < 8)))
                {
                    mSettler.SetSubType((mSettler.GetSubType() + 8));
                };
                mSettler.Animate();
            };
            if (_local_6)
            {
                if (this.mLastWait)
                {
                    _local_1 = gMisc.GetRandomMinMaxInt(0, 5);
                    _local_1 = 0;
                    if (_local_1 == 0)
                    {
                        if (!this.SelectRandomNeighbourField(this.mPos.x, this.mPos.y, SPEED))
                        {
                            DeactivateKI();
                        };
                    }
                    else
                    {
                        _local_1 = gMisc.GetRandomMinMaxInt(0, (this.mRandomWalkPositions_vector.length - 1));
                        _local_5 = this.mRandomWalkPositions_vector[_local_1];
                        _local_9 = (this.mPos.x + _local_5.x);
                        _local_10 = (this.mPos.y + _local_5.y);
                        this.CreateDestinationPos(_local_9, _local_10, SPEED);
                        if (mNewDirection < 5)
                        {
                            this.mWait = gMisc.GetRandomMinMax((2 * 1000), (4 * 1000));
                        };
                    };
                }
                else
                {
                    this.mWait = gMisc.GetRandomMinMax((0.5 * 1000), (4 * 1000));
                };
            }
            else
            {
                if (this.mWait == 0)
                {
                    _local_11 = Get8DirectionFromXY(int((mDirection.x * 1000)), int((mDirection.y * 1000)));
                    mSettler.SetSubType(_local_11);
                };
            };
            var _local_7:Number = this.mPos.x;
            var _local_8:Number = this.mPos.y;
            _local_7 = (_local_7 + _local_3);
            _local_8 = (_local_8 + _local_4);
            this.mPos.x = _local_7;
            this.mPos.y = _local_8;
            mSettler.SetPosition(_local_7, (_local_8 - global.streetGridYHalf));
        }


    }
}
