package 
{
    import PathFinding.cPathObject;
    import __AS3__.vec.Vector;
    import Interface.cGeneralInterface;
    import ServerState.cPlayerData;
    import Map.cPlayerZoneScreen;
    import Enums.COMMAND;
    import GO.cStreet;
    import Enums.OBJECTTYPE;
    import mx.core.*;
    import flash.events.*;
    import flash.display.*;
    import flash.geom.*;
    import mx.controls.*;
    import flash.text.*;
    import flash.media.*;
    import mx.collections.*;
    import Interface.*;
    import GO.*;
    import __AS3__.vec.*;
    import nLib.*;
    import PathFinding.*;
    import flash.utils.*;
    import flash.net.*;
    import Map.*;
    import nLib.SpriteLibDataClass.*;
    import GUI.*;
    import flash.system.*;
    import flash.ui.*;
    import Enums.*;
    import SettlerKI.*;

    public class cSetStreets 
    {

        private var mStartingPositionGridIdx:int;
        public var mSetStartPoint:Boolean;
        public var mPathObject:cPathObject = new cPathObject();
        private var oldCursorGridIdx:int = -1;
        private var mPathCostMatrix_list:Vector.<int> = null;
        private var mGeneralInterface:cGeneralInterface;

        public function cSetStreets(_arg_1:cGeneralInterface)
        {
            super();
            this.mGeneralInterface = _arg_1;
        }

        public function Remove4StreetConnectionsAllSectorsGridPos(_arg_1:cPlayerData, _arg_2:int):void
        {
            this.RemoveStreetConnectionsAllSectorsGridPos(_arg_1, (1 << 2), gCalculations.MoveStreetGridToDir8(this.mGeneralInterface.mCurrentPlayerZone, _arg_2, defines.DIR8_NORTH_EAST));
            this.RemoveStreetConnectionsAllSectorsGridPos(_arg_1, (1 << 3), gCalculations.MoveStreetGridToDir8(this.mGeneralInterface.mCurrentPlayerZone, _arg_2, defines.DIR8_SOUTH_EAST));
            this.RemoveStreetConnectionsAllSectorsGridPos(_arg_1, (1 << 0), gCalculations.MoveStreetGridToDir8(this.mGeneralInterface.mCurrentPlayerZone, _arg_2, defines.DIR8_SOUTH_WEST));
            this.RemoveStreetConnectionsAllSectorsGridPos(_arg_1, (1 << 1), gCalculations.MoveStreetGridToDir8(this.mGeneralInterface.mCurrentPlayerZone, _arg_2, defines.DIR8_NORTH_WEST));
        }

        public function MouseMove(_arg_1:cPlayerZoneScreen):Boolean
        {
            return (this.MouseDownOnMap(_arg_1));
        }

        public function MouseClickOnMap(_arg_1:cPlayerData, _arg_2:cPlayerZoneScreen):Boolean
        {
            var _local_6:Vector.<int>;
            var _local_7:String;
            if (!this.mGeneralInterface.mCurrentCursor.IsCursorValid())
            {
                return (false);
            };
            var _local_3:int = this.mGeneralInterface.mCurrentCursor.GetGridPosition();
            var _local_4:int = this.mGeneralInterface.mCurrentCursor.GetCursorXPixelPos();
            var _local_5:int = this.mGeneralInterface.mCurrentCursor.GetCursorYPixelPos();
            if (this.mGeneralInterface.mCurrentCursor.GetEditMode() == COMMAND.BUILD_WAY)
            {
                if (this.mSetStartPoint)
                {
                    this.mStartingPositionGridIdx = _local_3;
                    _local_6 = new Vector.<int>(1);
                    _local_6.push(this.mStartingPositionGridIdx);
                    this.mPathCostMatrix_list = this.mGeneralInterface.mCreatePath.CalculatePathCostMatrix_list(_local_6, null);
                    _arg_2.mStreetDataMap.ResetStreetPreview();
                    this.mGeneralInterface.mCurrentSecondaryCursor.SetCursorEditMode(COMMAND.BUILD_WAY_SECONDARY);
                    this.mGeneralInterface.mCurrentSecondaryCursor.SetPosition(_local_4, _local_5);
                }
                else
                {
                    this.mPathObject.Reset();
                    this.mPathObject = this.mGeneralInterface.mCreatePath.CalculateStreetPathFromMatrix(_local_3, this.mPathCostMatrix_list);
                    _arg_2.mStreetDataMap.CreateStreetWayFromPathStreet(_arg_1, this.mPathObject, false);
                    _arg_2.mStreetDataMap.ResetStreetPreview();
                    this.mGeneralInterface.mCurrentCursor.SetCursorEditMode(COMMAND.SELECT_BUILDING);
                    this.mGeneralInterface.SendServerAction(COMMAND.BUILD_WAY_SECONDARY, 0, _local_3, this.mStartingPositionGridIdx, null);
                };
                this.mSetStartPoint = (!(this.mSetStartPoint));
                return (true);
            };
            if (((((this.mGeneralInterface.mCurrentCursor.GetEditMode() == COMMAND.ADD_WAY_NE) || (this.mGeneralInterface.mCurrentCursor.GetEditMode() == COMMAND.ADD_WAY_NW)) || (this.mGeneralInterface.mCurrentCursor.GetEditMode() == COMMAND.ADD_WAY_SE)) || (this.mGeneralInterface.mCurrentCursor.GetEditMode() == COMMAND.ADD_WAY_SW)))
            {
                _local_7 = null;
                if (this.mGeneralInterface.mCurrentCursor.GetEditMode() == COMMAND.ADD_WAY_NE)
                {
                    _local_7 = "0";
                };
                if (this.mGeneralInterface.mCurrentCursor.GetEditMode() == COMMAND.ADD_WAY_SE)
                {
                    _local_7 = "1";
                };
                if (this.mGeneralInterface.mCurrentCursor.GetEditMode() == COMMAND.ADD_WAY_SW)
                {
                    _local_7 = "2";
                };
                if (this.mGeneralInterface.mCurrentCursor.GetEditMode() == COMMAND.ADD_WAY_NW)
                {
                    _local_7 = "3";
                };
                _arg_2.mStreetDataMap.SetSingleStreet(_arg_1, _local_7, _local_3);
                return (true);
            };
            if (this.mGeneralInterface.mCurrentCursor.GetEditMode() == COMMAND.ERASE_WAY)
            {
                if (this.mGeneralInterface.mCurrentPlayerZone.IsPositionInsideZone(_local_4, _local_5))
                {
                    this.mGeneralInterface.SendServerAction(COMMAND.ERASE_WAY, 0, _local_3, 0, null);
                    this.Remove4StreetConnectionsAllSectorsGridPos(_arg_1, _local_3);
                    this.mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.RemoveStreetGridPos(_local_3);
                    this.mGeneralInterface.mCurrentPlayerZone.SetBackgroundHasChanged(true);
                };
                return (true);
            };
            if (this.mGeneralInterface.mCurrentCursor.GetEditMode() == COMMAND.TEST_WAYPOINT)
            {
                this.mPathObject.AddPathPoint(this.mGeneralInterface, _local_3);
                this.mPathObject.RefreshLength();
                return (true);
            };
            return (false);
        }

        public function ShowStreetsInRealTime(_arg_1:cPlayerData):void
        {
            var _local_2:int;
            if (this.mGeneralInterface.mCurrentCursor.GetEditMode() == COMMAND.BUILD_WAY)
            {
                if (!this.mSetStartPoint)
                {
                    _local_2 = this.mGeneralInterface.mCurrentCursor.GetGridPosition();
                    if (this.oldCursorGridIdx != _local_2)
                    {
                        this.oldCursorGridIdx = _local_2;
                        this.mPathObject.Reset();
                        this.mPathObject = this.mGeneralInterface.mCreatePath.CalculateStreetPathFromMatrix(_local_2, this.mPathCostMatrix_list);
                    };
                    this.mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.CreateStreetWayFromPathStreet(_arg_1, this.mPathObject, true);
                    this.mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.ShowStreetPreview();
                    this.mGeneralInterface.mCurrentSecondaryCursor.RenderUnderBuildings();
                };
            };
        }

        public function MouseDownOnMap(_arg_1:cPlayerZoneScreen):Boolean
        {
            return (false);
        }

        private function RemoveStreetConnectionsAllSectorsGridPos(_arg_1:cPlayerData, _arg_2:int, _arg_3:int):void
        {
            var _local_5:int;
            var _local_4:String = this.mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.GetStreetNameFromGridPos_string(_arg_3);
            if (_local_4 != null)
            {
                _local_5 = cStreet.ConvertStreetNameToBitField(_local_4);
                _local_5 = (_local_5 & (~(_arg_2)));
                if (_local_5 != 0)
                {
                    this.mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.SetStreet(_arg_1, cStreet.CreateStringFromStreetBitField_string(_local_5), _arg_3, false, true);
                }
                else
                {
                    this.mGeneralInterface.mCurrentPlayerZone.RemoveAtGridPosition(_arg_1, OBJECTTYPE.STREET, _arg_3);
                };
            };
        }


    }
}
