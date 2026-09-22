package SettlerKI
{
    import GO.cSettler;
    import flash.geom.Point;
    import GO.cBuilding;
    import mx.core.*;
    import flash.geom.*;
    import GO.*;
    import nLib.*;
    import Map.*;

    public class cSettlerKI 
    {

        public static const SETTLER_STATE_NONE:int = 0;
        public static const SETTLER_STATE_HAS_NO_WORK:int = 1;
        public static const SETTLER_STATE_REMOVE_SETTLER:int = 2;
        public static const SETTLER_STATE_WALKING_ON_RESOURCE_PATH:int = 3;
        public static const SETTLER_STATE_WALKING_ON_DEPOSIT_PATH:int = 4;
        public static const SETTLER_STATE_WAIT_FOR_STORE_HOUSE:int = 5;
        public static const SETTLER_STATE_WALKING_ON_PATH:int = 6;
        public static const SETTLER_STATE_ATTACKING:int = 7;
        public static const SETTLER_STATE_IS_WORKING_IN_RESOURCE_CREATION_HOUSE:int = 9;
        public static const SETTLER_STATE_IS_WORKING_IN_EXTERNAL_WORKYARD:int = 10;
        public static const SETTLER_STATE_IS_QUEUED:int = 11;
        public static const SETTLER_STATE_WAITS_FOR_POPULATION:int = 12;
        public static const SETTLER_STATE_WAITS_BECAUSE_WAREHOUSE_IS_FULL:int = 13;
        public static const SETTLER_STATE_WAITS_BECAUSE_BUILDING_IS_MOVING:int = 14;
        protected static const SPEED:Number = 2;

        public var mVisible:Boolean = false;
        protected var mNewDirection:Number = 0;
        public var mAnimate:Boolean = true;
        protected var mSettler:cSettler;
        protected var mState:int = 0;
        protected var mStateBeforeMoving:int = 0;

        protected var mDirection:Point = new Point(0, 0);
        protected var mP:Point = new Point();
        protected var mSettlerPos:Point = new Point(0, 0);

        public function cSettlerKI(_arg_1:cSettler)
        {
            super();
            this.mSettler = _arg_1;
            this.mState = SETTLER_STATE_NONE;
            this.mStateBeforeMoving = SETTLER_STATE_NONE;
            this.mVisible = true;
            this.mAnimate = true;
            this.mNewDirection = 0;
            this.mSettler.SetSubType(0);
        }

        public function Get4DirectionFromXY(_arg_1:int, _arg_2:int):int
        {
            if (_arg_1 >= 0)
            {
                if (_arg_2 >= 0)
                {
                    return (defines.DIR8_SOUTH_EAST);
                };
                return (defines.DIR8_NORTH_EAST);
            };
            if (_arg_2 >= 0)
            {
                return (defines.DIR8_SOUTH_WEST);
            };
            return (defines.DIR8_NORTH_WEST);
        }

        public function SetKIState(_arg_1:int):void
        {
            this.mState = _arg_1;
        }

        public function Compute():void
        {
        }

        public function BuildingWasPlaced(_arg_1:cBuilding, _arg_2:int):void
        {
        }

        public function GetKIState():int
        {
            return (this.mState);
        }

        protected function BounceBackFromBoarder():void
        {
            var _local_1:Number = 0;
            var _local_2:int = (global.streetGridX * this.mSettler.mGeneralInterface.mCurrentPlayerZone.mMapWidth);
            var _local_3:int = (global.streetGridYHalf * this.mSettler.mGeneralInterface.mCurrentPlayerZone.mMapHeight);
            var _local_4:Boolean;
            if (this.mSettler.GetX() >= _local_2)
            {
                _local_1 = 0.25;
                _local_4 = true;
            }
            else
            {
                if (this.mSettler.GetX() <= 0)
                {
                    _local_1 = 0.75;
                    _local_4 = true;
                };
            };
            if (this.mSettler.GetY() >= _local_3)
            {
                _local_1 = 0.5;
                _local_4 = true;
            }
            else
            {
                if (this.mSettler.GetY() <= 0)
                {
                    _local_1 = 0;
                    _local_4 = true;
                };
            };
            if (_local_4)
            {
                this.mNewDirection = 10;
                this.mDirection = gCalculations.TransFormPoint(_local_1, 1);
            };
        }

        protected function SetSubTypeFromDirection():void
        {
            var _local_1:Number = this.mSettler.GetX();
            var _local_2:Number = this.mSettler.GetY();
            _local_1 = (_local_1 + ((this.mDirection.x * SPEED) * this.mSettler.mGeneralInterface.mCalculateTicks.mDeltaTicksOne));
            _local_2 = (_local_2 + ((this.mDirection.y * SPEED) * this.mSettler.mGeneralInterface.mCalculateTicks.mDeltaTicksOne));
            this.mSettler.SetPosition(int(_local_1), int(_local_2));
            var _local_3:int = this.Get4DirectionFromXY(int((this.mDirection.x * 1000)), int((this.mDirection.y * 1000)));
            this.mSettler.SetSubType(_local_3);
        }

        public function Get8DirectionFromXY(_arg_1:int, _arg_2:int):int
        {
            var _local_3:Number = 0.92388;
            this.mP.x = _arg_1;
            this.mP.y = _arg_2;
            this.mP.normalize(1);
            if (((this.mP.x >= 0) && (this.mP.y >= 0)))
            {
                if (this.mP.x > _local_3)
                {
                    return (defines.DIR8_EAST);
                };
                if (this.mP.y > _local_3)
                {
                    return (defines.DIR8_SOUTH);
                };
                return (defines.DIR8_SOUTH_EAST);
            };
            if (((this.mP.x >= 0) && (this.mP.y <= 0)))
            {
                if (this.mP.x > _local_3)
                {
                    return (defines.DIR8_EAST);
                };
                if (this.mP.y < -(_local_3))
                {
                    return (defines.DIR8_NORTH);
                };
                return (defines.DIR8_NORTH_EAST);
            };
            if (((this.mP.x <= 0) && (this.mP.y <= 0)))
            {
                if (this.mP.x < -(_local_3))
                {
                    return (defines.DIR8_WEST);
                };
                if (this.mP.y < -(_local_3))
                {
                    return (defines.DIR8_NORTH);
                };
                return (defines.DIR8_NORTH_WEST);
            };
            if (this.mP.x < -(_local_3))
            {
                return (defines.DIR8_WEST);
            };
            if (this.mP.y > _local_3)
            {
                return (defines.DIR8_SOUTH);
            };
            return (defines.DIR8_SOUTH_WEST);
        }

        public function Init():void
        {
        }

        public function DeactivateKI():void
        {
            this.mState = SETTLER_STATE_REMOVE_SETTLER;
        }

        public function RestoreKIStateBeforeMoving():void
        {
            this.mState = this.mStateBeforeMoving;
        }

        public function SetKIStateMoving():void
        {
            this.mStateBeforeMoving = this.mState;
            this.mState = SETTLER_STATE_WAITS_BECAUSE_BUILDING_IS_MOVING;
        }


    }
}
