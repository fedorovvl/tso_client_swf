package Map.SubMaps
{
    import __AS3__.vec.Vector;
    import GO.cGO;
    import GO.cBackground;
    import nLib.cClippingRectangle;
    import Interface.cGeneralInterface;
    import nLib.cXML;
    import Map.AdditionalDataTSO;
    import nLib.cZoom;
    import Enums.GCB_MODE_CLIPPING;
    import nLib.cBackbuffer;
    import __AS3__.vec.*;

    public class cBackgroundRectangleDataMap 
    {

        public static const RECTANGLE_ELEMENT_WIDTH:int = 234;
        public static const RECTANGLE_ELEMENT_HEIGHT:int = 144;

        protected var mMapSize:int;
        protected var mMapWidth:int;
        protected var mMaxUsableAreaX:int;
        protected var mMaxUsableAreaY:int;
        public var mMap_list:Vector.<cGO> = null;
        protected var mMinUsableAreaY:int;
        protected var mMinUsableAreaX:int;
        protected var mMapHeight:int;
        private var mStreetGridMap_list:Vector.<int> = null;
        public var mWaterTile:cBackground = null;
        protected var mTempClippingRectangle:cClippingRectangle = new cClippingRectangle();
        protected var mGeneralInterface:cGeneralInterface;

        public function cBackgroundRectangleDataMap(_arg_1:cGeneralInterface, _arg_2:int, _arg_3:int)
        {
            super();
            this.mGeneralInterface = _arg_1;
            this.mMapWidth = _arg_2;
            this.mMapHeight = _arg_3;
            this.mMapSize = (this.mMapWidth * this.mMapHeight);
            this.mMinUsableAreaX = 0;
            this.mMinUsableAreaY = 0;
            this.mMaxUsableAreaX = (this.mMapWidth - 1);
            this.mMaxUsableAreaY = (this.mMapHeight - 1);
            this.mMap_list = new Vector.<cGO>(this.mMapSize);
            this.mStreetGridMap_list = new Vector.<int>(this.mMapSize);
        }

        public function UpdatePositions():void
        {
            var _local_4:int;
            var _local_5:int;
            var _local_1:int;
            var _local_2:int;
            var _local_3:int;
            while (_local_3 < this.mMapHeight)
            {
                _local_4 = 0;
                _local_5 = 0;
                while (_local_5 < this.mMapWidth)
                {
                    if (this.mMap_list[_local_2] != null)
                    {
                        this.mMap_list[_local_2].SetPosition(_local_4, _local_1);
                    };
                    _local_4 = (_local_4 + RECTANGLE_ELEMENT_WIDTH);
                    _local_2++;
                    _local_5++;
                };
                _local_1 = (_local_1 + RECTANGLE_ELEMENT_HEIGHT);
                _local_3++;
            };
            this.mGeneralInterface.mCurrentPlayerZone.SetBackgroundHasChanged(true);
        }

        public function ConvertXMLStringToMap(_arg_1:String):void
        {
            var _local_7:cXML;
            var _local_8:String;
            var _local_9:Array;
            var _local_10:int;
            var _local_11:String;
            var _local_12:cBackground;
            var _local_2:cXML = new cXML();
            _local_2.SetXMLString(_arg_1);
            var _local_3:cXML = _local_2.MoveToSubNode("BackgroundMap");
            var _local_4:Vector.<cXML> = _local_3.CreateChildrenArray();
            var _local_5:int;
            var _local_6:int;
            for each (_local_7 in _local_4)
            {
                _local_8 = _local_7.GetAttributeString_string("element");
                _local_9 = _local_8.split(",");
                _local_10 = 0;
                _local_6 = (_local_10 + (_local_5 * this.mMapWidth));
                if (_local_5 < this.mMapHeight)
                {
                    for each (_local_11 in _local_9)
                    {
                        if (_local_11 != "#")
                        {
                            _local_12 = cBackground.CreateFromString(_local_11, this.mGeneralInterface);
                            if (_local_10 < this.mMapWidth)
                            {
                                this.mMap_list[_local_6] = _local_12;
                            };
                        }
                        else
                        {
                            if (_local_10 < this.mMapWidth)
                            {
                                this.mMap_list[_local_6] = null;
                            };
                        };
                        _local_10++;
                        _local_6++;
                    };
                };
                _local_5++;
            };
            this.UpdatePositions();
        }

        public function Render(_arg_1:int):void
        {
            var _local_2:int;
            var _local_3:int;
            var _local_8:cGO;
            var _local_10:int;
            this.CalculateMapClipping(_arg_1, this.mTempClippingRectangle);
            var _local_4:int = this.mTempClippingRectangle.minX;
            var _local_5:int = this.mTempClippingRectangle.minY;
            var _local_6:int = this.mTempClippingRectangle.maxX;
            var _local_7:int = this.mTempClippingRectangle.maxY;
            var _local_9:int = this.mTempClippingRectangle.minX;
            _local_3 = _local_5;
            while (_local_3 <= _local_7)
            {
                _local_10 = (_local_9 + (_local_3 * this.mMapWidth));
                if (!((_local_10 < 0) || (_local_10 >= this.mMap_list.length)))
                {
                    _local_2 = _local_4;
                    while (_local_2 <= _local_6)
                    {
                        if (_local_10 < this.mMap_list.length)
                        {
                            _local_8 = this.mMap_list[_local_10];
                            if (_local_8 != null)
                            {
                                if (this.mStreetGridMap_list[_local_10] != defines.ILLEGAL_INT_POS)
                                {
                                    if ((((this.mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.mAdditionalData2.get(this.mStreetGridMap_list[_local_10], AdditionalDataTSO.Fog) < 6) || (_local_2 <= (_local_4 + defines.STREET_ZONE_BORDER))) || (_local_3 <= (_local_5 + defines.STREET_ZONE_BORDER))))
                                    {
                                        _local_8.RenderNoAlpha();
                                    };
                                }
                                else
                                {
                                    _local_8.RenderNoAlpha();
                                };
                            };
                            _local_10++;
                        };
                        _local_2++;
                    };
                };
                _local_3++;
            };
            this.mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.RenderFreeBackgroundStatic(_arg_1);
            if (this.mGeneralInterface.showBackgroundGrid)
            {
                this.RenderGrid(_arg_1);
            };
            this.mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.RenderStreets(_arg_1);
        }

        public function FillWithPattern(_arg_1:String="P1"):void
        {
            var _local_2:int;
            while (_local_2 < this.mMapSize)
            {
                this.mMap_list[_local_2] = cBackground.CreateFromString(_arg_1, this.mGeneralInterface);
                _local_2++;
            };
            this.UpdatePositions();
        }

        public function Init():void
        {
            var _local_6:int;
            this.Clear();
            var _local_1:int;
            var _local_2:int;
            var _local_3:int;
            var _local_4:int;
            this.mWaterTile = gGfxResource.mWaterTile;
            var _local_5:int;
            while (_local_5 < this.mMapHeight)
            {
                _local_1 = _local_4;
                _local_6 = 0;
                while (_local_6 < this.mMapWidth)
                {
                    this.mStreetGridMap_list[_local_3] = gCalculations.ConvertPixelPosToStreetGridPos(this.mGeneralInterface.mCurrentPlayerZone, _local_1, _local_2);
                    _local_1 = (_local_1 + RECTANGLE_ELEMENT_WIDTH);
                    _local_3++;
                    _local_6++;
                };
                _local_2 = (_local_2 + RECTANGLE_ELEMENT_HEIGHT);
                _local_5++;
            };
        }

        public function IsGridPosUsable(_arg_1:int, _arg_2:int):Boolean
        {
            return (!((((_arg_1 < this.mMinUsableAreaX) || (_arg_1 > this.mMaxUsableAreaX)) || (_arg_2 < this.mMinUsableAreaY)) || (_arg_2 > this.mMaxUsableAreaY)));
        }

        public function mapWidth():int
        {
            return (this.mMapWidth);
        }

        public function SetGridPos(_arg_1:cGO, _arg_2:int):Boolean
        {
            var _local_3:Boolean;
            var _local_4:int = this.ConvertGridToXPos(_arg_2);
            var _local_5:int = this.ConvertGridToYPos(_arg_2);
            _arg_1.SetPosition(_local_4, _local_5);
            if (_arg_2 != defines.ILLEGAL_INT_POS)
            {
                this.mMap_list[_arg_2] = _arg_1;
                _local_3 = true;
            };
            return (_local_3);
        }

        public function RenderWaterBorder(_arg_1:int):void
        {
            var _local_2:int;
            var _local_3:int;
            var _local_4:int;
            var _local_5:int;
            var _local_6:int;
            var _local_7:int;
            var _local_8:int;
            var _local_10:int;
            _local_4 = this.mGeneralInterface.mZoom.Scale(-(global.screenWidthHalf), cZoom.HUNDRED_PERCENT_ZOOM);
            _local_5 = (_local_4 + this.mGeneralInterface.mZoom.GetScrollPosXInt());
            _local_4 = this.mGeneralInterface.mZoom.Scale(-(global.screenHeightHalf), cZoom.HUNDRED_PERCENT_ZOOM);
            _local_6 = (_local_4 + this.mGeneralInterface.mZoom.GetScrollPosYInt());
            _local_4 = this.mGeneralInterface.mZoom.Scale(global.screenWidthHalf, cZoom.HUNDRED_PERCENT_ZOOM);
            _local_7 = (_local_4 + this.mGeneralInterface.mZoom.GetScrollPosXInt());
            _local_4 = this.mGeneralInterface.mZoom.Scale(global.screenHeightHalf, cZoom.HUNDRED_PERCENT_ZOOM);
            _local_8 = (_local_4 + this.mGeneralInterface.mZoom.GetScrollPosYInt());
            _local_5 = int((_local_5 / RECTANGLE_ELEMENT_WIDTH));
            _local_6 = int((_local_6 / RECTANGLE_ELEMENT_HEIGHT));
            _local_7 = int((_local_7 / RECTANGLE_ELEMENT_WIDTH));
            _local_8 = int((_local_8 / RECTANGLE_ELEMENT_HEIGHT));
            _local_5--;
            _local_7 = (_local_7 + 1);
            _local_8 = (_local_8 + 3);
            var _local_9:int = (_local_5 * RECTANGLE_ELEMENT_WIDTH);
            var _local_11:int = (_local_6 * RECTANGLE_ELEMENT_HEIGHT);
            _local_3 = _local_6;
            while (_local_3 <= _local_8)
            {
                _local_10 = _local_9;
                _local_2 = _local_5;
                while (_local_2 <= _local_7)
                {
                    if (((((_local_2 < 0) || (_local_2 >= this.mMapWidth)) || (_local_3 < 0)) || (_local_3 >= this.mMapHeight)))
                    {
                        this.mWaterTile.mSprite.RenderPos(_local_10, _local_11);
                    };
                    _local_10 = (_local_10 + RECTANGLE_ELEMENT_WIDTH);
                    _local_2++;
                };
                _local_11 = (_local_11 + RECTANGLE_ELEMENT_HEIGHT);
                _local_3++;
            };
        }

        public function GetNameFromGrid_string(_arg_1:int):String
        {
            var _local_2:cGO = this.mMap_list[_arg_1];
            if (_local_2 != null)
            {
                return (_local_2.GetContainerName_string());
            };
            return (null);
        }

        public function ConvertGridToYPos(_arg_1:int):int
        {
            return (int((_arg_1 / this.mMapWidth)) * RECTANGLE_ELEMENT_HEIGHT);
        }

        public function ConvertGridToXPos(_arg_1:int):int
        {
            return ((_arg_1 % this.mMapWidth) * RECTANGLE_ELEMENT_WIDTH);
        }

        public function setAlternativeWater(_arg_1:Boolean):void
        {
            if (((_arg_1) && (this.mMap_list.length > 0)))
            {
                this.mWaterTile = (this.mMap_list[0] as cBackground);
            }
            else
            {
                this.mWaterTile = gGfxResource.mWaterTile;
            };
        }

        public function CalculateMapClipping(_arg_1:int, _arg_2:cClippingRectangle):void
        {
            var _local_3:int;
            var _local_4:int;
            var _local_5:int;
            var _local_6:int;
            var _local_7:int;
            if (_arg_1 == GCB_MODE_CLIPPING.CLIP_TO_SCREEN_FOREGROUND)
            {
                _local_7 = this.mGeneralInterface.mZoom.Scale(-(global.screenWidthHalf), cZoom.HUNDRED_PERCENT_ZOOM);
                _local_3 = (_local_7 + this.mGeneralInterface.mZoom.GetScrollPosXInt());
                _local_7 = this.mGeneralInterface.mZoom.Scale(-(global.screenHeightHalf), cZoom.HUNDRED_PERCENT_ZOOM);
                _local_4 = (_local_7 + this.mGeneralInterface.mZoom.GetScrollPosYInt());
                _local_7 = this.mGeneralInterface.mZoom.Scale(global.screenWidthHalf, cZoom.HUNDRED_PERCENT_ZOOM);
                _local_5 = (_local_7 + this.mGeneralInterface.mZoom.GetScrollPosXInt());
                _local_7 = this.mGeneralInterface.mZoom.Scale(global.screenHeightHalf, cZoom.HUNDRED_PERCENT_ZOOM);
                _local_6 = (_local_7 + this.mGeneralInterface.mZoom.GetScrollPosYInt());
                _local_3 = int((_local_3 / RECTANGLE_ELEMENT_WIDTH));
                _local_4 = int((_local_4 / RECTANGLE_ELEMENT_HEIGHT));
                _local_5 = int((_local_5 / RECTANGLE_ELEMENT_WIDTH));
                _local_6 = int((_local_6 / RECTANGLE_ELEMENT_HEIGHT));
                _local_5 = (_local_5 + 1);
                _local_6 = (_local_6 + 3);
                if (_local_3 < this.mMinUsableAreaX)
                {
                    _local_3 = this.mMinUsableAreaX;
                };
                if (_local_4 < this.mMinUsableAreaY)
                {
                    _local_4 = this.mMinUsableAreaY;
                };
                if (_local_5 > this.mMaxUsableAreaX)
                {
                    _local_5 = this.mMaxUsableAreaX;
                };
                if (_local_6 > this.mMaxUsableAreaY)
                {
                    _local_6 = this.mMaxUsableAreaY;
                };
            }
            else
            {
                if (_arg_1 == GCB_MODE_CLIPPING.CLIP_TO_SCREEN_BACKGROUND)
                {
                    _local_3 = this.mGeneralInterface.mZoom.Scale(((cBackbuffer.mClipMinX - global.screenWidthHalf) - cBackbuffer.mWidthSegment), cZoom.HUNDRED_PERCENT_ZOOM);
                    _local_4 = this.mGeneralInterface.mZoom.Scale(((cBackbuffer.mClipMinY - global.screenHeightHalf) - cBackbuffer.mHeightSegment), cZoom.HUNDRED_PERCENT_ZOOM);
                    _local_5 = this.mGeneralInterface.mZoom.Scale(((cBackbuffer.mClipMaxX - global.screenWidthHalf) + cBackbuffer.mWidthSegment), cZoom.HUNDRED_PERCENT_ZOOM);
                    _local_6 = this.mGeneralInterface.mZoom.Scale(((cBackbuffer.mClipMaxY - global.screenHeightHalf) + cBackbuffer.mHeightSegment), cZoom.HUNDRED_PERCENT_ZOOM);
                    _local_3 = int((_local_3 / RECTANGLE_ELEMENT_WIDTH));
                    _local_4 = int((_local_4 / RECTANGLE_ELEMENT_HEIGHT));
                    _local_5 = int((_local_5 / RECTANGLE_ELEMENT_WIDTH));
                    _local_6 = int((_local_6 / RECTANGLE_ELEMENT_HEIGHT));
                    _local_5 = (_local_5 + 1);
                    _local_6 = (_local_6 + 1);
                    if (_local_3 < this.mMinUsableAreaX)
                    {
                        _local_3 = this.mMinUsableAreaX;
                    };
                    if (_local_4 < this.mMinUsableAreaY)
                    {
                        _local_4 = this.mMinUsableAreaY;
                    };
                    if (_local_5 > this.mMaxUsableAreaX)
                    {
                        _local_5 = this.mMaxUsableAreaX;
                    };
                    if (_local_6 > this.mMaxUsableAreaY)
                    {
                        _local_6 = this.mMaxUsableAreaY;
                    };
                }
                else
                {
                    _local_3 = this.mMinUsableAreaX;
                    _local_4 = this.mMinUsableAreaY;
                    _local_5 = this.mMaxUsableAreaX;
                    _local_6 = this.mMaxUsableAreaY;
                };
            };
            _arg_2.minX = _local_3;
            _arg_2.minY = _local_4;
            _arg_2.maxX = _local_5;
            _arg_2.maxY = _local_6;
        }

        public function ConvertPixelPosToGrid(_arg_1:int, _arg_2:int):int
        {
            var _local_3:int = int((_arg_1 / RECTANGLE_ELEMENT_WIDTH));
            var _local_4:int = int((_arg_2 / RECTANGLE_ELEMENT_HEIGHT));
            if (!this.IsGridPosUsable(_local_3, _local_4))
            {
                return (defines.ILLEGAL_INT_POS);
            };
            var _local_5:int = (_local_3 + (_local_4 * this.mMapWidth));
            return (_local_5);
        }

        public function Remove(_arg_1:int, _arg_2:int):Boolean
        {
            var _local_3:Boolean;
            var _local_4:int = this.ConvertPixelPosToGrid(_arg_1, _arg_2);
            if (_local_4 != defines.ILLEGAL_INT_POS)
            {
                if (this.mMap_list[_local_4] != null)
                {
                    this.mMap_list[_local_4] = null;
                    _local_3 = true;
                };
            };
            return (_local_3);
        }

        public function mapHeight():int
        {
            return (this.mMapHeight);
        }

        public function Clear():void
        {
            var _local_1:int;
            while (_local_1 < this.mMapSize)
            {
                this.mMap_list[_local_1] = null;
                _local_1++;
            };
        }

        public function RemoveGridPos(_arg_1:int):Boolean
        {
            var _local_2:Boolean;
            if (_arg_1 != defines.ILLEGAL_INT_POS)
            {
                if (this.mMap_list[_arg_1] != null)
                {
                    this.mMap_list[_arg_1] = null;
                    _local_2 = true;
                };
            };
            return (_local_2);
        }

        public function GridCallBack(_arg_1:Function, _arg_2:int, _arg_3:Boolean):void
        {
        }

        public function RenderGrid(_arg_1:int):void
        {
            var _local_6:int;
            var _local_7:int;
            this.CalculateMapClipping(_arg_1, this.mTempClippingRectangle);
            var _local_2:int;
            var _local_3:int;
            var _local_4:int = this.mTempClippingRectangle.minX;
            var _local_5:int = this.mTempClippingRectangle.minY;
            while (_local_5 <= this.mTempClippingRectangle.maxY)
            {
                _local_6 = (_local_4 + (_local_5 * this.mMapWidth));
                _local_7 = this.mTempClippingRectangle.minX;
                while (_local_7 <= this.mTempClippingRectangle.maxX)
                {
                    if (this.mMap_list[_local_6] != null)
                    {
                        _local_2 = this.ConvertGridToXPos(_local_6);
                        _local_3 = this.ConvertGridToYPos(_local_6);
                        this.mGeneralInterface.mBackgroundCursorRed.SetPosition(_local_2, _local_3);
                        this.mGeneralInterface.mBackgroundCursorRed.Render();
                    };
                    _local_6++;
                    _local_7++;
                };
                _local_5++;
            };
        }


    }
}
