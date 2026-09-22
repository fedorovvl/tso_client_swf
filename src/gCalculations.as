package 
{
    import __AS3__.vec.Vector;
    import nLib.cPosInt;
    import Map.cPlayerZoneScreen;
    import flash.geom.Point;
    import mx.collections.ArrayCollection;
    import flash.geom.Matrix;
    import Communication.VO.grid.AreaGridVO;
    import Utils.HashSetWrapper;
    import nLib.gMisc;
    import __AS3__.vec.*;

    public class gCalculations 
    {

        public static var m8DirectionTableStreetGrid_vector:Vector.<cPosInt> = null;
        public static var m4DirectionBit_list:Vector.<int> = Vector.<int>([1, 2, 4, 8]);
        public static var m4DirectionOppositeBit_list:Vector.<int> = Vector.<int>([4, 8, 1, 2]);
        public static var mRandomTable_vector:Vector.<int>;


        public static function MoveStreetGridToDir8(_arg_1:cPlayerZoneScreen, _arg_2:int, _arg_3:int):int
        {
            var _local_4:cVectorListInt = _arg_1.m8DirectionTableStreetGridDirection_vector[((_arg_2 / _arg_1.mMapWidth) & 0x01)];
            return (_arg_2 + _local_4.mList_vector[_arg_3]);
        }

        public static function getGridDistace(_arg_1:cPlayerZoneScreen, _arg_2:int, _arg_3:int):Number
        {
            var _local_4:Point = new Point(Math.floor((_arg_2 / _arg_1.mMapWidth)), (_arg_2 % _arg_1.mMapWidth));
            var _local_5:Point = new Point(Math.floor((_arg_3 / _arg_1.mMapWidth)), (_arg_3 % _arg_1.mMapWidth));
            return (Point.distance(_local_4, _local_5));
        }

        public static function InitWidthZone(_arg_1:cPlayerZoneScreen):void
        {
            var _local_2:cVectorListInt;
            _arg_1.m8DirectionTableStreetGridDirection_vector = new Vector.<cVectorListInt>();
            _local_2 = new cVectorListInt();
            _local_2.mList_vector.push(-(_arg_1.mMapWidth));
            _local_2.mList_vector.push(_arg_1.mMapWidth);
            _local_2.mList_vector.push((_arg_1.mMapWidth - 1));
            _local_2.mList_vector.push((-(_arg_1.mMapWidth) - 1));
            _local_2.mList_vector.push(-(_arg_1.mMapWidth << 1));
            _local_2.mList_vector.push(1);
            _local_2.mList_vector.push((_arg_1.mMapWidth << 1));
            _local_2.mList_vector.push(-1);
            _arg_1.m8DirectionTableStreetGridDirection_vector.push(_local_2);
            _local_2 = new cVectorListInt();
            _local_2.mList_vector.push((-(_arg_1.mMapWidth) + 1));
            _local_2.mList_vector.push((_arg_1.mMapWidth + 1));
            _local_2.mList_vector.push(_arg_1.mMapWidth);
            _local_2.mList_vector.push(-(_arg_1.mMapWidth));
            _local_2.mList_vector.push(-(_arg_1.mMapWidth << 1));
            _local_2.mList_vector.push(1);
            _local_2.mList_vector.push((_arg_1.mMapWidth << 1));
            _local_2.mList_vector.push(-1);
            _arg_1.m8DirectionTableStreetGridDirection_vector.push(_local_2);
        }

        public static function GetGridIdxDown(_arg_1:int, _arg_2:int):int
        {
            if (((_arg_1 / _arg_2) & 0x01) != 0)
            {
                return (_arg_1 + (_arg_2 + 1));
            };
            return (_arg_1 + _arg_2);
        }

        public static function ConvertStreetGridToPixelPos(_arg_1:cPlayerZoneScreen, _arg_2:int, _arg_3:cPosInt):void
        {
            var _local_4:int = (_arg_2 % _arg_1.mMapWidth);
            var _local_5:int = int((_arg_2 / _arg_1.mMapWidth));
            var _local_6:int = (_local_4 * global.streetGridX);
            var _local_7:int = (_local_5 * global.streetGridYHalf);
            if ((_local_5 & 0x01) == 0)
            {
                _local_6 = (_local_6 - global.streetGridXHalf);
            };
            _arg_3.x = _local_6;
            _arg_3.y = _local_7;
        }

        public static function createIntListString(_arg_1:String, _arg_2:ArrayCollection):String
        {
            var _local_4:Boolean;
            var _local_5:Object;
            var _local_3:* = (("<" + _arg_1) + " list='");
            if (_arg_2 != null)
            {
                _local_4 = true;
                for each (_local_5 in _arg_2)
                {
                    if (!_local_4)
                    {
                        _local_3 = (_local_3 + ",");
                    };
                    _local_4 = false;
                    _local_3 = (_local_3 + _local_5.toString());
                };
            };
            return (_local_3 + "' />\n");
        }

        public static function TransFormPoint(_arg_1:Number, _arg_2:Number):Point
        {
            var _local_3:Number = (_arg_1 * (2 * Math.PI));
            var _local_4:Matrix = new Matrix();
            _local_4.identity();
            _local_4.rotate(_local_3);
            return (_local_4.transformPoint(new Point(0, _arg_2)));
        }

        public static function RestrictPixelPosToStreetGrid(_arg_1:cPlayerZoneScreen, _arg_2:cPosInt):void
        {
            var _local_3:int = ConvertPixelPosToStreetGridPos(_arg_1, _arg_2.x, _arg_2.y);
            ConvertStreetGridToPixelPos(_arg_1, _local_3, _arg_2);
        }

        public static function IsGridXYInsideMap(_arg_1:cPlayerZoneScreen, _arg_2:int, _arg_3:int):Boolean
        {
            return (!((((_arg_2 < _arg_1.mStreetMapMinUsableX) || (_arg_2 > _arg_1.mStreetMapMaxUsableX)) || (_arg_3 < _arg_1.mStreetMapMinUsableY)) || (_arg_3 > _arg_1.mStreetMapMaxUsableY)));
        }

        public static function AddAngle(_arg_1:Number, _arg_2:Number):Number
        {
            var _local_3:Number = _arg_1;
            _local_3 = (_local_3 + _arg_2);
            while (_local_3 > 1)
            {
                _local_3--;
            };
            while (_local_3 < 0)
            {
                _local_3 = (_local_3 + 1);
            };
            return (_local_3);
        }

        public static function AddGridIdxToVector(_arg_1:int, _arg_2:Vector.<AreaGridVO>, _arg_3:HashSetWrapper):void
        {
            if (!_arg_3.contains(_arg_1))
            {
                _arg_2.push(new AreaGridVO(_arg_1, 0));
                _arg_3.add(_arg_1);
            };
        }

        public static function CalculateTileListFromRadius(_arg_1:int):Vector.<cPosInt>
        {
            var _local_2:Vector.<cPosInt> = new Vector.<cPosInt>();
            _local_2.push(new cPosInt(0, 0));
            _local_2.push(new cPosInt(50, 50));
            _local_2.push(new cPosInt(50, -50));
            _local_2.push(new cPosInt(-50, 50));
            _local_2.push(new cPosInt(-50, -50));
            _local_2.push(new cPosInt(100, 0));
            _local_2.push(new cPosInt(-100, 0));
            _local_2.push(new cPosInt(0, 100));
            _local_2.push(new cPosInt(0, -100));
            _local_2.push(new cPosInt(100, 100));
            _local_2.push(new cPosInt(100, -100));
            _local_2.push(new cPosInt(-100, 100));
            _local_2.push(new cPosInt(-100, -100));
            _local_2.push(new cPosInt(150, 50));
            _local_2.push(new cPosInt(150, -50));
            _local_2.push(new cPosInt(-150, 50));
            _local_2.push(new cPosInt(-150, -50));
            _local_2.push(new cPosInt(50, 150));
            _local_2.push(new cPosInt(50, -150));
            _local_2.push(new cPosInt(-50, 150));
            _local_2.push(new cPosInt(-50, -150));
            _local_2.push(new cPosInt(0, 200));
            _local_2.push(new cPosInt(0, -200));
            _local_2.push(new cPosInt(200, 0));
            _local_2.push(new cPosInt(-200, 0));
            _local_2.push(new cPosInt(200, 100));
            _local_2.push(new cPosInt(200, -100));
            _local_2.push(new cPosInt(-200, 100));
            _local_2.push(new cPosInt(-200, -100));
            _local_2.push(new cPosInt(100, 200));
            _local_2.push(new cPosInt(100, -200));
            _local_2.push(new cPosInt(-100, 200));
            _local_2.push(new cPosInt(-100, -200));
            _local_2.push(new cPosInt(150, 150));
            _local_2.push(new cPosInt(150, -150));
            _local_2.push(new cPosInt(-150, 150));
            _local_2.push(new cPosInt(-150, -150));
            return (_local_2);
        }

        public static function IsGridInIslandArea(_arg_1:cPlayerZoneScreen, _arg_2:int):Boolean
        {
            var _local_3:int = (_arg_2 % _arg_1.mMapWidth);
            var _local_4:int = int((_arg_2 / _arg_1.mMapWidth));
            return (!((((_local_3 < _arg_1.mStreetMapMinUsableX) || (_local_3 > _arg_1.mStreetMapMaxUsableX)) || (_local_4 < ((_arg_1.mStreetMapMinUsableY + defines.STREET_ZONE_ISLAND_Y) - 1))) || (_local_4 > _arg_1.mStreetMapMaxUsableY)));
        }

        public static function GetGridIdxRight(_arg_1:int, _arg_2:int):int
        {
            if (((_arg_1 / _arg_2) & 0x01) != 0)
            {
                return (_arg_1 - (_arg_2 - 1));
            };
            return (_arg_1 - _arg_2);
        }

        public static function ConvertPixelPosToStreetGridPos(_arg_1:cPlayerZoneScreen, _arg_2:int, _arg_3:int):int
        {
            var _local_4:Number = (_arg_2 / global.streetGridXFloat);
            var _local_5:Number = ((_arg_3 - global.streetGridYHalf) / global.streetGridYFloat);
            var _local_6:Number = Math.round((_local_5 - _local_4));
            var _local_7:Number = Math.round((_local_5 + _local_4));
            var _local_8:int = int((((_local_7 - _local_6) / 2) * global.streetGridXFloat));
            var _local_9:int = int((((_local_7 + _local_6) / 2) * global.streetGridYFloat));
            var _local_10:int = int((_local_8 / global.streetGridX));
            var _local_11:int = int(((_local_9 + global.streetGridYHalf) / global.streetGridYHalf));
            _local_10 = (_local_10 + ((_local_11 & 0x01) ^ 0x01));
            if (!IsGridXYInsideMap(_arg_1, _local_10, _local_11))
            {
                return (defines.ILLEGAL_INT_POS);
            };
            var _local_12:int = (_local_10 + (_local_11 * _arg_1.mMapWidth));
            return (_local_12);
        }

        public static function ConvertGridFrom128WithToCurrent(_arg_1:cPlayerZoneScreen, _arg_2:int):int
        {
            var _local_3:* = (_arg_2 & 0x7F);
            var _local_4:* = (_arg_2 >> 7);
            return (_local_3 + (_local_4 * _arg_1.mMapWidth));
        }

        public static function GetFreeDirectionFromXY(_arg_1:int, _arg_2:int):Number
        {
            var _local_3:Number = (Math.atan2(-(_arg_2), _arg_1) + Math.PI);
            var _local_4:Number = ((_local_3 * 0.5) / Math.PI);
            _local_4 = (_local_4 + (1 / 16));
            if (_local_4 >= 1)
            {
                _local_4--;
            };
            return (_local_4);
        }

        public static function createListString(_arg_1:String, _arg_2:ArrayCollection):String
        {
            var _local_4:Object;
            var _local_3:* = (("<" + _arg_1) + ">\n");
            if (_arg_2 != null)
            {
                for each (_local_4 in _arg_2)
                {
                    _local_3 = (_local_3 + ((" " + _local_4.toString()) + "\n"));
                };
            };
            return (_local_3 + (("</" + _arg_1) + " >\n"));
        }

        public static function AddGridIdxNeighbours(_arg_1:int, _arg_2:Vector.<AreaGridVO>, _arg_3:int, _arg_4:HashSetWrapper):void
        {
            AddGridIdxToVector(_arg_1, _arg_2, _arg_4);
            AddGridIdxToVector(GetGridIdxLeft(_arg_1, _arg_3), _arg_2, _arg_4);
            AddGridIdxToVector(GetGridIdxRight(_arg_1, _arg_3), _arg_2, _arg_4);
            AddGridIdxToVector(GetGridIdxUp(_arg_1, _arg_3), _arg_2, _arg_4);
            AddGridIdxToVector(GetGridIdxDown(_arg_1, _arg_3), _arg_2, _arg_4);
            AddGridIdxToVector((_arg_1 - 1), _arg_2, _arg_4);
            AddGridIdxToVector((_arg_1 + 1), _arg_2, _arg_4);
            AddGridIdxToVector((_arg_1 - (_arg_3 * 2)), _arg_2, _arg_4);
            AddGridIdxToVector((_arg_1 + (_arg_3 * 2)), _arg_2, _arg_4);
        }

        public static function GetGridIdxLeft(_arg_1:int, _arg_2:int):int
        {
            if (((_arg_1 / _arg_2) & 0x01) != 0)
            {
                return (_arg_1 + _arg_2);
            };
            if (((_arg_1 < 0) && ((_arg_1 + _arg_2) >= 0)))
            {
                return (_arg_1 + _arg_2);
            };
            return (_arg_1 + (_arg_2 - 1));
        }

        public static function Init():void
        {
            var _local_2:int;
            m8DirectionTableStreetGrid_vector = new Vector.<cPosInt>();
            m8DirectionTableStreetGrid_vector.push(new cPosInt(global.streetGridXHalf, -(global.streetGridYHalf)));
            m8DirectionTableStreetGrid_vector.push(new cPosInt(global.streetGridX, 0));
            m8DirectionTableStreetGrid_vector.push(new cPosInt(global.streetGridXHalf, global.streetGridYHalf));
            m8DirectionTableStreetGrid_vector.push(new cPosInt(0, global.streetGridY));
            m8DirectionTableStreetGrid_vector.push(new cPosInt(-(global.streetGridXHalf), global.streetGridYHalf));
            m8DirectionTableStreetGrid_vector.push(new cPosInt(-(global.streetGridX), 0));
            m8DirectionTableStreetGrid_vector.push(new cPosInt(-(global.streetGridXHalf), -(global.streetGridYHalf)));
            m8DirectionTableStreetGrid_vector.push(new cPosInt(0, -(global.streetGridY)));
            mRandomTable_vector = new Vector.<int>();
            var _local_1:int;
            while (_local_1 < 0x2000)
            {
                _local_2 = gMisc.GetRandomMinMaxInt(-(gMisc.GetMaxIntValue()), gMisc.GetMaxIntValue());
                mRandomTable_vector.push(_local_2);
                _local_1++;
            };
        }

        public static function IsGridInsideMap(_arg_1:cPlayerZoneScreen, _arg_2:int):Boolean
        {
            var _local_3:int = (_arg_2 % _arg_1.mMapWidth);
            var _local_4:int = int((_arg_2 / _arg_1.mMapWidth));
            return (!((((_local_3 < _arg_1.mStreetMapMinUsableX) || (_local_3 > _arg_1.mStreetMapMaxUsableX)) || (_local_4 < _arg_1.mStreetMapMinUsableY)) || (_local_4 > _arg_1.mStreetMapMaxUsableY)));
        }

        public static function AddGridIdxRectangle(_arg_1:int, _arg_2:int, _arg_3:int, _arg_4:Vector.<AreaGridVO>, _arg_5:int):void
        {
            var _local_8:int;
            var _local_9:int;
            var _local_10:int;
            var _local_11:int;
            var _local_6:HashSetWrapper = new HashSetWrapper();
            var _local_7:int = _arg_1;
            if (((_arg_2 <= 0) || (_arg_3 <= 0)))
            {
                return;
            };
            if (((_arg_2 == 1) && (_arg_3 == 1)))
            {
                AddGridIdxToVector(_arg_1, _arg_4, _local_6);
                return;
            };
            if (((_arg_2 == 2) && (_arg_3 == 2)))
            {
                AddGridIdxToVector(_arg_1, _arg_4, _local_6);
                AddGridIdxToVector(GetGridIdxRight(_arg_1, _arg_5), _arg_4, _local_6);
                AddGridIdxToVector(GetGridIdxUp(_arg_1, _arg_5), _arg_4, _local_6);
                AddGridIdxToVector((_arg_1 - (_arg_5 * 2)), _arg_4, _local_6);
                return;
            };
            _arg_2 = (_arg_2 - 2);
            _arg_3 = (_arg_3 - 2);
            _local_10 = int((_arg_2 / 2));
            _local_11 = int((_arg_3 / 2));
            _local_8 = 0;
            while (_local_8 < _local_10)
            {
                _local_7 = GetGridIdxLeft(_local_7, _arg_5);
                _local_8++;
            };
            _local_8 = 0;
            while (_local_8 < _local_11)
            {
                _local_7 = GetGridIdxUp(_local_7, _arg_5);
                _local_8++;
            };
            _local_8 = 0;
            while (_local_8 < _arg_3)
            {
                _local_9 = 0;
                while (_local_9 < _arg_2)
                {
                    AddGridIdxNeighbours(_local_7, _arg_4, _arg_5, _local_6);
                    _local_7 = GetGridIdxRight(_local_7, _arg_5);
                    _local_9++;
                };
                _local_9 = 0;
                while (_local_9 < _arg_2)
                {
                    _local_7 = GetGridIdxLeft(_local_7, _arg_5);
                    _local_9++;
                };
                _local_7 = GetGridIdxDown(_local_7, _arg_5);
                _local_8++;
            };
        }

        public static function CalculateGFXUpgradeLevel(_arg_1:int, _arg_2:int):int
        {
            _arg_1--;
            if (_arg_1 < 0)
            {
                _arg_1 = 0;
            };
            if (_arg_1 > _arg_2)
            {
                _arg_1 = _arg_2;
            };
            return (_arg_1);
        }

        public static function GetGridIdxUp(_arg_1:int, _arg_2:int):int
        {
            if (((_arg_1 / _arg_2) & 0x01) != 0)
            {
                return (_arg_1 - _arg_2);
            };
            return (_arg_1 - (_arg_2 + 1));
        }


    }
}
