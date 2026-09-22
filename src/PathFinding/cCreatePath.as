package PathFinding
{
    import Interface.cGeneralInterface;
    import __AS3__.vec.Vector;
    import nLib.gMisc;
    import nLib.cLog;
    import GO.cBlockingData;
    import __AS3__.vec.*;

    public class cCreatePath 
    {

        public static const WAYPOINT_UNSET:int = 65532;
        public static const WAYPOINT_BLOCKED:int = 65533;
        public static const WAYPOINT_START:int = 65534;
        public static const WAYPOINT_DEST:int = 0xFFFF;

        private var mGeneralInterface:cGeneralInterface;
        public var costMatrix_list:Vector.<int>;

        public function cCreatePath(_arg_1:cGeneralInterface)
        {
            super();
            this.mGeneralInterface = _arg_1;
        }

        private static function getStringForCosts(_arg_1:int, _arg_2:Boolean):String
        {
            var _local_3:* = "";
            if (!_arg_2)
            {
                switch (_arg_1)
                {
                    case WAYPOINT_BLOCKED:
                        _local_3 = (_local_3 + "|##");
                        break;
                    case WAYPOINT_UNSET:
                        _local_3 = (_local_3 + "|__");
                        break;
                    case WAYPOINT_START:
                        _local_3 = (_local_3 + "|SS");
                        break;
                    case WAYPOINT_DEST:
                        _local_3 = (_local_3 + "|DD");
                        break;
                    default:
                        _local_3 = (_local_3 + (("|" + ((_arg_1 <= 15) ? "0" : "")) + gMisc.ConvertIntToStringRadix_string(_arg_1, 16)));
                };
            }
            else
            {
                switch (_arg_1)
                {
                    case WAYPOINT_BLOCKED:
                        _local_3 = (_local_3 + "|XX");
                        break;
                    case WAYPOINT_START:
                        _local_3 = (_local_3 + "|SS");
                        break;
                    case WAYPOINT_DEST:
                        _local_3 = (_local_3 + "|DD");
                        break;
                    default:
                        _local_3 = (_local_3 + "|__");
                };
            };
            return (_local_3);
        }

        public static function printWayCostMatrix(_arg_1:cGeneralInterface, _arg_2:Vector.<int>, _arg_3:Boolean):void
        {
            var _local_5:int;
            var _local_4:* = "";
            _local_4 = (_local_4 + "*** CostMatrix ***\n");
            _local_4 = (_local_4 + "    ");
            _local_5 = 0;
            while (_local_5 < _arg_1.mCurrentPlayerZone.mMapWidth)
            {
                if (_local_5 < 16)
                {
                    _local_4 = (_local_4 + ("|0" + gMisc.ConvertIntToStringRadix_string(_local_5, 16)));
                }
                else
                {
                    _local_4 = (_local_4 + ("|" + gMisc.ConvertIntToStringRadix_string(_local_5, 16)));
                };
                _local_5++;
            };
            _local_4 = (_local_4 + "\n");
            var _local_6:int;
            while (_local_6 < _arg_1.mCurrentPlayerZone.mMapHeight)
            {
                if (_local_6 <= 15)
                {
                    _local_4 = (_local_4 + (("0" + gMisc.ConvertIntToStringRadix_string(_local_6, 16)) + ": "));
                }
                else
                {
                    _local_4 = (_local_4 + (gMisc.ConvertIntToStringRadix_string(_local_6, 16) + ": "));
                };
                if (((!((_local_6 % 2) == 0)) && (_local_6 > 0)))
                {
                    _local_4 = (_local_4 + " ");
                };
                _local_5 = 0;
                while (_local_5 < _arg_1.mCurrentPlayerZone.mMapWidth)
                {
                    _local_4 = (_local_4 + getStringForCosts(_arg_2[((_local_6 * _arg_1.mCurrentPlayerZone.mMapWidth) + _local_5)], _arg_3));
                    _local_5++;
                };
                _local_4 = (_local_4 + "\n");
                _local_6++;
            };
            cLog.info(_local_4);
        }


        public function CalculatePathCostMatrix_list(_arg_1:Vector.<int>, _arg_2:Vector.<PFAdditionalData>):Vector.<int>
        {
            return (this.CalculatePathCostMatrix_listIntern(_arg_1, _arg_2, 100000));
        }

        public function CalculatePathCostMatrix_listIntern(_arg_1:Vector.<int>, _arg_2:Vector.<PFAdditionalData>, _arg_3:int):Vector.<int>
        {
            var _local_7:Vector.<int>;
            var _local_8:int;
            var _local_9:int;
            var _local_10:int;
            var _local_11:int;
            var _local_12:int;
            var _local_13:int;
            var _local_14:int;
            var _local_15:int;
            var _local_16:int;
            var _local_17:int;
            var _local_18:int;
            var _local_4:int;
            this.initCostMatrix(_arg_2);
            var _local_5:Vector.<int> = new Vector.<int>();
            var _local_6:Vector.<int> = new Vector.<int>();
            for each (_local_8 in _arg_1)
            {
                if (((_local_8 > 0) && (_local_8 < this.costMatrix_list.length)))
                {
                    this.costMatrix_list[_local_8] = WAYPOINT_DEST;
                    _local_5.push(_local_8);
                };
            };
            while (((_local_5.length > 0) && (_local_4 < _arg_3)))
            {
                _local_9 = this.costMatrix_list.length;
                _local_4++;
                for each (_local_10 in _local_5)
                {
                    _local_11 = int((_local_10 / this.mGeneralInterface.mCurrentPlayerZone.mMapWidth));
                    _local_12 = (_local_11 & 0x01);
                    _local_13 = (1 - _local_12);
                    _local_14 = (_local_12 - this.mGeneralInterface.mCurrentPlayerZone.mMapWidth);
                    _local_15 = (_local_12 + this.mGeneralInterface.mCurrentPlayerZone.mMapWidth);
                    _local_16 = (-(_local_13) + this.mGeneralInterface.mCurrentPlayerZone.mMapWidth);
                    _local_17 = (-(_local_13) - this.mGeneralInterface.mCurrentPlayerZone.mMapWidth);
                    _local_18 = (_local_10 + _local_14);
                    if ((((_local_18 >= 0) && (_local_18 < _local_9)) && (this.costMatrix_list[_local_18] == WAYPOINT_UNSET)))
                    {
                        this.costMatrix_list[_local_18] = _local_4;
                        _local_6.push(_local_18);
                    };
                    _local_18 = (_local_10 + _local_15);
                    if ((((_local_18 >= 0) && (_local_18 < _local_9)) && (this.costMatrix_list[_local_18] == WAYPOINT_UNSET)))
                    {
                        this.costMatrix_list[_local_18] = _local_4;
                        _local_6.push(_local_18);
                    };
                    _local_18 = (_local_10 + _local_16);
                    if ((((_local_18 >= 0) && (_local_18 < _local_9)) && (this.costMatrix_list[_local_18] == WAYPOINT_UNSET)))
                    {
                        this.costMatrix_list[_local_18] = _local_4;
                        _local_6.push(_local_18);
                    };
                    _local_18 = (_local_10 + _local_17);
                    if ((((_local_18 >= 0) && (_local_18 < _local_9)) && (this.costMatrix_list[_local_18] == WAYPOINT_UNSET)))
                    {
                        this.costMatrix_list[_local_18] = _local_4;
                        _local_6.push(_local_18);
                    };
                };
                _local_7 = _local_5;
                _local_5 = _local_6;
                _local_6 = _local_7;
                _local_6.length = 0;
            };
            return (this.costMatrix_list);
        }

        public function CalculateStreetPathFromMatrix(_arg_1:int, _arg_2:Vector.<int>):cPathObject
        {
            var _local_9:int;
            var _local_10:int;
            var _local_11:int;
            var _local_12:int;
            var _local_3:cPathObject = new cPathObject();
            var _local_4:int = (_arg_1 % this.mGeneralInterface.mCurrentPlayerZone.mMapWidth);
            var _local_5:int = int((_arg_1 / this.mGeneralInterface.mCurrentPlayerZone.mMapWidth));
            if (((((_local_4 < this.mGeneralInterface.mCurrentPlayerZone.mStreetMapMinUsableX) || (_local_4 > this.mGeneralInterface.mCurrentPlayerZone.mStreetMapMaxUsableX)) || (_local_5 < this.mGeneralInterface.mCurrentPlayerZone.mStreetMapMinUsableY)) || (_local_5 > this.mGeneralInterface.mCurrentPlayerZone.mStreetMapMaxUsableY)))
            {
                return (_local_3);
            };
            var _local_6:int = (_local_4 + (_local_5 * this.mGeneralInterface.mCurrentPlayerZone.mMapWidth));
            var _local_7:int = _arg_2[_arg_1];
            var _local_8:int = -1;
            if (((_local_7 >= WAYPOINT_UNSET) && (_local_7 < WAYPOINT_DEST)))
            {
                return (_local_3);
            };
            _local_3.AddPathPoint(this.mGeneralInterface, _arg_1);
            if (_local_7 == WAYPOINT_DEST)
            {
                return (_local_3);
            };
            while (true)
            {
                _local_9 = ((_local_6 / this.mGeneralInterface.mCurrentPlayerZone.mMapWidth) & 0x01);
                _local_10 = -1;
                _local_11 = -1;
                _local_12 = WAYPOINT_BLOCKED;
                if (_local_8 != defines.DIR4_NORTH_EAST)
                {
                    _local_10 = defines.DIR4_NORTH_EAST;
                    _local_11 = ((_local_6 + _local_9) - this.mGeneralInterface.mCurrentPlayerZone.mMapWidth);
                    _local_12 = _arg_2[_local_11];
                };
                if ((((_local_7 <= _local_12) || (_local_8 == defines.DIR4_NORTH_EAST)) && (!(_local_12 == WAYPOINT_DEST))))
                {
                    if (_local_8 != defines.DIR4_SOUTH_EAST)
                    {
                        _local_10 = defines.DIR4_SOUTH_EAST;
                        _local_11 = ((_local_6 + _local_9) + this.mGeneralInterface.mCurrentPlayerZone.mMapWidth);
                        _local_12 = _arg_2[_local_11];
                    };
                    if ((((_local_7 <= _local_12) || (_local_8 == defines.DIR4_SOUTH_EAST)) && (!(_local_12 == WAYPOINT_DEST))))
                    {
                        if (_local_8 != defines.DIR4_SOUTH_WEST)
                        {
                            _local_10 = defines.DIR4_SOUTH_WEST;
                            _local_11 = (((_local_6 - 1) + _local_9) + this.mGeneralInterface.mCurrentPlayerZone.mMapWidth);
                            _local_12 = _arg_2[_local_11];
                        };
                        if ((((_local_7 <= _local_12) || (_local_8 == defines.DIR4_SOUTH_WEST)) && (!(_local_12 == WAYPOINT_DEST))))
                        {
                            if (_local_8 != defines.DIR4_NORTH_WEST)
                            {
                                _local_10 = defines.DIR4_NORTH_WEST;
                                _local_11 = (((_local_6 - 1) + _local_9) - this.mGeneralInterface.mCurrentPlayerZone.mMapWidth);
                                _local_12 = _arg_2[_local_11];
                            };
                        };
                    };
                };
                if (((_local_7 <= _local_12) && (!(_local_12 == WAYPOINT_DEST))))
                {
                    switch (_local_8)
                    {
                        case defines.DIR4_NORTH_EAST:
                            _local_10 = defines.DIR4_NORTH_EAST;
                            _local_11 = ((_local_6 + _local_9) - this.mGeneralInterface.mCurrentPlayerZone.mMapWidth);
                            _local_12 = _arg_2[_local_11];
                            break;
                        case defines.DIR4_SOUTH_EAST:
                            _local_10 = defines.DIR4_SOUTH_EAST;
                            _local_11 = ((_local_6 + _local_9) + this.mGeneralInterface.mCurrentPlayerZone.mMapWidth);
                            _local_12 = _arg_2[_local_11];
                            break;
                        case defines.DIR4_SOUTH_WEST:
                            _local_10 = defines.DIR4_SOUTH_WEST;
                            _local_11 = (((_local_6 - 1) + _local_9) + this.mGeneralInterface.mCurrentPlayerZone.mMapWidth);
                            _local_12 = _arg_2[_local_11];
                            break;
                        case defines.DIR4_NORTH_WEST:
                            _local_10 = defines.DIR4_NORTH_WEST;
                            _local_11 = (((_local_6 - 1) + _local_9) - this.mGeneralInterface.mCurrentPlayerZone.mMapWidth);
                            _local_12 = _arg_2[_local_11];
                            break;
                    };
                };
                if (((_local_12 < _local_7) || (_local_12 == WAYPOINT_DEST)))
                {
                    _local_8 = _local_10;
                    _local_6 = _local_11;
                    _local_7 = _local_12;
                    _local_3.AddPathPoint(this.mGeneralInterface, _local_6);
                }
                else
                {
                    return (new cPathObject());
                };
                if (_local_12 >= WAYPOINT_UNSET)
                {
                    if (_local_12 < WAYPOINT_DEST)
                    {
                        if (cLog.isInfoEnabled())
                        {
                            cLog.info(("Way not found from " + _arg_1));
                        };
                    };
                    break;
                };
            };
            _local_3.RefreshLength();
            return (_local_3);
        }

        public function initCostMatrix(_arg_1:Vector.<PFAdditionalData>):void
        {
            var _local_5:int;
            var _local_11:PFAdditionalData;
            var _local_2:int = (this.mGeneralInterface.mCurrentPlayerZone.mMapWidth * this.mGeneralInterface.mCurrentPlayerZone.mMapHeight);
            this.costMatrix_list = new Vector.<int>(_local_2);
            var _local_3:int;
            var _local_4:int;
            var _local_6:int = ((this.mGeneralInterface.mCurrentPlayerZone.mStreetMapMinUsableX - 1) + (this.mGeneralInterface.mCurrentPlayerZone.mStreetMapMinUsableY * this.mGeneralInterface.mCurrentPlayerZone.mMapWidth));
            var _local_7:int = ((this.mGeneralInterface.mCurrentPlayerZone.mStreetMapMaxUsableX + 1) + (this.mGeneralInterface.mCurrentPlayerZone.mStreetMapMinUsableY * this.mGeneralInterface.mCurrentPlayerZone.mMapWidth));
            _local_4 = this.mGeneralInterface.mCurrentPlayerZone.mStreetMapMinUsableY;
            while (_local_4 <= this.mGeneralInterface.mCurrentPlayerZone.mStreetMapMaxUsableY)
            {
                this.costMatrix_list[_local_6] = WAYPOINT_BLOCKED;
                this.costMatrix_list[_local_7] = WAYPOINT_BLOCKED;
                _local_6 = (_local_6 + this.mGeneralInterface.mCurrentPlayerZone.mMapWidth);
                _local_7 = (_local_7 + this.mGeneralInterface.mCurrentPlayerZone.mMapWidth);
                _local_4++;
            };
            var _local_8:int = (((this.mGeneralInterface.mCurrentPlayerZone.mStreetMapMinUsableY - 1) * this.mGeneralInterface.mCurrentPlayerZone.mMapWidth) + (this.mGeneralInterface.mCurrentPlayerZone.mStreetMapMinUsableX - 1));
            var _local_9:int = (((this.mGeneralInterface.mCurrentPlayerZone.mStreetMapMaxUsableY + 1) * this.mGeneralInterface.mCurrentPlayerZone.mMapWidth) + (this.mGeneralInterface.mCurrentPlayerZone.mStreetMapMinUsableX - 1));
            _local_5 = (this.mGeneralInterface.mCurrentPlayerZone.mStreetMapMaxUsableX + 1);
            _local_3 = this.mGeneralInterface.mCurrentPlayerZone.mStreetMapMinUsableX;
            while (_local_3 <= _local_5)
            {
                this.costMatrix_list[_local_8] = WAYPOINT_BLOCKED;
                this.costMatrix_list[_local_9] = WAYPOINT_BLOCKED;
                _local_8++;
                _local_9++;
                _local_3++;
            };
            var _local_10:Boolean = ((this.mGeneralInterface.IsAdventureZone()) && (this.mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.useContinentalFog));
            _local_4 = this.mGeneralInterface.mCurrentPlayerZone.mStreetMapMinUsableY;
            while (_local_4 <= this.mGeneralInterface.mCurrentPlayerZone.mStreetMapMaxUsableY)
            {
                _local_3 = ((_local_4 * this.mGeneralInterface.mCurrentPlayerZone.mMapWidth) + this.mGeneralInterface.mCurrentPlayerZone.mStreetMapMinUsableX);
                _local_5 = (_local_3 + (this.mGeneralInterface.mCurrentPlayerZone.mStreetMapMaxUsableX - this.mGeneralInterface.mCurrentPlayerZone.mStreetMapMinUsableX));
                while (_local_3 <= _local_5)
                {
                    if (((this.mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.IsBlockedAllowedNothing(_local_3)) || ((_local_10) && (!(this.mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.isSectorExploredAtGridPosition(_local_3))))))
                    {
                        this.costMatrix_list[_local_3] = WAYPOINT_BLOCKED;
                    }
                    else
                    {
                        this.costMatrix_list[_local_3] = WAYPOINT_UNSET;
                    };
                    _local_3++;
                };
                _local_4++;
            };
            if (_arg_1 != null)
            {
                for each (_local_11 in _arg_1)
                {
                    if (((_local_11.left.gridIndex() >= 0) && (_local_11.left.gridIndex() < _local_2)))
                    {
                        if ((((_local_11.right == cBlockingData.BLOCK_TYPE_ALLOW_NOTHING) || (_local_11.right == cBlockingData.BLOCK_TYPE_ALLOW_WATERBUILD)) || (_local_11.right == cBlockingData.BLOCK_TYPE_ALLOW_SAFE)))
                        {
                            this.costMatrix_list[_local_11.left.gridIndex()] = WAYPOINT_BLOCKED;
                        }
                        else
                        {
                            this.costMatrix_list[_local_11.left.gridIndex()] = WAYPOINT_UNSET;
                        };
                    };
                };
            };
        }


    }
}
