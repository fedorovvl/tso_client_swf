package nLib
{
    import flash.geom.Matrix;
    import Model.Notifiers.InputNotifier;
    import Map.cPlayerZoneScreen;
    import Tracks.TrackManager;

    public class cZoom 
    {

        public static const HUNDRED_PERCENT_ZOOM:int = 1000;
        public static const STANDARD_ZOOM_FACTOR_ARRAY:Array = [1000, 870, 750, 625, 500, 420, 350, 275, 225, 200];
        public static const START_ZOOM_FACTOR:int = 500;

        private var mDefaultZoomDivFactor:Number = -1;
        public var mCacheZoomInvScaleScrollPosYMinusHalfScreenHeight:Number;
        public var mSmoothing:Boolean = true;
        private var mFactor:Number = -1;
        public var mFactorDivDefaultZoom:Number = -1;
        private var mStreetZoneX:int = 0;
        private var mStreetZoneY:int = 0;
        private var mScrollPosY:Number;
        private var mScrollPosX:Number;
        private var mVecZoomFactor:Array = null;
        private var mNLibInterface:cNLibInterface;
        private var mCurrentZoomMatrix:Matrix = new Matrix();
        public var mCacheZoomInvScaleScrollPosXMinusHalfScreenWidth:Number;
        private var mGraphicScaleMatrix:Matrix = new Matrix();
        private var mCurrentZoomValue:int = -1;


        public function modifyScaleIndex(_arg_1:int):void
        {
            this.setScaleIndex((this.mCurrentZoomValue + _arg_1));
        }

        private function ScrollX(_arg_1:Number):void
        {
            this.mScrollPosX = (this.mScrollPosX + _arg_1);
            this.RestrictScrollPos();
        }

        public function SetScrollPosToScreen():void
        {
            this.SetScrollPos(-(global.screenWidthHalf), -(global.screenHeightHalf));
            this.setScaleFactorDirect(1000);
        }

        private function ScrollY(_arg_1:Number):void
        {
            this.mScrollPosY = (this.mScrollPosY + _arg_1);
            this.RestrictScrollPos();
        }

        public function GetScrollPosYInt():int
        {
            return (int(this.mScrollPosY));
        }

        public function getCurrentZoomMatrix():Matrix
        {
            return (this.mCurrentZoomMatrix);
        }

        public function getGraphicScaleMatrix():Matrix
        {
            return (this.mGraphicScaleMatrix);
        }

        public function updateZoomMatrix():void
        {
            this.mCurrentZoomMatrix.identity();
            this.mCurrentZoomMatrix.scale(this.mFactorDivDefaultZoom, this.mFactorDivDefaultZoom);
            this.mGraphicScaleMatrix.identity();
            var _local_1:Number = (this.mFactor / (HUNDRED_PERCENT_ZOOM * global.mGraphicScaleFactor));
            this.mGraphicScaleMatrix.scale(_local_1, _local_1);
        }

        public function CalculateScrollPos(_arg_1:cPosInt):void
        {
            var _local_2:Number = (_arg_1.x * this.mFactorDivDefaultZoom);
            var _local_3:Number = (_arg_1.y * this.mFactorDivDefaultZoom);
            _arg_1.x = (_local_2 - this.mCacheZoomInvScaleScrollPosXMinusHalfScreenWidth);
            _arg_1.y = (_local_3 - this.mCacheZoomInvScaleScrollPosYMinusHalfScreenHeight);
        }

        public function GetScaleFactor():Number
        {
            return (this.mFactor);
        }

        public function SetScrollPos(_arg_1:Number, _arg_2:Number, _arg_3:Boolean=true):void
        {
            var _local_4:Boolean = ((!(this.mScrollPosX == _arg_1)) || (!(this.mScrollPosY == _arg_2)));
            this.mScrollPosX = _arg_1;
            this.mScrollPosY = _arg_2;
            this.UpdateScrollCacheValuesX();
            this.UpdateScrollCacheValuesY();
            if (((_arg_3) && (_local_4)))
            {
                global.ui.channels.INPUT.notifyPropertyObserver(InputNotifier.CAMERA_CHANGED_string, null);
            };
        }

        public function GetScrollPosXInt():int
        {
            return (int(this.mScrollPosX));
        }

        public function Scale(_arg_1:Number, _arg_2:Number):int
        {
            return (((_arg_1 * _arg_2) / this.mFactor) << 0);
        }

        public function SetScrollPosPlayerZoneSectorNr(_arg_1:cPlayerZoneScreen, _arg_2:int):void
        {
            var _local_3:int;
            var _local_4:int;
            var _local_5:int;
            if (_arg_2 < 11)
            {
                _local_3 = 0;
                _local_4 = 0;
                while (_local_4 < (defines.SECTORS_Y + defines.ZOOM_SECTORS_ISLAND_Y))
                {
                    _local_5 = 0;
                    while (_local_5 < defines.SECTORS_X)
                    {
                        if (_local_3 == _arg_2)
                        {
                            this.SetScrollPosPlayerZone(_arg_1, _local_5, _local_4);
                            return;
                        };
                        _local_3++;
                        _local_5++;
                    };
                    _local_4++;
                };
            }
            else
            {
                switch (_arg_2)
                {
                    case 11:
                        this.SetScrollPos(1600, 5500);
                        return;
                    case 12:
                        this.SetScrollPos(4000, 5500);
                        return;
                    case 13:
                        this.SetScrollPos(7300, 5500);
                        return;
                    case 16:
                    case 14:
                        this.SetScrollPos(8000, 4000);
                        return;
                    case 19:
                    case 15:
                        this.SetScrollPos(8000, 2200);
                        return;
                };
                return;
            };
        }

        public function setScrollRange(_arg_1:int, _arg_2:int):void
        {
            this.mStreetZoneX = (_arg_1 - 5);
            this.mStreetZoneY = (_arg_2 - 16);
        }

        public function Init(_arg_1:Array, _arg_2:cNLibInterface, _arg_3:cPlayerZoneScreen):void
        {
            this.mVecZoomFactor = _arg_1;
            this.mNLibInterface = _arg_2;
            this.ResetFactorAndPos(_arg_3);
        }

        public function InvCalculateScrollPos(_arg_1:cPosInt):void
        {
            var _local_2:Number = (this.mScrollPosX + (_arg_1.x * this.mDefaultZoomDivFactor));
            var _local_3:Number = (this.mScrollPosY + (_arg_1.y * this.mDefaultZoomDivFactor));
            _arg_1.x = (_local_2 - (global.screenWidthHalf * this.mDefaultZoomDivFactor));
            _arg_1.y = (_local_3 - (global.screenHeightHalf * this.mDefaultZoomDivFactor));
        }

        public function setScaleIndex(_arg_1:int):Boolean
        {
            if (((_arg_1 < 0) || (_arg_1 >= this.mVecZoomFactor.length)))
            {
                return (false);
            };
            if (_arg_1 == this.mCurrentZoomValue)
            {
                return (true);
            };
            this.mCurrentZoomValue = _arg_1;
            this.mFactor = this.mVecZoomFactor[this.mCurrentZoomValue];
            this.mFactorDivDefaultZoom = (this.mFactor / HUNDRED_PERCENT_ZOOM);
            this.mDefaultZoomDivFactor = (HUNDRED_PERCENT_ZOOM / this.mFactor);
            this.updateZoomMatrix();
            this.mNLibInterface.ZoomHasChanged();
            this.UpdateScrollCacheValuesX();
            this.UpdateScrollCacheValuesY();
            this.mNLibInterface.UpdatePositions();
            return (true);
        }

        public function SetScrollPosPlayerZone(_arg_1:cPlayerZoneScreen, _arg_2:int, _arg_3:int):void
        {
            var _local_4:int = (defines.BORDER_OFFSET_X + (_arg_2 * defines.STREET_ZONE_SIZE_X));
            var _local_5:int = (defines.BORDER_OFFSET_Y + (_arg_3 * defines.STREET_ZONE_SIZE_Y));
            this.SetScrollPos(_local_4, _local_5);
        }

        public function setScaleFactorDirect(_arg_1:Number):void
        {
            if (Math.floor(this.mFactor) != Math.floor(_arg_1))
            {
                this.mFactor = _arg_1;
                this.mFactorDivDefaultZoom = (this.mFactor / HUNDRED_PERCENT_ZOOM);
                this.mDefaultZoomDivFactor = (HUNDRED_PERCENT_ZOOM / this.mFactor);
                this.updateZoomMatrix();
                this.mNLibInterface.ZoomHasChanged();
                this.UpdateScrollCacheValuesX();
                this.UpdateScrollCacheValuesY();
                this.mNLibInterface.UpdatePositions();
            };
        }

        public function GetScrollPosY():Number
        {
            return (this.mScrollPosY);
        }

        public function UpdateScrollCacheValuesX():void
        {
            this.mCacheZoomInvScaleScrollPosXMinusHalfScreenWidth = (this.InvScale(this.mScrollPosX, cZoom.HUNDRED_PERCENT_ZOOM) - global.screenWidthHalf);
        }

        public function RestrictScrollPos():void
        {
            var _local_1:int;
            var _local_2:int;
            var _local_3:int = (global.streetGridX * (this.mStreetZoneX + (defines.STREET_ZONE_BORDER * 4)));
            var _local_4:int = (global.streetGridYHalf * (this.mStreetZoneY + (defines.STREET_ZONE_BORDER * 4)));
            if (this.mScrollPosX < _local_1)
            {
                this.mScrollPosX = _local_1;
            };
            if (this.mScrollPosY < _local_2)
            {
                this.mScrollPosY = _local_2;
            };
            if (this.mScrollPosX > _local_3)
            {
                this.mScrollPosX = _local_3;
            };
            if (this.mScrollPosY > _local_4)
            {
                this.mScrollPosY = _local_4;
            };
        }

        public function GetScrollPosX():Number
        {
            return (this.mScrollPosX);
        }

        public function setScaleIndexWithZoomFactor(_arg_1:int):void
        {
            var _local_2:int = -1;
            var _local_3:int;
            while (_local_3 < this.mVecZoomFactor.length)
            {
                if (((_local_2 == -1) || (Math.abs((this.mVecZoomFactor[_local_3] - _arg_1)) < Math.abs((this.mVecZoomFactor[_local_2] - _arg_1)))))
                {
                    _local_2 = _local_3;
                };
                _local_3++;
            };
            this.setScaleIndex(_local_2);
        }

        public function UpdateScrollCacheValuesY():void
        {
            this.mCacheZoomInvScaleScrollPosYMinusHalfScreenHeight = (this.InvScale(this.mScrollPosY, cZoom.HUNDRED_PERCENT_ZOOM) - global.screenHeightHalf);
        }

        public function GetInvScaleFactor():Number
        {
            return (this.mDefaultZoomDivFactor);
        }

        public function Scroll(_arg_1:int, _arg_2:Number):void
        {
            switch (_arg_1)
            {
                case defines.SCROLL_LEFT:
                    this.ScrollX(-(_arg_2));
                    break;
                case defines.SCROLL_RIGHT:
                    this.ScrollX(_arg_2);
                    break;
                case defines.SCROLL_UP:
                    this.ScrollY(-(_arg_2));
                    break;
                case defines.SCROLL_DOWN:
                    this.ScrollY(_arg_2);
                    break;
            };
            if (_arg_1 > 0)
            {
                cBackbuffer.SetClippingXYWH(this.InvScale(this.GetScrollPosX(), cZoom.HUNDRED_PERCENT_ZOOM), this.InvScale(this.GetScrollPosY(), cZoom.HUNDRED_PERCENT_ZOOM), global.screenWidth, global.screenHeight);
                this.mNLibInterface.CacheBackgroundScroll();
                cBackbuffer.SetDefaultClipping();
            };
        }

        public function InvScale(_arg_1:Number, _arg_2:Number):int
        {
            return (((_arg_1 * this.mFactor) / _arg_2) << 0);
        }

        public function ResetFactorAndPos(_arg_1:cPlayerZoneScreen):void
        {
            this.mStreetZoneX = (_arg_1.mStreetMapMaxUsableX - 5);
            this.mStreetZoneY = (_arg_1.mStreetMapMaxUsableY - 16);
            this.mScrollPosX = (((this.mStreetZoneX * global.streetGridX) / 2) + _arg_1.mStreetMapMinUsableX);
            this.mScrollPosY = (((this.mStreetZoneY * global.streetGridYHalf) / 2) + _arg_1.mStreetMapMinUsableY);
            this.mFactor = -1;
            this.mCurrentZoomValue = -1;
        }

        public function AddScaleFactor(_arg_1:Number):void
        {
            this.setScaleFactorDirect((this.mFactor + _arg_1));
            TrackManager.getInstance().trackUI(global.ui.mCurrentPlayer.GetPlayerId(), "Client Zoom", "zoom", _arg_1, true);
        }


    }
}
