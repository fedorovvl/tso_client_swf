package SettlerKI
{
    import ServerState.cResourceCreation;
    import GO.cSettler;
    import ServerState.cComputeResourceCreation;
    import GO.cBuilding;
    import nLib.cPosInt;
    import PathFinding.dPathObjectItem;
    import mx.core.*;
    import flash.geom.*;
    import GO.*;
    import nLib.*;
    import Map.*;
    import Enums.*;

    public class cSettlerKIWalkToDestination extends cSettlerKI 
    {

        private var visible:Boolean = true;
        public var mResourceCreation:cResourceCreation;

        public function cSettlerKIWalkToDestination(_arg_1:cSettler)
        {
            super(_arg_1);
        }

        public function SetResourcePath(_arg_1:cResourceCreation):void
        {
            this.mResourceCreation = _arg_1;
        }

        override public function Compute():void
        {
            this.visible = true;
            switch (mState)
            {
                case SETTLER_STATE_WALKING_ON_RESOURCE_PATH:
                    mSettlerPos.x = mSettler.GetX();
                    mSettlerPos.y = mSettler.GetY();
                    this.WalkOnResourcePath();
                    break;
                case SETTLER_STATE_WALKING_ON_DEPOSIT_PATH:
                    mSettlerPos.x = mSettler.GetX();
                    mSettlerPos.y = mSettler.GetY();
                    this.WalkOnDepositPath();
                    break;
                case SETTLER_STATE_WAIT_FOR_STORE_HOUSE:
                    if (this.mResourceCreation.GetStoreHouse() != null)
                    {
                        mState = SETTLER_STATE_WALKING_ON_RESOURCE_PATH;
                    };
                    break;
                default:
                    this.visible = false;
            };
            mVisible = this.visible;
            mSettler.SetPosition(int(mSettlerPos.x), int(mSettlerPos.y));
        }

        private function WalkOnDepositPath():void
        {
            var _local_1:int;
            var _local_2:int;
            if (this.mResourceCreation.GetDepositPath() == null)
            {
                this.visible = false;
                return;
            };
            var _local_3:int = this.mResourceCreation.pathPos;
            var _local_4:Number = (mSettler.mGeneralInterface.GetClientTime() - mSettler.mGeneralInterface.mLastGameTickRefreshClientTime);
            _local_3 = (_local_3 + (_local_4 * cComputeResourceCreation.SETTLER_WALK_SPEED_INT));
            if (((!(this.mResourceCreation.GetRemove())) && (!(this.mResourceCreation.GetResourceCreationHouse() == null))))
            {
                switch (this.mResourceCreation.GetResourceCreationHouse().GetBuildingMode())
                {
                    case cBuilding.BUILDING_MODE_SETTLER_WALKS_FROM_RESOURCECREATIONHOUSE_TO_EXTERNAL_RESOURCE:
                        if (_local_3 > this.mResourceCreation.GetDepositPath().pathLenX10000)
                        {
                            this.visible = false;
                            return;
                        };
                        break;
                    case cBuilding.BUILDING_MODE_SETTLER_WALKS_FROM_EXTERNAL_RESOURCE_TO_RESOURCECREATIONHOUSE:
                        if (_local_3 >= this.mResourceCreation.GetDepositPath().pathLenX20000)
                        {
                            this.visible = false;
                            return;
                        };
                        break;
                };
            };
            var _local_5:Number = _local_3;
            _local_5 = (_local_5 / defines.INT_SCALE_FACTOR);
            var _local_6:Number = (this.mResourceCreation.GetDepositPath().pathLenX10000 / defines.INT_SCALE_FACTOR);
            _local_1 = int(_local_5);
            if (_local_1 >= _local_6)
            {
                _local_1 = int((((_local_6 * 2) - 1) - _local_1));
                _local_2 = (_local_1 - 1);
            }
            else
            {
                _local_2 = (_local_1 + 1);
            };
            _local_5 = (_local_5 % 1);
            var _local_7:Boolean;
            if (_local_2 < 0)
            {
                _local_7 = true;
                _local_2 = 0;
            };
            if (_local_2 >= _local_6)
            {
                _local_7 = true;
                _local_2 = int((_local_6 - 1));
            };
            if (_local_7)
            {
                this.visible = false;
                return;
            };
            if (_local_1 < 0)
            {
                _local_1 = 0;
            };
            if (_local_1 >= _local_6)
            {
                _local_1 = int((_local_6 - 1));
            };
            var _local_8:cPosInt = (this.mResourceCreation.GetDepositPath().dest_vector[_local_1] as cPosInt);
            var _local_9:cPosInt = (this.mResourceCreation.GetDepositPath().dest_vector[_local_2] as cPosInt);
            var _local_10:int = int((_local_5 * 0x0100));
            mSettlerPos.x = (((_local_10 * (_local_9.x - _local_8.x)) >> 8) + _local_8.x);
            mSettlerPos.y = (((_local_10 * (_local_9.y - _local_8.y)) >> 8) + _local_8.y);
            mSettlerPos.y = (mSettlerPos.y - global.streetGridYHalf);
            var _local_11:int = Get4DirectionFromXY((_local_9.x - _local_8.x), (_local_9.y - _local_8.y));
            mSettler.SetSubType(_local_11);
            mSettler.Animate();
        }

        private function WalkOnResourcePath():void
        {
            var _local_1:int;
            var _local_2:int;
            if (this.mResourceCreation.GetPath() == null)
            {
                this.visible = false;
                return;
            };
            var _local_3:int = this.mResourceCreation.pathPos;
            var _local_4:Number = (mSettler.mGeneralInterface.GetClientTime() - mSettler.mGeneralInterface.mLastGameTickRefreshClientTime);
            _local_3 = (_local_3 + (_local_4 * cComputeResourceCreation.SETTLER_WALK_SPEED_INT));
            if (((!(this.mResourceCreation.GetRemove())) && (!(this.mResourceCreation.GetResourceCreationHouse() == null))))
            {
                switch (this.mResourceCreation.GetResourceCreationHouse().GetBuildingMode())
                {
                    case cBuilding.BUILDING_MODE_SETTLER_WALKS_FROM_STOREHOUSE_TO_RESOURCECREATIONHOUSE:
                    case cBuilding.BUILDING_MODE_SETTLER_WALKS_TO_BUILDING_GROUND_PLACE:
                        if (_local_3 >= this.mResourceCreation.GetPath().pathLenX10000)
                        {
                            this.visible = false;
                            return;
                        };
                        break;
                    case cBuilding.BUILDING_MODE_SETTLER_WALKS_FROM_RESOURCECREATIONHOUSE_TO_STOREHOUSE:
                    case cBuilding.BUILDING_MODE_BUILDER_WALKS_FROM_RESOURCECREATIONHOUSE_TO_STOREHOUSE:
                        if (_local_3 > this.mResourceCreation.GetPath().pathLenX20000)
                        {
                            this.visible = false;
                            return;
                        };
                        break;
                };
            };
            var _local_5:Number = _local_3;
            _local_5 = (_local_5 / defines.INT_SCALE_FACTOR);
            var _local_6:Number = this.mResourceCreation.GetPath().dest_vector.length;
            _local_1 = int(_local_5);
            if (_local_1 >= _local_6)
            {
                if (this.mResourceCreation.GetStoreHouse() == null)
                {
                    this.visible = false;
                    return;
                };
                _local_1 = int((((_local_6 * 2) - 1) - _local_1));
                _local_2 = (_local_1 - 1);
            }
            else
            {
                _local_2 = (_local_1 + 1);
            };
            _local_5 = (_local_5 % 1);
            var _local_7:Boolean;
            if (_local_2 < 0)
            {
                _local_7 = true;
                _local_2 = 0;
            };
            if (_local_2 >= _local_6)
            {
                _local_7 = true;
                _local_2 = int((_local_6 - 1));
            };
            if (_local_7)
            {
                this.visible = false;
                return;
            };
            if (_local_1 < 0)
            {
                _local_1 = 0;
            };
            if (_local_1 >= _local_6)
            {
                _local_1 = int((_local_6 - 1));
            };
            var _local_8:dPathObjectItem = (this.mResourceCreation.GetPath().dest_vector[_local_1] as dPathObjectItem);
            var _local_9:dPathObjectItem = (this.mResourceCreation.GetPath().dest_vector[_local_2] as dPathObjectItem);
            mSettlerPos.x = ((_local_5 * (_local_9.x - _local_8.x)) + _local_8.x);
            mSettlerPos.y = ((_local_5 * (_local_9.y - _local_8.y)) + _local_8.y);
            mSettlerPos.y = (mSettlerPos.y - global.streetGridYHalf);
            var _local_10:int = Get4DirectionFromXY((_local_9.x - _local_8.x), (_local_9.y - _local_8.y));
            mSettler.SetSubType(_local_10);
            mSettler.Animate();
        }


    }
}
